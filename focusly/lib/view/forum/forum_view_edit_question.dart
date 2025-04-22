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

  void _deleteQuestion(BuildContext context) async {
    try {
      await Provider.of<ForumQuestionViewModel>(context, listen: false)
          .deleteQuestion(widget.question.id!);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Question deleted successfully!')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete question: $error')),
        );
      }
    }
  }

  void _saveChanges(BuildContext context) async {
    final updatedTitle = _titleController.text.trim();
    final updatedDescription = _descriptionController.text.trim();

    if (updatedTitle.isNotEmpty && updatedDescription.isNotEmpty) {
      final updatedQuestion = widget.question.copyWith(
        title: updatedTitle,
        description: updatedDescription,
      );

      try {
        await Provider.of<ForumQuestionViewModel>(context, listen: false)
            .updateQuestion(updatedQuestion);
        if (mounted) {
          Navigator.pop(context); // Go back to the detail screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Question updated successfully!')),
          );
        }
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update question: $error')),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and description cannot be empty.')),
      );
    }
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
            onPressed: () => _deleteQuestion(context),
            icon: const Icon(Symbols.delete,)
        ),
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