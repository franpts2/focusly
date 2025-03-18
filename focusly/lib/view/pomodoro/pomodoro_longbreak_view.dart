import 'package:flutter/material.dart';

class PomodoroLongbreakView extends StatefulWidget {
  const PomodoroLongbreakView({super.key});

  @override
  State<PomodoroLongbreakView> createState() => _PomodoroLongbreakViewState();
}

class _PomodoroLongbreakViewState extends State<PomodoroLongbreakView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(  // temporary placeholder for the actual timer
        "15:00",
        style: TextStyle(fontSize: 57, fontWeight: FontWeight.w400),
      ),
    );
  }
}
