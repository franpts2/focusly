import 'package:flutter/material.dart';
import 'package:focusly/model/category_model.dart';
import 'package:focusly/model/flashcard_deck_model.dart';
import 'package:focusly/model/quiz_model.dart';
import 'package:focusly/view/home/flashcard_deck_view.dart';
import 'package:focusly/view/home/quiz_deck_view.dart';
import 'package:focusly/viewmodel/flashcard_deck_viewmodel.dart';
import 'package:focusly/viewmodel/quiz_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'dart:math';

class CategoryContentView extends StatefulWidget {
  final Category category;

  const CategoryContentView({super.key, required this.category});

  @override
  State<CategoryContentView> createState() => _CategoryContentViewState();
}

class _CategoryContentViewState extends State<CategoryContentView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openRandomLearningMaterial(BuildContext context) {
    final flashcardViewModel = Provider.of<FlashcardDeckViewModel>(
      context,
      listen: false,
    );
    final quizViewModel = Provider.of<QuizViewModel>(context, listen: false);

    final flashcardDecks =
        flashcardViewModel.decks
            .where((deck) => deck.category == widget.category.id)
            .toList();

    final quizzes =
        quizViewModel.quizzes
            .where((quiz) => quiz.category == widget.category.id)
            .toList();

    // Check if there are any items to choose from
    if (flashcardDecks.isEmpty && quizzes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No learning materials available in this category'),
        ),
      );
      return;
    }

    // Create a combined list of all learning material types
    final allLearningItems = [
      ...flashcardDecks.map((deck) => {'type': 'flashcard', 'item': deck}),
      ...quizzes.map((quiz) => {'type': 'quiz', 'item': quiz}),
    ];

    // Randomly select an item
    final random = Random();
    final randomItem =
        allLearningItems[random.nextInt(allLearningItems.length)];

    // Navigate to the appropriate view based on the item type
    if (randomItem['type'] == 'flashcard') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
                  FlashcardDeckView(deck: randomItem['item'] as FlashcardDeck),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => QuizDeckView(quizDeck: randomItem['item'] as Quiz),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.title),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: widget.category.textColor,
        bottom: TabBar(
          controller: _tabController,
          labelColor: widget.category.textColor,
          unselectedLabelColor: widget.category.textColor,
          indicatorColor: widget.category.textColor,
          tabs: const [Tab(text: 'Flashcards'), Tab(text: 'Quizzes')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Flashcards tab
          FlashcardsTabView(
            categoryId: widget.category.id!,
            categoryColor: widget.category.color,
            categoryTextColor: widget.category.textColor,
          ),

          // Quizzes tab
          QuizzesTabView(
            categoryId: widget.category.id!,
            categoryColor: widget.category.color,
            categoryTextColor: widget.category.textColor,
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: FloatingActionButton.extended(
          onPressed: () => _openRandomLearningMaterial(context),
          backgroundColor: widget.category.textColor,
          foregroundColor: widget.category.color,
          label: const Text(
            'LEARN',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          icon: const Icon(Symbols.play_arrow),
          heroTag: 'categoryLearnButton',
        ),
      ),
    );
  }
}

Widget _buildCard<T>({
  required BuildContext context,
  required T item,
  required String title,
  required int itemCount,
  required Color cardColor,
  required Color textColor,
  required IconData icon,
  required Color iconColor,
  required Function(BuildContext, T) onTap,
}) {
  return Card(
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    color: cardColor,
    child: InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => onTap(context, item),
      child: Stack(
        children: [
          // Main content - centered title
          Positioned.fill(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),

          // Bottom right - count and icon
          Positioned(
            bottom: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: cardColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$itemCount',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: iconColor,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(icon, color: iconColor, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class FlashcardsTabView extends StatelessWidget {
  final String categoryId;
  final Color categoryColor;
  final Color categoryTextColor;

  const FlashcardsTabView({
    super.key,
    required this.categoryId,
    required this.categoryColor,
    required this.categoryTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final flashcardViewModel = Provider.of<FlashcardDeckViewModel>(context);
    final flashcardDecks =
        flashcardViewModel.decks
            .where((deck) => deck.category == categoryId)
            .toList();

    if (flashcardDecks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Symbols.library_books, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No flashcards in this category',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.0,
        ),
        itemCount: flashcardDecks.length,
        itemBuilder: (context, index) {
          final deck = flashcardDecks[index];
          return _buildCard<FlashcardDeck>(
            context: context,
            item: deck,
            title: deck.title,
            itemCount: deck.flashcards.length,
            cardColor: categoryColor,
            textColor: categoryTextColor,
            icon: Symbols.library_books,
            iconColor: Theme.of(context).colorScheme.primary,
            onTap: (context, deck) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FlashcardDeckView(deck: deck),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class QuizzesTabView extends StatelessWidget {
  final String categoryId;
  final Color categoryColor;
  final Color categoryTextColor;

  const QuizzesTabView({
    super.key,
    required this.categoryId,
    required this.categoryColor,
    required this.categoryTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final quizViewModel = Provider.of<QuizViewModel>(context);
    final quizzes =
        quizViewModel.quizzes
            .where((quiz) => quiz.category == categoryId)
            .toList();

    if (quizzes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Symbols.quiz, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No quizzes in this category',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.0,
        ),
        itemCount: quizzes.length,
        itemBuilder: (context, index) {
          final quiz = quizzes[index];
          return _buildCard<Quiz>(
            context: context,
            item: quiz,
            title: quiz.title,
            itemCount: quiz.questions.length,
            cardColor: categoryColor,
            textColor: categoryTextColor,
            icon: Symbols.quiz,
            iconColor: categoryTextColor,
            onTap: (context, quiz) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizDeckView(quizDeck: quiz),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
