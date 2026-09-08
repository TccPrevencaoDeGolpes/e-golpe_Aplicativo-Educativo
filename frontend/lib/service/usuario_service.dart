import 'dart:convert';
import '../model/usuario.dart';
//comando no terminal: flutter pub add http
import 'package:http/http.dart' as http;

class UsuarioService {
  // Web / Windows: 'http://localhost:8080/usuarios'
  // Android Emulador: 'http://10.0.2.2:8080/usuarios'
  final String _baseUrl = 'http://localhost:8080/usuarios';

  //POST - Cadastrar Usuário
  Future<bool> cadastrarUsuario(Usuario usuario) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(usuario.toJson()),
    );

    return response.statusCode == 200 || response.statusCode == 201;
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
  Future<bool> alterarUsuario(int id, Usuario usuario) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(usuario.toJson()),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
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
