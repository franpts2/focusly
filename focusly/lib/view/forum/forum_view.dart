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

class _ForumViewState extends State<ForumView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final questions = context.watch<ForumQuestionViewModel>().questions;
    final user = FirebaseAuth.instance.currentUser;
    final allQuestions = context.watch<ForumQuestionViewModel>().allQuestions;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Forum"),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "New"),
            Tab(text: "My questions"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
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
                          builder: (_) => ForumQuestionDetail(question: question),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      backgroundImage: question.userPhotoUrl != null
                          ? NetworkImage(question.userPhotoUrl!)
                          : null,
                      backgroundColor: colorScheme.primaryContainer,
                      child: question.userPhotoUrl == null
                          ? const Icon(Icons.person, color: Colors.white)
                          : null,
                    ),
                    title: Text(
                      question.title,
                      style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.primary),
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
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
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
          questions.isEmpty
              ? Center(child: Text("No questions available"))
              : ListView.builder(
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    final question = questions[index];
                    return Column(
                      children: [
                        ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ForumQuestionDetail(
                                  question: question,
                                  userName: user?.displayName,
                                  photoUrl: user?.photoURL,
                                ),
                              ),
                            );
                          },
                          leading: CircleAvatar(
                            backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                            backgroundColor: colorScheme.primaryContainer,
                            child: user?.photoURL == null ? const Icon(Icons.person, color: Colors.white) : null,
                          ),
                          title: Text(
                            question.title,
                            style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.primary),
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
                                '${user?.displayName ?? "username"} • ${question.answerCount} answers',
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
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
