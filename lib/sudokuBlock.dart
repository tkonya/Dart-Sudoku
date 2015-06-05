library sudokuBlockLib;
import 'dart:html';
import 'package:polymer/polymer.dart';
import 'sudokuCell.dart';

@CustomTag('sudoku-block')
class SudokuBlock extends PolymerElement {

  @published int startX;
  @published int startY;
  String cellA1;
  String cellA2;
  String cellA3;
  String cellB1;
  String cellB2;
  String cellB3;
  String cellC1;
  String cellC2;
  String cellC3;

  SudokuBlock.created() : super.created() {
    print('startX = ' + startX.toString());
    print('startY = ' + startY.toString());
    cellA1 = 'x' + startX.toString() + 'y' + startY.toString();
    cellA2 = 'x' + (startX + 1).toString() + 'y' + startY.toString();
    cellA3 = 'x' + (startX + 2).toString() + 'y' + startY.toString();
    cellB1 = 'x' + startX.toString() + 'y' + (startY + 1).toString();
    cellB2 = 'x' + (startX + 1).toString() + 'y' + (startY + 1).toString();
    cellB3 = 'x' + (startX + 2).toString() + 'y' + (startY + 1).toString();
    cellC1 = 'x' + startX.toString() + 'y' + (startY + 2).toString();
    cellC2 = 'x' + (startX + 1).toString() + 'y' + (startY + 2).toString();
    cellC3 = 'x' + (startX + 2).toString() + 'y' + (startY + 2).toString();
  }

  void generateRandomBlock() {

    Set<int> numbersSet = new Set();
    numbersSet.add($[cellA1].setRandomNumberNotIn(numbersSet));
    numbersSet.add($[cellA2].setRandomNumberNotIn(numbersSet));
    numbersSet.add($[cellA3].setRandomNumberNotIn(numbersSet));
    numbersSet.add($[cellB1].setRandomNumberNotIn(numbersSet));
    numbersSet.add($[cellB2].setRandomNumberNotIn(numbersSet));
    numbersSet.add($[cellB3].setRandomNumberNotIn(numbersSet));
    numbersSet.add($[cellC1].setRandomNumberNotIn(numbersSet));
    numbersSet.add($[cellC2].setRandomNumberNotIn(numbersSet));
    numbersSet.add($[cellC3].setRandomNumberNotIn(numbersSet));

  }

  int getCellValue(String id) {
    return $[id].cellValue;
  }

  void setCellValue(String id, int value) {
    $[id].cellValue = value;
  }

  SudokuCell getCell(int x, int y) {
    return $['x' + x.toString() + 'y' + y.toString()];
  }

  // are there 9 unique numbers, and do they add up to 45?
  bool isBlockComplete() {
    Set<int> numbersSet = new Set();
    numbersSet.add($[cellA1].cellValue);
    numbersSet.add($[cellA2].cellValue);
    numbersSet.add($[cellA3].cellValue);
    numbersSet.add($[cellB1].cellValue);
    numbersSet.add($[cellB2].cellValue);
    numbersSet.add($[cellB3].cellValue);
    numbersSet.add($[cellC1].cellValue);
    numbersSet.add($[cellC2].cellValue);
    numbersSet.add($[cellC3].cellValue);

    int sum = 45;
    for (int number in numbersSet) {
      sum -= number;
    }

    if (sum == 0 && numbersSet.length == 9) {
      return true;
    } else {
      return false;
    }
  }

}