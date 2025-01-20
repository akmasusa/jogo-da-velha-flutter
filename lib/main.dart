import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TicTacToe(),
    );
  }
}

class TicTacToe extends StatefulWidget {
  @override
  _TicTacToeState createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  List<String> board = ['', '', '', '', '', '', '', '', ''];
  String currentPlayer = 'X';
  String result = '';
  int playerScore = 0;
  int aiScore = 0;

  void _resetGame() {
    setState(() {
      board = ['', '', '', '', '', '', '', '', ''];
      currentPlayer = 'X';
      result = '';
    });
  }

  void _makeMove(int index) {
    if (board[index] == '' && result == '') {
      setState(() {
        board[index] = currentPlayer;
        if (_checkWin(currentPlayer)) {
          result = 'Jogador $currentPlayer venceu!';
          if (currentPlayer == 'X') {
            playerScore++;
          } else {
            aiScore++;
          }
          Future.delayed(Duration(seconds: 2), _resetGame);
        } else if (!board.contains('')) {
          result = 'Empate!';
          Future.delayed(Duration(seconds: 2), _resetGame);
        } else {
          currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
          if (currentPlayer == 'O') {
            _makeAiMove();
          }
        }
      });
    }
  }

  void _makeAiMove() {
    // Simples estratégia de IA que escolhe o primeiro espaço vazio
    for (int i = 0; i < board.length; i++) {
      if (board[i] == '') {
        _makeMove(i);
        break;
      }
    }
  }

  bool _checkWin(String player) {
    List<List<int>> winPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6]
    ];

    for (var pattern in winPatterns) {
      if (board[pattern[0]] == player &&
          board[pattern[1]] == player &&
          board[pattern[2]] == player) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo da Velha com IA'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _makeMove(index),
                  child: Container(
                    margin: EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      border: Border.all(color: Colors.blue),
                    ),
                    child: Center(
                      child: Text(
                        board[index],
                        style: TextStyle(fontSize: 48.0),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Text(
            result,
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text('Jogador', style: TextStyle(fontSize: 18.0)),
                  Text(playerScore.toString(), style: TextStyle(fontSize: 18.0)),
                ],
              ),
              Column(
                children: [
                  Text('IA', style: TextStyle(fontSize: 18.0)),
                  Text(aiScore.toString(), style: TextStyle(fontSize: 18.0)),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _resetGame,
            child: Text('Reiniciar Jogo'),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
