import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_provider.dart';

List<Widget> scores() {
  return [
    Row( // Score
      children: [
        Icon(Icons.star, color: Colors.amber, size: 24),
        Consumer<GameProvider>(
            builder: (context, game, child) => Text('${game.score}')
        )
      ],
    ),

    SizedBox(width: 20),

    Row( // High Score
      children: [
        Image.asset('assets/trophy.png', width: 20, height: 20),
        Consumer<GameProvider>(
            builder: (context, game, child) => Text('${game.highScore}')
        )
      ],
    ),
  ];
}

