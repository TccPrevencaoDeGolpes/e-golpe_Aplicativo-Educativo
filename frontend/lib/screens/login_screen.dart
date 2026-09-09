import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/components/button_custom.dart';
import 'package:frontend/components/input_custom.dart';
import 'package:frontend/main.dart';
import 'package:frontend/service/autenticacao_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final AutenticacaoService _autenticacaoService = AutenticacaoService();

  bool _isLoading = false;

  // SVG do Ícone Oficial do Google
  static const String _googleSvgLogo = '''
  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48">
    <path fill="#EA4335" d="M24 9.5c3.54 0 6.71 1.22 9.21 3.6l6.85-6.85C35.9 2.38 30.47 0 24 0 14.62 0 6.51 5.38 2.56 13.22l7.98 6.19C12.43 13.7 17.74 9.5 24 9.5z"/>
    <path fill="#4285F4" d="M46.98 24.55c0-1.57-.15-3.09-.38-4.55H24v9.02h12.94c-.58 2.96-2.26 5.48-4.78 7.18l7.73 6c4.51-4.18 7.09-10.36 7.09-17.65z"/>
    <path fill="#FBBC05" d="M10.53 28.59c-.48-1.45-.76-2.99-.76-4.59s.27-3.14.76-4.59l-7.98-6.19C.92 16.46 0 20.12 0 24c0 3.88.92 7.54 2.56 10.78l7.97-6.19z"/>
    <path fill="#34A853" d="M24 48c6.48 0 11.93-2.13 15.89-5.81l-7.73-6c-2.15 1.45-4.92 2.3-8.16 2.3-6.26 0-11.57-4.2-13.47-9.91l-7.98 6.19C6.51 42.62 14.62 48 24 48z"/>
  </svg>
  ''';

  Future<void> _efetuarLogin() async {
    final loginText = emailController.text.trim();
    final senhaText = senhaController.text.trim();

    if (loginText.isEmpty || senhaText.isEmpty) {
      messengerKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor, preencha o e-mail/celular e a senha.',
            style: TextStyle(fontSize: 18, height: 1.4, color: Colors.black),
          ),
          
          backgroundColor: Color(0xFFFDE047),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final usuario = await _autenticacaoService.fazerLogin(loginText, senhaText);

    setState(() => _isLoading = false);

    if (mounted) {
      if (usuario != null) {
        // Redireciona para a tela de Perfil em caso de sucesso
        Navigator.of(context).pushReplacementNamed('/perfil');
      } else {
        messengerKey.currentState?.showSnackBar(
          const SnackBar(
            content: Text(
              'E-mail/celular ou senha incorretos.',
              style: TextStyle(fontSize: 18, height: 1.4, color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // Header Azul
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 12,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            color: const Color(0xFF1E3A8A),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      emailController.clear();
                      senhaController.clear();
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        Navigator.pushReplacementNamed(context, '/inicio');
                      }
                    },
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
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
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
                const SizedBox(height: 16),
                const Text(
                  'Acessar minha conta',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    height: 1.4,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),

          // Conteúdo com Scroll
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Já tem conta no Google? Entre rapidinho',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Botão do Google sem ação
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                      backgroundColor: Colors.white,
                      side: const BorderSide(
                        color: Color(0xFFCBD5E1),
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.string(
                          _googleSvgLogo,
                          width: 28,
                          height: 28,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Continuar com Google',
                          style: TextStyle(
                            fontSize: 18,
                            height: 1.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Divisor
                  Row(
                    children: const [
                      Expanded(
                        child: Divider(color: Color(0xFFCBD5E1), thickness: 1),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'ou use seu e-mail / celular',
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.4,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF475569),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(color: Color(0xFFCBD5E1), thickness: 1.5),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Campos de Texto
                  const Text(
                    'E-mail ou número de celular',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A8A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  InputCustom(
                    controller: emailController,
                    hintText: 'seu@email.com ou 11944443333',
                    icon: Icons.email_outlined,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Senha',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A8A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  InputCustom(
                    controller: senhaController,
                    isPassword: true,
                    icon: Icons.lock_outline,
                  ),

                  const SizedBox(height: 28),

                  // Botão Principal
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ButtonCustom(
                          label: 'Entrar →',
                          variant: ButtonTipo.primary,
                          onPressed: _efetuarLogin,
                        ),

                  const SizedBox(height: 16),

                  // Redirecionamento para Cadastro
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                          minimumSize: const Size(48, 48),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('/cadastro');
                        },
                        child: const Text(
                          'Não tenho conta — Criar agora',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF1E3A8A),
                            fontSize: 16,
                            height: 1.5,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
