class ForumQuestion {
  final String? id;
  final String title;
  final String description;
  final DateTime createdAt;
  final int answerCount;

  ForumQuestion({
    this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.answerCount = 0, // ainda nao sei se isto depois funciona... quem fizer as answers vai descobrir
  });

  ForumQuestion copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    int? answerCount,
  }) {
    return ForumQuestion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      answerCount: answerCount ?? this.answerCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'answerCount': answerCount,
    };
  }

  factory ForumQuestion.fromJson(Map<String, dynamic> json) {
    return ForumQuestion(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      answerCount: json['answerCount'] ?? 0,
    );
  }
}