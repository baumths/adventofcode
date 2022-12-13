import '../solution.dart' show Solution;

class DaySix implements Solution {
  @override
  Object solvePartOne(Iterable<String> lines) {
    return process(lines, packetSize: 4);
  }

  @override
  Object solvePartTwo(Iterable<String> lines) {
    return process(lines, packetSize: 14);
  }

  Object process(Iterable<String> lines, {required int packetSize}) {
    final results = <int>[];

    nextLine:
    for (final line in lines) {
      for (int i = 0; i < line.length - packetSize; ++i) {
        final sequence = line.substring(i, i + packetSize).split('').toSet();

        if (sequence.length == packetSize) {
          results.add(i + packetSize);
          continue nextLine;
        }
      }
    }

    return results.join(' ');
  }
}
