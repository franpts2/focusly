import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/view/pomodoro/pomodoro_timer_view.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MockFlutterLocalNotificationsPlugin extends Mock
    implements FlutterLocalNotificationsPlugin {}

void main() {
  late MockFlutterLocalNotificationsPlugin mockNotifications;

  setUp(() {
    mockNotifications = MockFlutterLocalNotificationsPlugin();
    // Mock the initialization method
    final initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    when(mockNotifications.initialize(initializationSettings))
      .thenAnswer((_) async => true);
  });

  testWidgets('Test Case 1: Start Pomodoro Timer', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: PomodoroTimer(
        duration: 25 * 60,
        skipNotifications: true, // Skip notifications in tests
      ),
    ));

    // Tap the Pomodoro mode button (already selected by default)
    await tester.tap(find.widgetWithText(TextButton, "Pomodoro"));
    await tester.pump();

    // Tap the Start button
    await tester.tap(find.text("START"));
    await tester.pump();

    // Verify the timer starts counting down from 25:00
    expect(find.text("25:00"), findsOneWidget);
  });

  testWidgets('Test Case 2: Start Short Break Timer', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: PomodoroTimer(
        duration: 5 * 60,
        skipNotifications: true, // Skip notifications in tests
      ),
    ));

    // Tap the Short Break mode button
    await tester.tap(find.widgetWithText(TextButton, "Short Break"));
    await tester.pump();

    // Tap the Start button
    await tester.tap(find.text("START"));
    await tester.pump();

    // Verify the timer starts counting down from 5:00
    expect(find.text("05:00"), findsOneWidget);
  });

  testWidgets('Test Case 3: Start Long Break Timer', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: PomodoroTimer(
        duration: 15 * 60,
        skipNotifications: true, // Skip notifications in tests
      ),
    ));

    // Tap the Long Break mode button
    await tester.tap(find.widgetWithText(TextButton, "Long Break"));
    await tester.pump();

    // Tap the Start button
    await tester.tap(find.text("START"));
    await tester.pump();

    // Verify the timer starts counting down from 15:00
    expect(find.text("15:00"), findsOneWidget);
  });
}