import 'package:flutter/material.dart';
import 'package:focusly/auth/signin_view.dart';
import 'package:focusly/auth/signup_view.dart';

class InitialPageView extends StatelessWidget {
  const InitialPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor =
        Theme.of(context).primaryColor; // Primary color from the theme
    final tertiaryColor =
        Theme.of(context).colorScheme.tertiary; // Tertiary color from the theme

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Welcome text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
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

          // Sign In button (left, slightly higher)
          Positioned(
            top: 450, // Adjust the vertical position
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 70,
                  vertical: 30,
                ),
                alignment: Alignment.center,
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

          // Sign Up button (right, slightly lower)
          Positioned(
            top: 580, // Adjust the vertical position
            right: 0, // Partially cut by the screen
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder:
                        (context, animation, secondaryAnimation) =>
                            const SignUpView(),
                    transitionsBuilder: (
                      context,
                      animation,
                      secondaryAnimation,
                      child,
                    ) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.easeInOut;

                      var tween = Tween(
                        begin: begin,
                        end: end,
                      ).chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: tertiaryColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(60),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 70,
                  vertical: 30,
                ),
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
