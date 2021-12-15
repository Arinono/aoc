import 'dart:math';

class Octopus {
  int energy;

  Octopus(this.energy);

  void increment() {
    energy++;
  }

  @override
  String toString() =>
      energy == 0 ? '\x1B[37m${energy.toString()}\x1B[0m' : energy.toString();
}

typedef OctopusesMap = Map<Point, Octopus>;

class Octopuses {
  late final int _size;
  late final OctopusesMap _map;
  final List<Point> _totalFlashed = List.empty(growable: true);

  Octopuses.from(List<List<int>> input) {
    final OctopusesMap map = {};
    _size = input.length;

    for (int y = 0; y < _size; y++) {
      final row = input.elementAt(y);
      for (int x = 0; x < row.length; x++) {
        final pt = Point(x, y);
        map[pt] = Octopus(row.elementAt(x));
      }
    }

    _map = map;
  }

  Set<Point> _flash(Set<Point> alreadyFlashed, Point octo) {
    if (!alreadyFlashed.contains(octo)) {
      final adj =
          adjacents(octo).where((pt) => !alreadyFlashed.contains(pt)).toSet();

      alreadyFlashed.add(octo);

      for (final _octo in adj) {
        _map[_octo]!.increment();
        if (_map[_octo]!.energy > 9) {
          _flash(alreadyFlashed, _octo);
        }
      }
    }

    return alreadyFlashed;
  }

  List<Point> flashFor({int step = 100}) {
    for (int i = 0; i < step; i++) {
      if (i % 10 == 0) {
        print('#$i\n$this');
      }
      for (final entry in _map.entries) {
        entry.value.increment();
      }
      for (final entry in _map.entries) {
        if (entry.value.energy > 9) {
          final flashed = _flash(<Point>{}, entry.key);
          _totalFlashed.addAll(flashed);
          for (var element in flashed) {
            _map[element]!.energy = 0;
          }
        }
      }
    }

    return _totalFlashed;
  }

  Set<Point> adjacents(Point pt) {
    Set<Point> adj = {};

    Point topLeft = Point(pt.x - 1, pt.y - 1);
    Point top = Point(pt.x, pt.y - 1);
    Point topRight = Point(pt.x + 1, pt.y - 1);

    Point left = Point(pt.x - 1, pt.y);
    Point right = Point(pt.x + 1, pt.y);

    Point botLeft = Point(pt.x - 1, pt.y + 1);
    Point bot = Point(pt.x, pt.y + 1);
    Point botRight = Point(pt.x + 1, pt.y + 1);

    for (final _pt in [
      topLeft,
      top,
      topRight,
      left,
      right,
      botLeft,
      bot,
      botRight,
    ]) {
      if (_map[_pt] != null) {
        adj.add(_pt);
      }
    }

    return adj;
  }

  Octopus at({required int x, required int y}) {
    assert(x >= 0 && x < 10 && y >= 0 && y < 10);
    return _map[Point(x, y)]!;
  }

  @override
  String toString() {
    String str = '';

    print(_size);

    for (int y = 0; y < _size; y++) {
      for (int x = 0; x < _size; x++) {
        str += _map[Point(x, y)]!.toString();
      }
      str += '\n';
    }

    return str;
  }
}
