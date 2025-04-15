import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:focusly/model/forum_question_model.dart';
import 'package:focusly/viewmodel/forum_question_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/authentication_service.dart';

class ForumAddQuestion extends StatelessWidget {
  const ForumAddQuestion({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

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
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Description',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
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
                  onPressed: () async {
                    final currentUser = FirebaseAuth.instance.currentUser;

                    // Retrieve the username
                    final authService = Provider.of<AuthenticationService>(context, listen: false);
                    final userName = await authService.getUserName() ?? 'Anonymous';

                    final question = ForumQuestion(
                      title: titleController.text,
                      description: descriptionController.text,
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
                  },
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