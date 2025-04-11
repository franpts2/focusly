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
    if (!_isInitialized) await _initialize();
    if (_databaseReference == null) {
      throw Exception('Cannot add question: User not authenticated');
    }
    final newQuestionRef = _databaseReference!.push();
    final questionID = newQuestionRef.key!;
    final questionWithID = question.copyWith(id: questionID);
    print('Adding question: ${questionWithID.toJson()}');
    await newQuestionRef.set(questionWithID.toJson());
    _questions.add(questionWithID);
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

  Future<void> incrementAnswerCount(String questionID) async {
    if (_databaseReference == null) return;
    final ref = _databaseReference!.child(questionID).child("answerCount");
    await ref.runTransaction((currentValue) {
      final current = (currentValue as int?) ?? 0;
      return Transaction.success(current + 1);
    });

    final index = _questions.indexWhere((q) => q.id == questionID);
    if (index != -1) {
      _questions[index] = _questions[index].copyWith(
        answerCount: _questions[index].answerCount + 1,
      );
      notifyListeners();
    }
  }
}