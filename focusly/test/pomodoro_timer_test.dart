import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/auth/initial_view.dart';
import 'package:focusly/auth/signin_view.dart';
import 'package:focusly/auth/signup_view.dart';
import 'package:focusly/view/navigation/navigation_view.dart';

void main() {
  testWidgets('InitialPageView has title and buttons', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: InitialPageView()));

    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
    // Optional: Check for your app name or logo
    expect(find.textContaining('Focusly'), findsNothing); // Replace if there's a title
  });

  testWidgets('SignInView has email and password fields', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignInView()));

    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.widgetWithText(TextField, 'Email'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Password'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget); // Button
  });

  testWidgets('SignUpView has sign up form', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignUpView()));

    expect(find.byType(TextField), findsWidgets); // Assume a few fields
    expect(find.text('Create Account'), findsOneWidget); // Adjust to match your button
  });

  testWidgets('NavigationView shows bottom navigation bar', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: NavigationView()));

    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.byIcon(Icons.home), findsOneWidget); // Or whatever icons you use
  });
}