class Jogo {
  final String? id;
  final String userId;
  final List<dynamic> topics;
  final int? difficulty; // Para a requisição de criação

  // Campos da resposta da API
  final DateTime? date;
  final double? score;
  final int? correctAnswers;
  final int? incorrectAnswers;
  final List<String>? questionsIds;

  Jogo({
    this.id,
    required this.userId,
    required this.topics,
    this.difficulty,
    this.date,
    this.score,
    this.correctAnswers,
    this.incorrectAnswers,
    this.questionsIds,
  });

  factory Jogo.fromJson(Map<String, dynamic> json) {
    return Jogo(
      id: json['id'],
      userId: json['userId'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      score: (json['score'] as num?)?.toDouble(),
      correctAnswers: json['correctAnswers'],
      incorrectAnswers: json['incorrectAnswers'],
      questionsIds: json['questionsIds'] != null
          ? List<String>.from(json['questionsIds'])
          : null,
      topics: json['topics'] != null ? List<dynamic>.from(json['topics']) : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'topics': topics,
    'difficulty': difficulty,
  };

  Map<String, dynamic> toResultJson() => {
    'score': score,
    'correctAnswers': correctAnswers,
    'incorrectAnswers': incorrectAnswers,
  };
}
