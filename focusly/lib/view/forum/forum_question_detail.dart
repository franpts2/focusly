import 'package:flutter/material.dart';
import 'package:focusly/model/forum_question_model.dart';
import 'package:focusly/view/forum/forum_view.dart';
import 'package:focusly/view/forum/forum_view_add_answer.dart';

class ForumQuestionDetail extends StatelessWidget {
  final ForumQuestion question;
  final String? userName;
  final String? photoUrl;

  const ForumQuestionDetail({
    super.key,
    required this.question,
    this.userName,
    this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Forum"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: question.userPhotoUrl != null && question.userPhotoUrl!.isNotEmpty
                      ? NetworkImage(question.userPhotoUrl!)
                      : null,
                  backgroundColor: colorScheme.primaryContainer,
                  child: (question.userPhotoUrl == null || question.userPhotoUrl!.isEmpty)
                      ? const Icon(Icons.person, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        question.description,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        question.userName,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${question.answerCount} answers",
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierColor: Colors.black.withOpacity(0.4),
                      barrierDismissible: false,
                      builder: (context) => const ForumViewAddAnswer(),
                    );
                  },
                  icon: const Icon(Icons.mode_comment_outlined, color: Colors.white),
                  label: const Text("Answer", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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