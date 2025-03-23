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

  testWidgets('Test Case 4: Pause the TImer', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: PomodoroView(skipNotifications: true), // Skip notifications
    ));

    // Tap the Pomodoro mode button (already selected by default)
    await tester.tap(find.widgetWithText(TextButton, "Pomodoro"));
    await tester.pump();

    // Tap the Start button
    await tester.tap(find.text("START"));
    await tester.pump();

    // Wait for 5 seconds to simulate the timer running
    await tester.pump(Duration(seconds: 5));

    // Tap the Pause button
    await tester.tap(find.text("PAUSE"));
    await tester.pump();

    // Verify the timer is paused and shows the correct remaining time (25:00 - 5 seconds = 24:55)
    expect(find.text("24:55"), findsOneWidget);
  });

  testWidgets('Test Case 5: Reset the Timer', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: PomodoroView(skipNotifications: true), // Skip notifications
    ));

    // Tap the Pomodoro mode button (already selected by default)
    await tester.tap(find.widgetWithText(TextButton, "Pomodoro"));
    await tester.pump();

    // Tap the Start button
    await tester.tap(find.text("START"));
    await tester.pump();

    // Wait for 5 seconds to simulate the timer running
    await tester.pump(Duration(seconds: 5));

    // Tap the Reset button
    await tester.tap(find.text("RESET"));
    await tester.pump();

    // Verify the timer resets to the initial value (25:00)
    expect(find.text("25:00"), findsOneWidget);
  });
}