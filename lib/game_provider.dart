import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'snake.dart';

enum Direction {Up, Down, Left, Right, Still}

class GameProvider extends ChangeNotifier {
  final Random _random = Random();
  late int fruitIndex;
  late int headIndex;
  late Direction currDirection;
  late Direction clickedDirection;
  int totalSquares;
  List<int> snakeBody = [];
  int columns;
  int rows;

  GameProvider({required this.columns, required this.rows, required this.totalSquares}) {
    fruitIndex = 0;
    headIndex = 0;
    initializeGame();
    currDirection = Direction.Left;
    clickedDirection = Direction.Still;
    runTimer();
  }

  void runTimer() async {
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      changeDirection();
    });
  }

  void initializeGame() {
    int totalSquares = columns * rows;
    initializeFruit(totalSquares);
    initializeSnake(totalSquares);
  }

  void initializeFruit(int totalSquares) {
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

  void changeDirection() {
    bool canChangeDirection = false;

    switch (clickedDirection) {
      case Direction.Up:
        if (currDirection != Direction.Down && headIndex >= columns) {
          canChangeDirection = true;
        }
        break;
      case Direction.Down:
        if (currDirection != Direction.Up && headIndex < columns * (rows - 1)) {
          canChangeDirection = true;
        }
        break;
      case Direction.Left:
        if (currDirection != Direction.Right && headIndex % columns != 0) {
          canChangeDirection = true;
        }
        break;
      case Direction.Right:
        if (currDirection != Direction.Left && (headIndex + 1) % columns != 0) {
          canChangeDirection = true;
        }
        break;
      case Direction.Still:
        break;
    }

    if (canChangeDirection) {
      currDirection = clickedDirection;
      moveSnake();
    }

  }

  void moveSnake() {
    int newHeadIndex = headIndex;

    switch (currDirection) {
      case Direction.Up:
        newHeadIndex = headIndex - columns;
        break;
      case Direction.Down:
        newHeadIndex = headIndex + columns;
        break;
      case Direction.Left:
        newHeadIndex = headIndex - 1;
        break;
      case Direction.Right:
        newHeadIndex = headIndex + 1;
        break;
      case Direction.Still:
        break;
    }

    headIndex = newHeadIndex;
    snakeBody.insert(0, headIndex);
    snakeBody.removeLast();
    notifyListeners();
  }

}

