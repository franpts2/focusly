import 'package:flutter/material.dart';

class PomodoroNormalView extends StatefulWidget {
  const PomodoroNormalView({super.key});

  @override
  State<PomodoroNormalView> createState() => _PomodoroNormalViewState();
}

class _PomodoroNormalViewState extends State<PomodoroNormalView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(  // temporary placeholder for the actual timer
        "25:00",
        style: TextStyle(fontSize: 57, fontWeight: FontWeight.w400),
      ),
    );
  }
}
