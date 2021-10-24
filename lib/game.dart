import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class SnakeGame extends StatefulWidget {
  String username;
  SnakeGame(this.username);
  @override
  _SnakeGameState createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  final int squaresPerRow = 20;
  final int squaresPerCol = 40;
  final fontStyle = TextStyle(color: Colors.white, fontSize: 20);
  final randomGen = Random();

  var snake = [
    [0, 1],
    [0, 0]
  ];
  var food = [0, 2];
  var direction = 'up';
  var isPlaying = false;

  void startGame() {
    const duration = Duration(milliseconds: 300);

    snake = [ // Snake head
      [(squaresPerRow / 2).floor(), (squaresPerCol / 2).floor()]
    ];

    snake.add([snake.first[0], snake.first[1]+1]); // Snake body

    createFood();

    isPlaying = true;
    Timer.periodic(duration, (Timer timer) {
      moveSnake();
      if (checkGameOver()) {
        timer.cancel();
        endGame();
      }
    });
  }

  void moveSnake() {
    setState(() {
      switch(direction) {
        case 'up':
          snake.insert(0, [snake.first[0], snake.first[1] - 1]);
          break;

        case 'down':
          snake.insert(0, [snake.first[0], snake.first[1] + 1]);
          break;

        case 'left':
          snake.insert(0, [snake.first[0] - 1, snake.first[1]]);
          break;

        case 'right':
          snake.insert(0, [snake.first[0] + 1, snake.first[1]]);
          break;
      }

      if (snake.first[0] != food[0] || snake.first[1] != food[1]) {
        snake.removeLast();
      } else {
        createFood();
      }
    });
  }

  void createFood() {
    food = [
      randomGen.nextInt(squaresPerRow),
      randomGen.nextInt(squaresPerCol)
    ];
  }

  bool checkGameOver() {
    if (!isPlaying
        || snake.first[1] < 0
        || snake.first[1] >= squaresPerCol
        || snake.first[0] < 0
        || snake.first[0] > squaresPerRow
    ) {
      return true;
    }

    for(var i=1; i < snake.length; ++i) {
      if (snake[i][0] == snake.first[0] && snake[i][1] == snake.first[1]) {
        return true;
      }
    }

    return false;
  }

  void endGame() {
    isPlaying = false;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Game Over',style: GoogleFonts.josefinSans(fontSize: 20),),
            content: Text(
              'Score: ${snake.length - 2}',
              style:  GoogleFonts.josefinSans(fontSize: 20),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Close',style: GoogleFonts.josefinSans(fontSize: 20),),
                onPressed: () async{
                  await FirebaseFirestore.instance.collection('score').add(
                      {
                        'username':widget.username,
                        'score': snake.length - 2,
                      }
                  );
                  print('done');
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }
 void initState()
 {
   startGame();
   super.initState();
 }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF343434),
      body: Column(
        children: <Widget>[
           SizedBox(
            height: 100,
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Text('Snake Game',style: GoogleFonts.josefinSans(fontSize: 48,color: Colors.white),)),
          ),
          Expanded(
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (direction != 'up' && details.delta.dy > 0) {
                  direction = 'down';
                } else if (direction != 'down' && details.delta.dy < 0) {
                  direction = 'up';
                }
              },
              onHorizontalDragUpdate: (details) {
                if (direction != 'left' && details.delta.dx > 0) {
                  direction = 'right';
                } else if (direction != 'right' && details.delta.dx < 0) {
                  direction = 'left';
                }
              },
              child: AspectRatio(
                aspectRatio: squaresPerRow / (squaresPerCol + 5),
                child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: squaresPerRow,
                    ),
                    itemCount: squaresPerRow * squaresPerCol,
                    itemBuilder: (BuildContext context, int index) {
                      var color;
                      var x = index % squaresPerRow;
                      var y = (index / squaresPerRow).floor();

                      bool isSnakeBody = false;
                      for (var pos in snake) {
                        if (pos[0] == x && pos[1] == y) {
                          isSnakeBody = true;
                          break;
                        }
                      }

                      if (snake.first[0] == x && snake.first[1] == y) {
                        color = Colors.black;
                      } else if (isSnakeBody) {
                        color = Colors.black;
                      } else if (food[0] == x && food[1] == y) {
                        color = Colors.amber;
                      } else {
                        color = Colors.white60;
                      }

                      return Container(
                        margin: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(6)
                        ),
                      );
                    }),
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height:50,
                    width: 140,
                    decoration: BoxDecoration(
                      color: isPlaying ? Colors.white : const Color(0xFF343434),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: FlatButton(
                        color: isPlaying ? Colors.white : Colors.black,
                        child: Text(
                          isPlaying ? 'End' : 'Start',
                          style: GoogleFonts.josefinSans(color: isPlaying?Colors.black87:Colors.white,fontSize: 24),
                        ),
                        onPressed: () async{
                          if (isPlaying) {
                            isPlaying = false;
                          } else {
                            startGame();
                          }
                        }),
                  ),
                  Text(
                    'Score: ${snake.length - 2}',
                    style: GoogleFonts.josefinSans(color:Colors.white,fontSize: 24),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
