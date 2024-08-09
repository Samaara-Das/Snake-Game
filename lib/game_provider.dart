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
  late int totalSquares;
  List<int> borders = [];
  List<int> snakeBody = [];
  int columns;
  int rows;
  int score = 0;
  int highScore = 0;
  bool gameOver = false;
  late Timer moveTimer;
  late Timer fruitTimer;
  late Timer gameOverTimer;

  GameProvider({required this.columns, required this.rows}) {
    totalSquares = columns * rows;
    fruitIndex = 0;
    headIndex = 0;
    _initializeBorders();
    initializeGame();
    currDirection = Direction.Left;
    clickedDirection = Direction.Still;
    runChecks();
  }

  void _initializeBorders() {
    // Add the indexes of the boxes on the top and bottom borders
    for (int i = 0; i < columns; i++) {
      borders.add(i);
      borders.add((totalSquares - 1) - i);
    }

    // Add the indexes of the boxes on the left and right borders
    for (int i = 0; i < rows; i++) {
      borders.add(i * columns);
      borders.add((i * columns) + (columns - 1));
    }

    // Remove any duplicate indexes
    borders = borders.toSet().toList();
  }

  int _getRandomNumber({required int start, required int end}) {
    if (start >= end) {
      throw ArgumentError('Start must be less than end');
    }

    Random random = Random();
    return start + random.nextInt(end - start + 1);
  }

  void runChecks() {
    moveTimer = Timer.periodic(Duration(milliseconds: 200), (timer) {
      if(!gameOver) changeDirection();
    });

    fruitTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if(!gameOver) isFruitEaten();
    });

    gameOverTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      isGameOver();
    });
  }

  void cancelTimers() {
    moveTimer.cancel();
    fruitTimer.cancel();
    gameOverTimer.cancel();
  }

  /// If the fruit is eaten the fruit re-appears elsewhere, the snake grows and the score and/or high score increases
  void isFruitEaten() {
    if (headIndex == fruitIndex) {
      // make the snake grow longer
      growSnake();

      // make the fruit re-appear somewhere else
      initializeFruit(totalSquares);

      // change the scores
      score++;
      if(score > highScore) highScore = score;
    }
  }

  /// Checks if the game is over if the snake collides with itself or the borders.
  void isGameOver() {
    // If the snake's head has collided with its body
    if(snakeBody.sublist(1, snakeBody.length).contains(headIndex)) {
      gameOver = true;
    }

    // If the snake's head stays on the border of the board for 1 second or more
    if(borders.contains(headIndex)) {
      gameOver = true;
    }
  }

  /// This resets the game to its initial state
  void resetGame() {
    cancelTimers();
    score = 0;
    gameOver = false;
    initializeGame();
    currDirection = Direction.Left;
    clickedDirection = Direction.Still;
    notifyListeners();
    runChecks();
  }

  void initializeGame() {
    initializeFruit(totalSquares);
    initializeSnake(totalSquares);
  }

  void initializeFruit(int totalSquares) {
    int attempts = 0;
    do {
      fruitIndex = _random.nextInt(totalSquares);
      attempts++;
      if (attempts > 1000) { // If there have been 1000 attempts, find a position to place the fruit
        for (int i = 0; i < totalSquares; i++) {
          if (!snakeBody.contains(i) && !borders.contains(i)) {
            fruitIndex = i;
            break;
          }
        }
        break;
      }
    } while (snakeBody.contains(fruitIndex) || borders.contains(fruitIndex));
  }

  void initializeSnake(int totalSquares) {
    int attempts = 0;

    // Select a random row, excluding the first and last rows
    int row = _getRandomNumber(start: 1, end: rows - 2);
    int startIndex = row * columns;
    int endIndex = startIndex + columns - 1;

    do {
      // Select a random position for the head, avoiding the first and last column
      headIndex = _getRandomNumber(start: startIndex + 1, end: endIndex - 3);
      attempts++;
      if (attempts > 1000) {
        // If too many attempts, place the snake in the middle of the row
        headIndex = (startIndex + endIndex) ~/ 2;
        break;
      }
    } while (
    headIndex == fruitIndex ||
        headIndex + 1 == fruitIndex ||
        headIndex + 2 == fruitIndex ||
        borders.contains(headIndex) ||
        borders.contains(headIndex + 1) ||
        borders.contains(headIndex + 2)
    );

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
        break;

      case Direction.Down:
        if (currDirection != Direction.Up && headIndex < columns * (rows - 1)) { // If the down arrow is pressed, change its direction downward unless the snake is moving up
          canChangeDirection = true;
          currDirection = clickedDirection;
        }
        break;

      case Direction.Left:
        if (currDirection != Direction.Right && headIndex % columns != 0) { // If the left arrow is pressed, change its direction to the left unless the snake is moving right
          canChangeDirection = true;
          currDirection = clickedDirection;
        }
        break;

      case Direction.Right:
        if (currDirection != Direction.Left && (headIndex + 1) % columns != 0) { // If the right arrow is pressed, change its direction to the right unless the snake is moving left
          canChangeDirection = true;
          currDirection = clickedDirection;
        }
        break;

      case Direction.Still:
        break;
    }

    if (canChangeDirection) {
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

