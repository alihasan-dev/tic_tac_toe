import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GameScreen extends StatefulWidget {

  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {

  bool isFirstTurn = true;
  var cellData = Map<int, dynamic>.fromIterables(List.generate(9, (index) => index), List.generate(9, (index) => null));
  int winCount = 0;
  int drawCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TicTacToe'), centerTitle: true),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(25),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'WIN : $winCount', 
                style: const TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold
                ),
              ).animate().fade().scale(),
              Text(
                'DRAW : $drawCount', 
                style: const TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold
                ),
              ).animate().fade().scale(),
            ],
          ),
          const SizedBox(height: 20),
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6
            ),
            children: List.generate(
              9, 
              (index) {
                return InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                  onTap: () => onCheckCell(index),
                  child: Ink(
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.8),
                      borderRadius: const BorderRadius.all(Radius.circular(4.0))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: FittedBox(
                        child: cellData[index] != null
                        ? cellData[index] == 'X'
                          ? const Icon(Icons.close).animate().fade(duration: const Duration(milliseconds: 120)).scale()
                          : const Icon(Icons.circle_outlined, color: Colors.white).animate().fade(duration: const Duration(milliseconds: 120)).scale()
                        : null,
                      ),
                    ),
                  ),
                );
              }
            ),
          ),
        ],
      ),
    );
  }

  Future<void> onCheckCell(int index) async {
    if(cellData[index] == null) {
      cellData[index] = isFirstTurn ? 'X' : 'O';
      isFirstTurn = !isFirstTurn;
      update();
      var result = predictGameDecision();
      if(result == 'X' || result == 'O') {
        winCount+=1;
        await showResultDialog(symbol: result);
        cellData.forEach((key, value) => cellData[key] = null);
      }
      if(cellData.values.every((element) => element != null)) {
        await showResultDialog();
        drawCount+=1;
        cellData.forEach((key, value) => cellData[key] = null);
      }
      update();
    }
  }

  void update() => setState((){});

  String predictGameDecision() {
    if(cellData[0] == cellData[1] && cellData[1] == cellData[2] && cellData[0] != null) {
      return cellData[0];
    } else if(cellData[3] == cellData[4] && cellData[4] == cellData[5] && cellData[3] != null) {
      return cellData[3];
    } else if(cellData[6] == cellData[7] && cellData[7] == cellData[8] && cellData[6] != null) {
      return cellData[6];
    } else if(cellData[0] == cellData[3] && cellData[3] == cellData[6] && cellData[0] != null) {
      return cellData[0];
    } else if(cellData[1] == cellData[4] && cellData[4] == cellData[7] && cellData[1] != null) {
      return cellData[1];
    } else if(cellData[2] == cellData[5] && cellData[5] == cellData[8] && cellData[2] != null) {
      return cellData[2];
    } else if(cellData[0] == cellData[4] && cellData[4] == cellData[8] && cellData[0] != null) {
      return cellData[0];
    } else if(cellData[2] == cellData[4] && cellData[4] == cellData[6] && cellData[2] != null) {
      return cellData[2];
    } else {
      return '';
    }
  }

  Future<bool> showResultDialog({String symbol = ''}) async {
    return await showDialog(
      context: context, 
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.teal,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              symbol == 'X'
              ? const Icon(
                  Icons.close,
                  size: 150,
                  color: Colors.black,
                )
              : symbol == 'O'
                ? const Icon(
                    Icons.circle_outlined,
                    size: 120,
                    color: Colors.white
                  )
                : FittedBox(
                  child: Row(
                    children: [
                      Transform.translate(
                        offset: const Offset(12, 0),
                        child: const Icon(
                          Icons.close,
                          size: 150,
                          color: Colors.black,
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(-12, 0),
                        child: const Icon(
                          Icons.circle_outlined,
                          size: 120,
                          color: Colors.white
                        ),
                      ),
                    ],
                  ),
                ),
              Text(
                symbol == 'X' || symbol == 'O'
                ? 'WINNER!'
                : 'DRAW!',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold
                ),
              )
            ],
          ),
        ).animate().fade(duration: const Duration(milliseconds: 120)).scale();
      }
    ) ?? true;
  }
}