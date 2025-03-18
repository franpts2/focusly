import 'package:flutter/material.dart';

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
          ), // Padding inside the card
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(onPressed: () {}, child: Text("Pomodoro")),
                  SizedBox(width: 8),
                  TextButton(onPressed: () {}, child: Text("Short Break")),
                  SizedBox(width: 8),
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
