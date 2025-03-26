import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class CreateViewAddQuiz extends StatelessWidget {
  const CreateViewAddQuiz({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New Quiz"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text("Quiz Creation Page Content"),
      ),
    );
  }
}