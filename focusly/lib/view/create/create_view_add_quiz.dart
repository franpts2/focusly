import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class CreateViewAddQuiz extends StatelessWidget {
  const CreateViewAddQuiz({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Quiz'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 7,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        hintText: 'Name your quiz here',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16), // Space between fields
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Divider(
                  thickness: 1, // Line thickness
                  height: 1, // Space the divider takes
                  color: Colors.grey, // Line color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}