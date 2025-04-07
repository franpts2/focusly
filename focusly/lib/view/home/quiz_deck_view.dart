import 'dart:math';
import 'package:flutter/material.dart';
import 'package:focusly/model/quiz_model.dart';

class QuizDeckView extends StatefulWidget {
  final Quiz quizDeck;

  const QuizDeckView({super.key, required this.quizDeck});

  @override
  State<QuizDeckView> createState() => _QuizDeckViewState();
}

class _QuizDeckViewState extends State<QuizDeckView> {

  @override
  Widget build(BuildContext context) {
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(

            ),
          ],
        ),
      ),
    );
  }

}