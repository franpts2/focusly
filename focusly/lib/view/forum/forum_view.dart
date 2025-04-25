import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'forum_add_question.dart';
import 'package:focusly/viewmodel/forum_question_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'forum_question_detail.dart';

class ForumView extends StatefulWidget {
  const ForumView({super.key});

  @override
  State<ForumView> createState() => _ForumViewState();
}

class _ForumViewState extends State<ForumView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ForumQuestionViewModel>().loadAllQuestions();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final allQuestions = context.watch<ForumQuestionViewModel>().allQuestions;
    final user = FirebaseAuth.instance.currentUser;
    final forumViewModel = context.read<ForumQuestionViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Forum"),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: "New"), Tab(text: "My questions")],
        ),
      ),
      body: Column(
        children: [
          // Search bar below the tab bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _searchController,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: 'Search a question',
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                  prefixIcon: const Icon(Icons.search, size: 20),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 50,
                    minHeight: 50,
                  ),
                  suffixIcon:
                      _searchController.text.isEmpty
                          ? null
                          : IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            onPressed: () {
                              _searchController.clear();
                              forumViewModel.clearSearch();
                            },
                          ),
                  suffixIconConstraints: const BoxConstraints(
                    minWidth: 50,
                    minHeight: 50,
                  ),
                ),
                style: TextStyle(color: colorScheme.onSurface),
                onChanged: (value) {
                  forumViewModel.searchQuestions(value);
                  setState(
                    () {},
                  ); // Update to show clear button when text is entered
                },
              ),
            ),
          ),
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // "New" Tab - Displays all questions
                allQuestions.isEmpty
                    ? const Center(child: Text("No questions found"))
                    : ListView.builder(
                      itemCount: allQuestions.length,
                      itemBuilder: (context, index) {
                        final question = allQuestions[index];
                        return Column(
                          children: [
                            ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => ForumQuestionDetail(
                                          question: question,
                                        ),
                                  ),
                                );
                              },
                              leading: CircleAvatar(
                                backgroundImage:
                                    question.userPhotoUrl != null
                                        ? NetworkImage(question.userPhotoUrl!)
                                        : null,
                                backgroundColor: colorScheme.primaryContainer,
                                child:
                                    question.userPhotoUrl == null
                                        ? const Icon(
                                          Icons.person,
                                          color: Colors.white,
                                        )
                                        : null,
                              ),
                              title: Text(
                                question.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    question.description.length > 50
                                        ? '${question.description.substring(0, 50)}...'
                                        : question.description,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${question.userName ?? "username"} • ${question.answerCount} answers',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              isThreeLine: true,
                            ),
                            const Divider(),
                          ],
                        );
                      },
                    ),
                // "My Questions" Tab - Displays questions asked by the current user
                allQuestions.isEmpty
                    ? const Center(child: Text("No questions found"))
                    : ListView.builder(
                      itemCount: allQuestions.length,
                      itemBuilder: (context, index) {
                        final question = allQuestions[index];
                        // Filter questions for the current user.
                        if (question.userName == user?.displayName) {
                          return Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => ForumQuestionDetail(
                                            question: question,
                                          ),
                                    ),
                                  );
                                },
                                leading: CircleAvatar(
                                  backgroundImage:
                                      question.userPhotoUrl != null
                                          ? NetworkImage(question.userPhotoUrl!)
                                          : null,
                                  backgroundColor: colorScheme.primaryContainer,
                                  child:
                                      question.userPhotoUrl == null
                                          ? const Icon(
                                            Icons.person,
                                            color: Colors.white,
                                          )
                                          : null,
                                ),
                                title: Text(
                                  question.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.primary,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      question.description.length > 50
                                          ? '${question.description.substring(0, 50)}...'
                                          : question.description,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${question.userName ?? "username"} • ${question.answerCount} answers',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                isThreeLine: true,
                              ),
                              const Divider(),
                            ],
                          );
                        } else {
                          return const SizedBox.shrink(); // Return an empty widget for other users' questions
                        }
                      },
                    ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            barrierColor: Colors.black.withOpacity(0.4),
            barrierDismissible: false,
            builder: (context) => const ForumAddQuestion(),
          );
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}
