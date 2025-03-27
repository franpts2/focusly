import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'create_view_add_quiz.dart';

class CreateView extends StatelessWidget {
  const CreateView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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

            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 200, // Prevent vertical overflow
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCreationCard(
                      icon: Symbols.library_add,
                      title: 'Flashcards',
                      description: 'Boost your memory with cards',
                      color: colorScheme.primaryContainer,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateViewAddQuiz(), // Change to flashcards page
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    _buildCreationCard(
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
                  ],
                ),
              ),
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
            ),
            const SizedBox(height: 16),

            _buildEditableItem(
              title: 'My Quizzes',
              height: 190,
              color: colorScheme.primaryContainer,
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
      width: 170,
      height: 170,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon),
                    const SizedBox(width: 8),
                    Flexible(  // Prevents text overflow
                      child: Text(
                        title,
                        style: const TextStyle(fontSize: 18),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: Text(
                    description,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                    maxLines: 2,  // Limits to 2 lines
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      )

    );
  }

  Widget _buildEditableItem({
    required String title,
    required double height,
    required Color color,
  }) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 18),
              ),
              // add content here
            ],
          ),
        ),
      ),
    );
  }
}