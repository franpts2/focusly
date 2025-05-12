import 'package:flutter/material.dart';
import 'package:focusly/model/flashcard_deck_model.dart';
import 'package:focusly/viewmodel/flashcard_deck_viewmodel.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:focusly/view/create/create_view_select_category.dart';
import 'package:focusly/viewmodel/category_viewmodel.dart';

class CreateViewAddFlashcardDeck extends StatefulWidget {
  const CreateViewAddFlashcardDeck({super.key});

  @override
  State<CreateViewAddFlashcardDeck> createState() =>
      _CreateViewAddFlashcardState();
}

class _CreateViewAddFlashcardState extends State<CreateViewAddFlashcardDeck> {
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final List<FlashcardUI> _flashcards = [];
  String? _selectedCategoryId;

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _addFlashcard() {
    // Show edit dialog for a new flashcard
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
              // Update existing flashcard
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
            ? null // No delete for new flashcards
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

  void _selectCategory() {
    showDialog(
      context: context,
      builder: (context) => CategorySelectionDialog(
        selectedCategoryId: _selectedCategoryId,
        onCategorySelected: (categoryId) {
          setState(() {
            _selectedCategoryId = categoryId;
          });
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

    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    final flashcardViewModel = Provider.of<FlashcardDeckViewModel>(
      context,
      listen: false,
    );

    // Convert FlashcardUI to Flashcard
    final modelFlashcards =
    _flashcards.map((flashcard) {
      return Flashcard(front: flashcard.front, back: flashcard.back);
    }).toList();

    // Create Deck object
    final deck = FlashcardDeck(
      title: _titleController.text,
      category: _selectedCategoryId!,
      flashcards: modelFlashcards,
    );

    try {
      await flashcardViewModel.addDeck(deck);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Deck saved successfully')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving deck: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Flashcard Deck'),
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
                  child: _buildCategoryButton(context),
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
              child: GestureDetector(
                onTap: () {
                  _showFlashcardDialog(flashcard: flashcard, isNew: false);
                },
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

  Widget _buildCategoryButton(BuildContext context) {
    final category = _selectedCategoryId != null
        ? context.read<CategoryViewModel>().getCategoryById(_selectedCategoryId!)
        : null;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(26.0),
      ),
      child: TextButton(
        onPressed: _selectCategory,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (category != null) ...[
              Icon(category.icon, color: category.color, size: 16),
              const SizedBox(width: 8),
            ],
            Text(
              _selectedCategoryId == null ? 'Choose Category' : 'Change Category',
              style: const TextStyle(fontSize: 14),
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