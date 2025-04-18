import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:focusly/model/forum_answer_model.dart';

class ForumAnswerViewModel extends ChangeNotifier {
  final Map<String, List<ForumAnswer>> _answersByQuestion = {}; // Maps questionID to its answers
  DatabaseReference? _databaseReference;
  bool _isInitialized = false;

  List<ForumAnswer> getAnswersForQuestion(String questionID) {
    return _answersByQuestion[questionID] ?? [];
  }

  ForumAnswerViewModel() {
    _initialize();
  }

  Future<void> _initialize() async {
    if (_isInitialized) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _databaseReference = FirebaseDatabase.instance
          .ref()
          .child(user.uid)
          .child("forum_answers");
      _isInitialized = true;
    }
  }

  Future<void> addAnswer(String questionID, ForumAnswer answer) async {
    final ref = FirebaseDatabase.instance.ref()
        .child("forum_questions")
        .child(questionID)
        .child("answers");

    final newAnswerRef = ref.push();
    final answerID = newAnswerRef.key!;
    final answerWithID = answer.copyWith(id: answerID);

    await newAnswerRef.set(answerWithID.toJson());

    final questionRef = FirebaseDatabase.instance.ref()
        .child("forum_questions")
        .child(questionID);

    await questionRef.update({
      "answerCount": ServerValue.increment(1),
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userRef = FirebaseDatabase.instance
          .ref()
          .child(user.uid)
          .child("forum_answers")
          .child(questionID)
          .child(answerID);
      await userRef.set(answerWithID.toJson());
    }

    // Update local cache
    if (!_answersByQuestion.containsKey(questionID)) {
      _answersByQuestion[questionID] = [];
    }
    _answersByQuestion[questionID]!.insert(0, answerWithID);
    notifyListeners();
  }

  Future<void> loadAnswersForQuestion(String questionID) async {
    try {
      final ref = FirebaseDatabase.instance.ref()
          .child("forum_questions")
          .child(questionID)
          .child("answers");

      final event = await ref.once();
      final data = event.snapshot.value;

      if (data != null) {
        final answersMap = Map<String, dynamic>.from(data as Map);
        final answersList = <ForumAnswer>[];

        answersMap.forEach((key, value) {
          try {
            if (value is Map) {
              final answerData = Map<String, dynamic>.from(value);
              answerData['id'] = key;
              answersList.add(ForumAnswer.fromJson(answerData));
            }
          } catch (e) {
            throw Exception('Error parsing answer $key: $e');
          }
        });

        // Sort by newest first
        answersList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        _answersByQuestion[questionID] = answersList;
      } else {
        _answersByQuestion[questionID] = [];
      }
      notifyListeners();
    } catch (e) {
      throw Exception('Error loading answers for question $questionID: $e');
    }
  }
}