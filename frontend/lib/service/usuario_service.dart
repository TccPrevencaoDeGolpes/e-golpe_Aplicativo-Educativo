import 'dart:convert';
import '../model/usuario.dart';
//comando no terminal: flutter pub add http
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UsuarioService {
  // Web / Windows: 'http://localhost:8080/usuarios'
  // Android Emulador: 'http://10.0.2.2:8080/usuarios'
  final String _baseUrl = '${dotenv.env['API_URL']}/usuarios';

  //POST - Cadastrar Usuário
  Future<http.Response> cadastrarUsuario(Usuario usuario) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(usuario.toJson()),
    );
    return response;
  }
  //GET - Carregar Usuário por ID
  Future<Usuario?> carregarUsuario(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return Usuario.fromJson(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  //PUT - Alterar Usuário por ID
  Future<http.Response> alterarUsuario(int id, Usuario usuario) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(usuario.toJson()),
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  //PUT - Alterar senha do Usuário
  Future<http.Response> alterarSenha(
    int id,
    String senhaAtual,
    String novaSenha,
  ) async {
    return await http.put(
      Uri.parse('$_baseUrl/$id/senha'),
      headers: {
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'senhaAtual': senhaAtual,
        'novaSenha': novaSenha,
      }),
    );
  }

  //DELETE - Deletar Usuário por ID
  Future<bool> deletarUsuario(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      return false;
    }
  }
}
