import 'package:flutter/material.dart';
import 'package:frontend/components/button_custom.dart';
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

  // Simulação do ID do usuário logado (Em um app real, viria do provider/sessão)
  late Usuario _currentUser;
  Usuario? _usuario;

  // Controllers para edição de informações
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _celularController = TextEditingController();
  final TextEditingController _dataNascController = TextEditingController();
  final TextEditingController _generoController = TextEditingController();

  // Controllers para alterar senha
  final TextEditingController _senhaAtualController = TextEditingController();
  final TextEditingController _novaSenhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final usuario = ModalRoute.of(context)!.settings.arguments as Usuario;

    _currentUser = usuario;

    _carregarDados();
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
    _celularController.text = _usuario!.celular ?? '';
    _dataNascController.text = _usuario!.dataNascimento != null
        ? _usuario!.dataNascimento.toString().split(' ').first
        : '';
    _generoController.text = _usuario!.genero ?? '';
  }

  Future<void> _salvarInformacoes() async {
    if (_usuario == null) return;

    setState(() => _isLoading = true);

    // Atualiza o objeto local com os dados dos controllers
    _usuario!.nome = _nomeController.text;
    _usuario!.email = _emailController.text;
    _usuario!.celular = _celularController.text;
    _usuario!.dataNascimento = DateTime.parse(_dataNascController.text);
    _usuario!.genero = _generoController.text;

    final sucesso = await _usuarioService.alterarUsuario(
      _currentUser.id!,
      _usuario!,
    );

    setState(() {
      _isLoading = false;
      if (sucesso) _isEditing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            sucesso
                ? 'Informações salvas com sucesso!'
                : 'Erro ao salvar informações.',
            style: const TextStyle(
              fontSize: 18,
              height: 1.4,
              color: Colors.white,
            ),
          ),
          backgroundColor: sucesso
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

  void _mostrarModalExcluir() {
    final TextEditingController confirmarController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Excluir conta?',
                style: TextStyle(
                  fontSize: 28,
                  height: 1.4,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Essa ação é permanente. Todo o seu progresso, conquistas e dados serão apagados e não poderão ser recuperados.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF1E293B),
                  fontSize: 18,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Digite "EXCLUIR" para confirmar:',
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.4,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: confirmarController,
                decoration: InputDecoration(
                  hintText: 'EXCLUIR',
                  hintStyle: TextStyle(color: Colors.red.shade200),
                  filled: true,
                  fillColor: Colors.red.shade50,
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
                ),
                onChanged: (val) => (context as Element)
                    .markNeedsBuild(), // Atualiza estado local
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey.shade100,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: confirmarController.text == 'EXCLUIR'
                          ? () {
                              Navigator.pop(context);
                              _excluirConta();
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        disabledBackgroundColor: Colors.red.shade200,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Excluir',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _mostrarModalSenha() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '🔑 Alterar senha',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey.shade100,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildInputLabel('Senha atual'),
              _buildTextField(_senhaAtualController, isPassword: true),
              const SizedBox(height: 16),
              _buildInputLabel('Nova senha (mínimo 6 caracteres)'),
              _buildTextField(_novaSenhaController, isPassword: true),
              const SizedBox(height: 16),
              _buildInputLabel('Confirmar nova senha'),
              _buildTextField(_confirmarSenhaController, isPassword: true),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ButtonCustom(
                  label: 'Salvar nova senha',
                  variant: ButtonTipo.primary,
                  onPressed: () {
                    // Aqui você chamaria o PUT apenas para a senha
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Senha atualizada com sucesso!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
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
                    color: Color(0xFF475569),
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
                    color: Color(0xFF1E293B),
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
                    top: MediaQuery.of(context).padding.top + 16,
                    bottom: 20,
                    left: 16,
                    right: 16,
                  ),
                  color: const Color(0xFF1E3A8A),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 48,
                            height: 48,
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.chevron_left,
                                color: Colors.white,
                                size: 32,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.white10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _usuario?.nome ?? 'Usuário',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          height: 1.4,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Text(
                        'Minha Conta',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          height: 1.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // BOTAO EDITAR/CANCELAR
                      SizedBox(
                        width: double.infinity,
                        child: ButtonCustom(
                          label: _isEditing ? 'Cancelar Edição' : 'Editar',
                          variant: ButtonTipo.neutral,
                          onPressed: () {
                            setState(() {
                              _isEditing = !_isEditing;
                              if (_isEditing) _preencherControllers();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // CORPO DA TELA
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: _isEditing ? _buildEditMode() : _buildViewMode(),
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
                _usuario?.celular ?? '-',
              ),
              _buildInfoRow(
                Icons.calendar_today_outlined,
                'Data de Nascimento',
                _usuario?.dataNascimento?.toString().split(' ').first ?? '-',
              ),

              // Botão Alterar Senha embutido no Card
              InkWell(
                onTap: _mostrarModalSenha,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.lock_outline,
                          color: Colors.orange.shade700,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SENHA',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black45,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Alterar senha →',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ],
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
          child: OutlinedButton.icon(
            onPressed: _mostrarModalExcluir,
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            label: const Text(
              'Excluir minha conta',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.red.shade50,
              side: BorderSide(color: Colors.red.shade200, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- MODO DE EDIÇÃO ---
  Widget _buildEditMode() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey.shade200, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.edit, color: Color(0xFF1E3A8A), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Editar informações',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E3A8A),
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
              _buildTextField(_celularController),
              const SizedBox(height: 16),

              _buildInputLabel('Data de Nascimento'),
              _buildTextField(_dataNascController),
              const SizedBox(height: 16),

              _buildInputLabel('Gênero'),
              _buildTextField(_generoController),
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
