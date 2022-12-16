import '../solution.dart' show Solution;

class DayTen implements Solution {
  @override
  Object solvePartOne(Iterable<String> lines) {
    final clock = PartOneClock();
    process(lines, clock);
    return clock.signalStrength;
  }

  @override
  Object solvePartTwo(Iterable<String> lines) {
    final clock = PartTwoClock();
    process(lines, clock);
    return clock.dumpCrt();
  }

  void process(Iterable<String> lines, Clock clock) {
    for (final line in lines) {
      final instructions = line.split(' ');

      switch (instructions[0]) {
        case 'noop':
          clock.noop();
          break;
        case 'addx':
          clock.addx(int.parse(instructions[1]));
          break;
        default:
          throw Exception('unknown instruction ${instructions[0]}');
      }
    }
  }
}

abstract class Clock {
  int cycle = 0;
  int x = 1;

  void addx(int x) {
    nextCycle();
    nextCycle();
    this.x += x;
  }

  void noop() {
    nextCycle();
  }

  void nextCycle() {
    cycle++;
  }
}

class PartOneClock extends Clock {
  int signalStrength = 0;

  @override
  void nextCycle() {
    super.nextCycle();
    maybeUpdateSignalStrength();
  }

  void maybeUpdateSignalStrength() {
    if ((cycle - 20) % 40 == 0) {
      signalStrength += cycle * x;
    }
  }
}

class PartTwoClock extends Clock {
  static const crtSize = 40 * 6;
  final List<int> crt = List.generate(crtSize, (_) => 0);

  @override
  void nextCycle() {
    drawPixel();
    super.nextCycle();
  }

  void drawPixel() {
    final cycleOffset = cycle % 40;

    if (x - 1 <= cycleOffset && cycleOffset <= x + 1) {
      crt[cycle] = 1;
    }
  }

  String dumpCrt() {
    final buf = StringBuffer()
      ..writeln('CRT Dump ↓')
      ..writeln('-' * 40);

    for (int sprite = 0; sprite < crt.length; sprite++) {
      if (sprite >= 40 && sprite % 40 == 0) {
        buf.writeln();
      }

      buf.write(crt[sprite] == 1 ? '#' : '.');
    }

    buf
      ..writeln()
      ..write('-' * 40);

    return buf.toString();
  }
}
