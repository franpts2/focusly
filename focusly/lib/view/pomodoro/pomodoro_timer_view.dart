import 'dart:async';
import 'package:flutter/material.dart';

class PomodoroTimer extends StatefulWidget {
  final int duration;
  final VoidCallback? onTimerEnd;

  const PomodoroTimer({super.key, required this.duration, this.onTimerEnd});

  @override
  State<PomodoroTimer> createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer> {
  late int remainingSeconds;
  Timer? timer;
  bool isRunning = false;
  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    remainingSeconds = widget.duration;
  }

  void startTimer() {
    if (isRunning) return;
    setState(() => isRunning = true);

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() => remainingSeconds--);
      } else {
        timer.cancel();
        setState(() => isRunning = false);
        if (widget.onTimerEnd != null) widget.onTimerEnd!();
      }
    });
  }

  void pauseTimer() {
    setState(() {
      isRunning = false;
      isPaused = true;
    });
    timer?.cancel();
  }

  void resumeTimer() {
    setState(() {
      isRunning = true;
      isPaused = false;
    });

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() => remainingSeconds--);
      } else {
        timer.cancel();
        setState(() => isRunning = false);
        if (widget.onTimerEnd != null) widget.onTimerEnd!();
      }
    });
  }

  void resetTimer() {
    timer?.cancel();
    setState(() {
      remainingSeconds = widget.duration;
      isRunning = false;
      isPaused = false;
    });
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          formatTime(remainingSeconds),
          style: TextStyle(fontSize: 57, fontWeight: FontWeight.w400),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                if (isRunning) {
                  pauseTimer();
                } else if (isPaused) {
                  resumeTimer();
                } else {
                  startTimer();
                }
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(colorScheme.primary),
                foregroundColor: WidgetStateProperty.all(colorScheme.onPrimary),
              ),
              child: Text(isRunning ? "PAUSE" : isPaused ? "RESUME" : "START"),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: resetTimer,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(colorScheme.primary),
                foregroundColor: WidgetStateProperty.all(colorScheme.onPrimary),
              ),
              child: Text("RESET"),
            ),
          ],
        ),
      ],
    );
  }
}