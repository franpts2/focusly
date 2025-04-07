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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final cardWidth = screenWidth * 0.8; // 80% of screen width
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
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  color: colorScheme.surfaceContainer,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _isFront ? _frontText : _backText,
                        style: TextStyle(fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
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
                      // Handle left arrow button press
                    },
                  ),
                  IconButton.filled(
                    icon: Icon(
                      Icons.arrow_forward,
                      color: colorScheme.onPrimary,
                    ),
                    onPressed: () {
                      // Handle right arrow button press
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
