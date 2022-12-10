part of '../solutions.dart';

/// Shared by both parts
const loss = 0;
const draw = 3;
const win = 6;

/// Shared by both parts
int mapLetterChoiceToPoint(String choice) {
  return <String, int>{
    'A': 1,
    'B': 2,
    'C': 3,
    'X': 1,
    'Y': 2,
    'Z': 3,
  }[choice]!;
}

/// Part 2
int mapLetterChoiceToOutcome(String choice) {
  return <String, int>{
    'X': loss,
    'Y': draw,
    'Z': win,
  }[choice]!;
}

class DayTwo implements Solution {
  @override
  Object solvePartOne(Iterable<String> lines) {
    int myScore = 0;

    for (final String line in lines) {
      final choices = line.split(' ');
      final opponent = mapLetterChoiceToPoint(choices[0]);
      final me = mapLetterChoiceToPoint(choices[1]);

      final int outcome;

      if (me == opponent) {
        outcome = draw;
      } else if (me > opponent) {
        outcome = (me + opponent).isEven ? loss : win;
      } else if (me < opponent) {
        outcome = (me + opponent).isEven ? win : loss;
      } else {
        throw Exception('unreachable');
      }

      myScore += me;
      myScore += outcome;
    }

    return myScore;
  }

  @override
  Object solvePartTwo(Iterable<String> lines) {
    int myScore = 0;

    /// Greater index wins, this solution goes in a loop with "% length"
    const choices = [
      1, // rock
      2, // paper
      3, // scissors
    ];

    for (final String line in lines) {
      final input = line.split(' ');
      final opponent = mapLetterChoiceToPoint(input[0]);
      final outcome = mapLetterChoiceToOutcome(input[1]);

      final int me;

      if (outcome == draw) {
        me = opponent;
      } else {
        final opponentIndex = opponent - 1;
        final offset = outcome == win ? 1 : -1;
        final meIndex = (opponentIndex + offset) % choices.length;

        me = choices[meIndex];
      }

      myScore += me;
      myScore += outcome;
    }

    return myScore;
  }
}
