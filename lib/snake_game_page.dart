import 'package:flutter/material.dart';
import 'board.dart';
import 'game_provider.dart';
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
            children: [
              Board(columns: 8, rows: 8, width: 400, height: 400),

            ],
          ),
        )
      ),
    );
  }
}

