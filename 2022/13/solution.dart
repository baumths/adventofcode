import 'dart:convert' show jsonDecode, jsonEncode;
import '../solution.dart' show Solution;

class DayThirteen implements Solution {
  @override
  Object solvePartOne(Iterable<String> lines) {
    int pairsInRightOrderIndexSum = 0;

    for (int offset = 0; offset < lines.length; offset += 3) {
      final left = jsonDecode(lines.elementAt(offset));
      final right = jsonDecode(lines.elementAt(offset + 1));

      if (process(left, right) < 0) {
        final index = (offset + 3) ~/ 3;
        pairsInRightOrderIndexSum += index;
      }
    }

    return pairsInRightOrderIndexSum;
  }

  @override
  Object solvePartTwo(Iterable<String> lines) {
    const dividers = <String>{'[[2]]', '[[6]]'};

    final input = lines //
        .where((line) => line.trim().isNotEmpty)
        .followedBy(dividers)
        .map(jsonDecode)
        .toList()
      ..sort(process);

    int result = 1;

    for (int index = 0; index < input.length; ++index) {
      final packet = jsonEncode(input[index]);

      if (dividers.contains(packet)) {
        result *= index + 1;
      }
    }

    return result;
  }

  int process(dynamic left, dynamic right) {
    if (left is int) {
      if (right is int) {
        return left - right;
      }

      return process([left], right);
    }

    if (right is int) {
      return process(left, [right]);
    }

    final iterLeft = (left as List).iterator;
    final iterRight = (right as List).iterator;

    while (iterLeft.moveNext() && iterRight.moveNext()) {
      final result = process(iterLeft.current, iterRight.current);
      if (result == 0) continue;
      return result;
    }

    return left.length - right.length;
  }
}
