import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:focusly/model/quiz_model.dart';
import 'package:focusly/viewmodel/quiz_viewmodel.dart';
import 'package:focusly/view/create/create_view_add_quiz.dart';

class QuizListView extends StatefulWidget {
  const QuizListView({super.key});

  @override
  State<QuizListView> createState() => _QuizListViewState();
}

class _QuizListViewState extends State<QuizListView> {
  @override
  void initState() {
    super.initState();
    // Refresh quizzes when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<QuizViewModel>(context, listen: false).refreshQuizzes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Quizzes'), centerTitle: true),
      body: Consumer<QuizViewModel>(
        builder: (context, quizViewModel, child) {
          final quizzes = quizViewModel.quizzes;

          if (quizzes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'You have no quizzes yet',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateViewAddQuiz(),
                        ),
                      );
                    },
                    child: const Text('Create a Quiz'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: quizzes.length,
            itemBuilder: (context, index) {
              final quiz = quizzes[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16.0),
                child: ListTile(
                  title: Text(
                    quiz.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    'Category: ${quiz.category} • ${quiz.questions.length} questions',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // Edit functionality to be implemented
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text('Delete Quiz'),
                                  content: Text(
                                    'Are you sure you want to delete "${quiz.title}"?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('CANCEL'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        quizViewModel.deleteQuiz(quiz.id!);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('DELETE'),
                                    ),
                                  ],
                                ),
                          );
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    // Show quiz details or start quiz
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateViewAddQuiz()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
