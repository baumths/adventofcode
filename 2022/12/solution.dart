import '../solution.dart' show Solution;

final asciiStart = 'a'.codeUnitAt(0);
final asciiEnd = 'z'.codeUnitAt(0);

class DayTwelve implements Solution {
  @override
  Object solvePartOne(Iterable<String> lines) {
    return process(
      lines.toList(),
      calculateDistanceIncrement: (Node node) => node.distance + 1,
    );
  }

  @override
  Object solvePartTwo(Iterable<String> lines) {
    return process(
      lines.toList(),
      calculateDistanceIncrement: (Node node) {
        return node.elevation == 0 ? 0 : node.distance + 1;
      },
    );
  }

  Object process(
    List<String> lines, {
    required int Function(Node) calculateDistanceIncrement,
  }) {
    final List<List<Node>> grid = List.generate(
      lines.length,
      (_) => List.generate(lines.first.length, (_) => Node.placeholder),
    );

    late final Node start, end;

    for (int row = 0; row < lines.length; ++row) {
      for (int col = 0; col < lines.first.length; ++col) {
        late final Node node;
        final char = lines[row][col];

        if (char == 'S') {
          node = Node(row, col, asciiStart - asciiStart);
          start = node;
        } else if (char == 'E') {
          node = Node(row, col, asciiEnd - asciiStart);
          end = node;
        } else {
          node = Node(row, col, char.codeUnitAt(0) - asciiStart);
        }

        grid[row][col] = node;
      }
    }

    final queue = <Node>[start];
    final visited = <String>{};

    while (queue.isNotEmpty) {
      final current = queue.removeAt(0);

      for (final edge in grid.getEdges(current.row, current.col)) {
        if (edge.elevation - current.elevation > 1) {
          continue;
        }

        if (visited.contains(edge.coord)) {
          continue;
        }

        edge.distance = calculateDistanceIncrement(current);
        visited.add(edge.coord);
        queue.add(edge);
      }
    }

    return end.distance;
  }
}

extension on List<List<Node>> {
  bool isInBounds(int row, int col) {
    return (0 <= row && row < length) && (0 <= col && col < first.length);
  }

  List<Node> getEdges(int row, int col) {
    return [
      if (isInBounds(row + 1, col)) this[row + 1][col],
      if (isInBounds(row, col + 1)) this[row][col + 1],
      if (isInBounds(row - 1, col)) this[row - 1][col],
      if (isInBounds(row, col - 1)) this[row][col - 1],
    ];
  }
}

class Node {
  static final placeholder = Node(-1, -1, -1);

  Node(this.row, this.col, this.elevation);

  final int row, col;
  final int elevation;

  String get coord => '$row,$col';

  int distance = 0;

  @override
  String toString() => coord;
}
