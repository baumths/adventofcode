import '../solution.dart' show Solution;

class DaySeven implements Solution {
  @override
  Object solvePartOne(Iterable<String> lines) {
    return parse(lines)
        .allDescendantDirectories
        .map(recursivelyCalculateDirectorySize)
        .where((size) => size <= 100000)
        .reduce((sum, size) => sum + size);
  }

  @override
  Object solvePartTwo(Iterable<String> lines) {
    const totalDiskSpace = 70000000;
    const requiredDiskSpace = 30000000;

    final root = parse(lines);
    final usedDiskSpace = recursivelyCalculateDirectorySize(root);
    final spaceToFree = requiredDiskSpace - (totalDiskSpace - usedDiskSpace);

    final candidateDirectories = root.allDescendantDirectories
        .map(recursivelyCalculateDirectorySize)
        .where((size) => size >= spaceToFree)
        .toList()
      ..sort();

    return candidateDirectories.first;
  }

  int recursivelyCalculateDirectorySize(Node node) {
    int total = node.size;

    for (final child in node.children) {
      total += recursivelyCalculateDirectorySize(child);
    }

    return total;
  }

  Node parse(Iterable<String> lines) {
    final root = Node(name: '/', size: 0);
    Node cwd = root;

    for (final line in lines.skip(1)) {
      final words = line.split(' ');

      if (line.startsWith(r'$')) {
        final cmd = words[1];

        if (cmd == 'cd') {
          final dir = words[2];

          if (dir == '..') {
            cwd = cwd.parent ?? root;
          } else {
            cwd = cwd.children.singleWhere((child) => child.name == dir);
          }
        }
      } else {
        cwd.addChild(
          Node(
            size: int.tryParse(words[0]),
            name: words[1],
          ),
        );
      }
    }

    return root;
  }
}

class Node {
  static const defaultDirectorySize = 0;

  Node({
    int? size,
    required this.name,
  })  : isDirectory = size == null,
        size = size ?? Node.defaultDirectorySize;

  final int size;
  final String name;
  final bool isDirectory;

  Node? parent;
  final List<Node> children = [];

  void addChild(Node child) {
    children.add(child);
    child.parent = this;
  }

  Iterable<Node> get allDescendantDirectories sync* {
    for (final child in children) {
      if (child.isDirectory) yield child;
      yield* child.allDescendantDirectories;
    }
  }
}
