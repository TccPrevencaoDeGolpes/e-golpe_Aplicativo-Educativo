import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:frontend/components/input_custom.dart';
import 'package:frontend/components/button_custom.dart';
import 'package:frontend/main.dart';
import 'package:frontend/model/usuario.dart';
import 'package:frontend/service/usuario_service.dart';

class CadastroContaScreen extends StatefulWidget {
  const CadastroContaScreen({super.key});

  @override
  State<CadastroContaScreen> createState() => _CadastroContaScreenState();
}

class _CadastroContaScreenState extends State<CadastroContaScreen> {
  //pageview
  late PageController _pageViewController;
  int _currentPageIndex = 0;
  final int _totalPages = 3;

  final UsuarioService _usuarioService = UsuarioService();

  //Controladores para os campos de entrada
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController contatoController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController confirmaSenhaController = TextEditingController();

  DateTime dataNascimento = DateTime(1960, 6, 15);
  String? genero;
  String tipoContato = 'celular';
  String erroContato = '';

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    nomeController.dispose();
    contatoController.dispose();
    senhaController.dispose();
    confirmaSenhaController.dispose();
    super.dispose();
  }

  void _avancarPasso() async {
    // Validação do Passo 1
    if (_currentPageIndex == 0) {
      if (nomeController.text.trim().length < 2) {
        messengerKey.currentState?.showSnackBar(
          const SnackBar(content: Text('Informe um nome válido')),
        );
        return;
      }
      if (genero == null) {
        messengerKey.currentState?.showSnackBar(
          const SnackBar(content: Text('Selecione seu gênero')),
        );
        return;
      }
    }

    // Validação do Passo 2
    if (_currentPageIndex == 1) {
      String texto = contatoController.text;
      if (tipoContato == 'email') {
        final email = texto.trim();

        final emailValido = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
            .hasMatch(email);

        if (!emailValido) {
          setState(() => erroContato = 'Digite um e-mail válido');
          return;
        }
      } else if (tipoContato == 'celular') {
        String apenasNumeros = texto.replaceAll(RegExp(r'[^0-9]'), '');
        if (apenasNumeros.length != 11) {
          setState(() => erroContato = 'Celular deve ter 11 números com DDD.');
          return;
        }
      }
      setState(() => erroContato = '');
    }

    if (_currentPageIndex < _totalPages - 1) {
      _fecharTeclado();
      _pageViewController.animateToPage(
        _currentPageIndex + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Validação senha
      if (senhaController.text.length < 6) {
        messengerKey.currentState?.showSnackBar(
          const SnackBar(
            content: Text('A senha devem ter pelo menos 6 caracteres'),
          ),
        );
        return;
      }
      if (senhaController.text != confirmaSenhaController.text) {
        messengerKey.currentState?.showSnackBar(
          const SnackBar(content: Text('As senhas não coincidem.')),
        );
        return;
      }

      _fecharTeclado();
      setState(() => _isLoading = true);

      // Instância final do Usuário usando a Model
      final novoUsuario = Usuario(
        nome: nomeController.text,
        genero: genero,
        dataNascimento: dataNascimento,
        email: tipoContato == 'email' ? contatoController.text : null,
        celular: tipoContato == 'celular'
            ? contatoController.text.replaceAll(RegExp(r'[^0-9]'), '')
            : null,
        senha: senhaController.text,
      );

      // Chamada da API pelo UsuarioService
      final response = await _usuarioService.cadastrarUsuario(novoUsuario);

      setState(() => _isLoading = false);

      if (mounted) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          messengerKey.currentState?.showSnackBar(
            const SnackBar(content: Text('Usuário cadastrado com sucesso!')),
          );
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false,
          );
        } else {
          messengerKey.currentState?.showSnackBar(
            SnackBar(
              content: Text(
                response.body.isNotEmpty
                    ? response.body
                    : 'Falha ao cadastrar. Tente novamente.',
              ),
            ),
          );
          // Voltar para a primeira página do cadastro
          _pageViewController.animateToPage(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      }
    }
  }

  // Fecha o teclado antes de trocar de etapa ou sair da tela.
  void _fecharTeclado() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  //BUILD
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER AZUL
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
                    onTap: () {
                      _fecharTeclado();

                      if (_currentPageIndex > 0) {
                        _pageViewController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
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
                        children: [
                          Icon(
                            _currentPageIndex == 0
                                ? Icons.close
                                : Icons.chevron_left,
                            color: const Color(0xFF1E3A8A),
                            size: 24,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _currentPageIndex == 0 ? 'Cancelar' : 'Voltar',
                            style: const TextStyle(
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

            Expanded(
              child: PageView(
                controller: _pageViewController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {                  
                  _fecharTeclado();
                  setState(() => _currentPageIndex = index);
                },
                children: [_buildPasso1(), _buildPasso2(), _buildPasso3()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Estrutura compartilhada das etapas do cadastro.
  // O título fica fora do header azul e o botão entra no fluxo do scroll.
  Widget _buildPagina({required List<Widget> children}) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Criar minha conta',
                style: TextStyle(
                  color: Color(0xFF1E3A8A),
                  fontSize: 36,
                  height: 1.4,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'PASSO ${_currentPageIndex + 1} DE $_totalPages',
                style: const TextStyle(
                  color: Color(0xFF475569),
                  fontSize: 14,
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 20),
              ...children,
              const SizedBox(height: 24),
              _buildAcaoPagina(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAcaoPagina() {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : ButtonCustom(
            label: _currentPageIndex == _totalPages - 1
                ? 'Criar minha conta'
                : 'Continuar',
            variant: _currentPageIndex == _totalPages - 1
                ? ButtonTipo.success
                : ButtonTipo.primary,
            onPressed: _avancarPasso,
          );
  }

  //Passo 1: Nome - data de nascimento e gênero
  Widget _buildPasso1() {
    return _buildPagina(
      children: [
        _rotulo('Seu nome', subtitulo: 'Só o primeiro nome está ótimo!'),
        InputCustom(controller: nomeController, hintText: 'Ex: Maria'),
        const SizedBox(height: 24),

        _rotulo(
          'Data de nascimento',
          subtitulo: 'Informe sua data de nascimento.',
        ),
        Container(
          height: 180,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            dateOrder: DatePickerDateOrder.dmy,
            initialDateTime: dataNascimento,
            minimumDate: DateTime(1900, 1, 1),
            maximumDate: DateTime.now(),
            onDateTimeChanged: (DateTime novaData) {
              setState(() {
                dataNascimento = novaData;
              });
            },
          ),
        ),
        const SizedBox(height: 24),

        _rotulo('Gênero', subtitulo: 'Selecione o seu gênero.'),
        ...['Masculino', 'Feminino', 'Outro', 'Prefiro não informar'].map((gen) {
          final selecionado = genero == gen;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => setState(() => genero = gen),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: selecionado ? const Color(0xFFDBEAFE) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selecionado
                        ? const Color(0xFF1E3A8A)
                        : const Color(0xFFCBD5E1),
                    width: 2,
                  ),
                ),
                child: Text(
                  gen,
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.4,
                    fontWeight: selecionado
                        ? FontWeight.bold
                        : FontWeight.w600,
                    color: const Color(0xFF1E3A8A),
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  //Passo 2: Email ou celular
  Widget _buildPasso2() {
    return _buildPagina(
      children: [
        _rotulo(
          'Como você quer acessar o aplicativo?',
          subtitulo: 'Escolha o que for mais fácil para você:',
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final botoes = [
              _botaoSelecaoContato(
                'Celular',
                'celular',
                Icons.phone_android,
              ),
              _botaoSelecaoContato(
                'E-mail',
                'email',
                Icons.email_outlined,
              ),
            ];

            if (constraints.maxWidth < 360) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  botoes[0],
                  const SizedBox(height: 12),
                  botoes[1],
                ],
              );
            }

            return Row(
              children: [
                Expanded(child: botoes[0]),
                const SizedBox(width: 12),
                Expanded(child: botoes[1]),
              ],
            );
          },
        ),
        const SizedBox(height: 24),
        _rotulo(
          tipoContato == 'celular'
              ? 'Digite seu celular'
              : 'Digite o seu e-mail',
        ),
        InputCustom(
          controller: contatoController,
          hintText: tipoContato == 'celular'
              ? '(11) 9 4444-33333'
              : 'seu@email.com',
          isPhone: tipoContato == 'celular',
        ),
        if (erroContato.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              erroContato,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                height: 1.4,
              ),
            ),
          ),
      ],
    );
  }

  //Passo 3: Senha
  Widget _buildPasso3() {
    return _buildPagina(
      children: [
        _rotulo('Senha', subtitulo: 'Escolha algo que só você saiba'),
        const SizedBox(height: 8),
        InputCustom(controller: senhaController, isPassword: true),
        const SizedBox(height: 24),

        _rotulo('Confirmar senha'),
        const SizedBox(height: 8),
        InputCustom(controller: confirmaSenhaController, isPassword: true),
      ],
    );
  }

  // --- WIDGETS AUXILIARES ---
  Widget _rotulo(String titulo, {String? subtitulo}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 24,
              height: 1.5,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E3A8A),
            ),
          ),
          if (subtitulo != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitulo,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Color(0xFF475569),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _botaoSelecaoContato(String titulo, String tipo, IconData icon) {
    final selecionado = tipoContato == tipo;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        _fecharTeclado();
        setState(() {
          if (tipoContato != tipo){
          contatoController.clear();
          }
          tipoContato = tipo;
          erroContato = '';
        });
      },
      child: Container(
        constraints: const BoxConstraints(minHeight: 70),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: selecionado ? const Color(0xFFDBEAFE) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selecionado
                ? const Color(0xFF1E3A8A)
                : const Color(0xFFCBD5E1),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 28,
              color: selecionado
                  ? const Color(0xFF1E3A8A)
                  : const Color(0xFF475569),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                titulo,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  height: 1.4,
                  fontWeight: FontWeight.bold,
                  color: selecionado
                      ? const Color(0xFF1E3A8A)
                      : const Color(0xFF64748B),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
