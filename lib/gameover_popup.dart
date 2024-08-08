import 'package:flutter/material.dart';
import 'game_provider.dart';
import 'package:provider/provider.dart';

class GameOverPopup extends StatefulWidget {
  const GameOverPopup({super.key});

  @override
  State<GameOverPopup> createState() => _StartPopupState();
}

class _StartPopupState extends State<GameOverPopup> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: context.watch<GameProvider>().gameOver,
      child: Container(
        width: 200,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.black,
          shape: BoxShape.rectangle
        ),
        child: const Text('GAME OVER', style: TextStyle(fontSize: 30, color: Colors.amber),),
      )
    );
  }
}

