import 'package:flutter/material.dart';

class PomodoroNormalView extends StatefulWidget {
  const PomodoroNormalView({super.key});

  @override
  State<PomodoroNormalView> createState() => _PomodoroNormalViewState();
}

class _PomodoroNormalViewState extends State<PomodoroNormalView> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        children: [
          Text(
            // temporary placeholder for the actual timer
            "25:00",
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

/* 
-> The following buttons are meant to be associated with the respective funcionality

PAUSE BUTTON: when the timer starts, this button replaces the start button and makes the timer pause
ElevatedButton(
  onPressed: () {
    // Pause the timer
  },
  style: ButtonStyle(
    backgroundColor: WidgetStateProperty.all(colorScheme.primary),
    foregroundColor: WidgetStateProperty.all(colorScheme.onPrimary),
  ),
  child: Text("PAUSE"),
),

RESTART BUTTON: when the timer ends, this button replaces the pause button and makes the timer reset
ElevatedButton(
  onPressed: () {
    // Reset the timer
  },
  style: ButtonStyle(
    backgroundColor: WidgetStateProperty.all(colorScheme.primary),
    foregroundColor: WidgetStateProperty.all(colorScheme.onPrimary),
  ),
  child: Text("RESET"),
),

*/
