class Quiz {
  final String? id;
  final String title;
  final String category;
  final List<Question> questions;

  Quiz({
    this.id,
    required this.title,
    required this.category,
    required this.questions,
  });

  Quiz copyWith({
    String? id,
    String? title,
    String? category,
    List<Question>? questions,
  }) {
    return Quiz(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      questions: questions ?? this.questions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'category': category,
      'questions': questions.map((q) => q.toMap()).toList(),
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