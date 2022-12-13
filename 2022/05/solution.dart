import '../solution.dart' show Solution;

const inputLetterOffset = 4;

final bracketsRegex = RegExp(r'\[(.*?)\]');
final onlyLettersRegex = RegExp(r'[a-zA-Z]+');
final onlyNumbersRegex = RegExp(r'[0-9]+');

class DayFive implements Solution {
  @override
  Object solvePartOne(Iterable<String> lines) {
    return process(lines, keepCratesOrder: false);
  }

  @override
  Object solvePartTwo(Iterable<String> lines) {
    return process(lines, keepCratesOrder: true);
  }

  Object process(Iterable<String> lines, {required bool keepCratesOrder}) {
    // will traverse the input in parts
    final List<String> inputLines = lines.toList();
    final List<String> stacks = [];

    String currentLine = inputLines.removeAt(0);

    // get the lines with crates
    while (bracketsRegex.hasMatch(currentLine)) {
      stacks.add(currentLine);
      currentLine = inputLines.removeAt(0);
    }
    // by now, `currentLine` holds the line that describes the stacks indices

    assert(
      stacks.length == currentLine.replaceAll(' ', '').split('').last,
      'ensure the number of stacks collected is the same as in the line that '
      'comes after the stacks grid.',
    );

    // remove the blank line that comes before the move commands
    inputLines.removeAt(0);

    List<List<String>> crateStacks = List.generate(
      stacks.length + 1,
      (_) => [],
    );

    for (int i = 0; i < stacks.length; ++i) {
      final stack = stacks[i];
      final crates = stack.split('');

      for (int j = 1; j < crates.length; j += inputLetterOffset) {
        final crate = crates[j];

        if (onlyLettersRegex.hasMatch(crate)) {
          crateStacks[(j / inputLetterOffset).round()].add(crate);
        }
      }
    }

    for (final line in inputLines) {
      final input = line
          .split(' ')
          .where(onlyNumbersRegex.hasMatch)
          .map(int.parse)
          .toList();

      final count = input[0];
      final from = input[1];
      final to = input[2];

      final fromStack = crateStacks[from - 1];
      final toStack = crateStacks[to - 1];

      int slot = 0;

      for (int i = 0; i < count; ++i) {
        final crate = fromStack.removeAt(0);
        toStack.insert(slot, crate);

        if (keepCratesOrder) {
          slot++;
        }
      }
    }

    return crateStacks.map((e) => e.isEmpty ? '' : e.first).join('');
  }
}
