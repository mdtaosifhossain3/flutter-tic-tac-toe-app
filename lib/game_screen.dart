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
  List<String> items = ['', '', '', '', '', '', '', '', ''];
  String result = '';
  int userScore = 0;
  int aiScore = 0;
  int itemFilled = 0;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      _showDialog(isInitial: true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: const Color(0xff5A1E76),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Tic Tac Toe Game",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 35),
              ), const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _scoreTile("User", userScore, Colors.amber),
                  _scoreTile("AI", aiScore, Colors.cyan),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 400,
                width: 400,
                child: GridView.builder(
                  itemCount: 9,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, crossAxisSpacing: 15, mainAxisSpacing: 15),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _onButtonPressed(index),
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xff43115B),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(
                            items[index],
                            style: TextStyle(
                              fontSize: 70,
                              fontWeight: FontWeight.bold,
                              color: items[index] == "0"
                                  ? Colors.amber
                                  : Colors.cyan,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _scoreTile(String label, int score, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(
          score.toString(),
          style: TextStyle(color: color, fontSize: 18),
        ),
      ],
    );
  }

  void _onButtonPressed(int index) {
    if (onTap && items[index] == '') {
      setState(() {
        items[index] = '0';
        itemFilled++;
        onTap = false;
      });

      if (!checkedIsWin()) {
        // AI moves after a short delay
        Timer(const Duration(milliseconds: 300), () {
          _makeAIMove();
        });
      }
    }
  }

  void _makeAIMove() {
    List<int> emptyIndices = [];
    for (int i = 0; i < items.length; i++) {
      if (items[i] == '') emptyIndices.add(i);
    }

    int bestMove = _getBestMove(); // Improved AI logic
    int aiMove = bestMove != -1 ? bestMove : emptyIndices[Random().nextInt(emptyIndices.length)];

    setState(() {
      items[aiMove] = 'x';
      itemFilled++;
      onTap = true;
    });

    checkedIsWin();
  }

  int _getBestMove() {
    for (int i = 0; i < 9; i++) {
      if (items[i] == '') {
        // Check if AI can win
        items[i] = 'x';
        if (_checkWinCondition('x')) {
          items[i] = '';
          return i;
        }
        items[i] = '';

        // Check if AI can block user
        items[i] = '0';
        if (_checkWinCondition('0')) {
          items[i] = '';
          return i;
        }
        items[i] = '';
      }
    }
    return -1; // No critical move found
  }

  bool checkedIsWin() {
    if (_checkWinCondition('0')) {
      setState(() {
        result = "User Wins!";
        userScore++;
        onTap = false; // Disable interactions until reset
      });
      _showDialog();
      return true;
    } else if (_checkWinCondition('x')) {
      setState(() {
        result = "AI Wins!";
        aiScore++;
        onTap = false; // Disable interactions until reset
      });
      _showDialog();
      return true;
    } else if (itemFilled == 9) {
      setState(() {
        result = "It's a Draw!";
        onTap = false; // Disable interactions until reset
      });
      _showDialog();
      return true;
    }
    return false;
  }


  bool _checkWinCondition(String player) {
    List<List<int>> winConditions = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];
    return winConditions.any((line) =>
    items[line[0]] == player &&
        items[line[1]] == player &&
        items[line[2]] == player);
  }

  void _showDialog({bool isInitial = false}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xff493AD1),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isInitial)
                const Text(
                  "Welcome to Tic Tac Toe Game",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xff24BCE7),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (!isInitial)
                Text(
                  result,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xff24BCE7),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff23C9CF),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  if (!isInitial) {
                    setState(() {
                      items = List.filled(9, ''); // Reset board
                      itemFilled = 0; // Reset filled count
                      result = ''; // Clear result message
                      onTap = true; // Re-enable interactions
                    });
                  }
                  Navigator.of(context).pop();
                },
                child: Text(isInitial ? "Let's Play" : "Play Again"),
              ),
            ],
          ),
        );
      },
    );
  }

}
