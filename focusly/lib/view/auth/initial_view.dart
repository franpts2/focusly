import 'package:flutter/material.dart';
import 'package:focusly/view/auth/signin_view.dart';
import 'package:focusly/view/auth/signup_view.dart';
//import 'package:focusly/auth/signup_view.dart';

class InitialPageView extends StatelessWidget {
  const InitialPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Get screen dimensions for responsive layout
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          // Welcome text
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.08,
              vertical: screenHeight * 0.15,
            ),
            child: Center(
              // Center the welcome text horizontally
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.1),
                  Text(
                    "Start organizing\nyour study now",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w400,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Sign In button
          Positioned(
            top: screenHeight * 0.55,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: screenWidth * 0.6,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInView(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(60),
                        ),
                      ),
                      padding: EdgeInsets.fromLTRB(
                        screenWidth * 0.06, // left
                        screenHeight * 0.035, // top
                        screenWidth * 0.02, // right
                        screenHeight * 0.035, // bottom
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 36,
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Sign Up button
          Positioned(
            top: screenHeight * 0.70,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: screenWidth * 0.6,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpView(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.tertiary,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(60),
                        ),
                      ),
                      padding: EdgeInsets.fromLTRB(
                        screenWidth * 0.02, // left
                        screenHeight * 0.035, // top
                        screenWidth * 0.06, // right
                        screenHeight * 0.035, // bottom
                      ),
                      alignment: Alignment.centerRight,
                    ),
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 36,
                        color: colorScheme.onTertiary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
