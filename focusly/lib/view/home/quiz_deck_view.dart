import 'package:flutter/material.dart';
import 'package:focusly/model/quiz_model.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/quiz_viewmodel.dart';

class QuizDeckView extends StatefulWidget {
  final Quiz quizDeck;

  const QuizDeckView({super.key, required this.quizDeck});

  @override
  State<QuizDeckView> createState() => _QuizDeckViewState();
}

class _QuizDeckViewState extends State<QuizDeckView> {
  List<String?> _selectedAnswers = [];

  @override
  void initState() {
    super.initState();
    _selectedAnswers = List.filled(widget.quizDeck.questions.length, null);
    // Update the lastOpened timestamp
    final quizViewModel = Provider.of<QuizViewModel>(context, listen: false);
    quizViewModel.updateQuiz(
      widget.quizDeck.copyWith(lastOpened: DateTime.now()),
    );
  }

  void _restartQuiz() {
    setState(() {
      _selectedAnswers = List.filled(widget.quizDeck.questions.length, null);
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quizDeck.title),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...List.generate(widget.quizDeck.questions.length, (index) {
                return _buildQuestion(widget.quizDeck.questions[index], index);
              }),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _submitQuiz,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestion(Question question, int questionIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${questionIndex + 1}. ${question.questionText}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...List.generate(question.options.length, (optionIndex) {
          return RadioListTile<String>(
            title: Text(question.options[optionIndex]),
            value: question.options[optionIndex],
            groupValue: _selectedAnswers[questionIndex],
            onChanged: (value) {
              setState(() {
                _selectedAnswers[questionIndex] = value;
              });
            },
          );
        }),
        const SizedBox(height: 16),
      ],
    );
  }

  void _submitQuiz() {
    int score = 0;
    for (int i = 0; i < widget.quizDeck.questions.length; i++) {
      if (_selectedAnswers[i] == widget.quizDeck.questions[i].correctAnswer) {
        score++;
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        Color scoreBackgroundColor = Colors.white;
        if (isScore100(score, widget.quizDeck.questions.length)) {
          scoreBackgroundColor = Colors.green.shade100;
        } else if (isScoreZero(score, widget.quizDeck.questions.length)) {
          scoreBackgroundColor = Colors.red.shade100;
        }
        return AlertDialog(
          title: const Text(
            'Quiz Completed!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: scoreBackgroundColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _getScoreMessage(score, widget.quizDeck.questions.length),
                style: TextStyle(color: Colors.black),
              ),
              Text(
                'Your score: $score / ${widget.quizDeck.questions.length}',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: _restartQuiz,
              child: const Text(
                'Restart',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  String _getScoreMessage(int score, int totalQuestions) {
    double percentage = (score / totalQuestions) * 100;

    if (percentage == 100) {
      return "Wow! Perfect score!";
    } else if (percentage >= 80) {
      return "Great job! You did really well.";
    } else if (percentage >= 60) {
      return "Not bad! You passed.";
    } else {
      return "You can do better next time!";
    }
  }

  bool isScore100(int score, int totalQuestions) {
    double percentage = (score / totalQuestions) * 100;
    if (percentage == 100) {
      return true;
    }
    return false;
  }

  bool isScoreZero(int score, int totalQuestions) {
    double percentage = (score / totalQuestions) * 100;
    if (percentage == 0) {
      return true;
    }
    return false;
  }
}
