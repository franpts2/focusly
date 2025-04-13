import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:focusly/view/navigation/navigation_view.dart';
import 'package:focusly/auth/initial_view.dart';

class AuthenticationService with ChangeNotifier {
  GoogleSignInAccount? _currentUser;
  String? _cachedAvatarUrl;
  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _auth;

  GoogleSignInAccount? get currentUser => _currentUser;

  AuthenticationService({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  }) : _auth = firebaseAuth ?? FirebaseAuth.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn() {
    _loadCachedAvatar();

    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _currentUser = _googleSignIn.currentUser;
      } else {
        _currentUser = null;
        _cachedAvatarUrl = null;
      }
      notifyListeners();
    });
  }

  Future<void> _loadCachedAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    _cachedAvatarUrl = prefs.getString('userAvatar');
    notifyListeners();
  }

  Future<void> signIn({BuildContext? context}) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      _cachedAvatarUrl = googleUser.photoUrl;
      _saveUserAvatar(_cachedAvatarUrl);

      _currentUser = googleUser;
      notifyListeners();

      // If context is provided, navigate directly to NavigationView
      if (context != null && context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const NavigationView()),
          (route) => false, // This removes all previous routes
        );
      }
    } catch (error) {
      print("Sign-in error: $error");
    }
  }

  Future<void> signOut({BuildContext? context}) async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    _currentUser = null;
    _cachedAvatarUrl = null;
    _removeUserAvatar();
    notifyListeners();

    // If context is provided, navigate back to InitialPageView
    if (context != null && context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const InitialPageView()),
        (route) => false, // This removes all previous routes
      );
    }
  }

  Future<void> _saveUserAvatar(String? photoURL) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userAvatar', photoURL ?? '');
  }

  Future<void> _removeUserAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userAvatar');
  }

  Future<String?> getUserAvatar() async {
    if (_cachedAvatarUrl != null) {
      return _cachedAvatarUrl;
    }
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userAvatar');
  }

  Future<User?> createUserWithEmailAndPassword(
    String email,
    String password, {
    BuildContext? context,
  }) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // If user creation was successful and context is provided, navigate to NavigationView
      if (userCredential.user != null && context != null && context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const NavigationView()),
          (route) => false, // This removes all previous routes
        );
      }

      return userCredential.user;
    } catch (e) {
      print("Error creating user: $e");
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password, {
    BuildContext? context,
  }) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null && context != null && context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const NavigationView()),
          (route) => false,
        );
      }

      return userCredential.user;
    } catch (e) {
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Sign in failed: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }

      return null;
    }
  }
}
