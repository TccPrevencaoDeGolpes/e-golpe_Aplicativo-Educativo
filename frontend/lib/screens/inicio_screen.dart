import 'package:flutter/material.dart';
import 'package:frontend/components/button_custom.dart';

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E3A8A), // Azul do fundo principal
      body: Stack(
        children: [
          // Círculos decorativos de fundo
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Positioned(
            top: 80,
            left: -60,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            top: 220,
            right: 20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF4ADE80).withValues(alpha: 0.15),
              ),
            ),
          ),

          // Layout principal
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Seção Superior - Logo e Recursos
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 20.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'e-golpe',
                          style: TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Aplicativo educativo para prevenção de golpes digitais direcionado ao público 50+',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Tags de recursos (Feature Pills)
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8,
                          runSpacing: 10,
                          children: const [
                            _FeaturePill(text: '🛡️ Aprenda Segurança digital'),
                            _FeaturePill(
                              text: '⚠️ Caí em um golpe, o que fazer',
                            ),
                            _FeaturePill(
                              text: '🎯 é golpe? descubra se a mensagem é suspeita',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Card Inferior - Ações
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 20,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 36),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Pronto para aprender?',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E3A8A),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Botão Principal (A caminho de /cadastro provisoriamente)
                      ButtonCustom(
                        label: 'Comece agora!',
                        variant: ButtonTipo.success,
                        onPressed: () {
                          Navigator.pushNamed(context, '/cadastro');
                        },
                      ),

                      const SizedBox(height: 8),
                      const Text(
                        'Sem precisar criar conta',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF94A3B8),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Botão Secundário - Fazer Login
                      ButtonCustom(
                        label: 'Fazer login',
                        variant: ButtonTipo.neutral,
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                      ),

                      const SizedBox(height: 14),

                      // Link Criar Conta
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/cadastro');
                        },
                        child: const Text(
                          'Ainda não tenho conta — Criar agora',
                          style: TextStyle(
                            color: Color(0xFF1E3A8A),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget utilitário para as tags arredondadas
class _FeaturePill extends StatelessWidget {
  final String text;
  const _FeaturePill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
