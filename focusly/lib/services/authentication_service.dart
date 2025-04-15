import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:focusly/view/navigation/navigation_view.dart';
import 'package:focusly/view/auth/initial_view.dart';
import 'package:focusly/viewmodel/flashcard_deck_viewmodel.dart';
import 'package:focusly/viewmodel/quiz_viewmodel.dart';
import 'package:provider/provider.dart';

class AuthenticationService with ChangeNotifier {
  GoogleSignInAccount? _currentUser;
  String? _cachedAvatarUrl;
  String? _cachedUserName;
  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _auth;

  GoogleSignInAccount? get currentUser => _currentUser;

  AuthenticationService({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  }) : _auth = firebaseAuth ?? FirebaseAuth.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn() {
    _loadCachedData();

    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _currentUser = _googleSignIn.currentUser;
        if (_currentUser == null && user.displayName != null) {
          _saveUserName(user.displayName);
        }
      } else {
        _currentUser = null;
        _cachedAvatarUrl = null;
      }
      notifyListeners();
    });
  }

  Future<void> _loadCachedData() async {
    final prefs = await SharedPreferences.getInstance();
    _cachedAvatarUrl = prefs.getString('userAvatar');
    _cachedUserName = prefs.getString('userName');
    notifyListeners();
  }

  Future<void> signIn({BuildContext? context}) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
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

      _cachedUserName = googleUser.displayName;
      _saveUserName(_cachedUserName);

      _currentUser = googleUser;
      notifyListeners();

      if (context != null && context.mounted) {
        // Refresh data in viewmodels to ensure we're loading the correct user's data
        _refreshUserData(context);

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const NavigationView()),
          (route) => false,
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

    if (context != null && context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const InitialPageView()),
        (route) => false,
      );
    }
  }

  // Helper method to refresh user-specific data in viewmodels
  void _refreshUserData(BuildContext context) {
    try {
      // Refresh flashcard decks
      final flashcardViewModel = Provider.of<FlashcardDeckViewModel>(
        context,
        listen: false,
      );
      flashcardViewModel.refreshDecks();

      // Refresh quizzes
      final quizViewModel = Provider.of<QuizViewModel>(context, listen: false);
      quizViewModel.refreshQuizzes();
    } catch (e) {
      print("Error refreshing user data: $e");
    }
  }

  Future<void> _saveUserAvatar(String? photoURL) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userAvatar', photoURL ?? '');
  }

  Future<void> _saveUserName(String? name) async {
    if (name != null && name.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', name);
      _cachedUserName = name;
    }
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

  Future<String?> getUserName() async {
    if (_cachedUserName != null) {
      return _cachedUserName;
    }

    final prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('userName');

    if (name == null || name.isEmpty) {
      final user = _auth.currentUser;
      if (user?.displayName != null) {
        name = user!.displayName;
        await _saveUserName(name);
      }
    }

    return name;
  }

  Future<User?> createUserWithEmailAndPassword(
    String email,
    String password, {
    BuildContext? context,
    String? name,
  }) async {
    try {
      if (context != null) {
        FocusScope.of(context).unfocus();
      }

      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (name != null && name.isNotEmpty) {
        await userCredential.user?.updateDisplayName(name);
        await _saveUserName(name); // Save the username locally
      }

      if (userCredential.user != null && context != null && context.mounted) {
        _refreshUserData(context);
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
            content: Text("Sign up failed: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password, {
    BuildContext? context,
  }) async {
    try {
      if (context != null) {
        FocusScope.of(context).unfocus();
      }

      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user?.displayName != null) {
        _saveUserName(userCredential.user!.displayName);
      }

      if (userCredential.user != null && context != null && context.mounted) {
        await Future.delayed(const Duration(milliseconds: 50));

        // Refresh data in viewmodels to ensure we're loading the correct user's data
        _refreshUserData(context);

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
