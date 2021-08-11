import 'package:flutter/material.dart';

import 'AI.dart';
import 'BoardField.dart';
import 'BoardUpdate.dart';
import 'dart:math';
import 'main.dart';

class Ataxx_Game extends StatefulWidget {
  Ataxx_Game(
      {Key? key,
      required this.play_with_cpu,
      this.CPU_difficulty = 2,
      this.CPU_starts = false})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final bool play_with_cpu;
  final int CPU_difficulty;
  final bool CPU_starts;

  @override
  _Ataxx_GameState createState() => _Ataxx_GameState(
      play_with_cpu: play_with_cpu,
      CPU_difficulty: CPU_difficulty,
      CPU_starts: CPU_starts);
}

class _Ataxx_GameState extends State<Ataxx_Game> {
  final List<List<int>> gridState = [
    [1, 0, 0, 0, 0, 0, 2],
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
    [2, 0, 0, 0, 0, 0, 1]
  ];

  _Ataxx_GameState(
      {required this.play_with_cpu,
      required this.CPU_difficulty,
      required this.CPU_starts}) {
    ai = AI(difficulty: CPU_difficulty);
  }

  final bool play_with_cpu;
  final int CPU_difficulty;
  final bool CPU_starts;

  int playerTurn = 1;
  final List<int> scores = [2, 2];
  bool piece_selected = false;
  AI ai = AI(difficulty: 2);
  int CPUTurn = -1;
  String player1 = 'Player 1';
  String player2 = 'Player 2';

  BoardUpdate boardUpdate = BoardUpdate();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    int b = Random().nextInt(6);

    int i = 0;

    while (i < b) {
      int x1 = Random().nextInt(7);
      int x2 = Random().nextInt(7);

      if ((x1 != 0 || x2 != 0) &&
          (x1 != 6 || x2 != 6) &&
          (x1 != 0 || x2 != 6) &&
          (x1 != 6 || x2 != 0)) {
        gridState[x1][x2] = -1;
        i++;
      }
    }

    if (play_with_cpu) {
      if (CPU_starts) {
        ai.move(gridState, playerTurn, scores);
        CPUTurn = 1;
        player1 = 'CPU';
        player2 = 'Player';
        playerTurn = 2;
      } else {
        CPUTurn = 2;
        player1 = 'Player';
        player2 = 'CPU';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(190),
        child: FractionallySizedBox(
          widthFactor: 0.6,
          heightFactor: 0.5,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Image.asset(
                'images/Ataxx.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
              child: Text(
            'Turn: Player $playerTurn',
            style: TextStyle(fontSize: 28),
          )),
          Container(
              height: 400,
              child: GridView.count(
                physics: NeverScrollableScrollPhysics(),
                childAspectRatio: 1,
                crossAxisCount: 7,
                children: List.generate(49, (index) {
                  return BoardField(
                    gridState: gridState,
                    index: index,
                    onButtonPressed: () {
                      setState(() {
                        int x = (index / gridState.first.length).floor();
                        int y = (index % gridState.first.length);

                        piece_selected = boardUpdate.piece_selected(
                            gridState, x, y, playerTurn);

                        if (gridState[x][y] == 0 && piece_selected) {
                          if (boardUpdate.valid_move(
                              gridState, scores, x, y, playerTurn)) {
                            boardUpdate.populate_table(
                                gridState, scores, x, y, playerTurn);
                            piece_selected = false;
                            playerTurn =
                                boardUpdate.next_player(gridState, playerTurn);
                            while (playerTurn == CPUTurn) {
                              List<int> am =
                                  ai.move(gridState, playerTurn, scores);
                              boardUpdate.populate_table(
                                  gridState, scores, am[0], am[1], playerTurn);
                              playerTurn = boardUpdate.next_player(
                                  gridState, playerTurn);
                            }

                            if (playerTurn == 0) {
                              String end_desc = '';

                              if (scores[0] > scores[1])
                                end_desc = '$player1 has won';
                              else if (scores[0] < scores[1])
                                end_desc = '$player2 has won';
                              else
                                end_desc = 'It is a tie';

                              showDialog<String>(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Game Over'),
                                  content: Text(end_desc),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, 'OK');
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => MyApp()));
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          }
                        }
                      });
                    },
                  );
                }),
              )),
          Container(
              child: Text('$player1 Score: ' + scores[0].toString(),
                  style: TextStyle(fontSize: 28))),
          Container(
              child: Text('$player2 Score: ' + scores[1].toString(),
                  style: TextStyle(fontSize: 28))),
        ],
      ),
    );
  }
}
