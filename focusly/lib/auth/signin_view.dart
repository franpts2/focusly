import 'package:flutter/material.dart';
import 'package:focusly/services/authentication_service.dart';
import 'package:provider/provider.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthenticationService>(context);

    final primaryColor =
        Theme.of(context).primaryColor; // primary color from the theme
    final secondaryColor =
        Theme.of(
          context,
        ).colorScheme.secondary; // Secondary color from the theme
    final tertiaryColor =
        Theme.of(context).colorScheme.tertiary; // tertiary color from the theme

    return Scaffold(
      body: Stack(
        children: [
          // Ellipses at the top
          Positioned(
            top: -80,
            left: -10,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: -70,
            right: -60,
            child: Container(
              width: 250,
              height: 300,
              decoration: BoxDecoration(
                color: secondaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 75,
            left: -60,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: tertiaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Main content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 250,
                  left: 40,
                ), // Adjust position of the text
                child: RichText(
                  textAlign: TextAlign.left, // Align text to the left
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Welcome\n",
                        style: TextStyle(
                          fontSize: 57,
                          fontWeight: FontWeight.w400,
                          color: primaryColor, // Use the primary color
                        ),
                      ),
                      TextSpan(
                        text: "Back",
                        style: TextStyle(
                          fontSize: 57,
                          fontWeight: FontWeight.w400,
                          color: primaryColor, // Use the primary color
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(), // Pushes the button to the bottom
              Center(
                child: ElevatedButton(
                  onPressed: () => authService.signIn(context: context),
                  child: const Text('Sign in with Google'),
                ),
              ),
              const SizedBox(height: 50), // Add spacing at the bottom
            ],
          ),
        ],
      ),
    );
  }
}
