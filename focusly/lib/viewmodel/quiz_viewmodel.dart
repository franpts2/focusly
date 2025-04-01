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
      // Create a fresh reference directly to users/{uid}/quizzes
      // Using absolute path instead of child() method to avoid nesting issues
      _databaseReference = FirebaseDatabase.instance
          .ref()
          .child("users")
          .child(user.uid)
          .child("quizzes");
      print("Database path: ${_databaseReference!.path}");
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
        print('Cannot load quizzes: Database reference not initialized');
        return;
      }

      final event = await _databaseReference!.once();
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        _quizzes.clear();
        data.forEach((key, value) {
          final quizData = Map<String, dynamic>.from(value);
          if (quizData['id'] == null) {
            quizData['id'] = key;
          }
          _quizzes.add(Quiz.fromJson(quizData));
        });
      }
      notifyListeners();
    } catch (e) {
      print('Error loading quizzes: $e');
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
}
