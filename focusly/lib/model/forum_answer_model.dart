class ForumAnswer {
  final String? id;
  final String description;
  final DateTime createdAt;
  final String userName;
  final String? userPhotoUrl;
  final String questionID; // Track which question this answer belongs to

  ForumAnswer({
    this.id,
    required this.description,
    required this.createdAt,
    required this.userName,
    this.userPhotoUrl,
    required this.questionID, 
  });

  ForumAnswer copyWith({
    String? id,
    String? description,
    DateTime? createdAt,
    String? userName,
    String? userPhotoUrl,
    String? questionID,
  }) {
    return ForumAnswer(
      id: id ?? this.id,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      userName: userName ?? this.userName,
      userPhotoUrl: userPhotoUrl ?? this.userPhotoUrl,
      questionID: questionID ?? this.questionID,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'userName': userName,
      'userPhotoUrl': userPhotoUrl,
      'questionID': questionID,
    };
  }

  factory ForumAnswer.fromJson(Map<String, dynamic> json) {
    return ForumAnswer(
      id: json['id'] ?? '',
      description: json['description'] ?? 'No description provided',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      userName: json['userName'] ?? 'Anonymous',
      userPhotoUrl: json['userPhotoUrl'],
      questionID: json['questionID'] ?? '', // Default to empty string if null
    );
  }
}