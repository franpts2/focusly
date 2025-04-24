import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:focusly/model/forum_question_model.dart';

class ForumQuestionViewModel extends ChangeNotifier {
  //final List<ForumQuestion> _questions = []; // Remove _questions
  DatabaseReference? _databaseReference;
  bool _isInitialized = false;

  //List<ForumQuestion> get questions => _questions; // Remove getter for _questions

  ForumQuestionViewModel() {
    _initialize();
  }

  Future<void> _initialize() async {
    if (_isInitialized) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _databaseReference = FirebaseDatabase.instance.ref().child("forum_questions"); // Use the main node
      await _loadQuestions();
      _isInitialized = true;
    }
  }

  Future<void> addQuestion(ForumQuestion question) async {
    if (_databaseReference == null) {
      throw Exception('Database reference not initialized');
    }

    final newQuestionRef = _databaseReference!.push();
    final questionId = newQuestionRef.key!;
    final questionWithId = question.copyWith(id: questionId);

    try {
      await newQuestionRef.set(questionWithId.toJson());
      _allQuestions.insert(0, questionWithId); // Add to _allQuestions
      notifyListeners();
    } catch (error) {
      print("Error adding question: $error");
      rethrow;(); // Important: rethrow the error
    }
  }

  Future<void> _loadQuestions() async {
    try {
      if (_databaseReference == null) {
        throw Exception('Cannot load questions: Database reference not initialized');
      }
      final event = await _databaseReference!.once();
      final data = event.snapshot.value;
      if (data != null) {
        _allQuestions.clear(); // Clear the list
        if (data is Map) {
          data.forEach((key, value) {
            try {
              if (value is Map) {
                final questionData = Map<String, dynamic>.from(value);
                questionData['id'] = key;
                _allQuestions.add(ForumQuestion.fromJson(questionData)); // Load all questions
              }
            } catch (e) {
              print('Error parsing question $key: $e');
            }
          });
        }
        _allQuestions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      }
      notifyListeners();
    } catch (e) {
      print('Error loading questions: $e');
      throw Exception('Error loading questions: $e');
    }
  }

  void incrementAnswerCount(String questionId) {
    final index = _allQuestions.indexWhere((q) => q.id == questionId);
    if (index != -1) {
      _allQuestions[index] = _allQuestions[index].copyWith(
        answerCount: _allQuestions[index].answerCount + 1,
      );
      if (_databaseReference != null) {
        _databaseReference!.child(questionId).update({
          'answerCount': _allQuestions[index].answerCount,
        });
      }
      notifyListeners();
    }
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
        if (data is Map) {
          data.forEach((key, value) {
            if (value is Map) {
              final questionData = Map<String, dynamic>.from(value);
              questionData['id'] = key;
              _allQuestions.add(ForumQuestion.fromJson(questionData));
            }
          });
        }

        _allQuestions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      }
      notifyListeners();
    } catch (e) {
      print("Error loading all questions: $e");
      rethrow;();
    }
  }

  Future<void> updateQuestion(ForumQuestion updatedQuestion) async {
    if (_databaseReference == null) {
      throw Exception('Database reference not initialized');
    }
    try {
      // Update in the database
      await _databaseReference!.child(updatedQuestion.id!).update(updatedQuestion.toJson());

      // Update in the local list
      final indexAll = _allQuestions.indexWhere((q) => q.id == updatedQuestion.id);
      if (indexAll != -1) {
        _allQuestions[indexAll] = updatedQuestion;
      }
      notifyListeners();
    } catch (error) {
      print('Error updating question: $error');
      rethrow;(); // Re-throw the error
    }
  }

  Future<void> deleteQuestion(String questionId) async {
    if (_databaseReference == null) {
      throw Exception('Database reference not initialized');
    }
    try {
      // Delete from the database
      await _databaseReference!.child(questionId).remove();

      // Remove from the local list
      _allQuestions.removeWhere((q) => q.id == questionId);
      notifyListeners();
    } catch (error) {
      print('Error deleting question: $error');
      rethrow;();
    }
  }
}

