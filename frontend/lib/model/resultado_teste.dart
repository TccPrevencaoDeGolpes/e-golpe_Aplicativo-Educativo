class ResultadoTeste {
  final int usuarioId;
  final int? testeId;
  final int totalPerguntas;
  final int acertos;
  final int erros;
  final double porcentagem;

  ResultadoTeste({
    required this.usuarioId,
    required this.testeId, 
    required this.totalPerguntas, 
    required this.acertos, 
    required this.erros, 
    required this.porcentagem
  });

  Map<String, dynamic> toJson() => {
        'usuarioId': usuarioId,
        'testeId': testeId,
        'totalPerguntas': totalPerguntas,
        'acertos': acertos,
        'erros': erros,
        'porcentagem': porcentagem,
      };

}