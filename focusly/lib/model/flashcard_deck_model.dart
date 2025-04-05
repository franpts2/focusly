class FlashcardDeck {
  final String? id;
  final String title;
  final String category;
  final List<Flashcard> flashcards;

  FlashcardDeck({
    this.id,
    required this.title,
    required this.category,
    required this.flashcards,
  });

  FlashcardDeck copyWith({
    String? id,
    String? title,
    String? category,
    List<Flashcard>? flashcards,
  }) {
    return FlashcardDeck(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      flashcards: flashcards ?? this.flashcards,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'category': category,
      'flashcards': flashcards.map((f) => f.toMap()).toList(),
    };
  }

  factory FlashcardDeck.fromJson(Map<String, dynamic> json) {
    return FlashcardDeck(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      flashcards: (json['flashcards'] as List)
          .map((f) => Flashcard.fromMap(f))
          .toList(),
    );
  }
}

class Flashcard {
  final String front;
  final String back;

  Flashcard({
    required this.front,
    required this.back,
  });

  Map<String, dynamic> toMap() {
    return {
      'front': front,
      'back': back,
    };
  }

  factory Flashcard.fromMap(Map<String, dynamic> map) {
    return Flashcard(
      front: map['front'] ?? '',
      back: map['back'] ?? '',
    );
  }

  Flashcard copyWith({
    String? front,
    String? back,
  }) {
    return Flashcard(
      front: front ?? this.front,
      back: back ?? this.back,
    );
  }
}