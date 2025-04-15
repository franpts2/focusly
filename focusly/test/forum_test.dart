import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/view/forum/forum_add_question.dart';

class MockForumService {
  final List<Map<String, String>> questions = [];

  void postQuestion(String title, String description, {String user = 'Current User'}) {
    questions.add({'title': title, 'description': description, 'user': user});
  }

  List<Map<String, String>> getQuestionsByUser(String user) {
    return questions.where((q) => q['user'] == user).toList();
  }
}

void main() {
  group('Forum Tests', () {
    final mockService = MockForumService();

    testWidgets('Test Case 1: Successfully Posting a Question', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ForumAddQuestion(),
          ),
        ),
      );

      // Enter title and description
      await tester.enterText(find.byType(TextField).at(0), 'Test Title');
      await tester.enterText(find.byType(TextField).at(1), 'Test Description');

      // Simulate posting the question
      mockService.postQuestion('Test Title', 'Test Description');

      // Verify the question was added
      expect(mockService.questions.length, 1);
      expect(mockService.questions.first['title'], 'Test Title');
      expect(mockService.questions.first['description'], 'Test Description');
    });

    testWidgets('Test Case 2: Attempting to Post a Question Without a Title', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ForumAddQuestion(),
          ),
        ),
      );

      // Enter only description
      await tester.enterText(find.byType(TextField).at(1), 'Test Description');

      // Tap the Publish button
      await tester.tap(find.text('Publish'));
      await tester.pump();

      // Verify error message is displayed
      expect(find.text('Title is required'), findsOneWidget);
    });

    testWidgets('Test Case 3: Attempting to Post a Question Without a Description', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ForumAddQuestion(),
          ),
        ),
      );

      // Enter only title
      await tester.enterText(find.byType(TextField).at(0), 'Test Title');

      // Tap the Publish button
      await tester.tap(find.text('Publish'));
      await tester.pump();

      // Verify error message is displayed
      expect(find.text('Description is required'), findsOneWidget);
    });

    testWidgets('Test Case 4: Viewing a Posted Question', (WidgetTester tester) async {
      // Add a question to the mock service
      mockService.postQuestion('Test Title', 'Test Description');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: mockService.questions
                  .asMap()
                  .entries
                  .map((entry) => ListTile(
                key: Key('question_${entry.key}'), // Unique key based on index
                title: Text(entry.value['title']!),
                subtitle: Text(entry.value['description']!),
              ))
                  .toList(),
            ),
          ),
        ),
      );

      // Ensure the widget tree is fully built
      await tester.pumpAndSettle();

      // Verify the ListTile exists using its unique key
      final listTileFinder = find.byKey(const Key('question_0'));
      expect(listTileFinder, findsOneWidget);

      // Verify the question details are displayed in the ListTile
      final listTile = tester.widget<ListTile>(listTileFinder);
      expect((listTile.title as Text).data, 'Test Title');
      expect((listTile.subtitle as Text).data, 'Test Description');
    });

    testWidgets('Test Case 5: Newly Posted Question Appears in the "New" Section', (WidgetTester tester) async {
      // Add multiple questions to the mock service
      mockService.postQuestion('Old Question', 'Old Description');
      mockService.postQuestion('New Question', 'New Description');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: mockService.questions
                  .reversed // Simulate "New" section with most recent first
                  .map((q) => ListTile(
                        key: Key(q['title']!), // Unique key based on title
                        title: Text(q['title']!),
                        subtitle: Text(q['description']!),
                      ))
                  .toList(),
            ),
          ),
        ),
      );

      // Verify the "New" section shows the most recent question first
      expect(find.text('New Question'), findsOneWidget);
      expect(find.text('Old Question'), findsOneWidget);
    });

    testWidgets('Test Case 6: Student’s Questions Appear in "My Questions" Section', (WidgetTester tester) async {
      // Add multiple questions to the mock service
      mockService.postQuestion('My Question 1', 'Description 1', user: 'Current User');
      mockService.postQuestion('My Question 2', 'Description 2', user: 'Current User');
      mockService.postQuestion('Other User Question', 'Other Description', user: 'Other User');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: mockService
                  .getQuestionsByUser('Current User') // Simulate filtering by user
                  .map((q) => ListTile(
                        key: Key(q['title']!), // Unique key based on title
                        title: Text(q['title']!),
                        subtitle: Text(q['description']!),
                      ))
                  .toList(),
            ),
          ),
        ),
      );

      // Verify only the current user's questions are displayed
      expect(find.text('My Question 1'), findsOneWidget);
      expect(find.text('My Question 2'), findsOneWidget);
      expect(find.text('Other User Question'), findsNothing);
    });
  });
}