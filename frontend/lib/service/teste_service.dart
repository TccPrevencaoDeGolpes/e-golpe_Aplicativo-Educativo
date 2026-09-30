import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/model/feedback_response.dart';
import 'package:frontend/model/pergunta.dart';
import 'package:frontend/model/resultado_teste.dart';
import 'package:frontend/model/teste.dart';
import 'package:http/http.dart' as http;

class TesteService {
  final String _baseUrl = '${dotenv.env['API_URL']}/testes';

  //GET Listar testes
  Future<List<Teste>> listarTestes() async {
    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => Teste.fromJson(item)).toList();
      }
      throw Exception('Falha ao carregar testes do servidor');
    } catch (e) {
      throw Exception('Erro ao carregar testes: $e');
    }
  }

  //GET - Buscar perguntas
  Future<List<Pergunta>> buscarPerguntasDoTeste(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$id/perguntas'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        return data.map((item) => Pergunta.fromJson(item)).toList();
      }
      throw Exception('Falha ao carregar perguntas do teste');
    } catch (e) {
      throw Exception('Erro ao carregar perguntas: $e');
    }
  }

  //POST - CRIAR TESTE PERSONALIZADO
  Future<List<Pergunta>> criarTestePersonalizado(
    int quantidadePerguntas,
    String? tema,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/personalizado'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'quantidadePerguntas': quantidadePerguntas,
          'tema': tema,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = jsonDecode(response.body);

        if (data.isEmpty) {
          throw Exception('Perguntas insuficientes');
        }

        return data.map((item) => Pergunta.fromJson(item)).toList();
      }
      throw Exception(
        response.body.isNotEmpty ? response.body : 'Não existem perguntas suficientes para a quantidade e o tema selecionados.',
      );
    } catch (e) {
      throw Exception('Erro ao criar teste personalizado: $e');
    }
  }

  
  // POST - Responder Pergunta
  Future<FeedbackResponse> responderPergunta(
    int perguntaId,
    int alternativaSelecionada,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/pergunta/responder'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'perguntaId': perguntaId,
          'alternativaSelecionada': alternativaSelecionada,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        return FeedbackResponse.fromJson(data);
      }

      throw Exception('Erro ao processar resposta');
    } catch (e) {
      throw Exception('Erro ao responder pergunta: $e');
    }
  }

  // POST - Salvar Resultado
  Future<bool> salvarResultado(ResultadoTeste resultado) async {
    try {
      final response = await http.post(
        Uri.parse('${dotenv.env['API_URL']}/resultados'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(resultado.toJson()),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      throw Exception('Erro ao salvar resultado: $e');
    }
  }
}
