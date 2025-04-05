import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:focusly/model/quiz_model.dart';
import 'package:focusly/viewmodel/quiz_viewmodel.dart';

class CreateViewAddQuiz extends StatefulWidget {
  const CreateViewAddQuiz({super.key});

  @override
  State<CreateViewAddQuiz> createState() => _CreateAddQuizState();
}

class _CreateAddQuizState extends State<CreateViewAddQuiz> {
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final List<QuizQuestion> _questions = [];

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _addQuestion() {
    // Show the edit dialog immediately when adding a new question
    _showQuestionDialog(
      question: QuizQuestion(
        question: '',
        options: ['', '', '', ''],
        correctIndex: 0,
      ),
      isNew: true,
    );
  }

  // Convert UI QuizQuestion to database Question model
  Question _convertToQuestion(QuizQuestion quizQuestion) {
    return Question(
      questionText: quizQuestion.question,
      correctAnswer: quizQuestion.options[quizQuestion.correctIndex],
      options: quizQuestion.options,
    );
  }

  void _saveQuiz() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a quiz title')),
      );
      return;
    }

    if (_questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one question')),
      );
      return;
    }

    final quizViewModel = Provider.of<QuizViewModel>(context, listen: false);

    // Convert UI questions to database model questions
    final List<Question> modelQuestions =
        _questions.map(_convertToQuestion).toList();

    // Create Quiz object
    final quiz = Quiz(
      title: _titleController.text,
      category:
          _categoryController.text.isEmpty
              ? 'General'
              : _categoryController.text,
      questions: modelQuestions,
    );

    try {
      // Save to Firebase
      await quizViewModel.addQuiz(quiz);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Quiz saved successfully')));

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving quiz: $e')));
    }
  }

  void _showQuestionDialog({
    required QuizQuestion question,
    bool isNew = false,
  }) {
    showDialog(
      context: context,
      builder:
          (context) => QuestionEditDialog(
            question: question,
            onSave: (updatedQuestion) {
              setState(() {
                if (isNew) {
                  _questions.add(updatedQuestion);
                } else {
                  // Find and update the existing question
                  final index = _questions.indexWhere(
                    (q) => q.question == question.question,
                  );
                  if (index != -1) {
                    _questions[index] = updatedQuestion;
                  }
                }
              });
            },
            onDelete:
                isNew
                    ? null // No delete for new questions
                    : () {
                      setState(() {
                        _questions.removeWhere(
                          (q) => q.question == question.question,
                        );
                      });
                      Navigator.pop(context);
                    },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Add Quiz'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      hintText: 'Name your quiz here',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(26.0),
                    ),
                    child: TextButton(
                      onPressed: () {},
                      child: Text('Category'),
                    ),
                  ),
                  /*child: TextField(
                   TextButton(onPressed: () {}, child: Text('Category'))
                    controller: _categoryController,
                    decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder(),),
                  ),*/
                ),
              ],
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_questions.length} questions',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  onPressed: _addQuestion,
                  icon: const Icon(Symbols.add_circle),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Expanded(
              child: ListView.builder(
                itemCount: _questions.length,
                itemBuilder: (context, index) {
                  return _buildQuestionCard(_questions[index], index);
                },
              ),
            ),

            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveQuiz,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(QuizQuestion question, int questionIndex) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${questionIndex + 1}. ${question.question}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Symbols.delete, size: 20),
                  onPressed: () {
                    setState(() {
                      _questions.removeAt(questionIndex);
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...List.generate(question.options.length, (optionIndex) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Radio<int>(
                      value: optionIndex,
                      groupValue: question.correctIndex,
                      onChanged: (value) {
                        setState(() {
                          _questions[questionIndex].correctIndex = value!;
                        });
                      },
                    ),
                    Expanded(child: Text(question.options[optionIndex])),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class QuestionEditDialog extends StatefulWidget {
  final QuizQuestion question;
  final Function(QuizQuestion) onSave;
  final VoidCallback? onDelete;

  const QuestionEditDialog({
    super.key,
    required this.question,
    required this.onSave,
    this.onDelete,
  });

  @override
  State<QuestionEditDialog> createState() => _QuestionEditDialogState();
}

class _QuestionEditDialogState extends State<QuestionEditDialog> {
  late TextEditingController _questionController;
  late List<TextEditingController> _optionControllers;
  late int _correctIndex;

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController(text: widget.question.question);
    _optionControllers =
        widget.question.options
            .map((option) => TextEditingController(text: option))
            .toList();
    _correctIndex = widget.question.correctIndex;
  }

  @override
  void dispose() {
    _questionController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AlertDialog(
      backgroundColor: colorScheme.primaryContainer,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _questionController,
              decoration: const InputDecoration(
                labelText: 'Question',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(_optionControllers.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Radio<int>(
                      value: index,
                      groupValue: _correctIndex,
                      onChanged: (value) {
                        setState(() {
                          _correctIndex = value!;
                        });
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: _optionControllers[index],
                        decoration: InputDecoration(
                          labelText: 'Option ${index + 1}',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
      actions: [
        Align(
          alignment: Alignment.center,
          child: ElevatedButton(
            onPressed: () {
              final updatedQuestion = QuizQuestion(
                question: _questionController.text,
                options: _optionControllers.map((c) => c.text).toList(),
                correctIndex: _correctIndex,
              );
              widget.onSave(updatedQuestion);
              Navigator.pop(context);
            },
            child: const Text('SAVE'),
          ),
        ),
      ],
    );
  }
}

class QuizQuestion {
  String question;
  List<String> options;
  int correctIndex;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}
