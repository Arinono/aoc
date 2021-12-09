import 'dart:math';

class Low extends LocStatus {
  Low(int value) : super(value);
}

class NotLow extends LocStatus {
  NotLow(int value) : super(value);
}

abstract class LocStatus {
  late final int value;

  LocStatus(this.value);
}

class Heightmap {
  late final Map<Point, int> _map;

  Heightmap.from(List<List<int>> input) {
    _map = {};

    for (int y = 0; y < input.length; y++) {
      final List<int> row = input.elementAt(y);
      for (int x = 0; x < row.length; x++) {
        _map[Point(x, y)] = row.elementAt(x);
      }
    }
  }

  Set<Point> adjacents({required int x, required int y}) {
    final Set<Point> adj = {};

    final Point top = Point(x, y - 1);
    final Point left = Point(x - 1, y);
    final Point bot = Point(x, y + 1);
    final Point right = Point(x + 1, y);

    for (final Point pt in List.of([top, left, bot, right])) {
      if (_map[pt] != null) {
        adj.add(pt);
      }
    }

    return adj;
  }

  int atPoint(Point pt) {
    final int? value = _map[pt];
    assert(value != null);
    return value!;
  }

  List<int> atPoints(Set<Point> pts) {
    final List<int> values = List.empty(growable: true);
    for (final pt in pts) {
      values.add(atPoint(pt));
    }
    return values;
  }

  LocStatus status(Point pt) {
    assert(_map[pt] != null);
    final int height = _map[pt]!;
    final Set<Point> adj = adjacents(x: pt.x as int, y: pt.y as int);

    return adj.every((value) => height < _map[value]!)
        ? Low(height)
        : NotLow(height);
  }

  Set<Point> get lowPoints {
    final Set<Point> lows = {};

    for (final key in _map.keys) {
      if (status(key) is Low) {
        lows.add(key);
      }
    }

    return lows;
  }

  Set<Point> _basinsFrom(Set<Point> pts, Point pt) {
    final Set<Point> adj = adjacents(x: pt.x as int, y: pt.y as int)
        .where((_pt) => _map[_pt]! != 9) // remove nines
        .where((_pt) => !pts.contains(_pt)) //  remove already done
        .toSet();

    for (final _pt in adj) {
      pts.addAll(_basinsFrom({...pts, _pt}, _pt));
    }

    return pts;
  }

  List<Set<Point>> get basins {
    List<Set<Point>> basins = List.empty(growable: true);

    for (final low in lowPoints) {
      basins.add(_basinsFrom(<Point>{low}, low));
    }

    return basins;
  }

  int riskLevel(Set<Point> pts) {
    return pts.fold(
      0,
      (previousValue, element) => previousValue + (_map[element]! + 1),
    );
  }

  int basinsSize(List<Set<Point>> basins) {
    final basinsCopy = basins.toList()
      ..sort((a, b) => b.length.compareTo(a.length));

    return basinsCopy.getRange(1, 3).fold(
        basinsCopy.first.length, (value, element) => value * element.length);
  }
}
