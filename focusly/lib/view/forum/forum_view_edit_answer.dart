import 'package:flutter/material.dart';
import 'package:focusly/model/forum_answer_model.dart';
import 'package:focusly/viewmodel/forum_answer_viewmodel.dart';
import 'package:provider/provider.dart';

class ForumEditAnswer extends StatefulWidget {
  final ForumAnswer answer;
  final String questionId;

  const ForumEditAnswer({super.key, required this.answer, required this.questionId});

  @override
  State<ForumEditAnswer> createState() => _ForumEditAnswerState();
}

class _ForumEditAnswerState extends State<ForumEditAnswer> {
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.answer.description);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveChanges(BuildContext context) async {
    final updatedDescription = _descriptionController.text.trim();

    final updatedAnswer = widget.answer.copyWith(
      description: updatedDescription,
    );
    try {
      await Provider.of<ForumAnswerViewModel>(context, listen: false)
          .updateAnswer(widget.questionId, updatedAnswer);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Answer updated successfully!')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update answer: $error')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Answer'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Cancel
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => _saveChanges(context),
          child: const Text('Save'),
        ),
      ],
    );
  }
}