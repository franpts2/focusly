import 'package:flutter/material.dart';

class PomodoroShortbreakView extends StatefulWidget {
  const PomodoroShortbreakView({super.key});

  @override
  State<PomodoroShortbreakView> createState() => _PomodoroShortbreakViewState();
}

class _PomodoroShortbreakViewState extends State<PomodoroShortbreakView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(  // temporary placeholder for the actual timer
        "05:00",
        style: TextStyle(fontSize: 57, fontWeight: FontWeight.w400),
      ),
    );
  }
}
