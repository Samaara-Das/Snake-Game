import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'highscores.dart';
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
  int foodPos = 55; // initial food position
  snake_Direction currentDirection = snake_Direction.RIGHT; // initial snake direction
  int currentScore = 0;
  bool gameHasStarted = false;
  TextEditingController _nameController = TextEditingController();
  List<String> highscore_DocIds = [];
  late final Future? letsGetDocIds;
  final FocusNode _focusNode = FocusNode(); // focus node to capture keyboard events
  bool showHighscoresAtTop = true;
  late bool isWideEnough;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    letsGetDocIds = getDocId();
    super.initState();
  }

  Future getDocId() async {
    await FirebaseFirestore.instance
      .collection('highscores')
      .orderBy('score', descending: true)
      .limit(10)
      .get()
      .then((value) => value.docs.forEach((element) => highscore_DocIds.add(element.reference.id)));
  }

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
          showDialog(
            context: context,
            barrierDismissible: false, // This prevents closing by clicking outside
            builder: (context) => AlertDialog(
              title: const Text('GAME OVER', textAlign: TextAlign.center),
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
                    // if the text field is empty, prompt the user to enter their name
                    if(_nameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Please enter your name', style: TextStyle(color: Colors.white)),
                          backgroundColor: Colors.pink[700]));
                    } else {
                      Navigator.pop(context);
                      submitScore();
                      newGame();
                    }
                  },
                  color: Colors.pink
                )
              ],
            )
          );
        }
      });
    });
  }

  void submitScore() {
    // get access to the collection
    var database = FirebaseFirestore.instance;

    // add data to firebase
    database.collection('highscores').add({
      'name': _nameController.text,
      'score': currentScore
    });
  }

  Future newGame() async {
    highscore_DocIds = [];
    await getDocId();
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        isWideEnough = screenWidth >= 900;

        return KeyboardListener(
          focusNode: _focusNode,
          autofocus: true,
          onKeyEvent: (event) {
            if (event is KeyDownEvent) {
              if (event.logicalKey == LogicalKeyboardKey.arrowDown && currentDirection != snake_Direction.UP) {
                currentDirection = snake_Direction.DOWN;
              } else if (event.logicalKey == LogicalKeyboardKey.arrowUp && currentDirection != snake_Direction.DOWN) {
                currentDirection = snake_Direction.UP;
              } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft && currentDirection != snake_Direction.RIGHT) {
                currentDirection = snake_Direction.LEFT;
              } else if (event.logicalKey == LogicalKeyboardKey.arrowRight && currentDirection != snake_Direction.LEFT) {
                currentDirection = snake_Direction.RIGHT;
              }
            }
          },
          child: Scaffold(
            backgroundColor: Colors.black,
            body: _game(),
          )
        );
      }
    );
  }

  Widget _game() {
    return Center(
      child: Container(
        width: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // score
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // current score
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Current Score'),
                      Text('$currentScore', style: const TextStyle(fontSize: 30))
                    ],
                  ),
                  isWideEnough ? Container() : _buildHighScores(height: 300)
                ]
              ),
            ),

            // game grid and high scores
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 400,
                  width: 400,
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
                        } else if(index == foodPos) {
                          return const FoodPixel();
                        } else {
                          return const BlankPixel();
                        }
                      }
                    ),
                  ),
                ),
              ]
            ),

            // play button
            Expanded(
              child: Center(
                child: MaterialButton(
                  child: const Text('PLAY'),
                  color: gameHasStarted ? Colors.grey : Colors.pink,
                  onPressed: gameHasStarted ? null : startGame,
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }

  Widget _buildHighScores({height}) {
    return Container(
      width: 200,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.amberAccent, width: 2, strokeAlign: BorderSide.strokeAlignOutside)
      ),
      child: FutureBuilder(
        future: letsGetDocIds,
        builder: (context, snapshot) => Highscores(highscore_DocIds: highscore_DocIds),
      ),
    );
  }
}

