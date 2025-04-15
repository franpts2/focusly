import 'package:flutter/material.dart';
import 'package:focusly/view/auth/signin_view.dart';
import 'package:focusly/view/auth/signup_view.dart';
//import 'package:focusly/auth/signup_view.dart';

class InitialPageView extends StatelessWidget {
  const InitialPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor =
        Theme.of(context).primaryColor; // Primary color from the theme
    final tertiaryColor =
        Theme.of(context).colorScheme.tertiary; // Tertiary color from the theme

    // Get screen dimensions for responsive layout
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Welcome text
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.08,
              vertical: screenHeight * 0.15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.1),
                Text(
                  "Start organizing\nyour study now",
                  style: const TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          // Sign In button 
          Positioned(
            top:
                screenHeight *
                0.55, // Relative positioning (55% of screen height)
            left: 0, // Partially cut by the screen
            child: ElevatedButton(
              onPressed: () {
                // Using pushReplacement instead of push
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInView()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(60),
                  ),
                ),
                padding: EdgeInsets.only(
                  left:
                      screenWidth *
                      0.10, // Less padding on left to move text left
                  right: screenWidth * 0.22, // More padding on right
                  top: screenHeight * 0.035,
                  bottom: screenHeight * 0.035,
                ),
                alignment: Alignment.centerLeft, // Align text to the left
              ),
              child: const Text(
                "Sign In",
                style: TextStyle(
                  fontSize: 36,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),

          // Sign Up button 
          Positioned(
            top:
                screenHeight * 0.70,
            right: 0, // Partially cut by the screen
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpView()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: tertiaryColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(60),
                  ),
                ),
                padding: EdgeInsets.only(
                  left: screenWidth * 0.22, // More padding on left
                  right:
                      screenWidth *
                      0.10, // Less padding on right to move text right
                  top: screenHeight * 0.035,
                  bottom: screenHeight * 0.035,
                ),
                alignment: Alignment.centerRight, // Align text to the right
              ),
              child: const Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 36,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
