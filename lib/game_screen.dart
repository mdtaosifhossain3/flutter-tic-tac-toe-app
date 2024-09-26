import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool onTap = true;
  bool isWinner = false;
  List items = ['', '', '', '', '', '', '', '', ''];
  String result = '';
  int userScore = 0;
  int aiScore = 0;
  int itemFilled = 0;
  bool isPlayAgain = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      _showDialog();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff5A1E76),
      body: Center(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Tic Tac Toe Game",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 35),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 400,
                    width: 400,
                    child: GridView.builder(
                        itemCount: 9,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 15),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              _onButtonPressed(index);
                            },
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                  color: const Color(0xff43115B),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Center(
                                  child: Text(
                                items[index],
                                style: TextStyle(
                                    fontSize: 70,
                                    fontWeight: FontWeight.bold,
                                    color: items[index] == "0"
                                        ? Colors.amber
                                        : Colors.cyan),
                              )),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _onButtonPressed(int index) {
    // Only allow user to make a move if the block is empty and it's the user's turn
    if (onTap && items[index] == '') {
      setState(() {
        items[index] = '0'; // Player's move
        onTap = false; // Disable user input until AI moves
        itemFilled++;
      });

      checkedIsWin(); // Check if player won

      // AI move after 2 seconds
      Timer(const Duration(milliseconds: 300), () {
        _makeAIMove();
      });
    }
  }

  void _makeAIMove() {
    // Find all empty positions
    List<int> emptyIndices = [];
    for (int i = 0; i < items.length; i++) {
      if (items[i] == '') {
        emptyIndices.add(i);
      }
    }

    if (emptyIndices.isNotEmpty) {
      // Choose a random empty position
      int randomIndex = emptyIndices[Random().nextInt(emptyIndices.length)];

      setState(() {
        items[randomIndex] = 'x'; // AI's move
        onTap = true; // Enable user input for next turn
      });

      checkedIsWin(); // Check if AI won
    }
  }

  checkedIsWin() {
    if (items[0] == items[1] && items[0] == items[2] && items[0] != '') {
      setState(() {
        result = "Players ${items[0]} is win";
        _scoreUpdater();
        _showDialog();
      });

      return;
    } else if (items[3] == items[4] && items[3] == items[5] && items[3] != '') {
      setState(() {
        result = "Players ${items[3]} is win";
        _scoreUpdater();
        _showDialog();
      });
    } else if (items[6] == items[7] && items[6] == items[8] && items[6] != '') {
      setState(() {
        result = "Players ${items[6]} is win";
        _scoreUpdater();
        _showDialog();
      });
    } else if (items[0] == items[3] && items[0] == items[6] && items[0] != '') {
      setState(() {
        result = "Players ${items[0]} is win";
        _scoreUpdater();
        _showDialog();
      });
    } else if (items[1] == items[4] && items[1] == items[7] && items[1] != '') {
      setState(() {
        result = "Players ${items[1]} is win";
        _scoreUpdater();
        _showDialog();
      });
    } else if (items[2] == items[5] && items[2] == items[8] && items[2] != '') {
      setState(() {
        result = "Players ${items[2]} is win";
        _scoreUpdater();
        _showDialog();
      });
    } else if (items[0] == items[4] && items[0] == items[8] && items[0] != '') {
      setState(() {
        result = "Players ${items[0]} is win";
        _scoreUpdater();
        _showDialog();
      });
    } else if (items[2] == items[4] && items[2] == items[6] && items[2] != '') {
      setState(() {
        result = "Players ${items[2]} is win";
        _scoreUpdater();
        _showDialog();
      });
    } else if (!isWinner && itemFilled == 9) {
      setState(() {
        result = "No one Wins";
        isPlayAgain = true;
        _showDialog();
      });
    }
  }

  _scoreUpdater() {
    isWinner = true;
    isPlayAgain = true;
  }

  void _showDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xff493AD1),
          content: Column(
            mainAxisSize:
                MainAxisSize.min, // Ensures the column is as small as possible
            mainAxisAlignment:
                MainAxisAlignment.center, // Centers content vertically
            children: [
              Text(
                result == "" ? "Welcome to" : "",
                textAlign: TextAlign.center, // Center text horizontally
                style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xff24BCE7),
                    fontWeight: FontWeight.bold), // Style the text if needed
              ),
              result == ""
                  ? const SizedBox(
                      height: 6,
                    )
                  : const SizedBox.shrink(),
              Text(
                result == "" ? "Tic Tac Toe Game" : result,
                textAlign: TextAlign.center, // Center text horizontally
                style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xff24BCE7),
                    fontWeight: FontWeight.bold), // Style the text if needed
              ),
              const SizedBox(
                  height: 20), // Adds space between the text and button
              Center(
                child: isPlayAgain
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            backgroundColor: const Color(0xff23C9CF),
                            foregroundColor: Colors.white),
                        child: const Text(
                          "Play Again",
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: () {
                          setState(() {
                            for (var i = 0; i < items.length; i++) {
                              items[i] = '';
                            }
                            result = '';
                          });
                          isWinner = false;
                          isPlayAgain = false;
                          itemFilled = 0;
                          Navigator.pop(context);
                        },
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            backgroundColor: const Color(0xff23C9CF),
                            foregroundColor: Colors.white),
                        child: const Text(
                          "Let's  Play",
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
