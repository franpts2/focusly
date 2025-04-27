import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:focusly/model/forum_question_model.dart';

class ForumQuestionViewModel extends ChangeNotifier {
  DatabaseReference? _databaseReference;
  bool _isInitialized = false;

  final List<ForumQuestion> _allQuestions = [];
  final List<ForumQuestion> _filteredQuestions = [];
  String _searchQuery = '';

  List<ForumQuestion> get allQuestions =>
      _filteredQuestions.isEmpty && _searchQuery.isEmpty
          ? _allQuestions
          : _filteredQuestions;

  ForumQuestionViewModel() {
    _initialize();
  }

  Future<void> _initialize() async {
    if (_isInitialized) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _databaseReference = FirebaseDatabase.instance.ref().child(
        "forum_questions",
      );
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
    final questionWithId = question.copyWith(
      id: questionId,
      uid: FirebaseAuth.instance.currentUser?.uid, // Ensure userId is set here
    );

    try {
      await newQuestionRef.set(questionWithId.toJson());
      _allQuestions.insert(0, questionWithId);
      notifyListeners();
    } catch (error) {
      print("Error adding question: $error");
      rethrow;
    }
  }

  Future<void> _loadQuestions() async {
    try {
      if (_databaseReference == null) {
        throw Exception(
          'Cannot load questions: Database reference not initialized',
        );
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
                _allQuestions.add(ForumQuestion.fromJson(questionData));
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

  void decrementAnswerCount(String questionId) {
    final index = _allQuestions.indexWhere((q) => q.id == questionId);
    if (index != -1) {
      _allQuestions[index] = _allQuestions[index].copyWith(
        answerCount: _allQuestions[index].answerCount - 1,
      );
      if (_databaseReference != null) {
        _databaseReference!.child(questionId).update({
          'answerCount': _allQuestions[index].answerCount,
        });
      }
      notifyListeners();
    }
  }

  void searchQuestions(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredQuestions.clear();
    } else {
      _filteredQuestions.clear(); // Clear the list first
      _filteredQuestions.addAll(
        _allQuestions
            .where((question) =>
            question.title.toLowerCase().contains(query.toLowerCase()) ||
                question.userName.toLowerCase().contains(query.toLowerCase())
            )
            .toList(),
      );
    }
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _filteredQuestions.clear();
    notifyListeners();
  }

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
      rethrow;
    }
  }

  Future<void> updateQuestion(ForumQuestion updatedQuestion) async {
    if (_databaseReference == null) {
      throw Exception('Database reference not initialized');
    }
    try {
      await _databaseReference!
          .child(updatedQuestion.id!)
          .update(updatedQuestion.toJson());

      final indexAll = _allQuestions.indexWhere(
        (q) => q.id == updatedQuestion.id,
      );
      if (indexAll != -1) {
        _allQuestions[indexAll] = updatedQuestion;
      }
      notifyListeners();
    } catch (error) {
      print('Error updating question: $error');
      rethrow;
    }
  }

  Future<void> deleteQuestion(String questionId) async {
    if (_databaseReference == null) {
      throw Exception('Database reference not initialized');
    }
    try {
      await _databaseReference!.child(questionId).remove();

      _allQuestions.removeWhere((q) => q.id == questionId);
      notifyListeners();
    } catch (error) {
      print('Error deleting question: $error');
      rethrow;
    }
  }
}
