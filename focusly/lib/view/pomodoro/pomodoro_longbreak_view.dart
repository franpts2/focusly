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
              // start timer here
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
                if (states.contains(WidgetState.pressed)) {
                  return colorScheme.primary.withValues(alpha: 0.7); // Slightly darker when pressed
                }
                return colorScheme.primary;
              }),
              foregroundColor: WidgetStateProperty.all(colorScheme.onPrimary),
              overlayColor: WidgetStateProperty.all(Colors.white.withValues(alpha: 0.2)), // Ripple effect
            ),
            child: Text("START"),
          ),
        ],
      ),
    );
  }
}
