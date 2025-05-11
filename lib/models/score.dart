class Score {
  final String category;
  final String difficulty;
  final int score;
  final int totalQuestions;
  final DateTime dateTime;

  Score({
    required this.category,
    required this.difficulty,
    required this.score,
    required this.totalQuestions,
    required this.dateTime,
  });

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      category: json['category'],
      difficulty: json['difficulty'],
      score: json['score'],
      totalQuestions: json['totalQuestions'],
      dateTime: DateTime.parse(json['dateTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'difficulty': difficulty,
      'score': score,
      'totalQuestions': totalQuestions,
      'dateTime': dateTime.toIso8601String(),
    };
  }
}