library sudokuBlockLib;
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

    // set the ID so we can get the SudokuCell element easily
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

//  int getCellValue(String id) {
//    return $[id].cellValue;
//  }
  int getCellValue(String id) => $[id].cellValue;

  void setCellValue(String id, int value) {
    $[id].cellValue = value;
  }

  SudokuCell getCell(int x, int y) {
    return $['x' + x.toString() + 'y' + y.toString()];
  }

  // are there 9 unique numbers, and do they add up to 45?
  bool isBlockComplete() {
    Set<int> numbersSet = getValuesPresent();

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

  Set<int> getValuesPresent() {
    Set<int> numbersSet = new Set();
    if ($[cellA1].cellValue != null && $[cellA1].cellValue > 0 && $[cellA1].cellValue < 10) {
      numbersSet.add($[cellA1].cellValue);
    }
    if ($[cellA2].cellValue != null && $[cellA2].cellValue > 0 && $[cellA2].cellValue < 10) {
      numbersSet.add($[cellA2].cellValue);
    }
    if ($[cellA3].cellValue != null && $[cellA3].cellValue > 0 && $[cellA3].cellValue < 10) {
      numbersSet.add($[cellA3].cellValue);
    }
    if ($[cellB1].cellValue != null && $[cellB1].cellValue > 0 && $[cellB1].cellValue < 10) {
      numbersSet.add($[cellB1].cellValue);
    }
    if ($[cellB2].cellValue != null && $[cellB2].cellValue > 0 && $[cellB2].cellValue < 10) {
      numbersSet.add($[cellB2].cellValue);
    }
    if ($[cellB3].cellValue != null && $[cellB3].cellValue > 0 && $[cellB3].cellValue < 10) {
      numbersSet.add($[cellB3].cellValue);
    }
    if ($[cellC1].cellValue != null && $[cellC1].cellValue > 0 && $[cellC1].cellValue < 10) {
      numbersSet.add($[cellC1].cellValue);
    }
    if ($[cellC2].cellValue != null && $[cellC2].cellValue > 0 && $[cellC2].cellValue < 10) {
      numbersSet.add($[cellC2].cellValue);
    }
    if ($[cellC3].cellValue != null && $[cellC3].cellValue > 0 && $[cellC3].cellValue < 10) {
      numbersSet.add($[cellC3].cellValue);
    }
    return numbersSet;
  }

  bool isBlockValid() {
    return getValuesPresent().length == 9;
  }

}