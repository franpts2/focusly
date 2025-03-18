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

/* 
-> The following buttons are meant to be associated with the respective funcionality

PAUSE BUTTON: when the timer starts, this button replaces the start button and makes the timer pause
ElevatedButton(
  onPressed: () {
    // pause timer here
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
  child: Text("PAUSE"),
),

RESTART BUTTON: when the timer ends, this button replaces the pause button and makes the timer reset
ElevatedButton(
  onPressed: () {
    // reset timer here
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
  child: Text("RESET"),
),

*/
