import 'package:flutter/material.dart';
import 'package:frontend/components/button_custom.dart';
import 'package:frontend/components/input_custom.dart';
import 'package:frontend/service/usuario_service.dart';

class AlterarSenhaScreen extends StatefulWidget {
  const AlterarSenhaScreen({super.key, required this.usuarioId});

  final int usuarioId;

  @override
  State<AlterarSenhaScreen> createState() => _AlterarSenhaScreenState();
}

class _AlterarSenhaScreenState extends State<AlterarSenhaScreen> {
  final _senhaAtualController = TextEditingController();
  final _novaSenhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  final UsuarioService _usuarioService = UsuarioService();

  String? _erroSenha;
  bool _salvando = false;

  @override
  void dispose() {
    _senhaAtualController.dispose();
    _novaSenhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> _alterarSenha() async {
    setState(() {
      _erroSenha = null;
    });

    final senhaAtual = _senhaAtualController.text;
    final novaSenha = _novaSenhaController.text;
    final confirmarSenha = _confirmarSenhaController.text;

    if (senhaAtual.isEmpty || novaSenha.isEmpty || confirmarSenha.isEmpty) {
      setState(() {
        _erroSenha = 'Preencha todos os campos.';
      });
      return;
    }

    if (novaSenha.length < 6) {
      setState(() {
        _erroSenha = 'A nova senha deve ter pelo menos 6 caracteres.';
      });
      return;
    }

    if (novaSenha != confirmarSenha) {
      setState(() {
        _erroSenha = 'As novas senhas não coincidem.';
      });
      return;
    }

    setState(() {
      _salvando = true;
    });

    try {
      final response = await _usuarioService.alterarSenha(
        widget.usuarioId,
        senhaAtual,
        novaSenha,
      );

      if (!mounted) return;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Senha alterada com sucesso!',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            backgroundColor: Color(0xFF15803D), // Verde
          ),
        );

        Navigator.of(context).pop(true);
        return;
      }

      setState(() {
        _salvando = false;
        _erroSenha = response.body.isNotEmpty
            ? response.body
            : 'Não foi possível alterar a senha.';
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _salvando = false;
        _erroSenha = 'Não foi possível alterar a senha.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      //header
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 60,
        leadingWidth: 120,
        leading: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                minimumSize: const Size(48,48),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Alterar senha',
                style: TextStyle(
                  fontSize: 34,
                  height: 1.4,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Text(
                'Altere sua senha preenchendo os campos abaixo',
                style: TextStyle(fontSize: 18, height: 1.5),
              ),

              const SizedBox(height: 24),

              if (_erroSenha != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _erroSenha!,
                    style: TextStyle(
                      color: Colors.red.shade800,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
              InputCustom(
                controller: _senhaAtualController,
                label: 'Senha atual',
                isPassword: true,
              ),

              const SizedBox(height: 16),

              InputCustom(
                controller: _novaSenhaController,
                label: 'Nova senha (mínimo 6 caracteres)',
                isPassword: true,
              ),

              const SizedBox(height: 16),

              InputCustom(
                controller: _confirmarSenhaController,
                label: 'Confirmar nova senha',
                isPassword: true,
              ),

              const SizedBox(height: 24),

              ButtonCustom(
                label: _salvando ? 'Salvando...' : 'Salvar nova senha',
                variant: ButtonTipo.primary,
                onPressed: _salvando ? () {} : _alterarSenha,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
