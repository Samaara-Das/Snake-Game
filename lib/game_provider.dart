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

  /// Populates the borders list with indexes that make up the border of the game
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

  /// Generates a random number from `start` inclusive to `end` inclusive
  int _getRandomNumber({required int start, required int end}) {
    if (start >= end) {
      throw ArgumentError('Start must be less than end');
    }

    Random random = Random();
    return start + random.nextInt(end - start + 1);
  }

  /// Makes `changeDirection()`, `isFruitEaten()` and `isGameOver()` execute periodically in the background
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

  /// Checks if the fruit is eaten. If it is, fruit re-appears elsewhere, the snake grows and the score and/or high score increases
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

  /// Initializes the snake and fruit
  void initializeGame() {
    initializeFruit(totalSquares);
    initializeSnake(totalSquares);
  }

  /// Places the fruit on a random place on the board within the borders
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

  /// Places the snake with 2 body parts on a random place on the board within the borders
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

  /// Gets the snake's body part or head based on the value of `index`
  Widget getSnakePart(int index) {
    if (index == headIndex) {
      return const Head();
    } else {
      return const SnakeBody();
    }
  }

  /// Changes the current direction of the snake
  void changeDirection() {
    switch (clickedDirection) {
      case Direction.Up:
        // If the up arrow is pressed, change its direction upward unless the snake is moving down
        if (currDirection != Direction.Down && headIndex >= columns) currDirection = clickedDirection;
        moveSnake();
        break;

      case Direction.Down:
        // If the down arrow is pressed, change its direction downward unless the snake is moving up
        if (currDirection != Direction.Up && headIndex < columns * (rows - 1)) currDirection = clickedDirection;
        moveSnake();
        break;

      case Direction.Left:
        // If the left arrow is pressed, change its direction to the left unless the snake is moving right
        if (currDirection != Direction.Right && headIndex % columns != 0) currDirection = clickedDirection;
        moveSnake();
        break;

      case Direction.Right:
        // If the right arrow is pressed, change its direction to the right unless the snake is moving left
        if (currDirection != Direction.Left && (headIndex + 1) % columns != 0) currDirection = clickedDirection;
        moveSnake();
        break;

      case Direction.Still:
        break;
    }

  }

  /// Moves the snake in `currDirection`
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

  /// Makes the snake longer by adding another body part
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

