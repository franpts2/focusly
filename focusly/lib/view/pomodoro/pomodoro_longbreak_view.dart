import 'package:flutter/material.dart';
import 'package:focusly/view/pomodoro/pomodoro_timer_view.dart';

class PomodoroLongbreakView extends StatefulWidget {
  const PomodoroLongbreakView({super.key});

  @override
  State<PomodoroLongbreakView> createState() => _PomodoroLongbreakViewState();
}

class _PomodoroLongbreakViewState extends State<PomodoroLongbreakView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: PomodoroTimer(duration: 15 * 60), // 15-minute break
    );
  }
}
