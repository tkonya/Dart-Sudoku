library sudokuCellLib;
import 'dart:html';
import 'dart:math';
import 'package:polymer/polymer.dart';

@CustomTag('sudoku-cell')
class SudokuCell extends PolymerElement {
  @observable int cellValue;
  @observable String color = 'white';
  bool preset = false;
  bool colorsOn = true;

  SudokuCell.created() : super.created();

  void setRandomNumber() {
    final random = new Random();
    cellValue = 1 + random.nextInt(9 - 1);
    colorCell();
  }

  void setCellValue(int value) {
    cellValue = value;
    colorCell();
  }

  // takes a set of ints and sets cellValue to a number not in that set, returns the value it set
  int setRandomNumberNotIn(Set<int> valueSet) {
    if (valueSet.length > 8) {
      print('There are already 9 or more values in this set, cannot set a random number not in this set');
    } else {
      print('Attempting to find value not in ' + valueSet.toString());
      final random = new Random();
      cellValue = 1 + random.nextInt(9);
      while (valueSet.contains(cellValue)) {
        cellValue = 1 + random.nextInt(9);
        print('setting cell value to ' + cellValue.toString());
      }
    }
    colorCell();
    return cellValue;
  }

  void incrementCellValue() {

    // set the value
    if (cellValue == null || cellValue == 9) {
      cellValue = 1;
    } else {
      cellValue++;
    }
    print('Incrementing cell value to ' + cellValue.toString());
    colorCell();
  }

  void colorCell() {
    if (colorsOn) {
      switch (cellValue) {
        case 1:
          color = '#03a9f4';
          break;
        case 2:
          color = '#00e676';
          break;
        case 3:
          color = '#ffeb3b';
          break;
        case 4:
          color = '#e67e22';
          break;
        case 5:
          color = '#ba68c8';
          break;
        case 6:
          color = '#e6ee9c';
          break;
        case 7:
          color = '#7986cb';
          break;
        case 8:
          color = '#c0392b';
          break;
        case 9:
          color = '#4dd0e1';
          break;
      }
    }
  }


}