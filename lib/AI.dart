import 'dart:math';

class AI {
  int difficulty;

  AI({required this.difficulty});

  // very easy difficulty
  List<int> veryEasy(
      List<List<int>> gridState, int playerTurn, List<int> scores) {
    // row destination
    List<int> rd = List<int>.filled(10, 0, growable: true);
    // col destination
    List<int> cd = List<int>.filled(10, 0, growable: true);
    // list of row sources for each destination
    List<List<int>> rs =
        List<List<int>>.filled(10, List<int>.filled(24, 0), growable: true);
    // list of col sources for each destination
    List<List<int>> cs =
        List<List<int>>.filled(10, List<int>.filled(24, 0), growable: true);
    // sizes of the sources for each destination
    List<int> d = List<int>.filled(10, 0, growable: true);

    // m is score, k is max score s is start of array index of destination, pt is other player turn
    // ls is true if same or better move is generally found

    int m, k = 8, s = 0, pt = 3 - playerTurn;
    bool ls;
    d[0] = 0;

    for (int row = 0; row < 7; ++row) {
      for (int col = 0; col < 7; ++col) {
        if (gridState[row][col] == 0) {
          ls = false;
          int l = row + 1 < 7 ? row + 2 : 7;
          int w = col + 1 < 7 ? col + 2 : 7;

          m = 0;

          for (int x = row - 1 >= 0 ? row - 1 : 0; x < l; x++) {
            for (int y = col - 1 >= 0 ? col - 1 : 0; y < w; y++) {
              if (gridState[x][y] == pt) {
                m++;
              }
            }
          }

          l = l + 1 < 7 ? l + 1 : 7;
          w = w + 1 < 7 ? w + 1 : 7;

          for (int i = row - 2 >= 0 ? row - 2 : 0; i < l; i++) {
            for (int j = col - 2 >= 0 ? col - 2 : 0; j < w; j++) {
              if (gridState[i][j] == playerTurn) {
                if ((i - row).abs() == 2 || (j - col).abs() == 2) {
                  if (m < k) {
                    s = 0;
                    d[0] = 0;
                    k = m;
                    rs[s][d[s]] = i;
                    cs[s][d[s]] = j;
                    d[s]++;
                    ls = true;
                  } else if (m == k) {
                    rs[s][d[s]] = i;
                    cs[s][d[s]] = j;
                    d[s]++;
                    ls = true;
                  }
                } else {
                  if (m + 1 == k) {
                    rs[s][d[s]] = i;
                    cs[s][d[s]] = j;
                    d[s]++;
                    ls = true;
                  } else if (m + 1 < k) {
                    s = 0;
                    d[0] = 0;
                    k = m + 1;
                    rs[s][d[s]] = i;
                    cs[s][d[s]] = j;
                    d[s]++;
                    ls = true;
                  }
                }
              }
            }
          }
          if (ls) {
            rd[s] = row;
            cd[s] = col;
            s++;
            if (s >= d.length) {
              d.add(0);
              rs.add(List<int>.filled(24, 0));
              cs.add(List<int>.filled(24, 0));
              rd.add(0);
              cd.add(0);
            }

            d[s] = 0;
          }
        }
      }
    }
    int t1 = Random().nextInt(s);
    int t2 = Random().nextInt(d[t1]);

    if ((rs[t1][t2] - rd[t1]).abs() == 2 || (cs[t1][t2] - cd[t1]).abs() == 2)
      gridState[rs[t1][t2]][cs[t1][t2]] = 0;
    else
      scores[playerTurn - 1]++;

    gridState[rd[t1]][cd[t1]] = playerTurn;

    return [rd[t1], cd[t1]];
  }

  List<int> easy(List<List<int>> gridState, int playerTurn, List<int> scores) {
    // row destination
    List<int> rd = List<int>.filled(24, 0, growable: true);
    // col destination
    List<int> cd = List<int>.filled(24, 0, growable: true);

    int n = 0; // row, col index

    int row;
    int col;
    bool m;

    for (row = 0; row < 7; ++row) {
      for (col = 0; col < 7; ++col) {
        if (gridState[row][col] == playerTurn) {
          m = false;

          int l = row + 2 < 7 ? row + 3 : 7;
          int w = col + 2 < 7 ? col + 3 : 7;

          for (int i = row - 2 >= 0 ? row - 2 : 0; i < l; i++) {
            for (int j = col - 2 >= 0 ? col - 2 : 0; j < w; j++) {
              if (gridState[i][j] == 0) {
                m = true;
                rd[n] = row;
                cd[n] = col;
                n++;
                if (n >= rd.length) {
                  rd.add(0);
                  cd.add(0);
                }
                break;
              }
            }
            if (m == true) break;
          }
        }
      }
    }
    int s = Random().nextInt(n);

    row = rd[s];
    col = cd[s];

    n = 0;
    int l = row + 2 < 7 ? row + 3 : 7;
    int w = col + 2 < 7 ? col + 3 : 7;

    for (int i = row - 2 >= 0 ? row - 2 : 0; i < l; i++) {
      for (int j = col - 2 >= 0 ? col - 2 : 0; j < w; j++) {
        if (gridState[i][j] == 0) {
          rd[n] = i;
          cd[n] = j;
          n++;
        }
      }
    }
    s = Random().nextInt(n);

    if ((rd[s] - row).abs() == 2 || (cd[s] - col).abs() == 2)
      gridState[row][col] = 0;
    else
      scores[playerTurn - 1]++;

    gridState[rd[s]][cd[s]] = playerTurn;

    return [rd[s], cd[s]];
  }

  List<int> medium(
      List<List<int>> gridState, int playerTurn, List<int> scores) {
    // row destination
    List<int> rd = List<int>.filled(24, 0, growable: true);
    // col destination
    List<int> cd = List<int>.filled(24, 0, growable: true);
    int n = 0;

    int row;
    int col;
    bool m = false;
    for (row = 0; row < 7; ++row) {
      for (col = 0; col < 7; ++col) {
        if (gridState[row][col] == playerTurn) {
          int l = row + 2 < 7 ? row + 3 : 7;
          int w = col + 2 < 7 ? col + 3 : 7;

          for (int i = row - 2 >= 0 ? row - 2 : 0; i < l; i++) {
            for (int j = col - 2 >= 0 ? col - 2 : 0; j < w; j++) {
              if (gridState[i][j] == 0) {
                if ((i - row).abs() < 2 && (j - col).abs() < 2) {
                  m = true;
                  rd[n] = row;
                  cd[n] = col;
                  n++;
                  if (n >= rd.length) {
                    rd.add(0);
                    cd.add(0);
                  }
                  break;
                } else
                  m = false;

                int ld = i + 1 < 7 ? i + 2 : 7;
                int wd = j + 1 < 7 ? j + 2 : 7;

                for (int x = i - 1 >= 0 ? i - 1 : 0; x < ld; x++) {
                  for (int y = j - 1 >= 0 ? j - 1 : 0; y < wd; y++) {
                    if (gridState[x][y] == 3 - playerTurn) {
                      m = true;
                      rd[n] = row;
                      cd[n] = col;
                      n++;
                      if (n >= rd.length) {
                        rd.add(0);
                        cd.add(0);
                      }
                      break;
                    }
                  }
                  if (m == true) break;
                }
                if (m == true) break;
              }
            }
            if (m == true) break;
          }
        }
      }
    }
    int s = Random().nextInt(n);

    row = rd[s];
    col = cd[s];

    n = 0;
    int l = row + 2 < 7 ? row + 3 : 7;
    int w = col + 2 < 7 ? col + 3 : 7;

    for (int i = row - 2 >= 0 ? row - 2 : 0; i < l; i++) {
      for (int j = col - 2 >= 0 ? col - 2 : 0; j < w; j++) {
        if (gridState[i][j] == 0) {
          if ((i - row).abs() < 2 && (j - col).abs() < 2) {
            rd[n] = i;
            cd[n] = j;
            n++;
          } else {
            m = false;

            int ld = i + 1 < 7 ? i + 2 : 7;
            int wd = j + 1 < 7 ? j + 2 : 7;

            for (int x = i - 1 >= 0 ? i - 1 : 0; x < ld; x++) {
              for (int y = j - 1 >= 0 ? j - 1 : 0; y < wd; y++) {
                if (gridState[x][y] == 3 - playerTurn) {
                  m = true;
                  rd[n] = i;
                  cd[n] = j;
                  n++;
                  break;
                }
              }
              if (m == true) break;
            }
          }
        }
      }
    }
    s = Random().nextInt(n);

    if ((rd[s] - row).abs() == 2 || (cd[s] - col).abs() == 2)
      gridState[row][col] = 0;
    else
      scores[playerTurn - 1]++;

    gridState[rd[s]][cd[s]] = playerTurn;

    return [rd[s], cd[s]];
  }

  List<int> hard(List<List<int>> gridState, int playerTurn, List<int> scores) {
    List<int> rd = List<int>.filled(10, 0, growable: true);
    // col destination
    List<int> cd = List<int>.filled(10, 0, growable: true);
    // list of row sources for each destination
    List<List<int>> rs =
        List<List<int>>.filled(10, List<int>.filled(24, 0), growable: true);
    // list of col sources for each destination
    List<List<int>> cs =
        List<List<int>>.filled(10, List<int>.filled(24, 0), growable: true);
    // sizes of the sources for each destination
    List<int> d = List<int>.filled(10, 0, growable: true);

    List<List<int>> tn1 = List.filled(7, List.filled(7, 0));

    int m, k = 0, s = 0, pt = 3 - playerTurn;
    bool ls, bk;
    d[0] = 0;

    for (int row = 0; row < 7; ++row) {
      for (int col = 0; col < 7; ++col) {
        if (gridState[row][col] == 0) {
          ls = false;
          bk = false;
          int l = row + 1 < 7 ? row + 2 : 7;
          int w = col + 1 < 7 ? col + 2 : 7;

          m = 0;
          int x, y;

          for (x = 0; x < 7; x++)
            for (y = 0; y < 7; y++) tn1[x][y] = gridState[x][y];

          for (int x = row - 1 >= 0 ? row - 1 : 0; x < l; x++) {
            for (int y = col - 1 >= 0 ? col - 1 : 0; y < w; y++) {
              if (gridState[x][y] == pt) {
                tn1[x][y] = playerTurn;
                m++;
              }
            }
          }

          if (m < k) {
            continue;
          }

          l = l + 1 < 7 ? l + 1 : 7;
          w = w + 1 < 7 ? w + 1 : 7;

          for (int i = row - 2 >= 0 ? row - 2 : 0; i < l; i++) {
            for (int j = col - 2 >= 0 ? col - 2 : 0; j < w; j++) {
              if (gridState[i][j] == playerTurn) {
                if ((i - row).abs() < 2 && (j - col).abs() < 2) {
                  m = m + 1;

                  if (m > k) {
                    s = 0;
                    d[0] = 0;
                    k = m;
                    rs[s][d[s]] = i;
                    cs[s][d[s]] = j;
                    d[s]++;
                    ls = true;
                  } else if (m == k) {
                    rs[s][d[s]] = i;
                    cs[s][d[s]] = j;
                    d[s]++;
                    ls = true;
                  }

                  bk = true;
                  break;
                }
                tn1[i][j] = 0;

                int xs = i + 1 < 7 ? i + 2 : 7;
                int ws = j + 1 < 7 ? j + 2 : 7;
                int l = 0;

                for (int x = i - 1 >= 0 ? i - 1 : 0; x < xs; x++) {
                  for (int y = j - 1 >= 0 ? j - 1 : 0; y < ws; y++) {
                    if (tn1[x][y] == playerTurn) {
                      l++;
                    }
                  }
                }
                m = m - l;

                if (m == k) {
                  rs[s][d[s]] = i;
                  cs[s][d[s]] = j;
                  d[s]++;
                  ls = true;
                } else if (m > k) {
                  s = 0;
                  d[0] = 0;
                  k = m;
                  rs[s][d[s]] = i;
                  cs[s][d[s]] = j;
                  d[s]++;
                  ls = true;
                }
                tn1[i][j] = playerTurn;
                m = m + l;
              }
            }
            if (bk) break;
          }
          if (ls) {
            rd[s] = row;
            cd[s] = col;
            s++;
            if (s >= d.length) {
              d.add(0);
              rs.add(List<int>.filled(24, 0));
              cs.add(List<int>.filled(24, 0));
              rd.add(0);
              cd.add(0);
            }
            d[s] = 0;
          }
        }
      }
    }
    int t1 = Random().nextInt(s);
    int t2 = Random().nextInt(d[t1]);

    if ((rs[t1][t2] - rd[t1]).abs() == 2 || (cs[t1][t2] - cd[t1]).abs() == 2)
      gridState[rs[t1][t2]][cs[t1][t2]] = 0;
    else
      scores[playerTurn - 1]++;

    gridState[rd[t1]][cd[t1]] = playerTurn;

    return [rd[t1], cd[t1]];
  }

  List<int> extreme(
      List<List<int>> gridState, int playerTurn, List<int> scores) {
    List<int> rd = List<int>.filled(10, 0, growable: true);
    // col destination
    List<int> cd = List<int>.filled(10, 0, growable: true);
    // list of row sources for each destination
    List<List<int>> rs =
        List<List<int>>.filled(10, List<int>.filled(24, 0), growable: true);
    // list of col sources for each destination
    List<List<int>> cs =
        List<List<int>>.filled(10, List<int>.filled(24, 0), growable: true);
    // sizes of the sources for each destination
    List<int> d = List<int>.filled(10, 0, growable: true);

    List<List<int>> tn1 = List.filled(7, List.filled(7, 0));

    int m, k = -8, s = 0, ps, pt = 3 - playerTurn;
    bool ls, bk;
    d[0] = 0;
    for (int row = 0; row < 7; ++row) {
      for (int col = 0; col < 7; ++col) {
        if (gridState[row][col] == 0) {
          ls = false;
          bk = false;
          int l = row + 1 < 7 ? row + 2 : 7;
          int w = col + 1 < 7 ? col + 2 : 7;

          m = 0;
          int x, y;

          for (x = 0; x < 7; x++)
            for (y = 0; y < 7; y++) tn1[x][y] = gridState[x][y];

          for (x = row - 1 >= 0 ? row - 1 : 0; x < l; x++) {
            for (y = col - 1 >= 0 ? col - 1 : 0; y < w; y++) {
              if (gridState[x][y] == pt) {
                tn1[x][y] = playerTurn;
                m++;
              }
            }
          }

          tn1[row][col] = playerTurn;
          l = l + 1 < 7 ? l + 1 : 7;
          w = w + 1 < 7 ? w + 1 : 7;

          for (int i = row - 2 >= 0 ? row - 2 : 0; i < l; i++) {
            for (int j = col - 2 >= 0 ? col - 2 : 0; j < w; j++) {
              if (gridState[i][j] == playerTurn) {
                if ((i - row).abs() < 2 && (j - col).abs() < 2) {
                  m = m + 1;

                  ps = maxHumanMove(tn1, pt);

                  if (m - ps > k) {
                    s = 0;
                    d[0] = 0;
                    k = m - ps;
                    rs[s][d[s]] = i;
                    cs[s][d[s]] = j;
                    d[s]++;
                    ls = true;
                  } else if (m - ps == k) {
                    rs[s][d[s]] = i;
                    cs[s][d[s]] = j;
                    d[s]++;
                    ls = true;
                  }

                  bk = true;
                  break;
                }
                tn1[i][j] = 0;

                ps = maxHumanMove(tn1, pt);

                if (m - ps == k) {
                  rs[s][d[s]] = i;
                  cs[s][d[s]] = j;
                  d[s]++;
                  ls = true;
                } else if (m - ps > k) {
                  s = 0;
                  d[0] = 0;
                  k = m - ps;
                  rs[s][d[s]] = i;
                  cs[s][d[s]] = j;
                  d[s]++;
                  ls = true;
                }
                tn1[i][j] = playerTurn;
              }
            }
            if (bk) break;
          }
          if (ls) {
            rd[s] = row;
            cd[s] = col;
            s++;
            if (s >= d.length) {
              d.add(0);
              rs.add(List<int>.filled(24, 0));
              cs.add(List<int>.filled(24, 0));
              rd.add(0);
              cd.add(0);
            }
            d[s] = 0;
          }
        }
      }
    }

    int t1 = Random().nextInt(s);
    int t2 = Random().nextInt(d[t1]);

    if ((rs[t1][t2] - rd[t1]).abs() == 2 || (cs[t1][t2] - cd[t1]).abs() == 2)
      gridState[rs[t1][t2]][cs[t1][t2]] = 0;
    else
      scores[playerTurn - 1]++;

    gridState[rd[t1]][cd[t1]] = playerTurn;

    return [rd[t1], cd[t1]];
  }

  // max score that a human can make in a turn
  int maxHumanMove(List<List<int>> gridState, int playerTurn) {
    List<List<int>> tn1 = List.filled(7, List.filled(7, 0));

    int m, k = 1, pt = 3 - playerTurn;
    bool bk;
    for (int row = 0; row < 7; ++row) {
      for (int col = 0; col < 7; ++col) {
        if (gridState[row][col] == 0) {
          bk = false;
          int l = row + 1 < 7 ? row + 2 : 7;
          int w = col + 1 < 7 ? col + 2 : 7;

          m = 0;
          int x, y;

          for (x = 0; x < 7; x++)
            for (y = 0; y < 7; y++) tn1[x][y] = gridState[x][y];

          for (int x = row - 1 >= 0 ? row - 1 : 0; x < l; x++) {
            for (int y = col - 1 >= 0 ? col - 1 : 0; y < w; y++) {
              if (gridState[x][y] == pt) {
                tn1[x][y] = playerTurn;
                m++;
              }
            }
          }

          if (m < k) {
            continue;
          }

          l = l + 1 < 7 ? l + 1 : 7;
          w = w + 1 < 7 ? w + 1 : 7;

          for (int i = row - 2 >= 0 ? row - 2 : 0; i < l; i++) {
            for (int j = col - 2 >= 0 ? col - 2 : 0; j < w; j++) {
              if (gridState[i][j] == playerTurn) {
                if ((i - row).abs() < 2 && (j - col).abs() < 2) {
                  m = m + 1;

                  if (m > k) {
                    k = m;
                  }
                  bk = true;
                  break;
                }
                tn1[i][j] = 0;

                int ls = i + 1 < 7 ? i + 2 : 7;
                int ws = j + 1 < 7 ? j + 2 : 7;
                int p = 0;

                for (int x = i - 1 >= 0 ? i - 1 : 0; x < ls; x++) {
                  for (int y = j - 1 >= 0 ? j - 1 : 0; y < ws; y++) {
                    if (tn1[x][y] == playerTurn) {
                      p++;
                    }
                  }
                }
                m = m - p;

                if (m > k) {
                  k = m;
                }
                m = m + p;

                tn1[i][j] = playerTurn;
              }
            }
            if (bk) break;
          }
        }
      }
    }
    return k;
  }

  List<int> move(List<List<int>> gridState, int playerTurn, List<int> scores) {
    if (difficulty == 0) return veryEasy(gridState, playerTurn, scores);
    if (difficulty == 1) return easy(gridState, playerTurn, scores);
    if (difficulty == 2) return medium(gridState, playerTurn, scores);
    if (difficulty == 3) return hard(gridState, playerTurn, scores);

    return extreme(gridState, playerTurn, scores);
  }
}
