library sudokuCellLib;
import 'dart:math';
import 'package:polymer/polymer.dart';

@CustomTag('sudoku-cell')
class SudokuCell extends PolymerElement {
  @observable int cellValue = null;
  @observable String color = 'white';
  @observable String decoration = 'none';
  @observable String weight = 'normal';
  bool preset = false;
  bool colorsOn = true;

  int x;
  int y;

  SudokuCell.created() : super.created();


  void setRandomNumber() {
    final random = new Random();
    cellValue = 1 + random.nextInt(9 - 1);
    colorCell();
  }

  void setCellValue(int value) {
    if (!preset) {
      cellValue = value;
      colorCell();
    }
  }

  bool hasCellValue() {
    return cellValue != null;
  }

  void setCellValuePreset(int value) {
    cellValue = value;
    preset = true;
    decoration = 'underline';
    weight = 'bold';
    colorCell();
  }

  int getCellValue() {
    return cellValue;
  }

  void setCoordinates(int x, int y) {
    this.x = x;
    this.y = y;
  }

  int getXCoordinate() {
    return x;
  }

  int getYCoordinate() {
    return y;
  }

  void clearCell() {
    preset = false;
    decoration = 'none';
    weight = 'normal';
    cellValue = null;
    color = 'white';
  }

  // takes a set of ints and sets cellValue to a number not in that set, returns the value it set
  int setRandomNumberNotIn(Set<int> valueSet) {
    if (valueSet.length > 8) {
//      print('There are already 9 or more values in this set, cannot set a random number not in this set');
    } else {
//      print('Attempting to find value not in ' + valueSet.toString());
      final random = new Random();
      cellValue = 1 + random.nextInt(9);
      while (valueSet.contains(cellValue)) {
        cellValue = 1 + random.nextInt(9);
      }
//      print('setting cell value to ' + cellValue.toString());
    }
    colorCell();
    return cellValue;
  }

  bool isPreset() {
    return preset;
  }

  void incrementCellValue() {
    if (!preset) {
      // set the value
      if (cellValue == null || cellValue == 9) {
        cellValue = 1;
      } else {
        cellValue++;
      }
//    print('Incrementing cell value to ' + cellValue.toString());
      colorCell();
    }
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
    } else {
      color = 'white';
    }
  }


}