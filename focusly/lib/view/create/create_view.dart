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
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            // change this to a create flashcards page
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
                                const Icon(Symbols.library_add),
                                Text(' Flashcards', style: TextStyle(fontSize: 20)),
                              ],
                            ),
                            SizedBox(height: 18),
                            Text('Boost your memory with cards', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54, fontSize: 19),),
                          ],
                        ),
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
                                    const Icon(Symbols.quiz),
                                    Text(' Quiz', style: TextStyle(fontSize: 20)),
                                  ],
                                ),
                                SizedBox(height: 18),
                                Text('Test your knowledge with a quiz', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54, fontSize: 19),),
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