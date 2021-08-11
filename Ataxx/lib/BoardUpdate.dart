class BoardUpdate {
  List<int> selectedIndex = [-1, -1];

  // select the current player piece if possible
  bool piece_selected(List<List<int>> gridState, int x, int y, int playerTurn) {
    if (gridState[x][y] == playerTurn) {
      if (selectedIndex[0] != -1) {
        gridState[selectedIndex[0]][selectedIndex[1]] -= 2;
      }
      selectedIndex = [x, y];
      gridState[x][y] += 2;
    }
    if (selectedIndex[0] == -1) return false;

    return true;
  }

//checks if a move is valid
  bool valid_move(List<List<int>> gridState, List<int> scores, int x, int y,
      int playerTurn) {
    if ((x - selectedIndex[0]).abs() < 3 && (y - selectedIndex[1]).abs() < 3) {
      gridState[selectedIndex[0]][selectedIndex[1]] -= 2;
      gridState[x][y] = playerTurn;
      if ((x - selectedIndex[0]).abs() == 2 ||
          (y - selectedIndex[1]).abs() == 2) {
        gridState[selectedIndex[0]][selectedIndex[1]] = 0;
      } else
        scores[playerTurn - 1]++;
      selectedIndex = [-1, -1];
      return true;
    }

    return false;
  }

  // after validating a move populates the table
  void populate_table(List<List<int>> gridState, List<int> scores, int x, int y,
      int playerTurn) {
    int l = x + 1 < 7 ? x + 2 : 7;
    int w = y + 1 < 7 ? y + 2 : 7;

    for (int i = x - 1 >= 0 ? x - 1 : 0; i < l; i++) {
      for (int j = y - 1 >= 0 ? y - 1 : 0; j < w; j++) {
        if (gridState[i][j] == 3 - playerTurn) {
          gridState[i][j] = playerTurn;
          scores[playerTurn - 1]++;
          scores[2 - playerTurn]--;
        }
      }
    }
  }

  int next_player(List<List<int>> gridState, int playerTurn) {
    bool gf = true;

    for (int row = 0; row < 7; ++row) {
      for (int col = 0; col < 7; ++col) {
        if (gridState[row][col] == 3 - playerTurn) {
          gf = false;
          break;
        }
      }
      if (!gf) {
        break;
      }
    }

    if (gf) {
      return 0;
    }

    gf = true;

    for (int row = 0; row < 7; ++row) {
      for (int col = 0; col < 7; ++col) {
        if (gridState[row][col] == 0) {
          gf = false;

          int l = row + 3 < 7 ? row + 3 : 7;
          int w = col + 3 < 7 ? col + 3 : 7;

          for (int i = row - 2 >= 0 ? row - 2 : 0; i < l; i++) {
            for (int j = col - 2 >= 0 ? col - 2 : 0; j < w; j++) {
              if (gridState[i][j] == 3 - playerTurn) {
                return 3 - playerTurn;
              }
            }
          }
        }
      }
    }

    if (gf) {
      return 0;
    }

    return playerTurn;
  }
}
