library sudokuBoardLib;
import 'package:polymer/polymer.dart';
import 'sudokuCell.dart';
import 'sudokuBlock.dart';
import 'dart:math';
import 'dart:html';

@CustomTag('sudoku-board')
class SudokuBoard extends PolymerElement {

  Random random = new Random();

  SudokuBoard.created() : super.created() {
    print('board created');

  }

  void newGame() {

    // set the coordinates of every cells so they know where they are
    setCoordinates();

    bool validGame = false;
    int tries = 0;
    while (!validGame && tries < 2000) {
      print('Generating game ' + tries.toString());
      validGame = generateGame();
      ++tries;
    }

    if (tries >= 2000) {
      window.alert('Failed to generate a game in 2000 tries, please try again');
    }

  }

  bool generateGame() {

//    print('Generating game');

    clearAllCells();

    // get all the empty cells left
    List<SudokuCell> emptyCells = getEmptyCells();
//    print('Got ' + emptyCells.length.toString() + ' empty cells');

    List<int> possibleValues;
    for (SudokuCell cell in emptyCells) {
//      print('Getting possible values for cell at (' + cell.x.toString() + ', ' + cell.y.toString() + ')');
      possibleValues = getPossibleCellValues(cell.getXCoordinate(), cell.getYCoordinate());
      if (possibleValues.length > 0) {
        possibleValues.shuffle();
        cell.setCellValue(possibleValues[0]);
      } else {
        print('There are no possible values for the cell at (' + cell.getXCoordinate().toString() + ', ' + cell.getYCoordinate().toString() + ')');
        return false;
      }
    }
    return true;
  }

  void clearAllCells() {
//    print('Clearing all cells...');
    // erase whatever might have been there before
    for (int x = 1; x < 10; ++x) {
      for (int y = 1; y < 10; ++y) {
        getCell(x, y).clearCell();
      }
    }
  }

  int getCellValue(int x, int y) {
    return getCell(x, y).cellValue;
  }

  bool isSetValid(Set<int> numbersSet) {
    if (numbersSet.length == 9) {
      for (int i = 1; i < 9; ++i) {
        if (!numbersSet.contains(i)) {
          return false;
        }
      }
      return true;
    } else {
      return false;
    }
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

  int getRandom() {
    return 1 + random.nextInt(9);
  }

  List<SudokuCell> getEmptyCells() {

    List<SudokuCell> emptyCells = new List<SudokuCell>();

    for (int x = 1; x < 10; ++x) {
      for (int y = 1; y < 10; ++y) {
        if (getCell(x, y).cellValue == null) {
          emptyCells.add(getCell(x, y));
        }
      }
    }

    return emptyCells;
  }

  List<int> getPossibleCellValues(int x, int y) {

    List<int> possibleValues = [1, 2, 3, 4, 5, 6, 7, 8, 9];

    Set<int> blockValues = getBlock(x, y).getValuesPresent();
    for (int value in blockValues) {
      possibleValues.remove(value);
    }

    // get all the values from the x axis
    for (int variableCoordinate = 1; variableCoordinate < 9; ++variableCoordinate) {
      possibleValues.remove(getCell(variableCoordinate, y).cellValue);
      possibleValues.remove(getCell(x, variableCoordinate).cellValue);
    }

    return possibleValues;

  }

  void setCoordinates() {
    for (int x = 1; x < 10; ++x) {
      for (int y = 1; y < 10; ++y) {
        if (getCell(x, y) != null) {
          getCell(x, y).setCoordinates(x, y);
        }
      }
    }
  }




}