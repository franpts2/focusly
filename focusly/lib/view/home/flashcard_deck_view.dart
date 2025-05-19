import 'dart:math';
import 'package:flutter/material.dart';
import 'package:focusly/model/flashcard_deck_model.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/flashcard_deck_viewmodel.dart';

class FlashcardDeckView extends StatefulWidget {
  final FlashcardDeck deck;

  const FlashcardDeckView({super.key, required this.deck});

  @override
  State<FlashcardDeckView> createState() => _FlashcardDeckViewState();
}

class _FlashcardDeckViewState extends State<FlashcardDeckView> {
  int _currentCardIndex = 0;
  bool _isFront = true;
  List<Flashcard> _cards = [];

  @override
  void initState() {
    super.initState();
    // Initialize with the deck's flashcards
    _cards = widget.deck.flashcards;
    // Update the lastOpened timestamp
    final flashcardViewModel = Provider.of<FlashcardDeckViewModel>(
      context,
      listen: false,
    );
    flashcardViewModel.updateDeck(
      widget.deck.copyWith(lastOpened: DateTime.now()),
    );
  }

  void _flipCard() {
    setState(() {
      _isFront = !_isFront;
    });
  }

  void _nextCard() {
    setState(() {
      if (_currentCardIndex < _cards.length - 1) {
        _currentCardIndex++;
        _isFront = true; // Reset to front when moving to a new card
      }
    });
  }

  void _previousCard() {
    setState(() {
      if (_currentCardIndex > 0) {
        _currentCardIndex--;
        _isFront = true; // Reset to front when moving to a new card
      }
    });
  }

  Widget _transitionBuilder(Widget widget, Animation<double> animation) {
    final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget,
      builder: (context, widget) {
        final isUnder = (ValueKey(_isFront) != widget?.key);
        var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
        tilt *= isUnder ? -1.0 : 1.0;
        final value =
            isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;

        // Only show the widget when it's mostly facing the viewer
        final shouldShow = value.abs() < pi / 2;

        return Transform(
          transform: Matrix4.rotationY(value)..setEntry(3, 0, tilt),
          alignment: Alignment.center,
          child: shouldShow ? widget : null,
        );
      },
    );
  }

  Widget _buildFront(BuildContext context, String text) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      key: const ValueKey<bool>(true), // Unique key for the front
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color:
          Theme.of(context).brightness == Brightness.light
              ? colorScheme.surfaceContainer
              : colorScheme.secondaryContainer,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            text,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildBack(BuildContext context, String text) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      key: const ValueKey<bool>(false), // Unique key for the back
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color:
          Theme.of(context).brightness == Brightness.light
              ? colorScheme.surfaceContainer
              : colorScheme.secondaryContainer,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 24,
              color:
                  Theme.of(context).brightness == Brightness.light
                      ? Colors.grey[600]
                      : colorScheme.onPrimaryContainer,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.8;
    final cardHeight = cardWidth / (345 / 246);
    final colorScheme = Theme.of(context).colorScheme;
    final currentCard = _cards[_currentCardIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.deck.title),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _flipCard,
              child: SizedBox(
                width: cardWidth,
                height: cardHeight,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 700),
                  switchInCurve: Curves.easeIn, // Add this line
                  transitionBuilder: _transitionBuilder,
                  layoutBuilder: (currentChild, previousChildren) {
                    return Stack(
                      children: <Widget>[
                        ...previousChildren,
                        if (currentChild != null) currentChild,
                      ],
                    );
                  },
                  child:
                      _isFront
                          ? _buildFront(context, currentCard.front)
                          : _buildBack(context, currentCard.back),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: (screenWidth - cardWidth) / 2,
                vertical: 20.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton.filled(
                    icon: Icon(Icons.arrow_back, color: colorScheme.onPrimary),
                    onPressed: _currentCardIndex > 0 ? _previousCard : null,
                    disabledColor: colorScheme.tertiary,
                  ),
                  IconButton.filled(
                    icon: Icon(
                      Icons.arrow_forward,
                      color: colorScheme.onPrimary,
                    ),
                    onPressed:
                        _currentCardIndex < _cards.length - 1
                            ? _nextCard
                            : null,
                    disabledColor: colorScheme.tertiary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
