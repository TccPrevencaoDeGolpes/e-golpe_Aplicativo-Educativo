import 'package:flutter/material.dart';
import 'package:frontend/components/button_custom.dart';
import 'package:frontend/model/resultado_teste.dart';

class ResultadoTesteScreen extends StatelessWidget {
  const ResultadoTesteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final resultado = ModalRoute.of(context)!.settings.arguments as ResultadoTeste;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'TESTE CONCLUÍDO',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF15803D)),
              ),
              const SizedBox(height: 32),

              // Indicador circular dinâmico de acertos
              Center(
                child: SizedBox(
                  width: 180,
                  height: 180,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 180,
                        height: 180,
                        child: CircularProgressIndicator(
                          value: resultado.porcentagem / 100, // Converte 40.0 para 0.4 (40%)
                          strokeWidth: 12,
                          backgroundColor: const Color(0xFFE2E8F0),
                          valueColor: const AlwaysStoppedAnimation(Color(0xFF15803D)),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${resultado.acertos}/${resultado.totalPerguntas}',
                            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: Color(0xFF1E3A8A)),
                          ),
                          const Text(
                            'ACERTOS',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                          ),
                          Text(
                            'Sua pontuação: ${resultado.porcentagem.toInt()}%',
                            style: const TextStyle(fontSize: 14, color: Color(0xFF15803D), fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Chip(
                    avatar: const Icon(Icons.check_circle, color: Color(0xFF15803D)),
                    label: Text('Acertos: ${resultado.acertos}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    backgroundColor: const Color(0xFFDCFCE7),
                  ),
                  const SizedBox(width: 12),
                  Chip(
                    avatar: const Icon(Icons.cancel, color: Color(0xFF991B1B)),
                    label: Text('Erros: ${resultado.erros}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    backgroundColor: const Color(0xFFFEE2E2),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              const Text(
                'Parabéns! Você demonstrou conhecimento sobre Segurança Digital. Continue praticando para ficar ainda mais protegido.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, height: 1.4, color: Color(0xFF475569)),
              ),

              const Spacer(),

              ButtonCustom(
                label: 'Voltar para a lista de testes',
                variant: ButtonTipo.primary,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}