import 'package:flutter/material.dart';
import 'package:focusly/view/create/create_view_add_flashcard_deck.dart';
import 'package:focusly/view/create/create_view_edit_flashcard_deck.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../model/category_model.dart';
import '../../viewmodel/category_viewmodel.dart';
import 'create_view_add_quiz.dart';
import 'package:provider/provider.dart';
import 'package:focusly/viewmodel/flashcard_deck_viewmodel.dart';
import 'package:focusly/viewmodel/quiz_viewmodel.dart';
import 'package:focusly/view/create/create_view_edit_quiz.dart';

class CreateView extends StatelessWidget {
  const CreateView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final quizzes = context.watch<QuizViewModel>().quizzes;

    return Scaffold(
      appBar: AppBar(title: const Text("Create"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Symbols.add_circle),
                SizedBox(width: 8),
                Text('Add', style: TextStyle(fontSize: 22)),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildCreationCard(
                    icon: Symbols.library_add,
                    title: 'Flashcards',
                    description: 'Boost your memory with cards',
                    color: colorScheme.primaryContainer,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateViewAddFlashcardDeck(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildCreationCard(
                    icon: Symbols.quiz,
                    title: 'Quiz',
                    description: 'Test your knowledge',
                    color: colorScheme.primaryContainer,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateViewAddQuiz(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            const Row(
              children: [
                Icon(Symbols.edit),
                SizedBox(width: 8),
                Text('Edit', style: TextStyle(fontSize: 22)),
              ],
            ),
            const SizedBox(height: 16),

            _buildFlashcardsSection(context, colorScheme),
            const SizedBox(height: 16),

            _buildQuizzesSection(context, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildCreationCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 170, // Fixed height for consistency
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          color: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        title,
                        style: const TextStyle(fontSize: 18),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: Text(
                    description,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black54, fontSize: 14,),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditableItem({
    required String title,
    required double height,
    required Color color,
    required List<dynamic> items, // Accepts either flashcards or quizzes
    required Widget Function(dynamic item) builder, // Builder for rendering items
  }) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 12),
              if (items.isEmpty)
                const Expanded(
                  child: Center(child: Text('No items available')),
                )
              else
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return builder(items[index]);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlashcardsSection(BuildContext context, ColorScheme colorScheme) {
    final flashcardDecks = context.watch<FlashcardDeckViewModel>().decks;

    return _buildEditableItem(
      title: 'My Flashcards',
      height: 190,
      color: colorScheme.primaryContainer,
      items: flashcardDecks,
      builder: (deck) {
        final category = context.read<CategoryViewModel>().getCategoryById(deck.category);
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateViewEditFlashcardDeck(deck: deck),
              ),
            );
          },
          child: _buildCategoryCard(
            deck.title,
            '${deck.flashcards.length} flashcards',
            context,
            category: category,
          ),
        );
      },
    );
  }

  Widget _buildQuizzesSection(BuildContext context, ColorScheme colorScheme) {
    final quizzes = context.watch<QuizViewModel>().quizzes;

    return _buildEditableItem(
      title: 'My Quizzes',
      height: 190,
      color: colorScheme.primaryContainer,
      items: quizzes,
      builder: (quiz) {
        final category = context.read<CategoryViewModel>().getCategoryById(quiz.category);
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateViewEditQuiz(quiz: quiz),
              ),
            );
          },
          child: _buildCategoryCard(
            quiz.title,
            '${quiz.questions.length} questions',
            context,
            category: category,
          ),
        );
      },
    );
  }

  Widget _buildCategoryCard(String title, String subtitle, BuildContext context, {Category? category}) {
    final cardColor = category?.color ?? Colors.grey.shade300; // Default to light gray
    final textColor = category?.textColor ?? Colors.black; // Default to black

    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0), // Compact padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, // Center title and count
            children: [
              // Title
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500, // Match edit page weight
                  color: Colors.black, // Title in black
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2, // Prevent overflow
              ),
              const SizedBox(height: 6), // Reduced spacing
              // Subtitle (e.g., "5 questions")
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black, // Subtitle in black
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8), // Reduced spacing
              // Category Icon and Name
              if (category != null) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(category.icon, size: 16, color: textColor),
                    const SizedBox(width: 4), // Closer spacing between icon and text
                    Expanded(
                      child: Text(
                        category.title,
                        style: TextStyle(
                          fontSize: 12,
                          color: textColor,
                        ),
                        textAlign: TextAlign.start, // Align category name to the left
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