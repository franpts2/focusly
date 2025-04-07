import 'dart:math';
import 'package:flutter/material.dart';

class FlashcardDeckView extends StatefulWidget {
  const FlashcardDeckView({super.key});

  @override
  State<FlashcardDeckView> createState() => _FlashcardDeckViewState();
}

class _FlashcardDeckViewState extends State<FlashcardDeckView> {
  bool _isFront = true;
  String _frontText = 'Question';
  String _backText = 'Answer';

  void _flipCard() {
    setState(() {
      _isFront = !_isFront;
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
        return Transform(
          transform: Matrix4.rotationY(value)..setEntry(3, 0, tilt),
          alignment: Alignment.center,
          child: widget,
        );
      },
    );
  }

  Widget _buildFront(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      key: const ValueKey<bool>(true), // Unique key for the front
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      color: colorScheme.surfaceContainer,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _frontText,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildBack(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      key: const ValueKey<bool>(false), // Unique key for the rear
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      color: colorScheme.surfaceContainer, 
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _backText,
            style: TextStyle(
              fontSize: 24,
              color: Colors.grey[600],
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Deck Name'),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {}),
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
                  duration: const Duration(milliseconds: 1000),
                  transitionBuilder: _transitionBuilder,
                  layoutBuilder: (currentChild, previousChildren) {
                    return Stack(
                      children: <Widget>[
                        if (previousChildren.isNotEmpty) previousChildren.first,
                        if (currentChild != null) currentChild,
                      ],
                    );
                  },
                  child: _isFront ? _buildFront(context) : _buildBack(context),
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
                    onPressed: () {
                      // Handle left arrow button press (previous card)
                    },
                  ),
                  IconButton.filled(
                    icon: Icon(
                      Icons.arrow_forward,
                      color: colorScheme.onPrimary,
                    ),
                    onPressed: () {
                      // Handle right arrow button press (next card)
                    },
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