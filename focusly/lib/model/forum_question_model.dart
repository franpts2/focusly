class ForumQuestion {
  final String title;
  final String description;
  final DateTime createdAt;

  ForumQuestion({
    required this.title,
    required this.description,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'createdAt': createdAt.toUtc(),
    };
  }

  factory ForumQuestion.fromJson(Map<String, dynamic> json) {
    return ForumQuestion(
      title: json['title'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}