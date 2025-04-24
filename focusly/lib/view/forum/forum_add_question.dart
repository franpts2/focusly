import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:focusly/model/forum_question_model.dart';
import 'package:focusly/viewmodel/forum_question_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/authentication_service.dart';

class ForumAddQuestion extends StatefulWidget {
  const ForumAddQuestion({super.key});

  @override
  _ForumAddQuestionState createState() => _ForumAddQuestionState();
}

class _ForumAddQuestionState extends State<ForumAddQuestion> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? titleError;
  String? descriptionError;

  void publishQuestion() async {
    setState(() {
      titleError = titleController.text.trim().isEmpty ? 'Title is required' : null;
      descriptionError = descriptionController.text.trim().isEmpty ? 'Description is required' : null;
    });

    if (titleError == null && descriptionError == null) {
      final currentUser = FirebaseAuth.instance.currentUser;

      // Retrieve the username
      final authService = Provider.of<AuthenticationService>(context, listen: false);
      final userName = await authService.getUserName() ?? 'Anonymous';

      final question = ForumQuestion(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        createdAt: DateTime.now(),
        answerCount: 0,
        userName: userName, // Use the retrieved username
        userPhotoUrl: currentUser?.photoURL,
      );

      final questionViewModel = Provider.of<ForumQuestionViewModel>(
        context,
        listen: false,
      );

      await questionViewModel.addQuestion(question);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Post your question',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: const OutlineInputBorder(),
                errorText: titleError,
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Description',
                alignLabelWithHint: true,
                border: const OutlineInputBorder(),
                errorText: descriptionError,
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: publishQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Text(
                      'Publish',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}