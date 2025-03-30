import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;  // Get the color scheme

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
              textColor: colorScheme.onPrimaryContainer,  // Pass the secondary color for text and icons
            ),
            _buildSection(
              title: 'Quizzes',
              color: colorScheme.primaryContainer,
              icon: Symbols.quiz,
              textColor: colorScheme.onPrimaryContainer,  // Pass the secondary color for text and icons
            ),
            _buildSection(
              title: 'Flashcards',
              color: colorScheme.primaryContainer,
              icon: Symbols.library_add,
              textColor: colorScheme.onPrimaryContainer,  // Pass the secondary color for text and icons
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Color color,
    required IconData icon,
    required Color textColor,  // Added textColor parameter
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
              Icon(icon, size: 24, color: textColor),  // Set the icon color
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(fontSize: 18, color: textColor),  // Set the text color
              ),
            ],
          ),
        ),
      ),
    );
  }
}
