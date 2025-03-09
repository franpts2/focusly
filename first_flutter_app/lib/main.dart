import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:namer_app/home_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class FavoritesPage extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        var appState = context.watch<MyAppState>();

        if (appState.favs.isEmpty) {
            return Center(
                child: Text('No favorites yet.'),
            );
        }

        return GridView(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400,
              childAspectRatio: 400 / 80,
            ),
            children: appState.favs.map((pair) => ListTile(
              leading: IconButton(
              icon: Icon(Icons.delete_outline),
              onPressed: () => appState.removeFav(pair),
              ),
              title: Text(pair.asLowerCase),
            )).toList(),
        );
    }
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'CheapTail App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreenAccent),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var history = <WordPair>[];
  GlobalKey? historyListKey;

  void getNext() {
    history.insert(0, current);
    var animatedList = historyListKey?.currentState as AnimatedListState;
    animatedList.insertItem(0);
    current = WordPair.random();
    notifyListeners();
  }

  var favs = <WordPair>[];

  void toggleFav([WordPair? pair]) {
    pair = pair ?? current;
    if (favs.contains(pair)) {
      favs.remove(pair);
    } else {
      favs.add(pair);
    }
    notifyListeners();
  }

  void removeFav(WordPair pair) {
    favs.remove(pair);
    notifyListeners();
  }
}
