import '../solution.dart' show Solution;

class DayNine implements Solution {
  @override
  Object solvePartOne(Iterable<String> lines) {
    var head = Offset.zero;
    var tail = Offset.zero;

    final visited = <String>{tail.toString()};

    for (final line in lines) {
      final instructions = line.split(' ');
      final steps = int.parse(instructions[1]);
      final delta = Offset.delta(instructions[0]);

      for (int step = 0; step < steps; ++step) {
        head += delta;

        final distance = head - tail;

        if (distance.x.abs() > 1 || distance.y.abs() > 1) {
          tail += distance.sign;
          visited.add(tail.toString());
        }
      }
    }

    return visited.length;
  }

  @override
  Object solvePartTwo(Iterable<String> lines) {
    final rope = List.generate(10, (_) => Offset.zero);

    final visited = <String>{Offset.zero.toString()};

    for (final line in lines) {
      final instructions = line.split(' ');
      final steps = int.parse(instructions[1]);
      final delta = Offset.delta(instructions[0]);

      for (int step = 0; step < steps; ++step) {
        rope[0] += delta;

        var head = 0;
        var tail = 1;

        while (tail < rope.length) {
          final distance = rope[head] - rope[tail];

          if (distance.x.abs() > 1 || distance.y.abs() > 1) {
            rope[tail] += distance.sign;

            if (tail == rope.length - 1) {
              visited.add(rope[tail].toString());
            }
          }

          head = tail++;
        }
      }
    }

    return visited.length;
  }
}

class Offset {
  static const zero = Offset(0, 0);

  const Offset(this.x, this.y);
  final int x, y;

  Offset operator +(Offset other) => Offset(x + other.x, y + other.y);
  Offset operator -(Offset other) => Offset(x - other.x, y - other.y);
  Offset get sign => Offset(x.sign, y.sign);

  @override
  String toString() => '$x,$y';

  static Offset delta(String direction) {
    return {
      'L': Offset(-1, 0),
      'U': Offset(0, 1),
      'R': Offset(1, 0),
      'D': Offset(0, -1),
    }[direction]!;
  }
}
