import 'package:flutter/material.dart';
import 'package:focusly/view/forum/forum_view_edit_answer.dart';
import 'package:focusly/viewmodel/forum_answer_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:focusly/model/forum_question_model.dart';
import 'package:focusly/model/forum_answer_model.dart';
import 'package:focusly/view/forum/forum_view_add_answer.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../viewmodel/forum_question_viewmodel.dart';

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
  final _formKey = GlobalKey<FormState>();
  late ForumQuestion _question;

  @override
  void initState() {
    super.initState();
    _question = widget.question;
    // Load answers for this question when the page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final answerViewModel = context.read<ForumAnswerViewModel>();
      answerViewModel.loadAnswersForQuestion(widget.question.id!);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showQuestionEditDialog(context) {
    showDialog(
      context: context,
      builder: (context) => ForumQuestionEditDialog(
        question: _question,
        onSave: (updatedQuestion) {
          setState(() {
            _question = updatedQuestion;
          });
          Provider.of<ForumQuestionViewModel>(context, listen: false)
              .updateQuestion(updatedQuestion);
          Navigator.of(context).pop();
        },
        onDelete: () {
          Provider.of<ForumQuestionViewModel>(context, listen: false)
              .deleteQuestion(_question.id!);
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
      ),
    );
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

  void _deleteAnswer(BuildContext context, answer) async {
    try {
      await Provider.of<ForumAnswerViewModel>(context, listen: false)
          .deleteAnswer(widget.question.id!, answer.id, context: context);
      if (mounted) {
        //Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Answer deleted successfully!')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete answer: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentUser = FirebaseAuth.instance.currentUser;
    final answerViewModel = context.watch<ForumAnswerViewModel>();
    final answers = answerViewModel.getAnswersForQuestion(widget.question.id!);
    final isCurrentUserQuestion = widget.question.userName == currentUser?.displayName;

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
                        widget.question.userName ?? "Anonymous",
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
                        _question.title,
                        //widget.question.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _question.description,
                        //widget.question.description,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                if (isCurrentUserQuestion)
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _showQuestionEditDialog(context),
                  ),
                if (isCurrentUserQuestion)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteQuestion(context),
                  )
                ],
            ),
            const SizedBox(height: 16),
            const Divider(thickness: 1),
            
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
                          context.read<ForumQuestionViewModel>().incrementAnswerCount(widget.question.id!);
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
                                    SizedBox(
                                      width: 60,
                                      child: Column(
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
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 11, 
                                              color: colorScheme.tertiary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
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
                                        ],
                                      ),
                                    ),
                                    if (answer.userName == currentUser?.displayName)
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        iconSize: 17,
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              return ForumEditAnswer(
                                                answer: answer,
                                                questionId: widget.question.id!,
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    if (answer.userName == currentUser?.displayName)
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        iconSize: 17,
                                        onPressed: () => _deleteAnswer(context, answer),
                                      )
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

class ForumQuestionEditDialog extends StatefulWidget {
  final ForumQuestion question;
  final Function(ForumQuestion) onSave;
  final VoidCallback? onDelete;

  const ForumQuestionEditDialog({
    super.key,
    required this.question,
    required this.onSave,
    this.onDelete,
  });

  @override
  State<ForumQuestionEditDialog> createState() =>
      _ForumQuestionEditDialogState();
}

class _ForumQuestionEditDialogState extends State<ForumQuestionEditDialog> {
  late TextEditingController _questionTitleController;
  late TextEditingController _questionDescriptionController;

  @override
  void initState() {
    super.initState();
    _questionTitleController =
        TextEditingController(text: widget.question.title);
    _questionDescriptionController = TextEditingController(
        text: widget.question.description);
  }

  @override
  void dispose() {
    _questionTitleController.dispose();
    _questionDescriptionController.dispose();
    super.dispose();
  }

  void _saveChanges(BuildContext context) async {
    final updatedTitle = _questionTitleController.text.trim();
    final updatedDescription = _questionDescriptionController.text.trim();

    final updatedQuestion = widget.question.copyWith(
      title: updatedTitle,
      description: updatedDescription,
    );
    try {
      await Provider.of<ForumQuestionViewModel>(context, listen: false)
          .updateQuestion(updatedQuestion);
      if (mounted) {
        //Navigator.pop(context);
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
              controller: _questionTitleController,
              decoration: const InputDecoration(
                labelText: 'Question Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _questionDescriptionController,
              decoration: const InputDecoration(
                labelText: 'Question Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
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
          onPressed: () {
            final updatedQuestion = ForumQuestion(
            id: widget.question.id,
            title: _questionTitleController.text,
            description: _questionDescriptionController.text,
            createdAt: widget.question.createdAt,
            userName: widget.question.userName,
            userPhotoUrl: widget.question.userPhotoUrl,
            answerCount: widget.question.answerCount,
            );
            widget.onSave(updatedQuestion);
            _saveChanges(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}