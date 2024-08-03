import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_provider.dart';
import 'fruit.dart';

class Board extends StatelessWidget {
  int columns;
  int rows;
  late int totalSquares;
  double width;
  double height;
  
  Board({super.key, required this.columns, required this.rows, required this.width, required this.height}) {
    this.totalSquares = rows * columns;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: Consumer<GameProvider>(
        builder: (context, game, child) {
          game.getRandomIndex(totalSquares);

          return GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: columns),
            itemCount: totalSquares,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.green,
                  border: Border.all(color: Colors.green.shade800, width: 1.5),
                ),
                child: game.fruitIndex == index ? Fruit() : null,
              );
            },
          );
        },
      ),
    );
  }
}
