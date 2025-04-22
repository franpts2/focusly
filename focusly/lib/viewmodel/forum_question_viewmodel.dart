import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:focusly/model/forum_question_model.dart';

class ForumQuestionViewModel extends ChangeNotifier {
  final List<ForumQuestion> _questions = [];
  DatabaseReference? _databaseReference;
  bool _isInitialized = false;

  List<ForumQuestion> get questions => _questions;

  ForumQuestionViewModel() {
    _initialize();
  }

  Future<void> _initialize() async {
    if (_isInitialized) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _databaseReference = FirebaseDatabase.instance
          .ref()
          .child(user.uid)
          .child("forum_questions");
      await _loadQuestions();
      _isInitialized = true;
    }
  }

  Future<void> addQuestion(ForumQuestion question) async {
    final ref = FirebaseDatabase.instance.ref().child("forum_questions");
    final newQuestionRef = ref.push();
    final questionID = newQuestionRef.key!;
    final questionWithID = question.copyWith(id: questionID);

    await newQuestionRef.set(questionWithID.toJson());

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userRef = FirebaseDatabase.instance
          .ref()
          .child(user.uid)
          .child("forum_questions")
          .child(questionID);
      await userRef.set(questionWithID.toJson());
    }

    _questions.add(questionWithID);
    _allQuestions.insert(0, questionWithID);
    notifyListeners();
  }

  Future<void> _loadQuestions() async {
    try {
      if (_databaseReference == null) {
        throw Exception('Cannot load questions: Database reference not initialized');
      }
      final event = await _databaseReference!.once();
      final data = event.snapshot.value;
      if (data != null) {
        _questions.clear();
        final questionsMap = Map<String, dynamic>.from(data as Map);
        questionsMap.forEach((key, value) {
          try {
            if (value is Map) {
              final questionData = Map<String, dynamic>.from(value);
              questionData['id'] = key;
              _questions.add(ForumQuestion.fromJson(questionData));
            }
          } catch (e) {
            print('Error parsing question $key: $e');
          }
        });
      }
      notifyListeners();
    } catch (e) {
      throw Exception('Error loading questions: $e');
    }
  }

  void incrementAnswerCount(String questionId) {
    final index = _allQuestions.indexWhere((q) => q.id == questionId);
    if (index != -1) {
      _allQuestions[index] = _allQuestions[index].copyWith(
        answerCount: _allQuestions[index].answerCount + 1,
      );
    }

    final myIndex = _questions.indexWhere((q) => q.id == questionId);
    if (myIndex != -1) {
      _questions[myIndex] = _questions[myIndex].copyWith(
        answerCount: _questions[myIndex].answerCount + 1,
      );
    }

    notifyListeners();
  }

  final List<ForumQuestion> _allQuestions = [];
  List<ForumQuestion> get allQuestions => _allQuestions;

  Future<void> loadAllQuestions() async {
    final ref = FirebaseDatabase.instance.ref().child("forum_questions");

    try {
      final event = await ref.once();
      final data = event.snapshot.value;

      if (data != null) {
        _allQuestions.clear();
        final questionsMap = Map<String, dynamic>.from(data as Map);
        questionsMap.forEach((key, value) {
          if (value is Map) {
            final questionData = Map<String, dynamic>.from(value);
            questionData['id'] = key;
            _allQuestions.add(ForumQuestion.fromJson(questionData));
          }
        });

        _allQuestions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      }
      notifyListeners();
    } catch (e) {
      print("Error loading all questions: $e");
    }
  }

  Future<void> updateQuestion(ForumQuestion updatedQuestion) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && updatedQuestion.userName == user.uid) {
        // Update the local lists
        final indexAll = _allQuestions.indexWhere((q) => q.id == updatedQuestion.id);
        if (indexAll != -1) {
          _allQuestions[indexAll] = updatedQuestion;
        }
        final indexMy = _questions.indexWhere((q) => q.id == updatedQuestion.id);
        if (indexMy != -1) {
          _questions[indexMy] = updatedQuestion;
        }
        notifyListeners();
      } else {
        throw Exception('Cannot update question: Not the owner.');
      }
    } catch (e) {
      print('Error updating question: $e');
      throw Exception('Failed to update question');
    }
  }

  Future<void> deleteQuestion(String questionId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final questionToDelete = _questions.firstWhere((q) => q.id == questionId);
      if (user != null && questionToDelete.userName == user.uid) {
        // Update the local lists
        _allQuestions.removeWhere((q) => q.id == questionId);
        _questions.removeWhere((q) => q.id == questionId);
        notifyListeners();
      } else {
        throw Exception('Cannot delete question: Not the owner.');
      }
    } catch (e) {
      print('Error deleting question: $e');
      throw Exception('Failed to delete question');
    }
  }

}