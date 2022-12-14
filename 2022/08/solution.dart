import 'dart:math' as math show max;
import '../solution.dart' show Solution;

class DayEight implements Solution {
  @override
  Object solvePartOne(Iterable<String> lines) {
    final grid = <List<int>>[
      for (final line in lines) line.split('').map(int.parse).toList(),
    ];

    int visibleTrees = grid.length * 4 - 4;

    for (int row = 1; row < grid.length - 1; ++row) {
      final columns = grid[row];

      for (int col = 1; col < columns.length - 1; ++col) {
        final tree = columns[col];

        // LEFT ----------------------------------------------------------------
        int current = col;
        bool visible = true;

        do {
          --current;
          visible = tree > columns[current];
        } while (visible && current > 0);

        if (visible) {
          visibleTrees++;
          continue;
        }

        // UP ------------------------------------------------------------------
        current = row;
        visible = true;

        do {
          --current;
          visible = tree > grid[current][col];
        } while (visible && current > 0);

        if (visible) {
          visibleTrees++;
          continue;
        }

        // RIGHT ---------------------------------------------------------------
        current = col;
        visible = true;

        do {
          ++current;
          visible = tree > columns[current];
        } while (visible && current < columns.length - 1);

        if (visible) {
          visibleTrees++;
          continue;
        }

        // DOWN ----------------------------------------------------------------
        current = row;
        visible = true;

        do {
          ++current;
          visible = tree > grid[current][col];
        } while (visible && current < grid.length - 1);

        if (visible) {
          visibleTrees++;
          continue;
        }
      }
    }

    return visibleTrees;
  }

  @override
  Object solvePartTwo(Iterable<String> lines) {
    final grid = <List<int>>[
      for (final line in lines) line.split('').map(int.parse).toList(),
    ];

    int highestScore = 0;

    for (int row = 1; row < grid.length - 1; ++row) {
      final columns = grid[row];

      for (int col = 1; col < columns.length - 1; ++col) {
        final tree = columns[col];
        int score = 1;

        // LEFT ----------------------------------------------------------------
        int current = col;
        bool keepGoing = true;

        do {
          --current;
          keepGoing = tree > columns[current];
        } while (keepGoing && current > 0);

        score *= col - current;

        // UP ------------------------------------------------------------------
        current = row;
        keepGoing = true;

        do {
          --current;
          keepGoing = tree > grid[current][col];
        } while (keepGoing && current > 0);

        score *= row - current;

        // RIGHT ---------------------------------------------------------------
        current = col;
        keepGoing = true;

        do {
          ++current;
          keepGoing = tree > columns[current];
        } while (keepGoing && current < columns.length - 1);

        score *= current - col;

        // DOWN ----------------------------------------------------------------
        current = row;
        keepGoing = true;

        do {
          ++current;
          keepGoing = tree > grid[current][col];
        } while (keepGoing && current < grid.length - 1);

        score *= current - row;

        highestScore = math.max(highestScore, score);
      }
    }

    return highestScore;
  }
}
