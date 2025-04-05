import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class CreateViewAddFlashcard extends StatefulWidget {
  const CreateViewAddFlashcard({super.key});

  @override
  State<CreateViewAddFlashcard> createState() => _CreateViewAddFlashcardState();
}

class _CreateViewAddFlashcardState extends State<CreateViewAddFlashcard> {
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final List<Flashcard> _flashcards = [];

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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_flashcards.length} flashcards',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  onPressed: (){},
                  icon: const Icon(Symbols.add_circle),
                ),
              ],
            ),
            const SizedBox(height: 8),

            
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

  Widget _buildFlashcardCard(Flashcard flashcard, int index) {
    return Card(
      child: ListTile(
        title: Text(flashcard.front),
        subtitle: Text(flashcard.back),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            setState(() {
              _flashcards.removeAt(index);
            });
          },
        ),
      ),
    );
  }
}

class Flashcard {
  String front;
  String back;

  Flashcard({required this.front, required this.back});
}