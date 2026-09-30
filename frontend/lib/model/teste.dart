

enum StatusTeste {concluido, disponivel, bloqueado}

class Teste {
  final int id;
  final String titulo;
  final String descricao;
  final int quantidadePerguntas;
  final StatusTeste status;

  
  Teste({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.quantidadePerguntas,
    required this.status,
  });

  //Factory -> receber dados da API
  factory Teste.fromJson(Map<String, dynamic> json) {
    return Teste(
      id: json['id'] ?? 0,
      titulo: json['titulo'] ?? '',
      descricao: json['descricao'] ?? '',
      quantidadePerguntas: json['quantidadePerguntas'] ?? 0,
      status: _parseStatus(json['status']),
    );
  }

  static StatusTeste _parseStatus(String? statusStr){
    switch (statusStr?.toUpperCase()) {
      case 'CONCLUIDO':
        return StatusTeste.concluido;
      case 'BLOQUEADO':
        return StatusTeste.bloqueado;
      default:
        return StatusTeste.disponivel;
    }
  }
}