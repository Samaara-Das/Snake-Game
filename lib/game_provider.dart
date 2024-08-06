import 'dart:math';
import 'package:flutter/material.dart';
import 'snake.dart';
import 'package:provider/provider.dart';

enum Direction {Up, Down, Left, Right}

class GameProvider extends ChangeNotifier {
  final Random _random = Random();
  late int fruitIndex;
  late int headIndex;
  List<int> snakeBody = [];
  late Direction currDirection;
  int columns;
  int rows;

  GameProvider({required this.columns, required this.rows}) {
    currDirection = Direction.Up;
    fruitIndex = 0;
    headIndex = 0;
  }

  void initializeGame() {
    int totalSquares = columns * rows;
    getRandomIndex(totalSquares);
    initializeSnake(totalSquares);
  }

  void getRandomIndex(int totalSquares) {
    do {
      fruitIndex = _random.nextInt(totalSquares);
    } while (snakeBody.contains(fruitIndex));
  }

  void initializeSnake(int totalSquares) {
    int row = _random.nextInt(rows);
    int startIndex = row * columns;
    int endIndex = startIndex + columns - 1;

    do {
      headIndex = _random.nextInt(endIndex - startIndex - 2) + startIndex;
    } while (headIndex == fruitIndex || headIndex + 1 == fruitIndex || headIndex + 2 == fruitIndex);

    snakeBody = [headIndex, headIndex + 1, headIndex + 2];
  }

  Widget getSnakePart(int index) {
    if (index == headIndex) {
      return const Head();
    } else {
      return const SnakeBody();
    }
  }

  void changeDirection(Direction newDirection) {
    if ((currDirection == Direction.Up && newDirection != Direction.Down) ||
        (currDirection == Direction.Down && newDirection != Direction.Up) ||
        (currDirection == Direction.Left && newDirection != Direction.Right) ||
        (currDirection == Direction.Right && newDirection != Direction.Left)) {
      currDirection = newDirection;
      moveSnake();
    }
  }

  void moveSnake() {
    switch (currDirection) {
      case Direction.Up:
        // if(headIndex <= columns-1) // if the top of the board has been reached, prevent the snake from leaving the board
        //   break;
        headIndex = headIndex - columns;
        break;
      case Direction.Down:
        // int lastRow = rows*columns;
        // if(((lastRow-9)-1) <= lastRow-1) // if the bottom of the board has been reached, prevent the snake from leaving the board
        //   break;
        headIndex = headIndex + columns;
        break;
      case Direction.Left:
        headIndex = headIndex - 1;
        break;
      case Direction.Right:
        headIndex = headIndex + 1;
        break;
    }

    snakeBody.insert(0, headIndex);
    snakeBody.removeLast();
    notifyListeners();
  }

}

