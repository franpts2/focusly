import 'package:flutter/material.dart';
import 'package:focusly/view/home/flashcard_deck_view.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:focusly/viewmodel/flashcard_deck_viewmodel.dart';
import 'package:focusly/viewmodel/quiz_viewmodel.dart';

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
            _buildSection(
              title: 'Continue Learning...',
              color: colorScheme.primaryContainer,
              icon: Symbols.menu_book,
              textColor: colorScheme.onPrimaryContainer,
            ),
            _buildQuizzesSection(context, colorScheme),
            _buildFlashcardsSection(context, colorScheme),
          ],
        ),
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
                final quiz = quizzes[index];
                return Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 12),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            quiz.title,
                            style: Theme.of(context).textTheme.titleMedium,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${quiz.questions.length} questions',
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
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
                  child: Container(
                    width: 140,
                    margin: const EdgeInsets.only(right: 12),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              deck.title,
                              style: Theme.of(context).textTheme.titleMedium,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${deck.flashcards.length} flashcards',
                              style: Theme.of(context).textTheme.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
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
}

