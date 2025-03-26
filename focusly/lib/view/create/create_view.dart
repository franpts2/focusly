import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'create_view_add_quiz.dart';

class CreateView extends StatelessWidget {
  const CreateView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text("Create"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(Symbols.add_circle), // Your icon
                Text(' Add', style: TextStyle(fontSize: 22)),
              ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    margin: const EdgeInsets.all(10.0),
                    width: 170,
                    height: 170,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: colorScheme.primaryContainer,
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Row (
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Symbols.add_box),
                              Text(' Flashcards', style: TextStyle(fontSize: 20)),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ),
                Flexible(
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateViewAddQuiz(),
                          ),
                        );
                      },
                      child: Container(
                          padding: const EdgeInsets.all(10.0),
                          margin: const EdgeInsets.all(10.0),
                          width: 170,
                          height: 170,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: colorScheme.primaryContainer,
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Row (
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(Symbols.add_box),
                                    Text(' Quiz', style: TextStyle(fontSize: 20)),
                                  ],
                                )
                              ],
                            ),
                          ),
                      )
                  )
                ),
              ],
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Symbols.edit), // Your icon
                  Text(' Edit', style: TextStyle(fontSize: 22)),
                ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                      child: Container(
                          padding: const EdgeInsets.all(10.0),
                          margin: const EdgeInsets.all(10.0),
                          height: 190,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: colorScheme.primaryContainer,
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Row (
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(' My Flashcards', style: TextStyle(fontSize: 20)),
                                  ],
                                )
                              ],
                            ),
                          ),
                    )
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                    child: Container(
                        padding: const EdgeInsets.all(10.0),
                        margin: const EdgeInsets.all(10.0),
                        height: 190,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: colorScheme.primaryContainer,
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Row (
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(' My Quizzes', style: TextStyle(fontSize: 20)),
                                ],
                              )
                            ],
                          ),
                        ),
                    )
                )
              ],
            )
          ],
        ),
      )
    );
  }
}