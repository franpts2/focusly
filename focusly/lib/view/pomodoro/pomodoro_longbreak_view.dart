import 'package:flutter/material.dart';
import 'package:focusly/view/pomodoro/pomodoro_timer_view.dart';

class PomodoroLongbreakView extends StatefulWidget {
  final bool skipNotifications;

  const PomodoroLongbreakView({super.key, this.skipNotifications = false});

  @override
  State<PomodoroLongbreakView> createState() => _PomodoroLongbreakViewState();
}

class _PomodoroLongbreakViewState extends State<PomodoroLongbreakView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: PomodoroTimer(duration: 15 * 60, skipNotifications: widget.skipNotifications,), // 15-minute break
    );
  }
}
