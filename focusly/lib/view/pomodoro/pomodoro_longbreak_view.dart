import 'package:flutter/material.dart';

class PomodoroLongbreakView extends StatefulWidget {
  const PomodoroLongbreakView({super.key});

  @override
  State<PomodoroLongbreakView> createState() => _PomodoroLongbreakViewState();
}

class _PomodoroLongbreakViewState extends State<PomodoroLongbreakView> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        children: [
          Text(
            // temporary placeholder for the actual timer
            "15:00",
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
