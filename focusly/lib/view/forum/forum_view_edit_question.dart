import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';
import 'package:focusly/model/forum_question_model.dart';
import 'package:focusly/viewmodel/forum_question_viewmodel.dart';

class ForumEditQuestion extends StatefulWidget {
  final ForumQuestion question;

  const ForumEditQuestion({super.key, required this.question});

  @override
  State<ForumEditQuestion> createState() => _ForumEditQuestionState();
}

class _ForumEditQuestionState extends State<ForumEditQuestion> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.question.title);
    _descriptionController = TextEditingController(text: widget.question.description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Question'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.pop(context); // Cancel
            },
            icon: Icon(Symbols.delete,)
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Cancel
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Save'),
        ),
      ],
    );
  }
}