import 'package:flutter/material.dart';
import 'package:focusly/view/pomodoro/pomodoro_timer_view.dart';

class PomodoroShortbreakView extends StatefulWidget {
  final bool skipNotifications;

  const PomodoroShortbreakView({super.key, this.skipNotifications = false});

  @override
  State<PomodoroShortbreakView> createState() => _PomodoroShortbreakViewState();
}

class _PomodoroShortbreakViewState extends State<PomodoroShortbreakView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: PomodoroTimer(duration: 5 * 60,  skipNotifications: widget.skipNotifications,), // 5-minute break
    );
  }
}
