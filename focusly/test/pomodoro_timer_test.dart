

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/view/pomodoro/pomodoro_view.dart';

void main() {
  group('Pomodoro Timer Acceptance Tests', () {

    testWidgets('Test Case 1: Start Pomodoro Timer', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: PomodoroView()));

      //tap the Pomodoro Mode button (already selected by default)
      await tester.tap(find.text('Pomodoro'));
      await tester.pump();

      //tap the Start button
      await tester.tap(find.text('START'));
      await tester.pump();

      //verify that the timer starts counting down from 25:00
      expect(find.text('25:00'), findsOneWidget);
    });

    testWidgets('Test Case 2: Start Short Break Timer', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: PomodoroView()));

      //tap the Short Break Mode button
      await tester.tap(find.text('Short Break'));
      await tester.pump();

      //tap the Start button
      await tester.tap(find.text('START'));
      await tester.pump();

      //verify that the timer starts counting down from 5:00
      expect(find.text('5:00'), findsOneWidget);
    });

    testWidgets('Test Case 3: Start Long Break Timer', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: PomodoroView()));

      //tap the Long Break Mode button
      await tester.tap(find.text('Long Break'));
      await tester.pump();

      //tap the Start button
      await tester.tap(find.text('START'));
      await tester.pump();

      //verify that the timer starts counting down from 15:00
      expect(find.text('15:00'), findsOneWidget);
    });

  });
}