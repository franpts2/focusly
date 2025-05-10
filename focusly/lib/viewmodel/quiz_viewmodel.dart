import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:focusly/model/quiz_model.dart';

class QuizViewModel extends ChangeNotifier {
  final List<Quiz> _quizzes = [];
  DatabaseReference? _databaseReference;
  bool _isInitialized = false;

  List<Quiz> get quizzes => _quizzes;

  QuizViewModel() {
    _initialize();
  }

  Future<void> _initialize() async {
    if (_isInitialized) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _databaseReference = FirebaseDatabase.instance
          .ref()
          .child(user.uid)
          .child("quizzes");
      await _loadQuizzes();
      _isInitialized = true;
    }
  }

  Future<void> addQuiz(Quiz quiz) async {
    // Make sure we're initialized
    if (!_isInitialized) {
      await _initialize();
    }

    // Check if we're still not initialized (user might not be logged in)
    if (!_isInitialized || _databaseReference == null) {
      throw Exception('Cannot add quiz: User not authenticated');
    }

    // Use the push() method on the direct quizzes reference
    final newQuizRef = _databaseReference!.push();
    final quizID = newQuizRef.key!;
    final quizWithID = quiz.copyWith(id: quizID);

    // Save quiz data without nesting the user ID again
    await newQuizRef.set(quizWithID.toJson());

    // Add to local list
    _quizzes.add(quizWithID);
    notifyListeners();
  }

  Future<void> updateQuiz(Quiz quiz) async {
    if (!_isInitialized) {
      await _initialize();
    }

    if (_databaseReference == null) {
      throw Exception('Cannot update quiz: Database reference not initialized');
    }

    if (quiz.id == null) {
      throw Exception('Cannot update quiz without an ID');
    }

    await _databaseReference!.child(quiz.id!).update(quiz.toJson());

    // Update local list
    final index = _quizzes.indexWhere((q) => q.id == quiz.id);
    if (index >= 0) {
      _quizzes[index] = quiz;
      notifyListeners();
    }
  }

  Future<void> deleteQuiz(String quizId) async {
    if (!_isInitialized) {
      await _initialize();
    }

    if (_databaseReference == null) {
      throw Exception('Cannot delete quiz: Database reference not initialized');
    }

    await _databaseReference!.child(quizId).remove();

    // Remove from local list
    _quizzes.removeWhere((quiz) => quiz.id == quizId);
    notifyListeners();
  }

  Future<void> _loadQuizzes() async {
    try {
      if (_databaseReference == null) {
        throw Exception(
          'Cannot load quizzes: Database reference not initialized',
        );
      }

      final event = await _databaseReference!.once();
      final data = event.snapshot.value;

      if (data != null) {
        _quizzes.clear();
        final quizzesMap = Map<String, dynamic>.from(data as Map);

        quizzesMap.forEach((key, value) {
          try {
            if (value is Map) {
              final quizData = Map<String, dynamic>.from(value);

              // Convert questions if they exist (similar to flashcards in decks)
              if (quizData['questions'] != null) {
                final questionsList = List<Map<String, dynamic>>.from(
                  quizData['questions'].map(
                    (q) => Map<String, dynamic>.from(q),
                  ),
                );
                quizData['questions'] = questionsList;
              }

              quizData['id'] = key; // Ensure the ID is set
              _quizzes.add(Quiz.fromJson(quizData));
            }
          } catch (e) {
            print('Error parsing quiz $key: $e');
            // For debugging:
            print('Problematic quiz data: $value');
          }
        });
      }
      notifyListeners();
    } catch (e) {
      throw Exception('Error loading quizzes: $e');
    }
  }

  Future<void> refreshQuizzes() async {
    // Complete reset of initialization state and database reference
    _isInitialized = false;
    _databaseReference = null;
    _quizzes.clear();

    // Re-initialize from scratch
    await _initialize();
  }

  // Method to clean up database listeners when signing out
  Future<void> cleanupForSignOut() async {
    debugPrint('QuizViewModel: Cleaning up for sign out');
    _databaseReference = null;
    _isInitialized = false;
    _quizzes.clear();
    notifyListeners();
    debugPrint('QuizViewModel: Cleanup completed');
  }
}
