import '../solution.dart' show Solution;

final numberRegex = RegExp(r'\d+');

class DayEleven implements Solution {
  @override
  Object solvePartOne(Iterable<String> lines) {
    final keepAway = KeepAway()
      ..parseMonkeys(lines.toList())
      ..play(20, (int worryLevel) => (worryLevel / 3).floor());

    return keepAway.monkeyBusiness;
  }

  @override
  Object solvePartTwo(Iterable<String> lines) {
    final keepAway = KeepAway()..parseMonkeys(lines.toList());

    late final commonDenominator = keepAway.monkeys
        .map((m) => m.denominator)
        .reduce((total, denominator) => total * denominator);

    keepAway.play(10000, (int worryLevel) => worryLevel % commonDenominator);

    return keepAway.monkeyBusiness;
  }
}

class KeepAway {
  final List<Monkey> monkeys = [];

  int get monkeyBusiness {
    final inspections = monkeys.map((m) => m.inspections).toList();
    inspections.sort((a, b) => b.compareTo(a));

    return inspections
        .take(2)
        .reduce((total, inspections) => total * inspections);
  }

  void play(int rounds, int Function(int worryLevel) reduceWorryLevel) {
    for (int round = 0; round < rounds; ++round) {
      for (final monkey in monkeys) {
        while (monkey.items.isNotEmpty) {
          final item = monkey.items.removeAt(0);

          final worryLevel = reduceWorryLevel(monkey.inspect(item));

          final nextMonkey = monkey.getNextMonkeyFromWorryLevel(worryLevel);
          monkeys[nextMonkey].items.add(worryLevel);
        }
      }
    }
  }

  void parseMonkeys(List<String> lines) {
    int index = 0;

    while (index < lines.length) {
      index++; // monkey id

      final items = numberRegex
          .allMatches(lines[index++])
          .map((m) => int.parse(m.group(0)!))
          .toList();

      final operation = lines[index++].split('=').last.trim().split(' ');

      final test = numberRegex.allMatches(lines[index++]).first.group(0)!;
      final ifTrue = numberRegex.allMatches(lines[index++]).first.group(0)!;
      final ifFalse = numberRegex.allMatches(lines[index++]).first.group(0)!;

      final monkey = Monkey(
        items: items,
        operation: operation,
        denominator: int.parse(test),
        ifTrue: int.parse(ifTrue),
        ifFalse: int.parse(ifFalse),
      );

      monkeys.add(monkey);
      index++; // blank line
    }
  }
}

class Monkey {
  Monkey({
    required this.items,
    required this.operation,
    required this.denominator,
    required this.ifTrue,
    required this.ifFalse,
  });

  final List<int> items;
  final List<String> operation;
  final int denominator;
  final int ifTrue;
  final int ifFalse;

  int inspections = 0;

  int getNextMonkeyFromWorryLevel(int worryLevel) {
    return worryLevel % denominator == 0 ? ifTrue : ifFalse;
  }

  int inspect(int item) {
    inspections++;

    final left = int.tryParse(operation[0]) ?? item;
    final operand = operation[1];
    final right = int.tryParse(operation[2]) ?? item;

    switch (operand) {
      case '+':
        return left + right;
      case '*':
        return left * right;
      default:
        throw Exception('unknown operand: $operand');
    }
  }
}
