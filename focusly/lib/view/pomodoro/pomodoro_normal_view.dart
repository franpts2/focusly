import 'package:flutter/material.dart';
import 'package:focusly/view/pomodoro/pomodoro_timer_view.dart';

class PomodoroNormalView extends StatefulWidget {
  final bool skipNotifications;

  const PomodoroNormalView({super.key, this.skipNotifications = false});

  @override
  State<PomodoroNormalView> createState() => _PomodoroNormalViewState();
}

class _PomodoroNormalViewState extends State<PomodoroNormalView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: PomodoroTimer(duration: 25 * 60, skipNotifications: widget.skipNotifications,), // 25-minute Pomodoro timer
    );
  }
}
