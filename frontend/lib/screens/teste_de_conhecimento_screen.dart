import 'package:flutter/material.dart';
import 'package:frontend/components/button_custom.dart';
import 'package:frontend/components/card_teste_custom.dart';
import 'package:frontend/model/teste.dart';
import 'package:frontend/service/teste_service.dart';

class TesteDeConhecimentoScreen extends StatefulWidget {
  final int? usuarioId;

  const TesteDeConhecimentoScreen({super.key, this.usuarioId});

  @override
  State<TesteDeConhecimentoScreen> createState() =>
      _TesteDeConhecimentoScreenState();
}

class _TesteDeConhecimentoScreenState extends State<TesteDeConhecimentoScreen> {
  final TesteService _service = TesteService();

  late Future<List<Teste>> _testesFuture;

  @override
  void initState() {
    super.initState();
    _carregarTestes();
  }

  void _carregarTestes() {
    setState(() {
      _testesFuture = _service.listarTestes();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Captura os argumentos repassados pelo MenuScreen
    final args = ModalRoute.of(context)?.settings.arguments;
    int? idUsuarioRecuperado = widget.usuarioId;

    if (idUsuarioRecuperado == null && args != null) {
      if (args is int) {
        idUsuarioRecuperado = args;
      } else if (args is Map) {
        idUsuarioRecuperado = args['id'] ?? args['usuarioId'] ?? args['userId'];
      } else {
        try { idUsuarioRecuperado = (args as dynamic).id; } catch(_) {}
      }
    }
    // --------------------------------

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      body: SafeArea(
        child: Column(
          children: [
            //HEADER AZUL
            Container(
              width: double.infinity,
              color: const Color(0xFF1E3A8A),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      constraints: const BoxConstraints(
                        minWidth: 48,
                        minHeight: 48,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.chevron_left,
                            color: Color(0xFF1E3A8A),
                            size: 24,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Voltar',
                            style: TextStyle(
                              color: Color(0xFF1E3A8A),
                              fontSize: 18,
                              height: 1.4,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            //FIM HEADER AZUL

            //Conteúdo
            Expanded(
              child: FutureBuilder<List<Teste>>(
                future: _testesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Erro ao carregar testes:\n${snapshot.error}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ButtonCustom(
                              label: 'Tentar Novamente',
                              onPressed: () {
                                setState(() {
                                  _carregarTestes();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final testes = snapshot.data ?? [];

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Testes Disponíveis',
                          style: TextStyle(
                            color: Color(0xFF1E3A84),
                            fontSize: 32,
                            height: 1.4,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 24),

                        //lista de teste
                        ...testes.map(
                          (teste) => CardtesteCustom(
                            teste: teste,
                            onTap: () async {
                              try {
                                final perguntas = await _service
                                    .buscarPerguntasDoTeste(teste.id);

                                if (!mounted) return;

                                Navigator.pushNamed(
                                  context,
                                  '/realizar-teste',
                                  arguments: {
                                    'usuarioId': idUsuarioRecuperado,
                                    'testeId': teste.id,
                                    'perguntas': perguntas,
                                  },
                                ).then((_) {
                                  if (mounted) {
                                    setState(() {
                                      _carregarTestes();
                                    });
                                  }
                                });
                              } catch (e) {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Erro ao carregar as perguntas: $e',
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        //FIM CONTEUDO
                        const SizedBox(height: 24),

                        //BOTÃO TESTE PERSONALIZADO
                        ButtonCustom(
                          label: 'Criar teste personalizado',
                          variant: ButtonTipo.primary,
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/criar-teste-personalizado',
                              arguments: {
                                'usuarioId': idUsuarioRecuperado,
                              }
                            ).then((_) => _carregarTestes());
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
