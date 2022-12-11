import 'dart:math' as math;
import '../solution.dart' show Solution;

class DayOne implements Solution {
  @override
  Object solvePartOne(Iterable<String> lines) {
    int res = 0, sum = 0;

    for (final line in lines) {
      if (line.trim().isEmpty) {
        res = math.max(res, sum);
        sum = 0;
      } else {
        sum += int.parse(line);
      }
    }

    return res;
  }

  @override
  Object solvePartTwo(Iterable<String> lines) {
    final totals = <int>[];
    int sum = 0;

    for (final line in lines) {
      if (line.trim().isEmpty) {
        totals.add(sum);
        sum = 0;
      } else {
        sum += int.parse(line);
      }
    }

    totals.sort();
    return totals.sublist(totals.length - 3).reduce((s, v) => s + v);
  }
}
