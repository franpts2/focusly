import 'package:flutter/material.dart';
import 'package:focusly/view/pomodoro/pomodoro_longbreak_view.dart';
import 'package:focusly/view/pomodoro/pomodoro_normal_view.dart';
import 'package:focusly/view/pomodoro/pomodoro_shortbreak_view.dart';

class PomodoroView extends StatefulWidget {
  final bool skipNotifications;

  const PomodoroView({super.key, required this.skipNotifications});

  @override
  PomodoroViewState createState() => PomodoroViewState();
}

class PomodoroViewState extends State<PomodoroView> {
  String selectedMode = "Pomodoro"; // Default selected mode

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text("Pomodoro"), centerTitle: true),
      body: Center(
        child: Container(
          width: 326,
          height: 230,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color:
                Theme.of(context).brightness == Brightness.light
                    ? colorScheme.primaryContainer
                    : colorScheme.secondaryContainer,
          ),
          padding: EdgeInsets.symmetric(horizontal: 3, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: _buildModeButton("Pomodoro")),
                  Flexible(child: _buildModeButton("Short Break")),
                  Flexible(child: _buildModeButton("Long Break")),
                ],
              ),
              if (selectedMode == 'Pomodoro')
                PomodoroNormalView(skipNotifications: widget.skipNotifications),
              if (selectedMode == 'Short Break')
                PomodoroShortbreakView(
                  skipNotifications: widget.skipNotifications,
                ),
              if (selectedMode == 'Long Break')
                PomodoroLongbreakView(
                  skipNotifications: widget.skipNotifications,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeButton(String mode) {
    bool isSelected = selectedMode == mode;
    final colorScheme = Theme.of(context).colorScheme;

    return TextButton(
      onPressed: () {
        setState(() {
          selectedMode = mode; // Update selected mode
        });
      },
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(
          colorScheme.onPrimaryContainer,
        ),
        backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (isSelected) {
            return colorScheme.primary.withValues(
              alpha: 0.2,
            ); // Light purple when selected
          }
          return Colors.transparent; // default (no background)
        }),
        overlayColor: WidgetStateProperty.all(
          colorScheme.primary.withValues(alpha: 0.3),
        ), // Hover effect
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
      child: Text(mode),
    );
  }
}
