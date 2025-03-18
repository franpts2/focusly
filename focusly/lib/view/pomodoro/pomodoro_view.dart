import 'package:flutter/material.dart';

class PomodoroView extends StatefulWidget {
  const PomodoroView({super.key});

  @override
  _PomodoroViewState createState() => _PomodoroViewState();
}

class _PomodoroViewState extends State<PomodoroView> {
  String selectedMode = "Pomodoro"; // Default selected mode

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text("Pomodoro"), centerTitle: true),
      body: Center(
        child: Container(
          width: 326,
          height: 230,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: colorScheme.primaryContainer,
          ),
          padding: EdgeInsets.symmetric(horizontal: 3, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildModeButton("Pomodoro"),
                  _buildModeButton("Short Break"),
                  _buildModeButton("Long Break"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeButton(String mode) {
    bool isSelected = selectedMode == mode;
    var colorScheme = Theme.of(context).colorScheme;

    return TextButton(
      onPressed: () {
        setState(() {
          selectedMode = mode; // Update selected mode
        });
      },
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(colorScheme.onPrimaryContainer),
        backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (isSelected) {
            return colorScheme.primary.withValues(alpha: 0.2); // Light purple when selected
          }
          return Colors.transparent; // default (no background)
        }),
        overlayColor: WidgetStateProperty.all(colorScheme.primary.withValues(alpha: 0.3)), // Hover effect
        padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 12, vertical: 6)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
      child: Text(mode),
    );
  }


}