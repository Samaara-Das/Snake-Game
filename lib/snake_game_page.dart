import 'package:flutter/material.dart';
import 'board.dart';
import 'game_provider.dart';
import 'controls.dart';
import 'package:provider/provider.dart';
import 'start_popup.dart';

class SnakeGamePage extends StatefulWidget {
  const SnakeGamePage({super.key, required this.title});
  final String title;

  @override
  State<SnakeGamePage> createState() => _SnakeGamePageState();
}

class _SnakeGamePageState extends State<SnakeGamePage> {
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Snake Game'), centerTitle: true,),
      body: Center(
        child: Consumer<GameProvider>(
          builder: (context, game, child) => Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Board(columns: game.columns, rows: game.rows, size:400),
                  Controls(
                      onUpPressed: () => game.clickedDirection = Direction.Up,
                      onDownPressed: () => game.clickedDirection = Direction.Down,
                      onLeftPressed: () => game.clickedDirection = Direction.Left,
                      onRightPressed: () => game.clickedDirection = Direction.Right
                  )
                ],
              ),
              StartPopup()
            ],
          ),
        )
      ),
    );
  }
}



