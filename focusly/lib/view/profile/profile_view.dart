import 'package:flutter/material.dart';
import 'package:focusly/services/authentication_service.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile"), centerTitle: true),
      body: Center(
        child: Consumer<AuthenticationService>(
          builder: (context, provider, child) {
            return ElevatedButton(
              onPressed: () {
                provider.signOut(context: context);
              },
              child: Text("Sign Out"),
            );
          },
        ),
      ),
    );
  }
}
