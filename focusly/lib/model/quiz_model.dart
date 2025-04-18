class Quiz {
  final String? id;
  final String title;
  final String category;
  final List<Question> questions;
  final DateTime? lastOpened; // Add this property

  Quiz({
    this.id,
    required this.title,
    required this.category,
    required this.questions,
    this.lastOpened,
  });

  Quiz copyWith({
    String? id,
    String? title,
    String? category,
    List<Question>? questions,
    DateTime? lastOpened,
  }) {
    return Quiz(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      questions: questions ?? this.questions,
      lastOpened: lastOpened ?? this.lastOpened,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'category': category,
      'questions': questions.map((q) => q.toMap()).toList(),
      'lastOpened': lastOpened?.toIso8601String(),
    };
  }

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      questions: (json['questions'] as List)
          .map((q) => Question.fromMap(q))
          .toList(),
      lastOpened: json['lastOpened'] != null
          ? DateTime.parse(json['lastOpened'])
          : null,
    );
  }
}

class Question {
  final String questionText;
  final String correctAnswer;
  final List<String> options;

  Question({
    required this.questionText,
    required this.correctAnswer,
    required this.options,
  });

  Map<String, dynamic> toMap() {
    return {
      'question': questionText,
      'answer': correctAnswer,
      'options': options,
    };
  }

  // Create a Question from a Map
  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      questionText: map['question'] ?? '',
      correctAnswer: map['answer'] ?? '',
      options: List<String>.from(map['options'] ?? []),
    );
  }

  // Helper method to create a copy of the question with updated values
  Question copyWith({
    String? questionText,
    String? correctAnswer,
    List<String>? options,
  }) {
    return Question(
      questionText: questionText ?? this.questionText,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      options: options ?? this.options,
    );
  }
}