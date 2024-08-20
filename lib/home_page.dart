import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import 'blank_pixel.dart';
import 'head_pixel.dart';
import 'snake_pixel.dart';
import 'food_pixel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

enum snake_Direction {
  RIGHT, LEFT, UP, DOWN
}

class _HomePageState extends State<HomePage> {
  int rowSize = 10;
  int totalNumberOfSquares = 100;
  List<int> snakePos = [0, 1, 2];
  int foodPos = 55;
  snake_Direction currentDirection = snake_Direction.RIGHT;
  int currentScore = 0; // initial snake direction
  bool gameHasStarted = false;
  TextEditingController _nameController = TextEditingController();

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        // keep the snake moving
        moveSnake();

        //check if game is over
        if(gameOver()) {
          timer.cancel();

          // show a dialog
          showDialog(context: context, builder: (context) => AlertDialog(
            title: const Text('GAME OVER'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Your score is $currentScore'),
                TextField(controller: _nameController, decoration: const InputDecoration(hintText: 'Enter your name')),
              ],
            ),
            actions: [
              MaterialButton(
                child: const Text('SUBMIT'), 
                onPressed: () {
                  Navigator.pop(context);
                  submitScore();
                  newGame();
                },
                color: Colors.pink
              )
            ],
          ));
        }
      });
    });
  }

  void submitScore() {

  }

  void newGame() {
    setState(() {
      snakePos = [0, 1, 2];
      foodPos = 55;
      currentDirection = snake_Direction.RIGHT;
      gameHasStarted = false;
      currentScore = 0;
    });
  }

  void moveSnake() {
    switch(currentDirection) {
      case snake_Direction.RIGHT:
        {
          // if snake reaches the right edge, make it continue from the left edge
          if(snakePos.last % rowSize == 9) {
            snakePos.add(snakePos.last + 1 - rowSize);
          } else {
            // add a new head
            snakePos.add(snakePos.last + 1);
          }
        }
        break;
      case snake_Direction.LEFT:
        {
          // if snake reaches the left edge, make it continue from the right edge
          if(snakePos.last % rowSize == 0) {
            snakePos.add(snakePos.last - 1 + rowSize);
          } else {
            // add a new head
            snakePos.add(snakePos.last - 1);
          }
        }
        break;
      case snake_Direction.UP:
        {
          // if snake reaches the top edge, make it continue from the bottom edge
          if(snakePos.last < rowSize) {
            snakePos.add(snakePos.last - rowSize + totalNumberOfSquares);
          } else {
            // add a new head
            snakePos.add(snakePos.last - rowSize);
          }
        }
        break;
      case snake_Direction.DOWN:
        {
          // if snake reaches the top edge, make it continue from the bottom edge
          if(snakePos.last >= totalNumberOfSquares - rowSize) {
            snakePos.add(snakePos.last + rowSize - totalNumberOfSquares);
          } else {
            // add a new head
            snakePos.add(snakePos.last + rowSize);
          }
        }
        break;
    }

    if(snakePos.last == foodPos) {
      currentScore++;
      eatFood();
    } else {
      snakePos.removeAt(0);
    }
  }

  void eatFood() {
    // move the food somewhere where the snake isn't
    while(snakePos.contains(foodPos)) {
      foodPos = Random().nextInt(totalNumberOfSquares);
    }
  }

  bool gameOver() {
    // if there are duplicate elements in snakePos, the snake has collided with itself
    List<int> snakeParts = snakePos.sublist(0, snakePos.length - 1); // body of the snake
    if(snakeParts.contains(snakePos.last)) { // if the last element of snakePos is in snakeParts, the snake has collided with itself
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox(
          width: screenWidth > 400 ? 400:screenWidth,
          child: Column(
            children: [
              // high score
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Current Score'),
                        Text('$currentScore', style: const TextStyle(fontSize: 30))
                      ],
                    ),
                    const Text('high score...')
                  ],
                ),
              ),
          
              // game grid
              Expanded(
                flex: 4,
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    if(details.delta.dy > 0 && currentDirection != snake_Direction.UP) {
                      currentDirection = snake_Direction.DOWN;
                    }
                    if(details.delta.dy < 0 && currentDirection != snake_Direction.DOWN) {
                      currentDirection = snake_Direction.UP;
                    }
                  },
                  onHorizontalDragUpdate: (details) {
                    if(details.delta.dx > 0 && currentDirection != snake_Direction.LEFT) {
                      currentDirection = snake_Direction.RIGHT;
                    }
                    if(details.delta.dx < 0 && currentDirection != snake_Direction.RIGHT) {
                      currentDirection = snake_Direction.LEFT;
                    }
                  },
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: rowSize), 
                    itemCount: totalNumberOfSquares,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      if(index == snakePos.last) {
                        return const HeadPixel();
                      } else if(snakePos.contains(index)) {
                        return const SnakePixel();
                      }  else if(index == foodPos) {
                        return const FoodPixel();
                      } else {
                        return const BlankPixel();
                      }
                    }
                  ),
                ),
              ),
          
              // play button
              Expanded(
                child: Container(
                  child: Center(
                    child: MaterialButton(
                      child: const Text('PLAY'),
                      color: gameHasStarted ? Colors.grey : Colors.pink,
                      onPressed: gameHasStarted ? null : startGame,
                    ),
                  ),
                ),
              ),
            ]
          ),
        ),
      )
    );
  }

  
}

