import 'package:flutter/material.dart';
import 'package:focusly/viewmodel/forum_answer_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:focusly/model/forum_question_model.dart';
import 'package:focusly/model/forum_answer_model.dart';
import 'package:focusly/viewmodel/forum_answer_viewmodel.dart';
import 'package:focusly/view/forum/forum_view_add_answer.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForumQuestionDetail extends StatefulWidget {
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
  State<ForumQuestionDetail> createState() => _ForumQuestionDetailState();
}

class _ForumQuestionDetailState extends State<ForumQuestionDetail> {
  @override
  void initState() {
    super.initState();
    // Load answers for this question when the page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final answerViewModel = context.read<ForumAnswerViewModel>();
      answerViewModel.loadAnswersForQuestion(widget.question.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentUser = FirebaseAuth.instance.currentUser;
    final answerViewModel = context.watch<ForumAnswerViewModel>();
    final answers = answerViewModel.getAnswersForQuestion(widget.question.id!);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Question Detail"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: widget.question.userPhotoUrl != null && 
                          widget.question.userPhotoUrl!.isNotEmpty
                          ? NetworkImage(widget.question.userPhotoUrl!)
                          : null,
                      backgroundColor: colorScheme.primaryContainer,
                      child: (widget.question.userPhotoUrl == null || 
                          widget.question.userPhotoUrl!.isEmpty)
                          ? const Icon(Icons.person, color: Colors.white)
                          : null,
                    ),
                    SizedBox(height: 8),
                    Text(
                        widget.question.userName,
                        style: TextStyle(
                          fontSize: 12, 
                          color: colorScheme.tertiary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.question.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.question.description,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(thickness: 1),
            
            // Answers Count and Add Answer Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${answers.length} answers",
                  style: TextStyle(
                    fontSize: 15, 
                    fontWeight: FontWeight.bold,
                    color: colorScheme.tertiary,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierColor: Colors.black.withOpacity(0.4),
                      barrierDismissible: false,
                      builder: (context) => ForumViewAddAnswer(
                        onAnswerSubmitted: (answerText) async {
                          final answer = ForumAnswer(
                            description: answerText,
                            createdAt: DateTime.now(),
                            userName: currentUser?.displayName ?? 'Anonymous',
                            userPhotoUrl: currentUser?.photoURL,
                            questionID: widget.question.id!,
                          );
                          
                          await answerViewModel.addAnswer(
                            widget.question.id!, 
                            answer
                          );
                          // Refresh the question to update answer count
                          if (mounted) {
                            Navigator.pop(context);
                          }
                        },
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.mode_comment_outlined, 
                    color: Colors.white
                  ),
                  label: const Text(
                    "Answer", 
                    style: TextStyle(color: Colors.white)
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12, 
                      vertical: 8
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Answers List
            Expanded(
              child: answers.isEmpty
                  ? const Center(
                      child: Text("No answers yet."),
                    )
                  : ListView.builder(
                      itemCount: answers.length,
                      itemBuilder: (context, index) {
                        final answer = answers[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12.0), 
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: colorScheme.primary,
                                    width: 1.0, 
                                  ),
                                  borderRadius: BorderRadius.circular(8.0), 
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundImage: answer.userPhotoUrl != null && 
                                              answer.userPhotoUrl!.isNotEmpty
                                              ? NetworkImage(answer.userPhotoUrl!)
                                              : null,
                                          backgroundColor: colorScheme.primaryContainer,
                                          child: (answer.userPhotoUrl == null || 
                                              answer.userPhotoUrl!.isEmpty)
                                              ? const Icon(
                                                  Icons.person, 
                                                  size: 20, 
                                                  color: Colors.white
                                                )
                                              : null,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          answer.userName,
                                          style: TextStyle(
                                            fontSize: 12, 
                                            color: colorScheme.tertiary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              answer.description,
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                          ),
                                          /*const SizedBox(height: 4),
                                          Text(
                                            _formatDate(answer.createdAt),
                                            style: const TextStyle(
                                              fontSize: 12, 
                                              color: Colors.grey
                                            ),
                                          ),*/
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }
}