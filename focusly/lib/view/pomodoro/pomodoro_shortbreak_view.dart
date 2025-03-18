import 'package:flutter/material.dart';

class PomodoroShortbreakView extends StatefulWidget {
  const PomodoroShortbreakView({super.key});

  @override
  State<PomodoroShortbreakView> createState() => _PomodoroShortbreakViewState();
}

class _PomodoroShortbreakViewState extends State<PomodoroShortbreakView> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        children: [
          Text(
            // temporary placeholder for the actual timer
            "05:00",
            style: TextStyle(fontSize: 57, fontWeight: FontWeight.w400),
          ),
          ElevatedButton(
            onPressed: () {
              // Start the timer
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(colorScheme.primary),
              foregroundColor: WidgetStateProperty.all(colorScheme.onPrimary),
            ),
            child: Text("START"),
          ),
        ],
      ),
    );
  }
}
