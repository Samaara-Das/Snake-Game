import 'package:flutter/material.dart';
import 'game_provider.dart';
import 'package:provider/provider.dart';

// This is a "Game Over" popup which shows when the player loses. It shows an option for the player to restart the game.

class GameOverPopup extends StatefulWidget {
  const GameOverPopup({super.key});

  @override
  State<GameOverPopup> createState() => _StartPopupState();
}

class _StartPopupState extends State<GameOverPopup> {

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: context.watch<GameProvider>().gameOver,
      child: Container(
        width: 200,
        height: 100,
        decoration: BoxDecoration(color: Colors.black, shape: BoxShape.rectangle),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('GAME OVER', style: TextStyle(fontSize: 34, color: Colors.amber, fontWeight: FontWeight.w800)),
            GestureDetector(
              onTap: () => context.read<GameProvider>().resetGame(),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.restart_alt),
                  SizedBox(width: 4.0),
                  Text('Restart Game', style: TextStyle(fontSize: 18, color: Colors.amber)),
                ]
              )
            )
        ])
      )
    );
  }
}

