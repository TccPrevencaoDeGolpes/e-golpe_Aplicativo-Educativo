import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  //TODO:PODE VIRAR COMPONENT
  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required Color shadowColor,
    required VoidCallback onClick,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onClick,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: color,
              width: 2.5,
            ),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                offset: const Offset(0, 4),
                blurRadius: 0,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: color,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuario = ModalRoute.of(context)?.settings.arguments;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'O que você quer fazer?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF64748B),
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 16),

              _buildMenuCard(
                icon: Icons.shield_outlined,
                title: 'Teste de conhecimento',
                description:
                    'Pratique e teste seus conhecimentos de segurança digital',
                color: const Color(0xFF1E3A8A),
                shadowColor: const Color(0xFF0F2460),
                onClick: () {
                  Navigator.pushNamed(
                    context,
                    '/testes',
                    arguments: usuario,
                  );
                },
              ),

              const SizedBox(height: 16),

              _buildMenuCard(
                icon: Icons.person_outline,
                title: 'Meu Perfil',
                description:
                    'Veja seu perfil, conquistas e configurações',
                color: const Color(0xFF0F766E),
                shadowColor: const Color(0xFF115E59),
                onClick: () {
                  Navigator.pushNamed(
                    context,
                    '/perfil',
                    arguments: usuario,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}