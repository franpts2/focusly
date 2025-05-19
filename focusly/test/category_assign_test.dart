import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/model/category_model.dart';
import 'package:focusly/model/flashcard_deck_model.dart';
import 'package:focusly/model/quiz_model.dart';

void main() {
  group('Category Assignment Tests', () {
    final testCategory = Category(
      id: 'cat-1',
      title: 'Science',
      color: Colors.blue,
      textColor: Colors.white,
      icon: Icons.science,
    );

    test('Assign category to flashcard deck at creation', () {
      final deck = FlashcardDeck(
        id: 'deck-1',
        title: 'Physics Basics',
        category: testCategory.id!,
        flashcards: [
          Flashcard(front: 'What is force?', back: 'Mass x Acceleration'),
        ],
      );
      expect(deck.category, testCategory.id);
    });

    test('Assign category to quiz at creation', () {
      final quiz = Quiz(
        id: 'quiz-1',
        title: 'Physics Quiz',
        category: testCategory.id!,
        questions: [
          Question(
            questionText: 'What is gravity?',
            options: ['Force', 'Energy', 'Mass', 'Speed'],
            correctAnswer: 'Force',
          ),
        ],
      );
      expect(quiz.category, testCategory.id);
    });

    test('Edit category of flashcard deck', () {
      final deck = FlashcardDeck(
        id: 'deck-2',
        title: 'Chemistry Basics',
        category: 'old-cat',
        flashcards: [],
      );
      final updatedDeck = deck.copyWith(category: testCategory.id);
      expect(updatedDeck.category, testCategory.id);
    });

    test('Edit category of quiz', () {
      final quiz = Quiz(
        id: 'quiz-2',
        title: 'Chemistry Quiz',
        category: 'old-cat',
        questions: [],
      );
      final updatedQuiz = quiz.copyWith(category: testCategory.id);
      expect(updatedQuiz.category, testCategory.id);
    });

    testWidgets('Flashcard deck displays correct color and icon in HomeView', (WidgetTester tester) async {
      final deck = FlashcardDeck(
        id: 'deck-3',
        title: 'Biology Basics',
        category: testCategory.id!,
        flashcards: [Flashcard(front: 'Cell?', back: 'Basic unit of life')],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Card(
            color: testCategory.color,
            child: Row(
              children: [
                Icon(testCategory.icon, color: testCategory.textColor),
                Text(deck.title, style: TextStyle(color: testCategory.textColor)),
              ],
            ),
          ),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.color, testCategory.color);
      expect(find.byIcon(testCategory.icon), findsOneWidget);
    });

    testWidgets('Quiz displays correct color and icon in HomeView', (WidgetTester tester) async {
      final quiz = Quiz(
        id: 'quiz-3',
        title: 'Biology Quiz',
        category: testCategory.id!,
        questions: [
          Question(
            questionText: 'What is DNA?',
            options: ['Protein', 'Acid', 'Sugar', 'Base'],
            correctAnswer: 'Acid',
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Card(
            color: testCategory.color,
            child: Row(
              children: [
                Icon(testCategory.icon, color: testCategory.textColor),
                Text(quiz.title, style: TextStyle(color: testCategory.textColor)),
              ],
            ),
          ),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.color, testCategory.color);
      expect(find.byIcon(testCategory.icon), findsOneWidget);
    });

    testWidgets('Flashcard deck displays correct color and icon in Create/Edit page', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Card(
            color: testCategory.color,
            child: Row(
              children: [
                Icon(testCategory.icon, color: testCategory.textColor),
                const Text('Edit Deck', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
      );
      final card = tester.widget<Card>(find.byType(Card));
      expect(card.color, testCategory.color);
      expect(find.byIcon(testCategory.icon), findsOneWidget);
    });

    testWidgets('Quiz displays correct color and icon in Create/Edit page', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Card(
            color: testCategory.color,
            child: Row(
              children: [
                Icon(testCategory.icon, color: testCategory.textColor),
                const Text('Edit Quiz', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
      );
      final card = tester.widget<Card>(find.byType(Card));
      expect(card.color, testCategory.color);
      expect(find.byIcon(testCategory.icon), findsOneWidget);
    });
  });
}