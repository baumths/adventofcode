import 'dart:io';

import 'days.dart' show days;
import 'solution.dart' show Solution;

void main(Iterable<String> args) {
  if (args.isEmpty) {
    days.forEach(solve);
  } else {
    final String day = args.first;

    if (!days.keys.contains(day)) {
      print('Day not found: $day');
      exit(1);
    }

    solve(day, days[day]!);
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

Iterable<String> readFile(String path) {
  final String dir = Directory.current.path.split('/').last;
  if (dir == 'adventofcode') {
    path = '2022/$path';
  }

  try {
    return File(path).readAsLinesSync();
  } on FileSystemException {
    print('Unable to open file: $path');
    exit(1);
  }
}
