import 'dart:async';

import 'package:flutter/material.dart';
import 'package:focusly/view/auth/initial_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with WidgetsBindingObserver {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Use Future.delayed instead of Timer for more reliable navigation
    _scheduleNavigation();
  }

  void _scheduleNavigation() {
    Future.delayed(Duration(seconds: 2), () {
      _navigateToInitialView();
    });
  }

  void _navigateToInitialView() {
    // Only navigate if not already navigated and context is available
    if (!_navigated && mounted && context != null) {
      _navigated = true;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 600),
          pageBuilder: (_, __, ___) => InitialPageView(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation),
                child: child,
              ),
            );
          },
        ),
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // If app resumes and we're still on the splash screen, try to navigate
    if (state == AppLifecycleState.resumed && !_navigated && mounted) {
      _navigateToInitialView();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ensure we navigate even if the delayed callback somehow missed
    if (!_navigated) {
      // Use a microtask to avoid calling during build
      Future.microtask(() {
        // Add additional delay to allow build to complete
        Future.delayed(Duration(milliseconds: 100), () {
          if (mounted && !_navigated) {
            _scheduleNavigation();
          }
        });
      });
    }

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundColor: Colors.white,
              child: Image.asset('assets/icon/elephant_logo.png', width: 100),
            ),
            const SizedBox(height: 24),
            const Text(
              'focusly',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
