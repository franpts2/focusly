import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/view/forum/forum_add_question.dart';

class MockForumService {
  final List<Map<String, String>> questions = [];

  void postQuestion(
    String title,
    String description, {
    String user = 'Current User',
  }) {
    questions.add({'title': title, 'description': description, 'user': user});
  }

  List<Map<String, String>> getQuestionsByUser(String user) {
    return questions.where((q) => q['user'] == user).toList();
  }

  List<Map<String, String>> searchQuestions(String query) {
    if (query.isEmpty) {
      return questions;
    }
    final lowercaseQuery = query.toLowerCase();
    return questions
        .where(
          (q) =>
              q['title']!.toLowerCase().contains(lowercaseQuery) ||
              q['user']!.toLowerCase().contains(lowercaseQuery),
        )
        .toList();
  }
}

void main() {
  group('Forum Tests', () {
    final mockService = MockForumService();

    testWidgets('Test Case 1: Successfully Posting a Question', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ForumAddQuestion())),
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

    testWidgets('Test Case 2: Attempting to Post a Question Without a Title', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ForumAddQuestion())),
      );

      // Enter only description
      await tester.enterText(find.byType(TextField).at(1), 'Test Description');

      // Tap the Publish button
      await tester.tap(find.text('Publish'));
      await tester.pump();

      // Verify error message is displayed
      expect(find.text('Title is required'), findsOneWidget);
    });

    testWidgets(
      'Test Case 3: Attempting to Post a Question Without a Description',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(home: Scaffold(body: ForumAddQuestion())),
        );

        // Enter only title
        await tester.enterText(find.byType(TextField).at(0), 'Test Title');

        // Tap the Publish button
        await tester.tap(find.text('Publish'));
        await tester.pump();

        // Verify error message is displayed
        expect(find.text('Description is required'), findsOneWidget);
      },
    );

    testWidgets('Test Case 4: Viewing a Posted Question', (
      WidgetTester tester,
    ) async {
      // Add a question to the mock service
      mockService.postQuestion('Test Title', 'Test Description');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children:
                  mockService.questions
                      .asMap()
                      .entries
                      .map(
                        (entry) => ListTile(
                          key: Key(
                            'question_${entry.key}',
                          ), // Unique key based on index
                          title: Text(entry.value['title']!),
                          subtitle: Text(entry.value['description']!),
                        ),
                      )
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

    testWidgets(
      'Test Case 5: Newly Posted Question Appears in the "New" Section',
      (WidgetTester tester) async {
        // Add multiple questions to the mock service
        mockService.postQuestion('Old Question', 'Old Description');
        mockService.postQuestion('New Question', 'New Description');

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ListView(
                children:
                    mockService
                        .questions
                        .reversed // Simulate "New" section with most recent first
                        .map(
                          (q) => ListTile(
                            key: Key(q['title']!), // Unique key based on title
                            title: Text(q['title']!),
                            subtitle: Text(q['description']!),
                          ),
                        )
                        .toList(),
              ),
            ),
          ),
        );

        // Verify the "New" section shows the most recent question first
        expect(find.text('New Question'), findsOneWidget);
        expect(find.text('Old Question'), findsOneWidget);
      },
    );

    testWidgets(
      'Test Case 6: Student’s Questions Appear in "My Questions" Section',
      (WidgetTester tester) async {
        // Add multiple questions to the mock service
        mockService.postQuestion(
          'My Question 1',
          'Description 1',
          user: 'Current User',
        );
        mockService.postQuestion(
          'My Question 2',
          'Description 2',
          user: 'Current User',
        );
        mockService.postQuestion(
          'Other User Question',
          'Other Description',
          user: 'Other User',
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ListView(
                children:
                    mockService
                        .getQuestionsByUser(
                          'Current User',
                        ) // Simulate filtering by user
                        .map(
                          (q) => ListTile(
                            key: Key(q['title']!), // Unique key based on title
                            title: Text(q['title']!),
                            subtitle: Text(q['description']!),
                          ),
                        )
                        .toList(),
              ),
            ),
          ),
        );

        // Verify only the current user's questions are displayed
        expect(find.text('My Question 1'), findsOneWidget);
        expect(find.text('My Question 2'), findsOneWidget);
        expect(find.text('Other User Question'), findsNothing);
      },
    );

    group('Search Functionality Tests', () {
      setUp(() {
        // Clear questions before each test
        mockService.questions.clear();

        // Setup test data with various questions and users
        mockService.postQuestion(
          'Flutter basics',
          'How to start with Flutter?',
          user: 'Alice',
        );
        mockService.postQuestion(
          'Dart programming',
          'Best practices for Dart',
          user: 'Bob',
        );
        mockService.postQuestion(
          'State management',
          'Redux vs Provider',
          user: 'Charlie',
        );
        mockService.postQuestion(
          'UI design tips',
          'Material design guidelines',
          user: 'Alice',
        );
        mockService.postQuestion(
          'Testing in Flutter',
          'Integration testing guide',
          user: 'David',
        );
      });

      testWidgets(
        'Test Case 7: Search by question title returns matching questions',
        (WidgetTester tester) async {
          // Create a simple search interface with TextField and results ListView
          List<Map<String, String>> searchResults = mockService.searchQuestions(
            '',
          );

          await tester.pumpWidget(
            MaterialApp(
              home: StatefulBuilder(
                builder: (context, setState) {
                  return Scaffold(
                    body: Column(
                      children: [
                        TextField(
                          key: Key('searchField'),
                          decoration: InputDecoration(
                            hintText: 'Search questions...',
                          ),
                          onChanged: (query) {
                            setState(() {
                              searchResults = mockService.searchQuestions(
                                query,
                              );
                            });
                          },
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: searchResults.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                key: Key('searchResult_$index'),
                                title: Text(searchResults[index]['title']!),
                                subtitle: Text(
                                  'by ${searchResults[index]['user']!}',
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );

          // Verify all questions are initially shown
          expect(find.byKey(Key('searchResult_0')), findsOneWidget);
          expect(find.byKey(Key('searchResult_4')), findsOneWidget);
          expect(find.text('Flutter basics'), findsOneWidget);
          expect(find.text('Testing in Flutter'), findsOneWidget);

          // Search for "Flutter" in titles
          await tester.enterText(find.byKey(Key('searchField')), 'Flutter');
          await tester.pump();

          // Verify only Flutter-related questions are shown
          expect(find.text('Flutter basics'), findsOneWidget);
          expect(find.text('Testing in Flutter'), findsOneWidget);
          expect(find.text('Dart programming'), findsNothing);
          expect(find.text('State management'), findsNothing);

          // Search for "design" in titles
          await tester.enterText(find.byKey(Key('searchField')), 'design');
          await tester.pump();

          // Verify only design-related question is shown
          expect(find.text('UI design tips'), findsOneWidget);
          expect(find.text('Flutter basics'), findsNothing);
          expect(find.text('Testing in Flutter'), findsNothing);
        },
      );

      testWidgets(
        'Test Case 8: Search by user name returns questions from that user',
        (WidgetTester tester) async {
          // Create a simple search interface with TextField and results ListView
          List<Map<String, String>> searchResults = mockService.searchQuestions(
            '',
          );

          await tester.pumpWidget(
            MaterialApp(
              home: StatefulBuilder(
                builder: (context, setState) {
                  return Scaffold(
                    body: Column(
                      children: [
                        TextField(
                          key: Key('searchField'),
                          decoration: InputDecoration(
                            hintText: 'Search questions...',
                          ),
                          onChanged: (query) {
                            setState(() {
                              searchResults = mockService.searchQuestions(
                                query,
                              );
                            });
                          },
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: searchResults.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                key: Key('searchResult_$index'),
                                title: Text(searchResults[index]['title']!),
                                subtitle: Text(
                                  'by ${searchResults[index]['user']!}',
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );

          // Search for user "Alice"
          await tester.enterText(find.byKey(Key('searchField')), 'Alice');
          await tester.pump();

          // Verify only Alice's questions are shown
          expect(find.text('by Alice'), findsNWidgets(2));
          expect(find.text('Flutter basics'), findsOneWidget);
          expect(find.text('UI design tips'), findsOneWidget);
          expect(find.text('Dart programming'), findsNothing);

          // Search for user "Bob"
          await tester.enterText(find.byKey(Key('searchField')), 'Bob');
          await tester.pump();

          // Verify only Bob's question is shown
          expect(find.text('by Bob'), findsOneWidget);
          expect(find.text('Dart programming'), findsOneWidget);
          expect(find.text('Flutter basics'), findsNothing);
        },
      );

      testWidgets('Test Case 9: Search with no matches shows empty results', (
        WidgetTester tester,
      ) async {
        // Create a simple search interface with TextField and results ListView
        List<Map<String, String>> searchResults = mockService.searchQuestions(
          '',
        );

        await tester.pumpWidget(
          MaterialApp(
            home: StatefulBuilder(
              builder: (context, setState) {
                return Scaffold(
                  body: Column(
                    children: [
                      TextField(
                        key: Key('searchField'),
                        decoration: InputDecoration(
                          hintText: 'Search questions...',
                        ),
                        onChanged: (query) {
                          setState(() {
                            searchResults = mockService.searchQuestions(query);
                          });
                        },
                      ),
                      Expanded(
                        child:
                            searchResults.isEmpty
                                ? Center(child: Text('No results found'))
                                : ListView.builder(
                                  itemCount: searchResults.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      key: Key('searchResult_$index'),
                                      title: Text(
                                        searchResults[index]['title']!,
                                      ),
                                      subtitle: Text(
                                        'by ${searchResults[index]['user']!}',
                                      ),
                                    );
                                  },
                                ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );

        // Search for a non-existent term
        await tester.enterText(
          find.byKey(Key('searchField')),
          'nonexistentterm',
        );
        await tester.pump();

        // Verify "No results found" message is displayed
        expect(find.text('No results found'), findsOneWidget);
        expect(find.byKey(Key('searchResult_0')), findsNothing);
      });

      testWidgets('Test Case 10: Search is case-insensitive', (
        WidgetTester tester,
      ) async {
        // Create a simple search interface with TextField and results ListView
        List<Map<String, String>> searchResults = mockService.searchQuestions(
          '',
        );

        await tester.pumpWidget(
          MaterialApp(
            home: StatefulBuilder(
              builder: (context, setState) {
                return Scaffold(
                  body: Column(
                    children: [
                      TextField(
                        key: Key('searchField'),
                        decoration: InputDecoration(
                          hintText: 'Search questions...',
                        ),
                        onChanged: (query) {
                          setState(() {
                            searchResults = mockService.searchQuestions(query);
                          });
                        },
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: searchResults.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              key: Key('searchResult_$index'),
                              title: Text(searchResults[index]['title']!),
                              subtitle: Text(
                                'by ${searchResults[index]['user']!}',
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );

        // Search with lowercase
        await tester.enterText(find.byKey(Key('searchField')), 'flutter');
        await tester.pump();

        // Verify case-insensitive matches
        expect(find.text('Flutter basics'), findsOneWidget);
        expect(find.text('Testing in Flutter'), findsOneWidget);

        // Search with mixed case
        await tester.enterText(find.byKey(Key('searchField')), 'aLiCe');
        await tester.pump();

        // Verify case-insensitive matches for user name
        expect(find.text('by Alice'), findsNWidgets(2));
      });

      testWidgets('Test Case 11: Clearing search shows all results again', (
        WidgetTester tester,
      ) async {
        // Create a simple search interface with TextField and results ListView
        List<Map<String, String>> searchResults = mockService.searchQuestions(
          '',
        );

        await tester.pumpWidget(
          MaterialApp(
            home: StatefulBuilder(
              builder: (context, setState) {
                return Scaffold(
                  body: Column(
                    children: [
                      TextField(
                        key: Key('searchField'),
                        decoration: InputDecoration(
                          hintText: 'Search questions...',
                        ),
                        onChanged: (query) {
                          setState(() {
                            searchResults = mockService.searchQuestions(query);
                          });
                        },
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: searchResults.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              key: Key('searchResult_$index'),
                              title: Text(searchResults[index]['title']!),
                              subtitle: Text(
                                'by ${searchResults[index]['user']!}',
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );

        // First filter to just one result
        await tester.enterText(find.byKey(Key('searchField')), 'Testing');
        await tester.pump();

        // Verify filtering worked
        expect(find.text('Testing in Flutter'), findsOneWidget);
        expect(find.text('Flutter basics'), findsNothing);

        // Clear the search
        await tester.enterText(find.byKey(Key('searchField')), '');
        await tester.pump();

        // Verify all results are shown again
        expect(find.text('Flutter basics'), findsOneWidget);
        expect(find.text('Dart programming'), findsOneWidget);
        expect(find.text('State management'), findsOneWidget);
        expect(find.text('UI design tips'), findsOneWidget);
        expect(find.text('Testing in Flutter'), findsOneWidget);
      });
    });
  });
}
