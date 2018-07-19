import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("int My App build context = $context");
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    print("in RandomWords createState");
    return RandomState();
  }
}

class RandomState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = Set<WordPair>();

  @override
  Widget build(BuildContext context) {
    print("in RandomState build context = $context");
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: _pushFavorites,
          )
        ],
      ),
      body: _buildList(),
    );
  }

  void _pushFavorites() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      final titles = _saved.map((pair) {
        return ListTile(
          title: Text(pair.asPascalCase),
        );
      });

      final divided = ListTile
          .divideTiles(
            context: context,
            tiles: titles,
          )
          .toList();

      return Scaffold(
        appBar: AppBar(
          title: Text("Favorite Words"),
        ),
        body: ListView(
          children: divided,
        ),
      );
    }));
  }

  Widget _buildList() {
    print("in _buildList");
    return ListView.builder(itemBuilder: (context, i) {
      print("in itemBuilder");
      if (i.isOdd) {
        return Divider(
          height: 1.0,
        );
      }
      final index = i ~/ 2;
      if (index >= _suggestions.length) {
        _suggestions.addAll(generateWordPairs().take(10));
      }
      return _buildRow(index);
    });
  }

  Widget _buildRow(int index) {
    final wordPair = _suggestions[index];
    final alreadySaved = _saved.contains(wordPair);
    return ListTile(
      title: Text("$index-${wordPair.asPascalCase}"),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(wordPair);
          } else {
            _saved.add(wordPair);
          }
        });
      },
    );
  }
}
