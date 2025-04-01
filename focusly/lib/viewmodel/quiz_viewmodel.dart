import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:focusly/model/quiz_model.dart';

class QuizViewModel extends ChangeNotifier {
  final List<Quiz> _quizzes = [];
  late DatabaseReference _databaseReference;

  List<Quiz> get quizzes => _quizzes;

  QuizViewModel({DatabaseReference? databaseReference}) {
    _databaseReference = databaseReference ?? FirebaseDatabase.instance.ref();
    _initialize();
  }

  Future<void> _initialize() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _databaseReference = _databaseReference.child(user.uid).child('quizzes');
      _loadQuizzes();
    }
  }

  Future<void> addQuiz(Quiz quiz) async {
    final newQuizRef = _databaseReference.push();
    final quizID = newQuizRef.key!;
    final quizWithID = quiz.copyWith(id: quizID);
    await newQuizRef.set(quizWithID.toJson());

    // Add to local list
    _quizzes.add(quizWithID);
    notifyListeners();
  }

  Future<void> updateQuiz(Quiz quiz) async {
    if (quiz.id == null) {
      throw Exception('Cannot update quiz without an ID');
    }

    await _databaseReference.child(quiz.id!).update(quiz.toJson());

    // Update local list
    final index = _quizzes.indexWhere((q) => q.id == quiz.id);
    if (index >= 0) {
      _quizzes[index] = quiz;
      notifyListeners();
    }
  }

  Future<void> deleteQuiz(String quizId) async {
    await _databaseReference.child(quizId).remove();

    // Remove from local list
    _quizzes.removeWhere((quiz) => quiz.id == quizId);
    notifyListeners();
  }

  Future<void> _loadQuizzes() async {
    try {
      final event = await _databaseReference.once();
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
    await _loadQuizzes();
  }
}
