import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:url_launcher/url_launcher.dart';

import 'otpView/otp_send_view.dart';

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

  // Function to send a message to the SMS app
  Future<void> sendStopMessage(context) async {
    const phoneNumber = '21213';
    const message = 'STOP atms';

    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: {'body': message}, // pre-fill message
    );

    // Check if the URL can be launched (i.e., if SMS is available)
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri); // Opens SMS app with pre-filled message
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch SMS')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                onPressed: () async {
                  await showPopover(
                    context: context,
                    bodyBuilder: (context) => Column(
                      children: [
                        TextButton(
                          onPressed: () async {
                            final navigator = Navigator.of(context);
                            await sendStopMessage(context);
                            await Future.delayed(const Duration(seconds: 6));
                            navigator.push(
                              MaterialPageRoute(builder: (_) => OtpSendView()),
                            );
                          },
                          child: const Text(
                            "Unsubscribe",
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      ],
                    ),
                    width: 120,
                    height: 50,
                    backgroundColor: Colors.black,
                    direction: PopoverDirection.bottom,
                  );
                },
                icon: const Icon(
                  Icons.logout_outlined,
                  color: Colors.white,
                ),
              );
            },
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff5A1E76), Color(0xff24BCE7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    "Tic Tac Toe",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      letterSpacing: 2,
                      fontFamily: 'Roboto',
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _scoreCard("You", userScore, Colors.amber),
                      _scoreCard("AI", aiScore, Colors.cyan),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 1, // Always square
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.25),
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.18),
                                blurRadius: 24,
                                offset: const Offset(0, 12),
                              ),
                            ],
                            backgroundBlendMode: BlendMode.overlay,
                          ),
                          child: GridView.builder(
                            itemCount: 9,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 18,
                              mainAxisSpacing: 18,
                            ),
                            itemBuilder: (context, index) {
                              bool isWinningTile =
                                  _getWinningTiles().contains(index);
                              return TweenAnimationBuilder<double>(
                                tween: Tween<double>(
                                    begin: 1,
                                    end: items[index] != '' ? 1.08 : 1),
                                duration: const Duration(milliseconds: 200),
                                builder: (context, scale, child) {
                                  return Transform.scale(
                                    scale: scale,
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 250),
                                      decoration: BoxDecoration(
                                        color: items[index] == ''
                                            ? Colors.white
                                                .withValues(alpha: 0.18)
                                            : items[index] == '0'
                                                ? Colors.amber
                                                    .withValues(alpha: 0.92)
                                                : Colors.cyan
                                                    .withValues(alpha: 0.92),
                                        borderRadius: BorderRadius.circular(22),
                                        border: isWinningTile
                                            ? Border.all(
                                                color: Colors.greenAccent
                                                    .withValues(alpha: 0.85),
                                                width: 4,
                                              )
                                            : null,
                                        boxShadow: [
                                          if (isWinningTile)
                                            BoxShadow(
                                              color: Colors.greenAccent
                                                  .withValues(alpha: 0.5),
                                              blurRadius: 18,
                                              spreadRadius: 2,
                                            ),
                                          if (items[index] != '')
                                            const BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 8,
                                              offset: Offset(0, 4),
                                            ),
                                        ],
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(22),
                                          onTap: () => _onButtonPressed(index),
                                          child: Center(
                                            child: AnimatedSwitcher(
                                              duration: const Duration(
                                                  milliseconds: 250),
                                              transitionBuilder:
                                                  (child, anim) =>
                                                      ScaleTransition(
                                                          scale: anim,
                                                          child: child),
                                              child: items[index] == ''
                                                  ? const SizedBox.shrink(
                                                      key: ValueKey('empty'))
                                                  : items[index] == '0'
                                                      ? Icon(
                                                          Icons
                                                              .radio_button_unchecked,
                                                          key: const ValueKey(
                                                              'o'),
                                                          size: 70,
                                                          color: Colors
                                                              .deepPurple
                                                              .shade700,
                                                          shadows: const [
                                                            Shadow(
                                                              color: Colors
                                                                  .black26,
                                                              blurRadius: 12,
                                                              offset:
                                                                  Offset(2, 2),
                                                            ),
                                                          ],
                                                        )
                                                      : Icon(
                                                          Icons.close,
                                                          key: const ValueKey(
                                                              'x'),
                                                          size: 80,
                                                          color: Colors
                                                              .deepPurple
                                                              .shade900,
                                                          shadows: const [
                                                            Shadow(
                                                              color: Colors
                                                                  .black26,
                                                              blurRadius: 12,
                                                              offset:
                                                                  Offset(2, 2),
                                                            ),
                                                          ],
                                                        ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff23C9CF),
        tooltip: "Reset Scores",
        child: const Icon(Icons.refresh, color: Colors.white),
        onPressed: () {
          setState(() {
            userScore = 0;
            aiScore = 0;
            items = List.filled(9, '');
            itemFilled = 0;
            result = '';
            onTap = true;
          });
        },
      ),
    );
  }

  Widget _scoreCard(String label, int score, Color color) {
    return Card(
      color: Colors.white.withValues(alpha: 0.15),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 6),
            Text(
              score.toString(),
              style: TextStyle(
                color: color,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'RobotoMono',
              ),
            ),
          ],
        ),
      ),
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
    int bestMove = _findBestMove();
    if (bestMove != -1) {
      setState(() {
        items[bestMove] = 'x';
        itemFilled++;
        onTap = true;
      });
      checkedIsWin();
    }
  }

  int _findBestMove() {
    int bestScore = -1000;
    int move = -1;
    for (int i = 0; i < 9; i++) {
      if (items[i] == '') {
        items[i] = 'x';
        int score = _minimax(0, false);
        items[i] = '';
        if (score > bestScore) {
          bestScore = score;
          move = i;
        }
      }
    }
    return move;
  }

  int _minimax(int depth, bool isMaximizing) {
    if (_checkWinCondition('x')) return 10 - depth;
    if (_checkWinCondition('0')) return depth - 10;
    if (!items.contains('')) return 0; // Draw

    if (isMaximizing) {
      int bestScore = -1000;
      for (int i = 0; i < 9; i++) {
        if (items[i] == '') {
          items[i] = 'x';
          int score = _minimax(depth + 1, false);
          items[i] = '';
          bestScore = max(score, bestScore);
        }
      }
      return bestScore;
    } else {
      int bestScore = 1000;
      for (int i = 0; i < 9; i++) {
        if (items[i] == '') {
          items[i] = '0';
          int score = _minimax(depth + 1, true);
          items[i] = '';
          bestScore = min(score, bestScore);
        }
      }
      return bestScore;
    }
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

  List<int> _getWinningTiles() {
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
    for (var line in winConditions) {
      if (items[line[0]] != '' &&
          items[line[0]] == items[line[1]] &&
          items[line[1]] == items[line[2]]) {
        return line;
      }
    }
    return [];
  }
}
