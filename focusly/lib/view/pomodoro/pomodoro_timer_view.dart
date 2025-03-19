import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';


class PomodoroTimer extends StatefulWidget {
  final int duration;
  final VoidCallback? onTimerEnd;

  const PomodoroTimer({super.key, required this.duration, this.onTimerEnd});

  @override
  State<PomodoroTimer> createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer> with WidgetsBindingObserver{
  late int remainingSeconds;
  Timer? timer;
  bool isRunning = false;
  bool isPaused = false;
  AudioPlayer _audioPlayer = AudioPlayer();
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  AppLifecycleState _appLifecycleState = AppLifecycleState.resumed;

  @override
  void initState() {
    super.initState();
    remainingSeconds = widget.duration;

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    WidgetsBinding.instance.addObserver(this);

    _requestPermissions();
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void startTimer() {
    if (isRunning) return;
    setState(() => isRunning = true);

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() => remainingSeconds--);
      } else {
        _playSound();
        if (_appLifecycleState != AppLifecycleState.resumed) {
          _showNotification(remainingSeconds);
        }
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
        if (_appLifecycleState != AppLifecycleState.resumed) {
          _showNotification(remainingSeconds);
        }
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

  void _playSound() async {
    await _audioPlayer.play(AssetSource('sound.wav'));
  }

  Future<void> _requestPermissions() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  void _showNotification(int remainingSeconds) async {
    var androidDetails = AndroidNotificationDetails( 'timer_id', 'Pomodoro Timer', channelDescription: 'Timer end notification',
      priority: Priority.high,
      importance: Importance.high,
    );
    var notificationDetails = NotificationDetails(
      android: androidDetails,
    );
    if (remainingSeconds == 0) {
      await flutterLocalNotificationsPlugin.show(0, 'Pomodoro Timer', 'Timer has ended!', notificationDetails, payload: 'timer_notification',);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _appLifecycleState = state;
  }

  @override
  void dispose() {
    timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
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
            )
          ],
        ),
      ],
    );
  }
}