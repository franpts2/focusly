import 'package:flutter/material.dart';
import 'package:focusly/services/authentication_service.dart';
import 'package:provider/provider.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final authService = Provider.of<AuthenticationService>(context, listen: false,);
            await authService.signIn();
          },
          child: const Text('Sign in with Google'),
        ),
      ),
    );
  }
}
