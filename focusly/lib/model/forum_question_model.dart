class ForumQuestion {
  final String? id;
  final String title;
  final String description;
  final DateTime createdAt;
  final int answerCount;
  final String userName; // New field
  final String? userPhotoUrl; // Optional field

  ForumQuestion({
    this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.answerCount = 0,
    required this.userName, // Make userName required
    this.userPhotoUrl,
  });

  ForumQuestion copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    int? answerCount,
    String? userName,
    String? userPhotoUrl,
  }) {
    return ForumQuestion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      answerCount: answerCount ?? this.answerCount,
      userName: userName ?? this.userName,
      userPhotoUrl: userPhotoUrl ?? this.userPhotoUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'answerCount': answerCount,
      'userName': userName, // Save userName
      'userPhotoUrl': userPhotoUrl, // Save userPhotoUrl
    };
  }

  factory ForumQuestion.fromJson(Map<String, dynamic> json) {
    return ForumQuestion(
      id: json['id'] ?? '', // Default to an empty string if null
      title: json['title'] ?? 'Untitled', // Default to 'Untitled' if null
      description: json['description'] ?? 'No description provided', // Default description
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(), // Default to current time if null
      answerCount: json['answerCount'] ?? 0, // Default to 0 if null
      userName: json['userName'] ?? 'Anonymous', // Default to 'Anonymous' if null
      userPhotoUrl: json['userPhotoUrl'], // Allow null for optional fields
    );
  }
}