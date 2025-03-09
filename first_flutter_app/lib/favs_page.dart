
import 'package:flutter/material.dart';
import 'package:namer_app/main.dart';
import 'package:provider/provider.dart';

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