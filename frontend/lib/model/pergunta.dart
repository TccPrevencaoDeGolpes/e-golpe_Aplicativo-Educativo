class Pergunta {
  final int id;
  final String enunciado;
  final String? remetente;
  final String? mensagem;
  final List<String> alternativas;
  final int? alternativaCerta;
  final List<String> feedbacks;
  final String? tema;
  final String tipoPergunta;

  Pergunta({
    required this.id,
    required this.enunciado,
    this.remetente,
    this.mensagem,
    required this.alternativas,
    this.alternativaCerta,
    required this.feedbacks,
    this.tema,
    required this.tipoPergunta,
  });

  factory Pergunta.fromJson(Map<String, dynamic> json) {
    return Pergunta(
      id: json['id'] ?? 0, 
      enunciado: json['enunciado'] ?? '',
      remetente: json['remetente'],
      mensagem: json['mensagem'], 
      alternativas: List<String>.from(
        json['alternativas'] ?? [],
      ),
      alternativaCerta: json['alternativaCerta'], 
      feedbacks: List<String>.from(
        json['feedbacks'] ?? [], 
      ),
      tema: json['tema'], 
      tipoPergunta: json['tipoPergunta'] ?? '',
    );
  }

}