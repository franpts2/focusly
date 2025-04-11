import 'package:flutter/material.dart';
import 'package:focusly/model/flashcard_deck_model.dart';
import 'package:focusly/viewmodel/flashcard_deck_viewmodel.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

class CreateViewEditFlashcardDeck extends StatefulWidget {
  final FlashcardDeck deck;
  const CreateViewEditFlashcardDeck({super.key, required this.deck});

  @override
  State<CreateViewEditFlashcardDeck> createState() =>
      _CreateViewEditFlashcardState();
}

class _CreateViewEditFlashcardState extends State<CreateViewEditFlashcardDeck> {
  late TextEditingController _titleController;
  late TextEditingController _categoryController;
  late List<FlashcardUI> _flashcards;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.deck.title);
    _categoryController = TextEditingController(text: widget.deck.category);
    _flashcards =
        widget.deck.flashcards
            .map((f) => FlashcardUI(front: f.front, back: f.back))
            .toList();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _addFlashcard() {
    _showFlashcardDialog(
      flashcard: FlashcardUI(front: '', back: ''),
      isNew: true,
    );
  }

  void _showFlashcardDialog({
    required FlashcardUI flashcard,
    bool isNew = false,
  }) {
    showDialog(
      context: context,
      builder:
          (context) => FlashcardEditDialog(
            flashcard: flashcard,
            onSave: (updatedFlashcard) {
              setState(() {
                if (isNew) {
                  _flashcards.add(updatedFlashcard);
                } else {
                  final index = _flashcards.indexWhere(
                    (f) =>
                        f.front == flashcard.front && f.back == flashcard.back,
                  );
                  if (index != -1) {
                    _flashcards[index] = updatedFlashcard;
                  }
                }
              });
            },
            onDelete:
                isNew
                    ? null
                    : () {
                      setState(() {
                        _flashcards.removeWhere(
                          (f) =>
                              f.front == flashcard.front &&
                              f.back == flashcard.back,
                        );
                      });
                      Navigator.pop(context);
                    },
          ),
    );
  }

  void _saveDeck() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a deck title')),
      );
      return;
    }

    if (_flashcards.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one flashcard')),
      );
      return;
    }

    final flashcardViewModel = Provider.of<FlashcardDeckViewModel>(
      context,
      listen: false,
    );

    final modelFlashcards =
        _flashcards.map((flashcard) {
          return Flashcard(front: flashcard.front, back: flashcard.back);
        }).toList();

    final updatedDeck = FlashcardDeck(
      id: widget.deck.id,
      title: _titleController.text,
      category:
          _categoryController.text.isEmpty
              ? 'General'
              : _categoryController.text,
      flashcards: modelFlashcards,
    );

    try {
      await flashcardViewModel.updateDeck(updatedDeck);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Deck updated successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error updating deck: $e')));
    }
  }

  Future<void> _deleteDeck() async {
    // Show confirmation dialog
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.red),
                const SizedBox(width: 12),
                const Text(
                  'Delete Deck',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: const Text(
              'Are you sure you want to delete this deck? \nThis action cannot be undone!',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (shouldDelete != true) return;

    final flashcardViewModel = Provider.of<FlashcardDeckViewModel>(
      context,
      listen: false,
    );

    try {
      await flashcardViewModel.deleteDeck(widget.deck.id as String);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Deck deleted successfully')),
      );
      Navigator.pop(context); // Go back after deletion
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error deleting deck: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Flashcard Deck'),
        centerTitle: true,
      ),
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
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ElevatedButton(
                        onPressed: _saveDeck,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Done',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: ElevatedButton(
                        onPressed: _deleteDeck,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.tertiary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlashcardCard(FlashcardUI flashcard, int flashcardIndex) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 16.0),
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        color: colorScheme.primaryContainer,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Card(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize:
                            MainAxisSize.min, // Important for centering
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .stretch, // Stretch to take full width
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
                              style: TextStyle(color: Colors.grey[600]),
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
              right:
                  15.0, // Adjust position relative to the outer card's padding
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
  final FlashcardUI flashcard;
  final Function(FlashcardUI) onSave;
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
              final updatedFlashcard = FlashcardUI(
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

class FlashcardUI {
  String front;
  String back;

  FlashcardUI({required this.front, required this.back});
}
