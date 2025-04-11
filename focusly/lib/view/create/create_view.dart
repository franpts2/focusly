import 'package:flutter/material.dart';
import 'package:focusly/view/create/create_view_add_flashcard_deck.dart';
import 'package:focusly/view/create/create_view_edit_flashcard_deck.dart';
import 'package:material_symbols_icons/symbols.dart';
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
    final flashcardDecks = context.watch<FlashcardDeckViewModel>().decks;
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

            _buildEditableItem(
              title: 'My Flashcards',
              height: 190,
              color: colorScheme.primaryContainer,
              items: flashcardDecks,
              itemType: 'flashcards',
            ),
            const SizedBox(height: 16),

            _buildEditableItem(
              title: 'My Quizzes',
              height: 190,
              color: colorScheme.primaryContainer,
              items: quizzes,
              itemType: 'quizzes',
            ),
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
    required String itemType, // Specify "flashcards" or "quizzes"
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
                      final item = items[index];
                      return Container(
                        width: 140,
                        margin: const EdgeInsets.only(right: 12),
                        child: GestureDetector(
                          onTap: () {
                            itemType == 'quizzes'
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CreateViewEditQuiz(quiz: item),),)
                            : ();
                            itemType == 'flashcards'
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CreateViewEditFlashcardDeck(),),)
                            : ();
                          },
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
                                    item.title,
                                    style: Theme.of(context).textTheme.titleMedium,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    itemType == 'flashcards'
                                        ? '${item.flashcards.length} flashcards'
                                        : '${item.questions.length} questions',
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
                ),
            ],
          ),
        ),
      ),
    );
  }
}