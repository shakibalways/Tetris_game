import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tetris_game/global_widgets/pixel.dart';
import 'package:tetris_game/pages/piece.dart';
import 'package:tetris_game/pages/values.dart';
/*
 GAME BOARD

 This is a 2x2 gird with null representing an empty space,
  A non empty space will have the color to represent th landed pieces
 */

// create game board

List<List<Tetromino?>> gameBoard = List.generate(
  colLength,
  (i) => List.generate(
    rowLength,
    (j) => null,
  ),
);

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  //current tetris piece
  Piece currentPiece = Piece(type: Tetromino.T);

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    currentPiece.initializePiece();

    // frame refresh rate
    Duration frameRate = const Duration(milliseconds: 600);
    gameLoop(frameRate);
  }

  void gameLoop(Duration frameRate) {
    Timer.periodic(frameRate, (timer) {
      setState(() {
        //move current piece down
        currentPiece.movePiece(Direction.down);
      });
    });
  }

  // check for collision in a future position
  // return true -> there is a collision
  // return false -> there is no collision
  bool checkCollision(Direction direction) {
    // loop through each position of the current piece
    for (int i = 0; i < currentPiece.position.length; i++) {
      // calculate the row and column of the current position
      int row = (currentPiece.position[i] / rowLength).floor();
      int col = currentPiece.position[i] % rowLength;
      //adjust the row and col based on the direction
      if (direction == Direction.left) {
        col -= 1;
      } else if (direction == Direction.right) {
        col += 1;
      } else if (direction == Direction.down) {
        row += 1;
      }
      // check if the piece is out of bounds(either too low or too far to the left or right)
      if (row >= colLength || col < 0 || col >= rowLength) {
        return true;
      }
    }
    // if no collisions are detected return false
    return false;
  }

  void checkLanding(){
    // if going down is occupied
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GridView.builder(
        itemCount: rowLength * colLength,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: rowLength),
        itemBuilder: (context, index) {
          if (currentPiece.position.contains(index)) {
            return Pixel(
              color: Colors.yellow,
              child: index,
            );
          } else {
            return Pixel(
              color: Colors.grey[900],
              child: index,
            );
          }
        },
      ),
    );
  }
}
