import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_provider.dart';
import 'fruit.dart';


class Board extends StatefulWidget {
  int columns;
  int rows;
  late int totalSquares;
  double size = 500;
  
  Board({super.key, required this.columns, required this.rows}) {
    totalSquares = rows * columns;
  }

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      child: Consumer<GameProvider>(
        builder: (context, game, child) {
          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: widget.columns),
            itemCount: widget.totalSquares,
            itemBuilder: (context, index) {
              bool isBorder = game.borders.contains(index);

              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: isBorder ? Colors.brown[700] : Colors.green,
                  border: Border.all(color: isBorder ? Colors.brown.shade900 : Colors.green.shade800, width: 1.5),
                ),
                child: game.fruitIndex == index ? const Fruit() : game.snakeBody.contains(index) ? game.getSnakePart(index) : null,
              );
            },
          );
        }
      ),
    );
  }
}
