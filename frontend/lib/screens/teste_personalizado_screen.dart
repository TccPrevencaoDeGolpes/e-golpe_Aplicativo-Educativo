import 'package:flutter/material.dart';
import 'package:frontend/components/button_custom.dart';
import 'package:frontend/service/teste_service.dart';

class TestePersonalizadoScreen extends StatefulWidget {
  const TestePersonalizadoScreen({super.key});

  @override
  State<TestePersonalizadoScreen> createState() => _TestePersonalizadoScreenState();
}

class _TestePersonalizadoScreenState extends State<TestePersonalizadoScreen> {
  final TesteService _service = TesteService();
  int _qtdSelecionada = 5;
  String _temaSelecionado = 'Aleatório';
  bool _isLoading = false;

  final List<int> _opcoesQtd = [5, 10, 20];

  //TODO: Arrumar isso, ruim de manutenção
  final List<String> _temasDisponiveis = ['Aleatório', 'MENSAGEM'];

  void _criarTeste() async {
    //Recupera o usuarioId repassado para esta tela
      final args = ModalRoute.of(context)?.settings.arguments;
      int? usuarioId;
      if (args is int) {
        usuarioId = args;
      } else if (args is Map) {
        usuarioId = args['usuarioId'] ?? args['userId'] ?? args['id'];
      }
    setState(() => _isLoading = true);
    try {

      final String temaParaEnviar = (_temaSelecionado == 'Aleatório') ? 'ALEATORIO' : _temaSelecionado;

      final perguntas = await _service.criarTestePersonalizado(
        _qtdSelecionada,
        temaParaEnviar,
      );
      

      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.pushReplacementNamed(
          context,
          '/realizar-teste',
          arguments: {
            'usuarioId': usuarioId,
            'testeId': null,
            'perguntas': perguntas,
          },
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text(
              'Não foi possível criar o teste',
              style: TextStyle(color: Color(0xFF1E3A8A), fontWeight: FontWeight.bold),
            ),
            content: Text(
              e.toString().replaceAll('Exception:', ''),
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('OK', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              color: const Color(0xFF1E3A8A),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.close, color: Color(0xFF1E3A8A), size: 24),
                        SizedBox(width: 4),
                        Text('Cancelar', style: TextStyle(color: Color(0xFF1E3A8A), fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Criar Teste Personalizado',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF1E3A8A)),
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      'Quantidade de perguntas',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)),
                    ),
                    const Text('Selecione uma opção.', style: TextStyle(fontSize: 16, color: Color(0xFF475569))),
                    const SizedBox(height: 12),

                    ..._opcoesQtd.map((qtd) {
                      final isSelected = _qtdSelecionada == qtd;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: InkWell(
                          onTap: () => setState(() => _qtdSelecionada = qtd),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFDBEAFE) : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? const Color(0xFF1E3A8A) : const Color(0xFFCBD5E1),
                                width: 2,
                              ),
                            ),
                            child: Text(
                              '$qtd Perguntas',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)),
                            ),
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 24),
                    const Text(
                      'Escolha o tema das perguntas',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)),
                    ),
                    const SizedBox(height: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFCBD5E1), width: 2),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _temaSelecionado,
                          isExpanded: true,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)),
                          items: _temasDisponiveis
                              .map((t) => DropdownMenuItem<String>(value: t, child: Text(t)))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _temaSelecionado = val);
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ButtonCustom(
                            label: 'CRIAR TESTE',
                            variant: ButtonTipo.success,
                            onPressed: _criarTeste,
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