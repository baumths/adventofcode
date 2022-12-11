part of '../solutions.dart';

const alphabet = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';

extension on String {
  int get priority {
    assert(alphabet.contains(this));
    return alphabet.indexOf(this) + 1;
  }
}

class DayThree implements Solution {
  @override
  Object solvePartOne(Iterable<String> lines) {
    int total = 0;

    for (final line in lines) {
      final firstCompartment = <String>{};
      final secondCompartment = <String>{};

      final size = line.length;

      for (int i = 0; i < size / 2; ++i) {
        firstCompartment.add(line[i]);
        secondCompartment.add(line[size - (i + 1)]);
      }

      final commonLetters = firstCompartment.intersection(secondCompartment);
      if (commonLetters.isEmpty) continue;

      total += commonLetters
          .map((letter) => letter.priority)
          .reduce((sum, priority) => sum + priority);
    }

    return total;
  }

  @override
  Object solvePartTwo(Iterable<String> lines) {
    int total = 0;

    for (int i = 0; i < lines.length; i += 3) {
      final first = lines.elementAt(i).split('').toSet();
      final second = lines.elementAt(i + 1).split('').toSet();
      final third = lines.elementAt(i + 2).split('').toSet();

      final commonLetter = first.intersection(second).intersection(third);
      total += commonLetter.single.priority;
    }

    return total;
  }
}
