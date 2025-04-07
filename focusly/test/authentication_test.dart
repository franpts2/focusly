import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/auth/initial_view.dart';
import 'package:focusly/auth/signin_view.dart';
import 'package:focusly/auth/signup_view.dart';
import 'package:focusly/services/authentication_service.dart';
import 'package:focusly/view/navigation/navigation_view.dart';
import 'package:provider/provider.dart';

class TestAuthService extends AuthenticationService {
  final bool shouldSucceed;

  TestAuthService({this.shouldSucceed = true});

  @override
  Future<void> signIn({BuildContext? context}) async {
    if (shouldSucceed && context != null && context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const NavigationView()),
            (route) => false,
      );
    }
  }

  @override
  Future<void> signUp({BuildContext? context}) async {
    if (shouldSucceed && context != null && context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const NavigationView()),
            (route) => false,
      );
    }
  }
}

void main() {
  testWidgets('Acceptance Test 1: InitialPageView shows buttons', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<AuthenticationService>(
          create: (_) => TestAuthService(),
          child: const InitialPageView(),
        ),
      ),
    );

    expect(find.text("Sign In"), findsOneWidget);
    expect(find.text("Sign Up"), findsOneWidget);
  });


  testWidgets('Acceptance Test 2: SignIn button navigates to SignInView', (WidgetTester tester) async {
    final authService = TestAuthService();

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<AuthenticationService>.value(
          value: authService,
          child: const InitialPageView(),
        ),
        routes: {
          '/signin': (context) => ChangeNotifierProvider<AuthenticationService>.value(
            value: authService,
            child: const SignInView(),
          ),
        },
      ),
    );

    await tester.tap(find.text("Sign In"));
    await tester.pump(); // Start navigation
    await tester.pumpAndSettle(); // Complete navigation
    expect(find.byType(SignInView), findsOneWidget);
  });

  testWidgets('Acceptance Test 3: Successful sign-in navigates to NavigationView', (WidgetTester tester) async {
    final authService = TestAuthService(shouldSucceed: true);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChangeNotifierProvider<AuthenticationService>.value(
            value: authService,
            child: Builder(
              builder: (context) => ElevatedButton(
                child: const Text('Sign in with Google'),
                onPressed: () => authService.signIn(context: context),
              ),
            ),
          ),
        ),
        routes: {
          '/home': (context) => const NavigationView(),
        },
      ),
    );

    await tester.tap(find.text('Sign in with Google'));
    await tester.pump(); // Start navigation
    await tester.pumpAndSettle(); // Complete navigation
    expect(find.byType(NavigationView), findsOneWidget);
  });

  testWidgets('Acceptance Test 4: SignUp button navigates to SignUpView', (WidgetTester tester) async {
    final authService = TestAuthService();

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<AuthenticationService>.value(
          value: authService,
          child: const InitialPageView(),
        ),
        routes: {
          '/signup': (context) => ChangeNotifierProvider<AuthenticationService>.value(
            value: authService,
            child: const SignUpView(),
          ),
        },
      ),
    );

    await tester.tap(find.text("Sign Up"));
    await tester.pump(); // Start navigation
    await tester.pumpAndSettle(); // Complete navigation
    expect(find.byType(SignUpView), findsOneWidget);
  });
}