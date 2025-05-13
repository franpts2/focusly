import 'package:flutter/material.dart';
import 'package:focusly/view/home/flashcard_deck_view.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:focusly/viewmodel/flashcard_deck_viewmodel.dart';
import 'package:focusly/viewmodel/quiz_viewmodel.dart';
import 'package:focusly/view/home/quiz_deck_view.dart';

import '../../model/category_model.dart';
import '../../model/flashcard_deck_model.dart';
import '../../model/quiz_model.dart';
import '../../viewmodel/category_viewmodel.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Home"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildContinueLearningSection(context, colorScheme),
            _buildQuizzesSection(context, colorScheme),
            _buildFlashcardsSection(context, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueLearningSection(BuildContext context, ColorScheme colorScheme) {
    final flashcardDecks = context.watch<FlashcardDeckViewModel>().decks;
    final quizzes = context.watch<QuizViewModel>().quizzes;

    final items = [
      ...flashcardDecks.map((deck) => {'type': 'flashcard', 'item': deck}),
      ...quizzes.map((quiz) => {'type': 'quiz', 'item': quiz}),
    ];

    // Sort by `lastOpened` in descending order
    items.sort((a, b) {
      final aLastOpened = (a['item'] as dynamic).lastOpened ?? DateTime(0);
      final bLastOpened = (b['item'] as dynamic).lastOpened ?? DateTime(0);
      return bLastOpened.compareTo(aLastOpened);
    });

    return _buildSectionWithContent(
      title: 'Continue Learning...',
      color: colorScheme.primaryContainer,
      icon: Symbols.menu_book,
      textColor: colorScheme.onPrimaryContainer,
      content: items.isEmpty
          ? const Center(child: Text('No recent activity'))
          : ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          if (item['type'] == 'flashcard') {
            final deck = item['item'] as FlashcardDeck;
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FlashcardDeckView(deck: deck),
                  ),
                );
              },
              child: _buildCard(
                deck.title,
                '${deck.flashcards.length} flashcards',
                context,
                category: context.read<CategoryViewModel>().getCategoryById(deck.category), // Ensure this fetches the updated category
              ),
            );
          } else {
            final quiz = item['item'] as Quiz;
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizDeckView(quizDeck: quiz),
                  ),
                );
              },
              child: _buildCard(
                quiz.title,
                '${quiz.questions.length} questions',
                context,
                category: context.read<CategoryViewModel>().getCategoryById(quiz.category),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildQuizzesSection(BuildContext context, ColorScheme colorScheme) {
    final quizzes = context.watch<QuizViewModel>().quizzes;

    return _buildSectionWithContent(
      title: 'Quizzes',
      color: colorScheme.primaryContainer,
      icon: Symbols.quiz,
      textColor: colorScheme.onPrimaryContainer,
      content: quizzes.isEmpty
          ? const Center(child: Text('No quizzes available'))
          : ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: quizzes.length,
        itemBuilder: (context, index) {
          final quizDeck = quizzes[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizDeckView(quizDeck: quizDeck),
                ),
              );
            },
            child: _buildCard(
              quizDeck.title,
              '${quizDeck.questions.length} questions',
              context,
              category: context.read<CategoryViewModel>().getCategoryById(quizDeck.category),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFlashcardsSection(BuildContext context, ColorScheme colorScheme) {
    final flashcardDecks = context.watch<FlashcardDeckViewModel>().decks;

    return _buildSectionWithContent(
      title: 'Flashcards',
      color: colorScheme.primaryContainer,
      icon: Symbols.library_add,
      textColor: colorScheme.onPrimaryContainer,
      content: flashcardDecks.isEmpty
          ? const Center(child: Text('No flashcards available'))
          : ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: flashcardDecks.length,
        itemBuilder: (context, index) {
          final deck = flashcardDecks[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FlashcardDeckView(deck: deck),
                ),
              );
            },
            child: _buildCard(
              deck.title,
              '${deck.flashcards.length} flashcards',
              context,
              category: context.read<CategoryViewModel>().getCategoryById(deck.category),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionWithContent({
    required String title,
    required Color color,
    required IconData icon,
    required Color textColor,
    required Widget content,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 190,
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 24, color: textColor),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(fontSize: 18, color: textColor),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(child: content),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Color color,
    required IconData icon,
    required Color textColor,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 190,
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 24, color: textColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(fontSize: 18, color: textColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String title, String subtitle, BuildContext context, {Category? category}) {
    final cardColor = category?.id == null
        ? Colors.grey.shade300
        : category?.color ?? Colors.grey.shade300;
    final textColor = category?.id == null
        ? Colors.grey.shade600
        : category?.textColor ?? Colors.black;

    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              if (category != null) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(category.icon, size: 16, color: textColor),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        category.title,
                        style: TextStyle(
                          fontSize: 12,
                          color: textColor,
                        ),
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

