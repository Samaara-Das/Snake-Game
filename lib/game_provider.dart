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
  /// The current score of the player
  int score = 0;
  /// The highest score of the player
  int highScore = 0;

  GameProvider({required this.columns, required this.rows, required this.totalSquares}) {
    totalSquares = columns * rows;
    fruitIndex = 0;
    headIndex = 0;
    initializeGame();
    currDirection = Direction.Left;
    clickedDirection = Direction.Still;
    runChecks();
  }

  void runChecks() async {
    // Move the snake in its direction
    Future.value(Timer.periodic(Duration(milliseconds: 200), (timer) {
      changeDirection();
    }));

    // Check if the fruit is eaten
    Future.value(Timer.periodic(Duration(milliseconds: 100), (timer) {
      isFruitEaten();
    }));
  }

  /// If the fruit is eaten the fruit re-appears elsewhere, the snake grows and the score and/or high score increases
  void isFruitEaten() {
    if (snakeBody.first == fruitIndex) {
      // make the snake grow longer
      growSnake();

      // make the fruit re-appear somewhere else
      initializeFruit(totalSquares);

      // change the scores
      score++;
      if(score > highScore) highScore = score;
    }
  }

  void initializeGame() {
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
        if (currDirection != Direction.Down && headIndex >= columns) { // If the up arrow is pressed, change its direction upward unless the snake is moving down
          canChangeDirection = true;
          currDirection = clickedDirection;
        }

        if (currDirection == Direction.Down && headIndex >= columns) { // otherwise, if the up arrow is pressed while the snake is moving down, let it keep moving down
          canChangeDirection = true;
        }
        break;
      case Direction.Down:
        if (currDirection != Direction.Up && headIndex < columns * (rows - 1)) { // If the down arrow is pressed, change its direction downward unless the snake is moving up
          canChangeDirection = true;
          currDirection = clickedDirection;
        }

        if (currDirection == Direction.Up && headIndex >= columns) { // otherwise, if the down arrow is pressed while the snake is moving up, let it keep moving up
          canChangeDirection = true;
        }
        break;
      case Direction.Left:
        if (currDirection != Direction.Right && headIndex % columns != 0) { // If the left arrow is pressed, change its direction to the left unless the snake is moving right
          canChangeDirection = true;
          currDirection = clickedDirection;
        }

        if (currDirection == Direction.Right && headIndex >= columns) { // otherwise, if the left arrow is pressed while the snake is moving right, let it keep moving right
          canChangeDirection = true;
        }
        break;
      case Direction.Right:
        if (currDirection != Direction.Left && (headIndex + 1) % columns != 0) { // If the right arrow is pressed, change its direction to the right unless the snake is moving left
          canChangeDirection = true;
          currDirection = clickedDirection;
        }

        if (currDirection == Direction.Left && headIndex >= columns) { // otherwise, if the right arrow is pressed while the snake is moving left, let it keep moving left
          canChangeDirection = true;
        }
        break;
      case Direction.Still:
        break;
    }

    if (canChangeDirection) {
      print('Snake can now change direction to ${currDirection.name}');
      moveSnake();
    } else {
      print('Snake will not change Direction. currDirection: ${currDirection.name}');
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

  void growSnake() {
    switch(currDirection) {
      case Direction.Up:
        snakeBody.add(snakeBody.last + columns);
        break;
      case Direction.Down:
        snakeBody.add(snakeBody.last - columns);
        break;
      case Direction.Left:
        snakeBody.add(snakeBody.last + 1);
        break;
      case Direction.Right:
        snakeBody.add(snakeBody.last - 1);
        break;
      case Direction.Still:
        break;
    }

    headIndex = snakeBody.first;
    notifyListeners();
  }

}

