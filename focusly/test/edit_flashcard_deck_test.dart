import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/model/flashcard_deck_model.dart';
import 'package:focusly/view/create/create_view_edit_flashcard_deck.dart';
import 'package:focusly/viewmodel/flashcard_deck_viewmodel.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

class MockFlashcardDeckViewModel extends Mock implements FlashcardDeckViewModel {
  @override
  Future<void> deleteDeck(String id) => 
      super.noSuchMethod(
        Invocation.method(#deleteDeck, [id]),
        returnValue: Future.value(),
        returnValueForMissingStub: Future.value(),
      );

  @override
  Future<void> updateDeck(FlashcardDeck deck) => 
      super.noSuchMethod(
        Invocation.method(#updateDeck, [deck]),
        returnValue: Future.value(),
        returnValueForMissingStub: Future.value(),
      );
}

void main() {
  late MockFlashcardDeckViewModel mockViewModel;
  late FlashcardDeck testDeck;

  setUp(() {
    mockViewModel = MockFlashcardDeckViewModel();
    testDeck = FlashcardDeck(
      id: '1',
      title: 'Test Deck',
      category: 'General',
      flashcards: [
        Flashcard(front: 'Front 1', back: 'Back 1'),
        Flashcard(front: 'Front 2', back: 'Back 2'),
      ],
    );
    when(mockViewModel.deleteDeck('1')).thenAnswer((_) => Future.value());
    when(mockViewModel.updateDeck(testDeck)).thenAnswer((_) => Future.value());
  });

  Future<void> pumpEditDeckScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<FlashcardDeckViewModel>.value(
          value: mockViewModel,
          child: CreateViewEditFlashcardDeck(deck: testDeck),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('Flashcard Deck Editing', () {
    testWidgets('Test Case 1: Editing a Flashcard Deck Title', (WidgetTester tester) async {
      await pumpEditDeckScreen(tester);

      // Verify initial title
      expect(find.text('Test Deck'), findsOneWidget);

      // Edit title
      await tester.enterText(find.byType(TextField).first, 'Updated Title');
      await tester.pump();

      expect(find.text('Updated Title'), findsOneWidget); // may not work here
    });
      

    testWidgets('Test Case 2: Editing a Flashcard', (WidgetTester tester) async {
      await pumpEditDeckScreen(tester);

      // Tap on first flashcard to edit
      await tester.tap(find.text('Front 1'));
      await tester.pumpAndSettle();

      // Edit flashcard content
      await tester.enterText(find.byType(TextField).at(0), 'Updated Front');
      await tester.enterText(find.byType(TextField).at(1), 'Updated Back');
      await tester.tap(find.text('SAVE'));
      await tester.pumpAndSettle();

      // Verify changes
      expect(find.text('Updated Front'), findsOneWidget);
      expect(find.text('Updated Back'), findsOneWidget);
    });

    testWidgets('Test Case 3: Deleting a Flashcard', (WidgetTester tester) async {
      await pumpEditDeckScreen(tester);

      // Verify initial count
      expect(find.text('2 flashcards'), findsOneWidget);

      // Delete first flashcard
      await tester.tap(find.byIcon(Symbols.delete).first);
      await tester.pump();

      // Verify deletion
      expect(find.text('1 flashcards'), findsOneWidget);
      expect(find.text('Front 1'), findsNothing);
    });

    testWidgets('Deleting a Deck', (WidgetTester tester) async {
      // 1. Setup mock response
      when(mockViewModel.deleteDeck('1')).thenAnswer((_) => Future.value());

      // 2. Load the widget
      await pumpEditDeckScreen(tester);

      // 3. Trigger deletion flow
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle(); // Wait for dialog

      // 4. Confirm deletion
      await tester.tap(find.text('Delete').last);
      await tester.pumpAndSettle();

      // 5. Verify
      verify(mockViewModel.deleteDeck('1')).called(1);
    });

    testWidgets('Empty title validation', (WidgetTester tester) async {
      await pumpEditDeckScreen(tester);

      // Clear title field
      await tester.enterText(find.byType(TextField).first, '');
      
      // Tap Done button
      final doneButton = find.widgetWithText(ElevatedButton, 'Done');
      await tester.ensureVisible(doneButton);
      await tester.tap(doneButton);
      
      // Wait for snackbar
      await tester.pump(); // Initial update
      await tester.pump(const Duration(seconds: 2)); // Extended wait
      
      // Verify using multiple approaches
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Please enter a deck title'), findsOneWidget);
    });

    testWidgets('Empty flashcards validation', (WidgetTester tester) async {
      await pumpEditDeckScreen(tester);

      await tester.enterText(find.byType(TextField).first, 'Valid Title');
      
      // Clear all flashcards
      while (tester.any(find.byIcon(Symbols.delete))) {
        await tester.tap(find.byIcon(Symbols.delete).first);
        await tester.pump();
      }

      // Tap Done button
      final doneButton = find.widgetWithText(ElevatedButton, 'Done');
      await tester.ensureVisible(doneButton);
      await tester.tap(doneButton);

      // Wait for snackbar
      await tester.pump(); // Initial update
      await tester.pump(const Duration(seconds: 2)); // Extended wait
      
      // Verify using multiple approaches
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Please add at least one flashcard'), findsOneWidget);
    });
  });
}