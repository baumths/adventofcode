import 'dart:math' as math;
import '../solution.dart' show Solution;

class DayFourteen implements Solution {
  @override
  Object solvePartOne(Iterable<String> lines) {
    int minWidth = 999;
    int maxWidth = 0;
    int minHeight = 999;
    int maxHeight = 0;

    final rocks = <Point>{};
    int fallenSand = 0;

    void updateConstraints(int x, int y) {
      minWidth = math.min(minWidth, x);
      maxWidth = math.max(maxWidth, x);
      minHeight = math.min(minHeight, y);
      maxHeight = math.max(maxHeight, y);
    }

    for (final line in lines) {
      final points = line //
          .split(' -> ')
          .map((coord) => coord.split(','))
          .map(Point.parse);

      // Orthogonal steps
      forEachPairIn(points, (p1, p2) {
        final delta = p2 - p1;
        final abs = delta.abs;
        final sign = delta.sign;

        Point p = Point(p1.x, p1.y);

        updateConstraints(p.x, p.y);
        rocks.add(p);

        for (int ix = 0, iy = 0; ix < abs.x || iy < abs.y;) {
          if ((1 + 2 * ix) * abs.y < (1 + 2 * iy) * abs.x) {
            p = Point(p.x + sign.x, p.y);
            ++ix;
          } else {
            p = Point(p.x, p.y + sign.y);
            ++iy;
          }

          updateConstraints(p.x, p.y);
          rocks.add(p);
        }
      });
    }

    final width = maxWidth - minWidth + 2; // +2 expand bounding box
    final height = maxHeight - minHeight + 5; // +5 to add a margin on top

    final grid = List.generate(height, (_) => List.generate(width, (_) => '.'));

    for (final point in rocks) {
      final x = point.x - minWidth;
      final y = point.y - minHeight + 4; // +4 to align at bottom
      grid[y][x] = '#';
    }

    final origin = Point(500 - minWidth, 1);
    Point current = origin;

    while (true) {
      final down = Point(current.x, current.y + 1);

      if (grid.isInBounds(down.x, down.y)) {
        if (grid.canFit(down)) {
          current = down;
          continue;
        }
      }

      final left = Point(current.x - 1, current.y + 1);

      if (grid.isInBounds(left.x, left.y)) {
        if (grid.canFit(left)) {
          current = left;
          continue;
        }
      } else {
        break; // abyss reached
      }

      final right = Point(current.x + 1, current.y + 1);

      if (grid.isInBounds(right.x, right.y)) {
        if (grid.canFit(right)) {
          current = right;
          continue;
        }
      }

      grid[current.y][current.x] = 'o';
      current = origin;

      fallenSand++;
    }

    return fallenSand;
  }

  @override
  Object solvePartTwo(Iterable<String> lines) {
    final blockedCoords = <Point>{};
    int abyss = 0;

    for (final line in lines) {
      final points = line //
          .split(' -> ')
          .map((coord) => coord.split(','))
          .map(Point.parse);

      // Orthogonal steps
      forEachPairIn(points, (p1, p2) {
        final delta = p2 - p1;
        final abs = delta.abs;
        final sign = delta.sign;

        Point p = Point(p1.x, p1.y);

        abyss = math.max(abyss, p.y);
        blockedCoords.add(p);

        for (int ix = 0, iy = 0; ix < abs.x || iy < abs.y;) {
          if ((1 + 2 * ix) * abs.y < (1 + 2 * iy) * abs.x) {
            p = Point(p.x + sign.x, p.y);
            ++ix;
          } else {
            p = Point(p.x, p.y + sign.y);
            ++iy;
          }

          abyss = math.max(abyss, p.y);
          blockedCoords.add(p);
        }
      });
    }

    abyss++;
    final origin = Point(500, 0);
    int fallenSand = 0;

    while (!blockedCoords.contains(origin)) {
      Point current = origin;

      while (true) {
        if (current.y >= abyss) {
          break;
        }

        final down = Point(current.x, current.y + 1);

        if (!blockedCoords.contains(down)) {
          current = down;
          continue;
        }

        final left = Point(current.x - 1, current.y + 1);

        if (!blockedCoords.contains(left)) {
          current = left;
          continue;
        }

        final right = Point(current.x + 1, current.y + 1);

        if (!blockedCoords.contains(right)) {
          current = right;
          continue;
        }

        break;
      }

      blockedCoords.add(current);
      fallenSand++;
    }

    return fallenSand;
  }
}

void forEachPairIn<T>(Iterable<T> iterable, void Function(T, T) cb) {
  if (iterable.isEmpty) return;

  final it = iterable.iterator;
  it.moveNext();

  T previous = it.current;

  while (it.moveNext()) {
    final current = it.current;
    cb(previous, current);
    previous = current;
  }
}

class Point {
  const Point(this.x, this.y);
  Point.parse(List<String> list) : this(int.parse(list[0]), int.parse(list[1]));

  final int x, y;

  Point operator -(Point other) => Point(x - other.x, y - other.y);

  Point get abs => Point(x.abs(), y.abs());
  Point get sign => Point(x.sign, y.sign);

  @override
  String toString() => '$x,$y';

  @override
  int get hashCode => Object.hash(x, y);

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Point && other.x == x && other.y == y;
  }
}

extension on List<List<Object>> {
  bool isInBounds(int x, int y) {
    return (0 <= y && y < length) && (0 <= x && x < first.length);
  }

  bool canFit(Point p) => !'#o'.contains(this[p.y][p.x].toString());
}
