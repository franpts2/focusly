import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:focusly/model/flashcard_deck_model.dart';

class FlashcardDeckViewModel extends ChangeNotifier {
  final List<FlashcardDeck> _decks = [];
  DatabaseReference? _databaseReference;
  bool _isInitialized = false;

  List<FlashcardDeck> get decks => _decks;

  FlashcardDeckViewModel() {
    _initialize();
  }

  Future<void> _initialize() async {
    if (_isInitialized) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _databaseReference = FirebaseDatabase.instance
          .ref()
          .child(user.uid)
          .child("flashcard_decks");
      await _loadDecks();
      _isInitialized = true;
    }
  }

  Future<void> addDeck(FlashcardDeck deck) async {
    if (!_isInitialized) await _initialize();
    if (!_isInitialized || _databaseReference == null) {
      throw Exception('Cannot add deck: User not authenticated');
    }

    final newDeckRef = _databaseReference!.push();
    final deckID = newDeckRef.key!;
    final deckWithID = deck.copyWith(id: deckID);

    await newDeckRef.set(deckWithID.toJson());
    _decks.add(deckWithID);
    notifyListeners();
  }

  Future<void> updateDeck(FlashcardDeck deck) async {
    if (!_isInitialized) await _initialize();
    if (_databaseReference == null) {
      throw Exception('Cannot update deck: Database reference not initialized');
    }
    if (deck.id == null) {
      throw Exception('Cannot update deck without an ID');
    }

    await _databaseReference!.child(deck.id!).update(deck.toJson());

    final index = _decks.indexWhere((d) => d.id == deck.id);
    if (index >= 0) {
      _decks[index] = deck;
      notifyListeners();
    }
  }

  Future<void> deleteDeck(String deckId) async {
    if (!_isInitialized) await _initialize();
    if (_databaseReference == null) {
      throw Exception('Cannot delete deck: Database reference not initialized');
    }

    await _databaseReference!.child(deckId).remove();
    _decks.removeWhere((deck) => deck.id == deckId);
    notifyListeners();
  }

  Future<void> _loadDecks() async {
    try {
      if (_databaseReference == null) {
        throw Exception('Cannot load decks: Database reference not initialized');
      }

      final event = await _databaseReference!.once();
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        _decks.clear();
        data.forEach((key, value) {
          final deckData = Map<String, dynamic>.from(value);
          if (deckData['id'] == null) {
            deckData['id'] = key;
          }
          _decks.add(FlashcardDeck.fromJson(deckData));
        });
      }
      notifyListeners();
    } catch (e) {
      throw Exception('Error loading decks: $e');
    }
  }

  Future<void> refreshDecks() async {
    _isInitialized = false;
    _databaseReference = null;
    _decks.clear();
    await _initialize();
  }
}