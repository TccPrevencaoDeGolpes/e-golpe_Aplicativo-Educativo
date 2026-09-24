import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/button_custom.dart';
import 'package:frontend/components/input_custom.dart';
import 'package:frontend/main.dart';
import 'package:frontend/screens/alterar_senha_screen.dart';
import 'package:frontend/service/usuario_service.dart';

import '../model/usuario.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final UsuarioService _usuarioService = UsuarioService();

  // Controle de estado da tela
  bool _isLoading = true;
  bool _isEditing = false;
  bool _dadosInicializados = false;

  // Simulação do ID do usuário logado (Em um app real, viria do provider/sessão)
  late Usuario _currentUser;
  Usuario? _usuario;

  // Controllers para edição de informações
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _celularController = TextEditingController();
  DateTime? _dataNascimentoSelecionada;
  String? _generoSelecionado;

  String _formatarCelular(String celular) {
    final numeros = celular.replaceAll(RegExp(r'[^0-9]'), '');

    if (numeros.length != 11) {
      return celular;
    }

    return '(${numeros.substring(0, 2)}) '
        '${numeros.substring(2, 7)}-'
        '${numeros.substring(7)}';
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_dadosInicializados) {
      final usuario = ModalRoute.of(context)!.settings.arguments as Usuario;

      _currentUser = usuario;

      _carregarDados();
      _dadosInicializados = true;
    }
  }

  Future<void> _carregarDados() async {
    setState(() => _isLoading = true);
    final usuario = await _usuarioService.carregarUsuario(_currentUser.id!);

    if (usuario != null) {
      setState(() {
        _usuario = usuario;
        _preencherControllers();
      });
    }
    setState(() => _isLoading = false);
  }

  void _preencherControllers() {
    if (_usuario == null) return;
    _nomeController.text = _usuario!.nome ?? '';
    _emailController.text = _usuario!.email ?? '';
    _dataNascimentoSelecionada = _usuario!.dataNascimento;
    _generoSelecionado = _usuario!.genero;
    final celular = _usuario!.celular ?? '';

    if (celular.isNotEmpty) {
      final numeros = celular.replaceAll(RegExp(r'[^0-9]'), '');

      if (numeros.length == 11) {
        _celularController.text =
            '(${numeros.substring(0, 2)}) '
            '${numeros.substring(2, 7)}-'
            '${numeros.substring(7)}';
      } else {
        _celularController.text = celular;
      }
    } else {
      _celularController.clear();
    }
  }

  Future<void> _salvarInformacoes() async {
    if (_usuario == null) return;

    setState(() => _isLoading = true);

    final celular = _celularController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (celular.isNotEmpty && celular.length != 11) {
      setState(() => _isLoading = false);
      messengerKey.currentState?.showSnackBar(
        const SnackBar(content: Text('Celular deve ter 11 números com DDD.')),
      );
      return;
    }

    // Atualiza o objeto local com os dados dos controllers
    _usuario!.nome = _nomeController.text;
    _usuario!.email = _emailController.text;
    _usuario!.celular = celular.isEmpty ? null : celular;
    _usuario!.dataNascimento = _dataNascimentoSelecionada;
    _usuario!.genero = _generoSelecionado;

    final response = await _usuarioService.alterarUsuario(
      _currentUser.id!,
      _usuario!,
    );

    setState(() {
      _isLoading = false;
      if (response.statusCode == 200) _isEditing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            (response.statusCode == 200 || response.statusCode == 204)
                ? 'Dados atualizados com sucesso!'
                : (response.body.isNotEmpty
                      ? response.body
                      : 'Falha ao atualizar os dados'),
            style: const TextStyle(
              fontSize: 18,
              height: 1.4,
              color: Colors.white,
            ),
          ),
          backgroundColor:
              (response.statusCode == 200 || response.statusCode == 204)
              ? Color(0xFF15803D)
              : const Color(0xFF991B1B),
        ),
      );
    }
  }

  Future<void> _excluirConta() async {
    setState(() => _isLoading = true);
    final sucesso = await _usuarioService.deletarUsuario(_currentUser.id!);
    setState(() => _isLoading = false);

    if (mounted) {
      if (sucesso) {
        // Redireciona para o Início limpando a pilha de navegação
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/inicio', (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao excluir conta. Tente novamente.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // MODAL EXCLUIR
  void _mostrarModalExcluir() {
    final TextEditingController confirmarController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final podeExcluir = confirmarController.text == 'EXCLUIR';

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 24,
              ),
              contentPadding: const EdgeInsets.all(24),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.red.shade700,
                          size: 30,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Excluir conta?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        height: 1.3,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Essa ação é permanente.\n' 
                      ' Seu progresso, conquistas e dados serão apagados e não poderão ser recuperados.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF1E293B),
                        fontSize: 17,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Digite "EXCLUIR" para confirmar:',
                      style: TextStyle(
                        fontSize: 17,
                        height: 1.4,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: confirmarController,
                      textCapitalization: TextCapitalization.characters,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        hintText: 'EXCLUIR',
                        hintStyle: TextStyle(color: Colors.red.shade300),
                        filled: true,
                        fillColor: Colors.red.shade50,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.red.shade200,
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.red.shade200,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.red.shade700,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (_) {
                        setDialogState(() {});
                      },
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              Future.delayed(
                                const Duration(milliseconds: 50),
                                () {
                                  if (context.mounted) {
                                    Navigator.of(dialogContext).pop();
                                  }
                                },
                              );
                            },
                            style: TextButton.styleFrom(
                              minimumSize: const Size(0, 52),
                              backgroundColor: Colors.grey.shade100,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Cancelar',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: ElevatedButton(
                            onPressed: podeExcluir
                                ? () {
                                    Navigator.of(dialogContext).pop();
                                    _excluirConta();
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(0, 52),
                              backgroundColor: const Color(0xFFB91C1C),
                              disabledBackgroundColor: Colors.red.shade200,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Excluir',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 18,
          height: 1.5,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1E3A8A),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller, {
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(
        fontSize: 18,
        height: 1.5,
        color: Color(0xFF1E293B),
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1E3A8A), width: 2),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Color(0xFF1E3A8A), size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF1E3A8A)),
            )
          : Column(
              children: [
                // HEADER AZUL
                Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 8,
                    bottom: 12,
                    left: 16,
                    right: 16,
                  ),
                  color: const Color(0xFF1E3A8A),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 48,
                        child: TextButton(
                          onPressed: () {
                            if(_isEditing) {
                              setState(() {
                                _isEditing = false;
                                _preencherControllers();
                              });
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          style: TextButton.styleFrom(
                            minimumSize: const Size(48,48),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
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
                                color:Color(0xFF1E3A8A),
                                size: 24,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Voltar',
                                style: TextStyle(
                                  color: Color(0xFF1E3A8A),
                                  fontSize: 18,
                                  height: 1.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ]
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // CORPO DA TELA
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 720),
                        child: SizedBox(
                          width: double.infinity,
                          child: _isEditing
                              ? _buildEditMode()
                              : _buildViewMode(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  // --- MODO DE VISUALIZAÇÃO ---
  Widget _buildViewMode() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            _usuario?.nome ?? 'Usuário',
            textAlign: TextAlign.center,
            softWrap: true,
            style: const TextStyle(
              color: Color(0xFF1E3A8A),
              fontSize: 34,
              height: 1.3,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),

        const SizedBox(height: 4),

        const Text(
          'Minha Conta',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            height: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 16),

        SizedBox(
          width: double.infinity,
          child: ButtonCustom(
            label: 'Editar',
            variant: ButtonTipo.neutral,
            onPressed: () {
              setState(() {
                _isEditing = true;
                _preencherControllers();
              });
            },
          ),
        ),

        const SizedBox(height: 16),
        // Card de Informações
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey.shade200, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildInfoRow(
                Icons.person_outline,
                'Nome',
                _usuario?.nome ?? '-',
              ),
              _buildInfoRow(
                Icons.email_outlined,
                'E-mail',
                _usuario?.email ?? '-',
              ),
              _buildInfoRow(
                Icons.smartphone_outlined,
                'Celular',
                _usuario?.celular != null
                    ? _formatarCelular(_usuario!.celular!)
                    : '-',
              ),
              _buildInfoRow(
                Icons.calendar_today_outlined,
                'Data de Nascimento',
                _usuario?.dataNascimento?.toString().split(' ').first ?? '-',
              ),
              _buildInfoRow(
                Icons.person_outline,
                'Gênero',
                _usuario?.genero ?? '-',
              ),

              // Botão Alterar Senha embutido no Card
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () async {
                  final alterouComSucesso = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          AlterarSenhaScreen(usuarioId: _currentUser.id!),
                    ),
                  );

                  if (alterouComSucesso == true && mounted) {
                    _carregarDados();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 4,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.lock_outline,
                          color: Colors.orange.shade700,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'SENHA',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E3A8A),
                                letterSpacing: 0.5,
                              ),
                            ),

                            SizedBox(height: 2),

                            Text(
                              'Alterar senha →',
                              style: TextStyle(
                                fontSize: 18,
                                height: 1.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF991B1B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Atalho Conquistas
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.orange.shade300, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.shade400,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.emoji_events_outlined,
                  color: Colors.orange.shade700,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Minhas Conquistas',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Colors.orange.shade900,
                    ),
                  ),
                  Text(
                    '2 desbloqueadas · Ver todas →',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange.shade700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Botão Excluir Conta
        SizedBox(
          width: double.infinity,
          child: ButtonCustom(
            label: 'Excluir minha conta',
            variant: ButtonTipo.neutral,
            onPressed: _mostrarModalExcluir,
          ),
        ),
      ],
    );
  }

  // --- MODO DE EDIÇÃO ---
  Widget _buildEditMode() {
    return Column(
      children: [
        // Botão para cancelar a edição
        SizedBox(
          width: double.infinity,
          child: ButtonCustom(
            label: 'Cancelar Edição',
            variant: ButtonTipo.neutral,
            onPressed: () {
              setState(() {
                _isEditing = false;
                _preencherControllers();
              });
            },
          ),
        ),
        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.grey.shade200, 
              width: 2
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.edit, 
                    color: Color(0xFF1E3A8A), 
                    size: 20
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Editar informações',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              _buildInputLabel('Nome'),
              _buildTextField(_nomeController),
              const SizedBox(height: 16),

              _buildInputLabel('E-mail'),
              _buildTextField(_emailController),

              const SizedBox(height: 16),

              _buildInputLabel('Celular'),
              InputCustom(
                controller: _celularController,
                hintText: '(11) 9 4444-3333',
                isPhone: true,
              ),

              const SizedBox(height: 16),

              _buildInputLabel('Data de Nascimento'),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  dateOrder: DatePickerDateOrder.dmy,
                  initialDateTime:
                      _dataNascimentoSelecionada ?? DateTime(1960, 6, 15),
                  minimumDate: DateTime(1900, 1, 1),
                  maximumDate: DateTime.now(),
                  onDateTimeChanged: (novaData) {
                    setState(() {
                      _dataNascimentoSelecionada = novaData;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),

              _buildInputLabel('Gênero'),
              const Text(
                'Selecione o seu gênero.',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 10),

              ...[
                'Masculino', 
                'Feminino', 
                'Outro', 
                'Prefiro não informar'
              ].map(
                (gen) {
                  final selecionado = _generoSelecionado == gen;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        setState(() {
                          _generoSelecionado = gen;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          color: selecionado
                              ? const Color(0xFFDBEAFE)
                              : Colors.white,
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
                            fontWeight: selecionado
                                ? FontWeight.bold
                                : FontWeight.w600,
                            color: const Color(0xFF1E3A8A),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,
          child: ButtonCustom(
            label: 'Salvar alterações',
            variant: ButtonTipo.success,
            onPressed: _salvarInformacoes,
          ),
        ),
      ],
    );
  }
}
