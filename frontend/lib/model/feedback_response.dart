class FeedbackResponse {
  final bool correta;
  final String feedback;
  final int alternativaCerta;

  FeedbackResponse({
    required this.correta, 
    required this.feedback, 
    required this.alternativaCerta
  });

  factory FeedbackResponse.fromJson(Map<String, dynamic> json,) {
    return FeedbackResponse(
      correta: json['correta'] ?? false,
      feedback: json['feedback'] ?? '',
      alternativaCerta: json['alternativaCerta'] ?? 0,
    );
  }
}