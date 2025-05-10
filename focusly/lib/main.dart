import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:focusly/firebase_options.dart';
import 'package:focusly/view/navigation/navigation_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:focusly/viewmodel/category_viewmodel.dart';
import 'package:focusly/viewmodel/flashcard_deck_viewmodel.dart';
import 'package:focusly/viewmodel/forum_answer_viewmodel.dart';
import 'package:focusly/viewmodel/forum_question_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:focusly/services/authentication_service.dart';
import 'package:focusly/viewmodel/quiz_viewmodel.dart';
import 'package:focusly/view/auth/splash_view.dart';
import 'package:focusly/view/auth/initial_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationService()),
        ChangeNotifierProvider(create: (_) => QuizViewModel()),
        ChangeNotifierProvider(create: (_) => FlashcardDeckViewModel()),
        ChangeNotifierProvider(create: (_) => ForumQuestionViewModel()),
        ChangeNotifierProvider(create: (_) => ForumAnswerViewModel()),
        ChangeNotifierProvider(create: (_) => CategoryViewModel()),
        // add other providers here if needed
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/initial': (context) => const InitialPageView(),
        '/splash': (context) => const SplashView(),
      },
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Always show splash screen first when the app starts
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasData) {
            // User is logged in
            return const NavigationView();
          } else {
            // User is not logged in, show initial view directly
            return const InitialPageView();
          }
        },
      ),
    );
  }
}
