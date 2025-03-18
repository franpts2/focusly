import 'package:flutter/material.dart';

class PomodoroView extends StatefulWidget {
  const PomodoroView({super.key});

  @override
  _PomodoroViewState createState() => _PomodoroViewState();
  
}

class _PomodoroViewState extends State<PomodoroView> {
  String selectedMode = "Pomodoro"; //default selected mode

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
          padding: EdgeInsets.symmetric(
            horizontal: 3,
            vertical: 12,
          ),
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
    bool isSelected = selectedMode == mode; // Check if button is selected
    return TextButton(
      onPressed: () {
        setState(() {
          selectedMode = mode;
        });
      },
      style: TextButton.styleFrom(
        foregroundColor: isSelected
            ? Colors.white // Selected text color
            : Theme.of(context).colorScheme.onPrimaryContainer,
        backgroundColor: isSelected
            ? Theme.of(context).colorScheme.primary // Selected background
            : Colors.transparent, // Unselected background
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(mode),
    );
  }
}

/*
class PomodoroView extends StatelessWidget {
  const PomodoroView({super.key});

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
          padding: EdgeInsets.symmetric(
            horizontal: 3,
            vertical: 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(onPressed: () {}, child: Text("Pomodoro")),
                  TextButton(onPressed: () {}, child: Text("Short Break")),
                  TextButton(onPressed: () {}, child: Text("Long Break")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/