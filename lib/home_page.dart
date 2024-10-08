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
  double widthOfGame = 400;
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
  late bool isWideEnough;
  String? playerId;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    letsGetDocIds = getDocId();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!gameHasStarted) {
        showInitialDialog();
      }
    });
  }

  void showInitialDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Welcome to Snake Game!', textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Please enter your name to start:'),
              TextField(controller: _nameController),
            ],
          ),
          actions: [
            MaterialButton(
                child: const Text('START'),
                onPressed: () {
                  if(_nameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Please enter your name', style: TextStyle(color: Colors.white)),
                        backgroundColor: Colors.pink[700]));
                  } else {
                    Navigator.pop(context);
                    initializePlayer();
                  }
                },
                color: Colors.pink
            )
          ],
        )
    );
  }

  void initializePlayer() async {
    var database = FirebaseFirestore.instance;

    // Create a new document for the player with an initial score of 0
    DocumentReference playerRef = await database.collection('highscores').add({
      'name': _nameController.text,
      'score': 0
    });

    // Store the document ID for later use
    setState(() {
      playerId = playerRef.id;
    });
  }

  Future<void> getDocId() async {
    highscore_DocIds = [];  // Clear the list before populating it
    await FirebaseFirestore.instance
        .collection('highscores')
        .where('score', isGreaterThan: 0) // Only get scores greater than 0
        .orderBy('score', descending: true)
        .limit(10)
        .get()
        .then((value) => value.docs.forEach((element) => highscore_DocIds.add(element.reference.id)));
  }

  void startGame() {
    if (playerId == null) {
      showInitialDialog();
    }

    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        gameHasStarted = true;

        // keep the snake moving
        moveSnake();

        //check if game is over
        if(gameOver()) {
          timer.cancel();

          // show a GAME OVER dialog
          showDialog(
            context: context,
            barrierDismissible: false, // This prevents closing by clicking outside
            builder: (context) => AlertDialog(
              title: const Text('GAME OVER', textAlign: TextAlign.center),
              content: Text('Your score is $currentScore'),
              actions: [
                MaterialButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                    submitScore();
                    newGame();
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

  void submitScore() async {
    if (playerId != null) {
      var database = FirebaseFirestore.instance;

      // Get the current document
      DocumentSnapshot doc = await database.collection('highscores').doc(playerId).get();

      // Check if the document exists and has a score field
      if (doc.exists && doc.data() is Map<String, dynamic>) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        int previousScore = data['score'] ?? 0;

        // Only update if the new score is higher
        if (currentScore > previousScore) {
          await database.collection('highscores').doc(playerId).update({
            'score': currentScore
          });
        }
      } else {
        // If the document doesn't exist or doesn't have a score, set the new score
        await database.collection('highscores').doc(playerId).set({
          'name': _nameController.text,
          'score': currentScore
        });
      }

      // Refresh the high scores
      await getDocId();
      setState(() {}); // Trigger a rebuild to show updated high scores
    }
  }

  Future newGame() async {
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
        isWideEnough = screenWidth >= 800;

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
            body: _game(isWideEnough),
          )
        );
      }
    );
  }

  Widget _game(bool isWideEnough) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Current Score
              Container(
                width: widthOfGame,
                child: Row(
                  mainAxisAlignment: isWideEnough ? MainAxisAlignment.center : MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text('Current Score'),
                        Text('$currentScore', style: const TextStyle(fontSize: 30)),
                      ]
                    ),

                    if(!isWideEnough && !gameHasStarted) _buildHighScores(height: 200)
                  ],
                ),
              ),

              SizedBox(height: 20),
              // Game grid
              Container(
                height: 400,
                width: widthOfGame,
                child: _buildGameGrid(),
              ),
              SizedBox(height: 20),
              // Play button
              MaterialButton(
                child: const Text('PLAY'),
                color: gameHasStarted ? Colors.grey : Colors.pink,
                onPressed: gameHasStarted ? null : startGame,
              ),
            ],
          ),
          if (isWideEnough)
            SizedBox(width: 20),
          if (isWideEnough && !gameHasStarted)
            _buildHighScores(height: 400),
        ],
      ),
    );
  }

  Widget _buildGameGrid() {
    return GestureDetector(
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
    );
  }

  Widget _buildHighScores({required double height}) {
    return Container(
      width: 200,
      padding: EdgeInsets.all(8),
      height: height,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.amberAccent, width: 2, strokeAlign: BorderSide.strokeAlignOutside)
      ),
      child: FutureBuilder(
        future: getDocId(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Highscores(highscore_DocIds: highscore_DocIds);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

