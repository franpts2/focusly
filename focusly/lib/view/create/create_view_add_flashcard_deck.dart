import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class CreateViewAddFlashcardDeck extends StatefulWidget {
  const CreateViewAddFlashcardDeck({super.key});

  @override
  State<CreateViewAddFlashcardDeck> createState() => _CreateViewAddFlashcardState();
}

class _CreateViewAddFlashcardState extends State<CreateViewAddFlashcardDeck> {
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final List<Flashcard> _flashcards = [];

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _addFlashcard() {
    // Show edit dialog for a new flashcard
    _showFlashcardDialog(
      flashcard: Flashcard(front: '', back: ''),
      isNew: true,
    );
  }

  void _showFlashcardDialog({
    required Flashcard flashcard,
    bool isNew = false,
  }) {
    showDialog(
      context: context,
      builder: (context) => FlashcardEditDialog(
        flashcard: flashcard,
        onSave: (updatedFlashcard) {
          setState(() {
            if (isNew) {
              _flashcards.add(updatedFlashcard);
            } else {
              // Update existing flashcard
              final index = _flashcards.indexWhere(
                (f) => f.front == flashcard.front && f.back == flashcard.back
              );
              if (index != -1) {
                _flashcards[index] = updatedFlashcard;
              }
            }
          });
        },
        onDelete: isNew
          ? null // No delete for new flashcards
          : () {
              setState(() {
                _flashcards.removeWhere(
                  (f) => f.front == flashcard.front && f.back == flashcard.back
                );
              });
              Navigator.pop(context);
            },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Add Flashcard Deck'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      hintText: 'Name your deck here',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(26.0),
                    ),
                    child: TextButton(
                      onPressed: () {},
                      child: Text('Category'),
                    ),
                  ),
                  /*child: TextField(
                   TextButton(onPressed: () {}, child: Text('Category'))
                    controller: _categoryController,
                    decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder(),),
                  ),*/
                ),
              ],
            ),
            const SizedBox(height: 24),
            Divider(color: Colors.grey[300]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_flashcards.length} flashcards',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton.outlined(
                  onPressed: _addFlashcard,
                  icon: const Icon(Symbols.add, size: 24),
                ),
              ],
            ),
            const SizedBox(height: 16),

            
            Expanded(
              child: ListView.builder(
                itemCount: _flashcards.length,
                itemBuilder: (context, index) {
                  return _buildFlashcardCard(_flashcards[index], index);
                },
              ),
            ),

            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:() {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }

  Widget _buildFlashcardCard(Flashcard flashcard, int flashcardIndex) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 16.0),
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        color: colorScheme.primaryContainer, 
        child:Stack(
            children: [ 
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Card(
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0), 
                        child: Column(
                          mainAxisSize: MainAxisSize.min, // Important for centering
                          crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch to take full width
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                flashcard.front,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Divider(color: Colors.grey[300]),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                flashcard.back,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 15.0, // Adjust position relative to the outer card's padding
                right: 15.0, // Adjust position relative to the outer card's padding
                child: IconButton.filled(
                icon: Icon(Symbols.delete, size: 20),
                color: colorScheme.onPrimary,
                onPressed: () {
                    setState(() {
                      _flashcards.removeAt(flashcardIndex);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FlashcardEditDialog extends StatefulWidget {
  final Flashcard flashcard;
  final Function(Flashcard) onSave;
  final VoidCallback? onDelete;

  const FlashcardEditDialog({
    super.key,
    required this.flashcard,
    required this.onSave,
    this.onDelete,
  });

  @override
  State<FlashcardEditDialog> createState() => _FlashcardEditDialogState();
}

class _FlashcardEditDialogState extends State<FlashcardEditDialog> {
  late TextEditingController _frontController;
  late TextEditingController _backController;

  @override
  void initState() {
    super.initState();
    _frontController = TextEditingController(text: widget.flashcard.front);
    _backController = TextEditingController(text: widget.flashcard.back);
  }

  @override
  void dispose() {
    _frontController.dispose();
    _backController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AlertDialog(
      backgroundColor: colorScheme.primaryContainer,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _frontController,
            decoration: const InputDecoration(
              labelText: 'Front',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _backController,
            decoration: const InputDecoration(
              labelText: 'Back',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        Align(
          alignment: Alignment.center,
          child: ElevatedButton(
            onPressed: () {
              final updatedFlashcard = Flashcard(
                front: _frontController.text,
                back: _backController.text,
              );
              widget.onSave(updatedFlashcard);
              Navigator.pop(context);
            },
            child: const Text('SAVE'),
          ),
        ),
      ],
    );
  }
}

class Flashcard {
  String front;
  String back;

  Flashcard({required this.front, required this.back});
}