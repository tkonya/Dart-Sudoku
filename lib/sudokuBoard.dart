library sudokuBoardLib;
import 'dart:html';
import 'package:polymer/polymer.dart';
import 'sudokuCell.dart';
import 'sudokuBlock.dart';

@CustomTag('sudoku-board')
class SudokuBoard extends PolymerElement {

  SudokuBoard.created() : super.created() {
    print('board created');
  }

//  Set<int> verticalLeft1 = new Set();
//  Set<int> verticalLeft2 = new Set();
//  Set<int> verticalLeft3 = new Set();
//  Set<int> verticalCenter1 = new Set();
//  Set<int> verticalCenter2 = new Set();
//  Set<int> verticalCenter3 = new Set();
//  Set<int> verticalRight1 = new Set();
//  Set<int> verticalRight2 = new Set();
//  Set<int> verticalRight3 = new Set();
//
//  Set<int> horizontalTop1 = new Set();
//  Set<int> horizontalTop2 = new Set();
//  Set<int> horizontalTop3 = new Set();
//  Set<int> horizontalCenter1 = new Set();
//  Set<int> horizontalCenter2 = new Set();
//  Set<int> horizontalCenter3 = new Set();
//  Set<int> horizontalBottom1 = new Set();
//  Set<int> horizontalBottom2 = new Set();
//  Set<int> horizontalBottom3 = new Set();

  void newGame() {
//    $["x1"].generateRandomBlock();

//    print($["x1"].getCellValue('x1y1'));

//    $["x1y1"].setRandomNumber();

    setCellValue(6, 6, 9);

  }

  int getCellValue(int x, int y) {
    return getCell(x, y).cellValue;
  }

  void setCellValue(int x, int y, int value) {
    getCell(x, y).setCellValue(value);
  }

  SudokuCell getCell(int x, int y) {
    return getBlock(x, y).getCell(x, y);
  }

  SudokuBlock getBlock(int x, int y) {
    if (x < 4) {
      if (y < 4) {
        return $['blockX1Y1'];
      } else if (y < 7) {
        return $['blockX1Y2'];
      } else {
        return $['blockX1Y3'];
      }
    } else if (x < 7) {
      if (y < 4) {
        return $['blockX2Y1'];
      } else if (y < 7) {
        return $['blockX2Y2'];
      } else {
        return $['blockX2Y3'];
      }
    } else {
      if (y < 4) {
        return $['blockX3Y1'];
      } else if (y < 7) {
        return $['blockX3Y2'];
      } else {
        return $['blockX3Y3'];
      }
    }
  }



}