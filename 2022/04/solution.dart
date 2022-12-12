import '../solution.dart' show Solution;

class Range {
  final int begin;
  final int end;

  Range(String begin, String end)
      : begin = int.parse(begin),
        end = int.parse(end);

  bool fullyContains(Range other) {
    return begin <= other.begin && other.end <= end;
  }

  bool overlaps(Range other) {
    return (begin <= other.begin && end >= other.begin) ||
        (end >= other.begin && end <= other.end);
  }
}

class DayFour implements Solution {
  void applyToAllRangePairs(
    Iterable<String> lines,
    void Function(Range, Range) callback,
  ) {
    for (final line in lines) {
      final sections = line.split(',');
      final firstSection = sections[0].split('-');
      final secondSection = sections[1].split('-');

      final first = Range(firstSection[0], firstSection[1]);
      final second = Range(secondSection[0], secondSection[1]);

      callback(first, second);
    }
  }

  @override
  Object solvePartOne(Iterable<String> lines) {
    int total = 0;

    applyToAllRangePairs(lines, (Range first, Range second) {
      if (first.fullyContains(second) || second.fullyContains(first)) {
        total++;
      }
    });

    return total;
  }

  @override
  Object solvePartTwo(Iterable<String> lines) {
    int total = 0;

    applyToAllRangePairs(lines, (Range first, Range second) {
      if (first.overlaps(second) || second.overlaps(first)) {
        total++;
      }
    });

    return total;
  }
}
