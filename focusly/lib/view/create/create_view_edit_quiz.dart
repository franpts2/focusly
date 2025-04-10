import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:focusly/model/quiz_model.dart';
import 'package:focusly/viewmodel/quiz_viewmodel.dart';
import 'package:focusly/view/create/create_view_add_quiz.dart';

class CreateViewEditQuiz extends StatefulWidget {
  final Quiz quiz;
  CreateViewEditQuiz({super.key, required this.quiz});

  @override
  State<CreateViewEditQuiz> createState() => _CreateEditQuizState();
}

class _CreateEditQuizState extends State<CreateViewEditQuiz> {
  late TextEditingController _titleController;
  final List<QuizQuestion> _questions = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.quiz.title);
    _questions.addAll(widget.quiz.questions.map((q) => QuizQuestion(
      question: q.questionText,
      options: List<String>.from(q.options),
      correctIndex: q.options.indexOf(q.correctAnswer),
    )));
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _addQuestion() {
    _showQuestionDialog(
      question: QuizQuestion(
        question: '',
        options: ['', '', '', ''],
        correctIndex: 0,
      ),
      isNew: true,
    );
  }

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
    final List<Question> updatedQuestions =
    _questions.map(_convertToQuestion).toList();

    final updatedQuiz = Quiz(
      id: widget.quiz.id,
      title: _titleController.text,
      category: widget.quiz.category, // Keep the original category for now
      questions: updatedQuestions,
    );

    try {
      await quizViewModel.updateQuiz(updatedQuiz);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Quiz updated successfully')));
      Navigator.pop(context); // Go back to the previous screen
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error updating quiz: $e')));
    }
  }


  void _showQuestionDialog({
    required QuizQuestion question,
    bool isNew = false,
  }) {
    showDialog(
      context: context,
      builder: (context) => QuestionEditDialog(
        question: question,
        onSave: (updatedQuestion) {
          if (_hasDuplicateOptions(updatedQuestion.options)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Options cannot have the same value')),
            );
            return;
          }
          setState(() {
            if (isNew) {
              _questions.add(updatedQuestion);
            } else {
              final index = _questions.indexWhere(
                    (q) => q.question == question.question,
              );
              if (index != -1) {
                _questions[index] = updatedQuestion;
              }
            }
          });
        },
        onDelete: isNew
            ? null
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

  bool _hasDuplicateOptions(List<String> options) {
    final seenOptions = <String>{};
    for (final option in options) {
      if (seenOptions.contains(option.trim())) {
        return true;
      }
      seenOptions.add(option.trim());
    }
    return false;
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
                  icon: const Icon(Symbols.edit, size: 20),
                  onPressed: () {
                    _showQuestionDialog(question: question);
                  },
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Quiz'), centerTitle: true),
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