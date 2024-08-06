import 'package:flutter/material.dart';
import 'board.dart';
import 'game_provider.dart';
import 'controls.dart';
import 'package:provider/provider.dart';

class SnakeGamePage extends StatefulWidget {
  const SnakeGamePage({super.key, required this.title});
  final String title;

  @override
  State<SnakeGamePage> createState() => _SnakeGamePageState();
}

class _SnakeGamePageState extends State<SnakeGamePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Snake Game'), centerTitle: true,),
      body: Center(
        child: Consumer<GameProvider>(
          builder: (context, game, child) => Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Board(columns: game.columns, rows: game.columns, size:400),
              Controls(
                  onUpPressed: () => game.changeDirection(Direction.Up),
                  onDownPressed: () => game.changeDirection(Direction.Down),
                  onLeftPressed: () => game.changeDirection(Direction.Left),
                  onRightPressed: () => game.changeDirection(Direction.Right)
              )
            ],
          ),
        )
      ),
    );
  }
}

