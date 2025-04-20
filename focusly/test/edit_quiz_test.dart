import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:focusly/model/quiz_model.dart';
import 'package:focusly/viewmodel/quiz_viewmodel.dart';
import 'package:focusly/view/create/create_view_edit_quiz.dart';

class MockQuizViewModel extends Mock implements QuizViewModel {
  @override
  Future<void> updateQuiz(Quiz quiz) => super.noSuchMethod(
    Invocation.method(#updateQuiz, [quiz]),
    returnValue: Future.value(),
    returnValueForMissingStub: Future.value(),
  );

  @override
  Future<void> deleteQuiz(String id) => super.noSuchMethod(
    Invocation.method(#deleteQuiz, [id]),
    returnValue: Future.value(),
    returnValueForMissingStub: Future.value(),
  );
}

void main() {
  late MockQuizViewModel mockQuizViewModel;
  late Quiz initialQuiz;

  setUp(() {
    mockQuizViewModel = MockQuizViewModel();
    initialQuiz = Quiz(
      id: '1',
      title: 'Initial Quiz Title',
      category: 'General Knowledge',
      questions: [
        Question(
          questionText: 'Question 1',
          options: ['A', 'B', 'C', 'D'],
          correctAnswer: 'A',
        ),
      ],
    );
    when(mockQuizViewModel.updateQuiz(initialQuiz)).thenAnswer((_) => Future.value());
    when(mockQuizViewModel.deleteQuiz('1')).thenAnswer((_) => Future.value());
  });

  Future<void> pumpEditQuizScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<QuizViewModel>.value(
          value: mockQuizViewModel,
          child: CreateViewEditQuiz(quiz: initialQuiz),
        ),
      )
    );
    await tester.pumpAndSettle();
  }

  group('Quiz Editing', () {
    testWidgets('Editing a Quiz Title', (WidgetTester tester) async {
      await pumpEditQuizScreen(tester);
      expect(find.text('Initial Quiz Title'), findsOneWidget);

      await tester.enterText(find.byType(TextField).first, 'Updated Quiz Title');
      await tester.pump();

      expect(find.text('Updated Quiz Title'), findsOneWidget);
    });


    testWidgets('Editing a Quiz Question', (WidgetTester tester) async {
      await pumpEditQuizScreen(tester);

      await tester.tap(find.byIcon(Symbols.edit).first);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).at(0), 'Updated Question 1');
      await tester.enterText(find.byType(TextField).at(1), 'New A');
      await tester.tap(find.text('SAVE'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      expect(find.text('Updated Question 1'), findsOneWidget);
      expect(find.text('New A'), findsOneWidget);
    });

    testWidgets('Test Case 7: Deleting a Quiz Question', (WidgetTester tester) async {
      await pumpEditQuizScreen(tester);

      expect(find.text('1 quiz'), findsOneWidget);

      await tester.tap(find.byIcon(Symbols.delete).first);
      await tester.pump();

      await tester.tap(find.byIcon(Symbols.delete).first);
      await tester.pump();
    });

    testWidgets('Test Case 8: Adding a New Quiz Question', (WidgetTester tester) async {
      await pumpEditQuizScreen(tester);

      await tester.tap(find.byIcon(Symbols.add_circle));
      await tester.pumpAndSettle();

      await tester.tap(find.text('SAVE'));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Done'));
      await tester.pumpAndSettle();
    });

  });

}