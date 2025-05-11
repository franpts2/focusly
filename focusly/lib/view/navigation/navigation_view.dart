import 'package:flutter/material.dart';
import 'package:focusly/view/create/create_view.dart';
import 'package:focusly/view/home/home_view.dart';
import 'package:focusly/view/forum/forum_view.dart';
import 'package:focusly/view/pomodoro/pomodoro_view.dart';
import 'package:focusly/view/profile/profile_view.dart';
import 'package:material_symbols_icons/symbols.dart';

class NavigationView extends StatefulWidget {
  const NavigationView({super.key});

  @override
  State<NavigationView> createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  int currentIndex = 0;
  final List<Widget> _pages = [
    const HomeView(),
    const ForumView(),
    const CreateView(),
    const PomodoroView(skipNotifications: false),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: _pages),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(45)),
          child: NavigationBar(
            selectedIndex: currentIndex,
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            destinations: [
              NavigationDestination(
                icon: Icon(Symbols.family_home),
                label: "Home",
              ),
              NavigationDestination(
                icon: Icon(Symbols.question_mark),
                label: "Forum",
              ),
              NavigationDestination(
                icon: Icon(Symbols.add_circle),
                label: "Create",
              ),
              NavigationDestination(
                icon: Icon(Symbols.timer),
                label: "Pomodoro",
              ),
              NavigationDestination(
                icon: Icon(Symbols.person),
                label: "Profile",
              ),
            ],
            onDestinationSelected: (int index) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
