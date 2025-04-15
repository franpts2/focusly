import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:focusly/services/authentication_service.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthenticationService>(context);
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text("Profile"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Profile picture section
            Center(
              child: FutureBuilder<String?>(
                future: authService.getUserAvatar(),
                builder: (context, snapshot) {
                  return Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: theme.primaryColor, width: 3),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child:
                          snapshot.data != null && snapshot.data!.isNotEmpty
                              // Show Google profile picture if available
                              ? Image.network(
                                snapshot.data!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildDefaultAvatar(theme);
                                },
                                loadingBuilder: (
                                  context,
                                  child,
                                  loadingProgress,
                                ) {
                                  if (loadingProgress == null) return child;
                                  return _buildDefaultAvatar(theme);
                                },
                              )
                              // Default avatar for email/password users
                              : _buildDefaultAvatar(theme),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // User name section
            FutureBuilder<String?>(
              future: authService.getUserName(),
              builder: (context, snapshot) {
                String displayName =
                    snapshot.data ??
                    (user?.displayName ??
                        (user?.email?.split('@').first ?? 'User'));

                return Text(
                  displayName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                );
              },
            ),

            Text(
              user?.email ?? '',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),

            const SizedBox(height: 40),

            // Sign out button
            ElevatedButton(
              onPressed: () {
                authService.signOut(context: context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: const Text("Sign Out"),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build default avatar
  Widget _buildDefaultAvatar(ThemeData theme) {
    return Container(
      color: theme.primaryColor.withOpacity(0.2),
      child: Icon(Icons.person, size: 60, color: theme.primaryColor),
    );
  }
}
