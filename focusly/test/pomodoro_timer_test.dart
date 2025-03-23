import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/view/pomodoro/pomodoro_view.dart';

void main() {
  testWidgets('Test Case 1: Start Pomodoro Timer', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: PomodoroView(skipNotifications: true), // Pass the flag
    ));

    // Tap the Pomodoro mode button (already selected by default)
    await tester.tap(find.widgetWithText(TextButton, "Pomodoro"));
    await tester.pump();

    // Verify the PomodoroTimer is rendered with the correct duration (25:00)
    expect(find.text("25:00"), findsOneWidget);

    // Tap the Start button
    await tester.tap(find.text("START"));
    await tester.pump();

    // Verify the timer starts counting down from 25:00
    expect(find.text("25:00"), findsOneWidget);
  });

  testWidgets('Test Case 2: Start Short Break Timer', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: PomodoroView(skipNotifications: true), // Pass the flag
    ));

    // Tap the Short Break mode button
    await tester.tap(find.widgetWithText(TextButton, "Short Break"));
    await tester.pump();

    // Verify the PomodoroTimer is rendered with the correct duration (5:00)
    expect(find.text("05:00"), findsOneWidget);

    // Tap the Start button
    await tester.tap(find.text("START"));
    await tester.pump();

    // Verify the timer starts counting down from 5:00
    expect(find.text("05:00"), findsOneWidget);
  });

  testWidgets('Test Case 3: Start Long Break Timer', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: PomodoroView(skipNotifications: true), // Pass the flag
    ));

    // Tap the Long Break mode button
    await tester.tap(find.widgetWithText(TextButton, "Long Break"));
    await tester.pump();

    // Verify the PomodoroTimer is rendered with the correct duration (15:00)
    expect(find.text("15:00"), findsOneWidget);

    // Tap the Start button
    await tester.tap(find.text("START"));
    await tester.pump();

    // Verify the timer starts counting down from 15:00
    expect(find.text("15:00"), findsOneWidget);
  });
}