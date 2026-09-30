import 'package:flutter/material.dart';
import 'package:frontend/components/button_custom.dart';
import 'package:frontend/model/feedback_response.dart';
import 'package:frontend/model/pergunta.dart';
import 'package:frontend/model/resultado_teste.dart';
import 'package:frontend/service/teste_service.dart';

class RealizarTesteScreen extends StatefulWidget {
  const RealizarTesteScreen({super.key});

  @override
  State<RealizarTesteScreen> createState() => _RealizarTesteScreenState();
}

class _RealizarTesteScreenState extends State<RealizarTesteScreen> {
  final TesteService _service = TesteService();

  int? _usuarioId;
  int? _testeId;
  List<Pergunta> _perguntas = [];
  int _currentIndex = 0;

  int? _alternativaSelecionada;
  bool _respostaConfirmada = false;
  FeedbackResponse? _feedback;
  bool _isLoading = false;

  int _acertos = 0;
  int _erros = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    if (args != null) {
      // Aceita IDs enviados como int ou String e nomes usados pelas rotas.
      _usuarioId ??= _parseId(args['usuarioId'] ?? args['userId']);
      _testeId ??= _parseId(args['testeId'] ?? args['idTeste']);
      if (_perguntas.isEmpty && args['perguntas'] is List) {
        _perguntas = (args['perguntas'] as List).whereType<Pergunta>().toList();
      }
    }
  }

  int? _parseId(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  void _confirmarResposta() async {
    if (_alternativaSelecionada == null) return;
    setState(() => _isLoading = true);

    try {
      final perguntaAtual = _perguntas[_currentIndex];
      final res = await _service.responderPergunta(
        perguntaAtual.id,
        _alternativaSelecionada!,
      );

      setState(() {
        _isLoading = false;
        _feedback = res;
        _respostaConfirmada = true;
        if (res.correta) {
          _acertos++;
        } else {
          _erros++;
        }
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro ao enviar resposta: $e')));
    }
  }

  void _proximaPerguntaOuFinalizar() async {
    if (_currentIndex < _perguntas.length - 1) {
      setState(() {
        _currentIndex++;
        _alternativaSelecionada = null;
        _respostaConfirmada = false;
        _feedback = null;
      });
    } else {
      // Registrar resultado na API e navegar para o Resultado
      setState(() => _isLoading = true);

      try {
        final usuarioId = _usuarioId;
        final testeId = _testeId;
        if (usuarioId == null) {
          throw StateError('ID do usuário  não informado.');
        }

        if (_perguntas.isEmpty) {
          throw StateError('Nenhuma pergunta foi carregada.');
        }

        final double porcentagem = (_acertos / _perguntas.length) * 100;
        final resultado = ResultadoTeste(
          usuarioId: usuarioId,
          testeId: testeId,
          totalPerguntas: _perguntas.length,
          acertos: _acertos,
          erros: _erros,
          porcentagem: porcentagem,
        );

        bool ok = await _service.salvarResultado(resultado);

        if (!mounted) return;
        setState(() => _isLoading = false);

        if (ok) {
          Navigator.pushReplacementNamed(
            context,
            '/resultado-teste',
            arguments: resultado,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Erro ao salvar o resultado do teste. Tente novamente.',
              ),
            ),
          );
        }
      } catch (e) {
        if (!mounted) return;
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Erro na requisição: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_perguntas.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Nenhuma pergunta carregada.')),
      );
    }

    final perguntaAtual = _perguntas[_currentIndex];
    final progress = (_currentIndex + 1) / _perguntas.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      body: SafeArea(
        child: Column(
          children: [
            // Header e Progresso
            Container(
              color: const Color(0xFF1E3A8A),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pergunta ${_currentIndex + 1} de ${_perguntas.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white24,
                    color: const Color(0xFFF59E0B),
                    minHeight: 10,
                  ),
                ],
              ),
            ),

            // Pergunta
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Badge do tipo de pergunta
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDBEAFE),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          perguntaAtual.tipoPergunta == 'IDENTIFICAR_GOLPE'
                              ? 'Identifique o tipo de golpe'
                              : 'Classifique a mensagem',
                          style: const TextStyle(
                            color: Color(0xFF1E3A8A),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Text(
                      perguntaAtual.enunciado,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Exibição de estilo Chat caso haja mensagem/remetente
                    if (perguntaAtual.mensagem != null)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFCBD5E1)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: const Color(0xFF6B21A8),
                              child: Text(
                                perguntaAtual.remetente != null &&
                                        perguntaAtual.remetente!.isNotEmpty
                                    ? perguntaAtual.remetente![0].toUpperCase()
                                    : 'N',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3E8FF),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  perguntaAtual.mensagem!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Alternativas (3 ou 4 opções)
                    ...perguntaAtual.alternativas.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final alt = entry.value;
                      final isSelected = _alternativaSelecionada == idx;

                      Color itemBg = Colors.white;
                      Color borderColor = const Color(0xFFCBD5E1);

                      if (_respostaConfirmada && _feedback != null) {
                        if (idx == _feedback!.alternativaCerta) {
                          itemBg = const Color(0xFFDCFCE7); // Verde
                          borderColor = const Color(0xFF15803D);
                        } else if (isSelected && !_feedback!.correta) {
                          itemBg = const Color(0xFFFEE2E2); // Vermelho
                          borderColor = const Color(0xFF991B1B);
                        }
                      } else if (isSelected) {
                        itemBg = const Color(0xFFDBEAFE);
                        borderColor = const Color(0xFF1E3A8A);
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: _respostaConfirmada
                              ? null
                              : () => setState(
                                  () => _alternativaSelecionada = idx,
                                ),
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: itemBg,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: borderColor, width: 2),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isSelected
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_off,
                                  color: borderColor,
                                  size: 26,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    alt,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E3A8A),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),

                    // Feedback Teórico pós-confirmação
                    if (_respostaConfirmada && _feedback != null)
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _feedback!.correta
                              ? const Color(0xFFDCFCE7)
                              : const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _feedback!.correta
                                ? const Color(0xFF15803D)
                                : const Color(0xFF991B1B),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _feedback!.correta
                                  ? 'Resposta correta!'
                                  : 'Resposta incorreta',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _feedback!.correta
                                    ? const Color(0xFF15803D)
                                    : const Color(0xFF991B1B),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _feedback!.feedback,
                              style: const TextStyle(
                                fontSize: 16,
                                height: 1.4,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Botão Ação
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (!_respostaConfirmada)
                      ButtonCustom(
                        label: 'Confirmar resposta',
                        variant: ButtonTipo.primary,
                        onPressed: _alternativaSelecionada != null
                            ? _confirmarResposta
                            : () {},
                      )
                    else
                      ButtonCustom(
                        label: _currentIndex < _perguntas.length - 1
                            ? 'Próxima pergunta'
                            : 'Ver resultado',
                        variant: ButtonTipo.success,
                        onPressed: _proximaPerguntaOuFinalizar,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
