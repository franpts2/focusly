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
    );
  }
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
          return _buildFlashcardDeckCard(context, deck);
        },
      ),
    );
  }

  Widget _buildFlashcardDeckCard(BuildContext context, FlashcardDeck deck) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: categoryColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FlashcardDeckView(deck: deck),
            ),
          );
        },
        child: Stack(
          children: [
            // Main content - centered title
            Positioned.fill(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    deck.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: categoryTextColor,
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
                  color: categoryColor.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${deck.flashcards.length}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Symbols.library_books,
                      color: colorScheme.primary,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
          return _buildQuizCard(context, quiz);
        },
      ),
    );
  }

  Widget _buildQuizCard(BuildContext context, Quiz quiz) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: categoryColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizDeckView(quizDeck: quiz),
            ),
          );
        },
        child: Stack(
          children: [
            // Main content - centered title
            Positioned.fill(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    quiz.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: categoryTextColor,
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
                  color: categoryColor.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${quiz.questions.length}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: categoryTextColor,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(Symbols.quiz, color: categoryTextColor, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
