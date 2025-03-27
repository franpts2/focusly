import 'package:flutter/material.dart';
import 'package:focusly/services/authentication_service.dart';
import 'package:provider/provider.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor =
        Theme.of(context).primaryColor; // Get the primary color from the theme

    return Scaffold(
      body: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Align children to the start (left)
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 250,
              left: 20,
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
              onPressed: () async {
                final authService = Provider.of<AuthenticationService>(
                  context,
                  listen: false,
                );
                await authService.signIn();
              },
              child: const Text('Sign in with Google'),
            ),
          ),
          const SizedBox(height: 50), // Add spacing at the bottom
        ],
      ),
    );
  }
}
