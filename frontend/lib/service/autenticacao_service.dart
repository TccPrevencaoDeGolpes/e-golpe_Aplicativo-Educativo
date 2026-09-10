import 'dart:convert';
import '../model/usuario.dart';
//comando no terminal: flutter pub add http
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AutenticacaoService {
  // Web / Windows: 'http://localhost:8080/usuarios/login'
  // Android Emulador: 'http://10.0.2.2:8080/usuarios/login'
  final String _baseUrl = '${dotenv.env['API_URL']}/usuarios/login';


  /// Realiza a autenticação do usuário.
  /// Retorna o objeto [Usuario] se as credenciais forem válidas,
  /// ou `null` caso haja falha
  Future<Usuario?> fazerLogin(String login, String senha) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'login': login, // pode ser e-mail ou número de celular
          'senha': senha,
        }),
      );

      // Status 200 OK indica sucesso na autenticação
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return Usuario.fromJson(data);
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }
}