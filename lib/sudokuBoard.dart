library sudokuBoardLib;
import 'package:polymer/polymer.dart';
import 'sudokuCell.dart';
import 'sudokuBlock.dart';
import 'dart:math';
import 'dart:html';

@CustomTag('sudoku-board')
class SudokuBoard extends PolymerElement {

  final int triesToGenerateGame = 2000;
  final int triesToCreateValidGame = 100;
  Random random = new Random();
  var answers;
  var candidateGame;
  @observable int inputDifficulty = 51;

  final int easiestDifficulty = 40;
  final int easyDifficulty = 30;
  final int normalDifficulty = 25;
  final int hardDifficulty = 21;
  final int hardestDifficulty = 17;

  SudokuBoard.created() : super.created() {
    print('board created');
    setCoordinates();
  }

  void newGame() {
    newGameBasedOnBlankCells(40);
  }

  void newGameBasedOnInput() {
    if (inputDifficulty > 81) {
      window.alert('You cannot have more than 81 empty cells, since there are only 81 cells total');
    } else if (inputDifficulty < 0) {
      window.alert('Less than 0 empty cells does not make sense');
    }


    newGameBasedOnBlankCells(inputDifficulty);
  }

  // the passed in value difficulty should be an int from 0 to 81, this represents the number of cells that will be empty when the game starts
  void newGameBasedOnBlankCells(int difficulty) {

    if (generateValidBoard()) {
      // save the answers, we'll probably need to reload them repeatedly
      saveAnswers();

      bool solvablePuzzle = false;
      int tries = 0;
      while (!solvablePuzzle && tries < triesToCreateValidGame) {
        print('Trying to create solvable game, attempt ' + (tries + 1).toString() + ' out of ' + triesToCreateValidGame.toString());
        reloadGame();
        blankCells(difficulty);
        saveCandidateGame();
        solvablePuzzle = attemptToSolveBoard();
        ++tries;
      }

      if (solvablePuzzle) {
        // write the candidate game and solidify the non null values
        print('solvable puzzle found in ' + tries.toString() + ' attempts.');
        reloadCandidateGame();
      }

    }

  }

  // generates a game where there are knownSolutions number of cells where there is a definite solution
  void newGameBasedOnInitialKnownSolutions(int knownSolutionsTarget) {

    if (generateValidBoard()) {
      saveAnswers();

      List<SudokuCell> allCells = getAllCells();
      allCells.shuffle();

      int initialNumberToClear = 9;

      for (SudokuCell sudokuCell in allCells) {

        // clear the initial number of cells, no need to do anything else until we do this
        if (initialNumberToClear > 0) {
          sudokuCell.clearCell();
          --initialNumberToClear;
          continue;
        }



        // check if the board is still solvable
        saveCandidateGame();
        bool boardSolvable = attemptToSolveBoard();
        if (boardSolvable) {
          reloadCandidateGame();



        } else {
          break;
        }

      }


    }

  }


  bool generateValidBoard() {
    bool validBoard = false;
    int tries = 0;
    while (tries < triesToGenerateGame) {
      print('Attempting to generate valid completed board, attempt ' + (tries + 1).toString() + ' out of ' + triesToGenerateGame.toString());
      validBoard = generateGame();
      if (validBoard) {
        break;
      }
      ++tries;
    }
    if (!validBoard) {
      window.alert('Failed to generate a game in ' + tries.toString() + ' tries, please try again');
    } else {
      print('Generated valid complete board in ' + (tries + 1).toString() + ' tries');
    }
    return validBoard;
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
//        print('There are no possible values for the cell at (' + cell.getXCoordinate().toString() + ', ' + cell.getYCoordinate().toString() + ')');
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
    return getCell(x, y).getCellValue();
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

  List<SudokuBlock> getAllBlocks() {
    List<SudokuBlock> allBlocks = new List<SudokuBlock>();
    allBlocks.add($['blockX1Y1']);
    allBlocks.add($['blockX1Y2']);
    allBlocks.add($['blockX1Y3']);
    allBlocks.add($['blockX2Y1']);
    allBlocks.add($['blockX2Y2']);
    allBlocks.add($['blockX2Y3']);
    allBlocks.add($['blockX3Y1']);
    allBlocks.add($['blockX3Y2']);
    allBlocks.add($['blockX3Y3']);
    return allBlocks;
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

  List<SudokuCell> getAllCells() {

    List<SudokuCell> emptyCells = new List<SudokuCell>();

    for (int x = 1; x < 10; ++x) {
      for (int y = 1; y < 10; ++y) {
        emptyCells.add(getCell(x, y));
      }
    }

    return emptyCells;
  }

  void saveAnswers() {
    print('Saving answers');
    answers = new Map<String, int>();
    for (int x = 1; x < 10; ++x) {
      for (int y = 1; y < 10; ++y) {
        String coordinates = 'x' + x.toString() + 'y' + y.toString();
        int cellValue = getCell(x, y).getCellValue();
        answers[coordinates] = cellValue;
//        print('Answer for (' + x.toString() + ', ' + y.toString() + ') is ' + cellValue.toString());
      }
    }
  }

  void saveCandidateGame() {
    print('Saving candidate game');
    candidateGame = new Map<String, int>();
    for (int x = 1; x < 10; ++x) {
      for (int y = 1; y < 10; ++y) {
        String coordinates = 'x' + x.toString() + 'y' + y.toString();
        int cellValue = getCell(x, y).getCellValue();
        if (cellValue != null) {
          candidateGame[coordinates] = cellValue;
//        print('Known value for (' + x.toString() + ', ' + y.toString() + ') is ' + cellValue.toString());
        }
      }
    }
  }

  void checkAnswers() {

  // cycle through every cell, 1 incorrect cell will cause many other to be read as incorrect so do not output number wrong, just say that it's wrong
    List<SudokuCell> allCells = getAllCells();
    for (SudokuCell cell in allCells) {
      if (cell.isPreset()) {
        continue;
      }

      if (!cell.hasCellValue()) {
        window.alert('The board isn\'t complete yet');
        return;
      } else {
        if (!checkCellAnswer(cell.getXCoordinate(), cell.getYCoordinate())) {
          window.alert('The solution is not correct');
          return;
        }
      }

    }
    window.alert('Congratulations: you win!');

  }

  // solves a random
  void helpMe() {
    List<SudokuCell> emptyCells = getEmptyCells();
    if (emptyCells.length > 0) {

      // first just try to solve 100% known blocks
      emptyCells.shuffle();
      for (SudokuCell cell in emptyCells) {
        if (attemptToSolveCell(cell)) {
          break;
        }
      }
      console.log('could not solve any empty cells simply');

      // now look x moves ahead


    }
  }

  void reloadGame() {
    for (int x = 1; x < 10; ++x) {
      for (int y = 1; y < 10; ++y) {
        String coordinates = 'x' + x.toString() + 'y' + y.toString();
        getCell(x, y).setCellValue(answers[coordinates]);
      }
    }
  }

  void reloadCandidateGame() {
    for (int x = 1; x < 10; ++x) {
      for (int y = 1; y < 10; ++y) {
        String coordinates = 'x' + x.toString() + 'y' + y.toString();
        if (candidateGame.containsKey(coordinates)) {
          getCell(x, y).setCellValuePreset(candidateGame[coordinates]);
        } else {
          getCell(x, y).clearCell();
        }
      }
    }
  }

  List<int> getPossibleCellValues(int x, int y) {
    List<int> possibleValues = [1, 2, 3, 4, 5, 6, 7, 8, 9];

    Set<int> blockValues = getBlock(x, y).getValuesPresent();
    for (int value in blockValues) {
      possibleValues.remove(value);
    }

    // get all the values from the x and y axis
    for (int variableCoordinate = 1; variableCoordinate <= 9; ++variableCoordinate) {
      possibleValues.remove(getCell(variableCoordinate, y).cellValue);
      possibleValues.remove(getCell(x, variableCoordinate).cellValue);
    }

    return possibleValues;
  }

  bool checkCellAnswer(int x, int y) {
    List<int> possibleValues = [1, 2, 3, 4, 5, 6, 7, 8, 9];

    if (getCellValue(x, y) != null) {

      // check if the block contains
      Set<int> blockValues = getBlock(x, y).getValuesPresent();
      for (int value in possibleValues) {
        if (!blockValues.contains(value)) {
          return false;
        }
      }

      List<int> xValues = [1, 2, 3, 4, 5, 6, 7, 8, 9];
      List<int> yValues = [1, 2, 3, 4, 5, 6, 7, 8, 9];

      for (int variableCoordinate = 1; variableCoordinate <= 9; ++variableCoordinate) {
        xValues.remove(getCell(variableCoordinate, y).getCellValue());
        yValues.remove(getCell(x, variableCoordinate).getCellValue());
      }

      if (xValues.length > 0 || yValues.length > 0) {
        if (xValues.length > 0) {
          print('The value(s) ' + xValues.toString() + ' are missing from the column on (' + x.toString() + ', ' + y.toString() + ')');
        }
        if (yValues.length > 0) {
          print('The value(s) ' + yValues.toString() + ' are missing from the row on (' + x.toString() + ', ' + y.toString() + ')');
        }
        return false;
      }

      return true;
    } else {
      return false;
    }
  }

  bool attemptToSolveCell(SudokuCell cell) {
    List<int> possibleCellValues = getPossibleCellValues(cell.getXCoordinate(), cell.getYCoordinate());
    if (possibleCellValues.length == 1) {
      cell.setCellValue(possibleCellValues[0]);
      return true;
    }
    return false;
  }

  bool attemptToSolveBoard() {
    print('Attempting to solve game');
    List<SudokuCell> emptyCells = getEmptyCells();
    emptyCells.shuffle();
    int unsolvedCells = emptyCells.length;

    int i;
    for (i = 0; i < emptyCells.length; ++i) {

      bool changeMadeThisRound = false;
      for (SudokuCell cell in emptyCells) {

        if (cell.hasCellValue()) {
          continue;
        }

        if (attemptToSolveCell(cell)) {
          --unsolvedCells;
          changeMadeThisRound = true;
        }

        if (unsolvedCells == 0) {
          return true;
        }
      }

      // if every round we don't solve at least one cell then the puzzle is unsolvable
      if (!changeMadeThisRound) {
        return false;
      }

    }

    print('Was not able to solve every cell in ' + i.toString() + ' rounds. Still have ' + unsolvedCells.toString() + ' unsolved cells.');

    return false;
  }

  int countSolvableCells() {
    List<SudokuCell> cells = getAllCells();
    int solvable = 0;

    for (SudokuCell cell in cells) {
      if (!cell.hasCellValue() && getPossibleCellValues(cell.getXCoordinate(), cell.getYCoordinate()).length == 1) {
        ++solvable;
      }
    }

    return solvable;
  }

  // this method just blanks cells completely randomly
  void blankCells(int numberToBlank) {
    int numberBlanked = 0;

    while (numberBlanked < numberToBlank) {
      int x = getRandom();
      int y = getRandom();
      if (getCell(x, y).getCellValue() != null) {
        getCell(x, y).clearCell();
        ++numberBlanked;
      }
    }
  }

  void smartBlankCells(int difficulty) {

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