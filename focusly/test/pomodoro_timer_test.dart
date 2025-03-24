import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/view/navigation/navigation_view.dart';
import 'package:focusly/view/pomodoro/pomodoro_view.dart';
import 'package:material_symbols_icons/symbols.dart';

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

  testWidgets("Test Case 6: Ensure Timer Doesn't Skip or Freeze", (WidgetTester tester) async {
    // Start at PomodoroView with skipNotifications: true
    await tester.pumpWidget(MaterialApp(
      home: PomodoroView(skipNotifications: true), // Skip notifications
    ));

    // Wait for the UI to fully load
    await tester.pumpAndSettle();

    // Verify the Pomodoro screen is displayed by checking the AppBar title
    expect(find.descendant(
      of: find.byType(AppBar),
      matching: find.text("Pomodoro"),
    ), findsOneWidget);

    // Tap the Pomodoro mode button (already selected by default)
    await tester.tap(find.widgetWithText(TextButton, "Pomodoro"));
    await tester.pump();

    // Tap the Start button
    await tester.tap(find.text("START"));
    await tester.pump();

    // Verify the timer starts counting down from 25:00
    expect(find.text("25:00"), findsOneWidget);

    // Now, navigate to the NavigationView to switch tabs
    await tester.pumpWidget(MaterialApp(
      home: NavigationView(), // Switch to NavigationView
    ));
    await tester.pumpAndSettle();

    // Tap the Home icon to switch to the Home tab
    await tester.tap(find.byIcon(Symbols.family_home));
    await tester.pumpAndSettle();

    // Simulate time passing (e.g., 10 seconds)
    await tester.pump(Duration(seconds: 10));

    // Navigate back to the Pomodoro screen
    await tester.tap(find.byIcon(Symbols.timer));
    await tester.pumpAndSettle();

    // Verify the timer is still running and shows the correct remaining time (25:00 - 10 seconds = 24:50)
    expect(find.text("24:50"), findsOneWidget);
  });

  testWidgets('Test Case 7: Display Correct Active Mode', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: PomodoroView(skipNotifications: true), // Skip notifications
    ));

    // Get the color scheme from the theme
    final colorScheme = Theme.of(tester.element(find.byType(PomodoroView))).colorScheme;

    // Verify the Pomodoro mode is visually highlighted by default
    final pomodoroButton = tester.widget<TextButton>(find.widgetWithText(TextButton, "Pomodoro"));
    expect(
      pomodoroButton.style?.backgroundColor?.resolve({}),
      colorScheme.primary.withOpacity(0.2), // Check the highlight color
    );

    // Verify the Short Break mode is not highlighted
    final shortBreakButton = tester.widget<TextButton>(find.widgetWithText(TextButton, "Short Break"));
    expect(
      shortBreakButton.style?.backgroundColor?.resolve({}),
      Colors.transparent, // Check that the background is transparent
    );

    // Verify the Long Break mode is not highlighted
    final longBreakButton = tester.widget<TextButton>(find.widgetWithText(TextButton, "Long Break"));
    expect(
      longBreakButton.style?.backgroundColor?.resolve({}),
      Colors.transparent, // Check that the background is transparent
    );

    // Tap the Short Break mode button
    await tester.tap(find.widgetWithText(TextButton, "Short Break"));
    await tester.pump();

    // Verify the Short Break mode is now highlighted
    expect(
      tester.widget<TextButton>(find.widgetWithText(TextButton, "Short Break")).style?.backgroundColor?.resolve({}),
      colorScheme.primary.withOpacity(0.2), // Check the highlight color
    );

    // Verify the Pomodoro mode is no longer highlighted
    expect(
      tester.widget<TextButton>(find.widgetWithText(TextButton, "Pomodoro")).style?.backgroundColor?.resolve({}),
      Colors.transparent, // Check that the background is transparent
    );

    // Verify the Long Break mode is still not highlighted
    expect(
      tester.widget<TextButton>(find.widgetWithText(TextButton, "Long Break")).style?.backgroundColor?.resolve({}),
      Colors.transparent, // Check that the background is transparent
    );
  });

  testWidgets('Test Case 8: Ensure UI Matches Mockups', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: PomodoroView(skipNotifications: true), // Skip notifications
    ));

    // Verify the layout matches the mockups
    expect(find.byType(AppBar), findsOneWidget); // Check for the AppBar

    // Use a more specific finder for the "Pomodoro" text
    expect(find.descendant(
      of: find.byType(AppBar),
      matching: find.text("Pomodoro"),
    ), findsOneWidget); // Check for the title in the AppBar

    expect(find.byType(TextButton), findsNWidgets(3)); // Check for 3 mode buttons
    expect(find.text("START"), findsOneWidget); // Check for the Start button
    expect(find.text("RESET"), findsOneWidget); // Check for the Reset button

    // Verify the colors match the mockups
    final colorScheme = Theme.of(tester.element(find.byType(PomodoroView))).colorScheme;
    expect(
      tester.widget<TextButton>(find.widgetWithText(TextButton, "Pomodoro")).style?.backgroundColor?.resolve({}),
      colorScheme.primary.withOpacity(0.2), // Check the highlight color
    );
  });

}