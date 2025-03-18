import 'package:flutter/material.dart';
import 'package:focusly/view/pomodoro/pomodoro_timer_view.dart';

class PomodoroNormalView extends StatefulWidget {
  const PomodoroNormalView({super.key});

  @override
  State<PomodoroNormalView> createState() => _PomodoroNormalViewState();
}

class _PomodoroNormalViewState extends State<PomodoroNormalView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: PomodoroTimer(duration: 15), // 25-minute Pomodoro timer
    );
  }
}