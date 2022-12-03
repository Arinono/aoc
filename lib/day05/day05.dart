import 'dart:collection';

class Point {
  final int x;
  final int y;

  Point(this.x, this.y);

  @override
  String toString() {
    return '$x:$y';
  }
}

class ToEastLine extends Line {
  ToEastLine(Point start, Point end) : super(start, end);

  @override
  List<Point> get points {
    List<Point> points = List.empty(growable: true);

    for (int i = start.x; i != end.x + 1; i++) {
      points.add(
        Point(i, start.y),
      );
    }
    return points;
  }
}

class ToSouthLine extends Line {
  ToSouthLine(Point start, Point end) : super(start, end);

  @override
  List<Point> get points {
    List<Point> points = List.empty(growable: true);

    for (int i = start.y; i != end.y + 1; i++) {
      points.add(
        Point(start.x, i),
      );
    }
    return points;
  }
}

class ToWestLine extends Line {
  ToWestLine(Point start, Point end) : super(start, end);

  @override
  List<Point> get points {
    List<Point> points = List.empty(growable: true);

    for (int i = start.x; i != end.x - 1; i--) {
      points.add(
        Point(i, start.y),
      );
    }
    return points;
  }
}

class ToNorthLine extends Line {
  ToNorthLine(Point start, Point end) : super(start, end);

  @override
  List<Point> get points {
    List<Point> points = List.empty(growable: true);

    for (int i = start.y; i != end.y - 1; i--) {
      points.add(
        Point(start.x, i),
      );
    }
    return points;
  }
}

class ToSouthEastLine extends Line {
  ToSouthEastLine(Point start, Point end) : super(start, end);

  @override
  List<Point> get points {
    List<Point> points = List.empty(growable: true);

    int x = start.x;
    int y = start.y;

    while (x != end.x + 1 && y != end.y + 1) {
      points.add(Point(x, y));

      x++;
      y++;
    }

    return points;
  }
}

class ToSouthWestLine extends Line {
  ToSouthWestLine(Point start, Point end) : super(start, end);

  @override
  List<Point> get points {
    List<Point> points = List.empty(growable: true);

    int x = start.x;
    int y = start.y;

    while (x != end.x - 1 && y != end.y + 1) {
      points.add(Point(x, y));

      x--;
      y++;
    }

    return points;
  }
}

class ToNorthWestLine extends Line {
  ToNorthWestLine(Point start, Point end) : super(start, end);

  @override
  List<Point> get points {
    List<Point> points = List.empty(growable: true);

    int x = start.x;
    int y = start.y;

    while (x != end.x - 1 && y != end.y - 1) {
      points.add(Point(x, y));

      x--;
      y--;
    }

    return points;
  }
}

class ToNorthEastLine extends Line {
  ToNorthEastLine(Point start, Point end) : super(start, end);

  @override
  List<Point> get points {
    List<Point> points = List.empty(growable: true);

    int x = start.x;
    int y = start.y;

    while (x != end.x + 1 && y != end.y - 1) {
      points.add(Point(x, y));

      x++;
      y--;
    }

    return points;
  }
}

abstract class Line {
  final Point start;
  final Point end;

  Line(this.start, this.end);

  // This is trash
  factory Line.from(String input) {
    final List<String> parts = input.split(' -> ');
    assert(parts.length == 2);
    final List<int> s = parts.first.split(',').map((e) => e.toInt).toList();
    final List<int> e = parts.last.split(',').map((e) => e.toInt).toList();
    assert(s.length == 2 && e.length == 2);

    final isToEast =
        s.first != e.first && s.last == e.last && s.first < e.first;
    final isToSouth = s.first == e.first && s.last != e.last && s.last < e.last;
    final isToWest =
        s.first != e.first && s.last == e.last && s.first > e.first;
    final isToNorth = s.first == e.first && s.last != e.last && s.last > e.last;
    final isToSE = s.first != e.first &&
        s.last != e.last &&
        s.first < e.first &&
        s.last < e.last;
    final isToSW = s.first != e.first &&
        s.last != e.last &&
        s.first > e.first &&
        s.last < e.last;
    final isToNW = s.first != e.first &&
        s.last != e.last &&
        s.first > e.first &&
        s.last > e.last;
    final isToNE = s.first != e.first &&
        s.last != e.last &&
        s.first < e.first &&
        s.last > e.last;

    if (isToEast) {
      return ToEastLine(Point(s.first, s.last), Point(e.first, e.last));
    } else if (isToSouth) {
      return ToSouthLine(Point(s.first, s.last), Point(e.first, e.last));
    } else if (isToWest) {
      return ToWestLine(Point(s.first, s.last), Point(e.first, e.last));
    } else if (isToNorth) {
      return ToNorthLine(Point(s.first, s.last), Point(e.first, e.last));
    } else if (isToSE) {
      return ToSouthEastLine(Point(s.first, s.last), Point(e.first, e.last));
    } else if (isToSW) {
      return ToSouthWestLine(Point(s.first, s.last), Point(e.first, e.last));
    } else if (isToNW) {
      return ToNorthWestLine(Point(s.first, s.last), Point(e.first, e.last));
    } else if (isToNE) {
      return ToNorthEastLine(Point(s.first, s.last), Point(e.first, e.last));
    } else {
      throw UnknownLineDirectionException();
    }
  }

  List<Point> get points;
}

class Grid {
  final HashMap<String, int> _grid = HashMap();

  Grid(List<Line> lines) {
    for (final l in lines) {
      for (final pt in l.points) {
        if (_grid.containsKey(pt.toString())) {
          _grid[pt.toString()] = _grid[pt.toString()]! + 1;
        } else {
          _grid[pt.toString()] = 1;
        }
      }
    }
  }

  int at({required int x, required int y}) {
    return _grid[Point(x, y).toString()] ?? 0;
  }

  int get overlaps {
    int sum = 0;

    for (final v in _grid.values) {
      if (v > 1) {
        sum++;
      }
    }

    return sum;
  }

  @override
  String toString() {
    String str = '';

    for (final entry in _grid.entries) {
      str += '${entry.key.toString().padRight(2)} ${entry.value}\n';
    }

    return str;
  }
}

extension FilterLines on List<Line> {
  List<Line> filterBy({bool horizontal = false, bool vertical = false}) {
    final List<Line> lines = List.empty(growable: true);

    for (final line in this) {
      final bool isHorizontal =
          horizontal && (line is ToEastLine || line is ToWestLine);
      final bool isVertical =
          vertical && (line is ToSouthLine || line is ToNorthLine);

      if (isHorizontal || isVertical) {
        lines.add(line);
      }
    }

    return lines;
  }
}

extension StringsToLines on List<String> {
  List<Line> get toLines {
    return map((e) => Line.from(e)).toList();
  }
}

extension StrToInt on String {
  int get toInt {
    return int.parse(this);
  }
}

class UnknownLineDirectionException implements Exception {
  UnknownLineDirectionException();
}
