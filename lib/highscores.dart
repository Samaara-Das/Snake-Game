import 'package:flutter/material.dart';
import 'highscore_tile.dart';

class Highscores extends StatelessWidget {
  var highscore_DocIds;
  Highscores({super.key, required this.highscore_DocIds});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: highscore_DocIds.length,
      itemBuilder: (context, index) => HighscoreTile(documentId: highscore_DocIds[index])
    );
  }
}
