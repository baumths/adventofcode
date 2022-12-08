import 'dart:io';

void main(Iterable<String> args) {
  if (args.isEmpty) {
    Solution.days.forEach(solve);
  } else {
    final String day = args.first;

    if (!Solution.days.keys.contains(day)) {
      print('Day not found: $day');
      exit(1);
    }

    solve(day, Solution.days[day]!);
  }
}

void solve(String day, Solution solution) {
  final StringBuffer buffer = StringBuffer();
  buffer.writeln('Day $day');

  Iterable<String> lines = readFile('$day/example.txt');

  buffer.writeln('├─ Example');
  buffer.writeln('│  ├─ Part 1: ${solution.solvePartOne(lines)}');
  buffer.writeln('│  └─ Part 2: ${solution.solvePartTwo(lines)}');

  lines = readFile('$day/input.txt');

  buffer.writeln('└─ Input');
  buffer.writeln('   ├─ Part 1: ${solution.solvePartOne(lines)}');
  buffer.writeln('   └─ Part 2: ${solution.solvePartTwo(lines)}');

  print(buffer.toString());
}

abstract class Solution {
  Object solvePartOne(Iterable<String> lines);
  Object solvePartTwo(Iterable<String> lines);

  static final Map<String, Solution> days = {};
}

Iterable<String> readFile(String path) {
  final String dir = Directory.current.path.split('/').last;
  if (dir == 'adventofcode') {
    path = '2022/$path';
  }

  try {
    return File(path).readAsLinesSync();
  } on FileSystemException catch (e) {
    print('Unable to open file: $path');
    print(e);
    exit(1);
  }
}
