class UnderwaterPosition {
  int depth = 0;
  int horizon = 0;

  UnderwaterPosition();
  UnderwaterPosition.from({required this.depth, required this.horizon});

  @override
  String toString() {
    return '$horizon:$depth';
  }
}

class Forward extends Direction {
  Forward(int by) : super(by);

  @override
  UnderwaterPosition moveFrom(UnderwaterPosition start) {
    return UnderwaterPosition.from(
      depth: start.depth,
      horizon: start.horizon + by,
    );
  }
}

class Up extends Direction {
  Up(int by) : super(by);

  @override
  UnderwaterPosition moveFrom(UnderwaterPosition start) {
    if (start.depth - by < 0) {
      throw SubmarineCannotFlyException();
    }

    return UnderwaterPosition.from(
      depth: start.depth - by,
      horizon: start.horizon,
    );
  }
}

class Down extends Direction {
  Down(int by) : super(by);

  @override
  UnderwaterPosition moveFrom(UnderwaterPosition start) {
    return UnderwaterPosition.from(
      depth: start.depth + by,
      horizon: start.horizon,
    );
  }
}

abstract class Direction {
  final int by;
  Direction(this.by);

  UnderwaterPosition moveFrom(UnderwaterPosition start);

  factory Direction.from(String op) {
    final opL = op.split(' ');
    assert(opL.length == 2);

    int by;
    try {
      by = int.parse(opL.last, radix: 10);
    } catch (e) {
      throw SubmarineOperationFormatException();
    }

    switch (opL.first) {
      case 'up':
        return Up(by);
      case 'down':
        return Down(by);
      case 'forward':
        return Forward(by);
      default:
        throw SubmarineOperationFormatException();
    }
  }
}

class Submarine {
  UnderwaterPosition _pos = UnderwaterPosition();

  void move(Direction direction) {
    try {
      _pos = direction.moveFrom(_pos);
    } on SubmarineCannotFlyException {
      rethrow;
    }
  }

  void moveMultipleTimes(List<Direction> directions) {
    for (final direction in directions) {
      move(direction);
    }
  }

  int get depth {
    return _pos.depth;
  }

  int get horizon {
    return _pos.horizon;
  }

  @override
  String toString() {
    return '$horizon:$depth';
  }
}

class SubmarineCannotFlyException implements Exception {
  SubmarineCannotFlyException();
}

class SubmarineOperationFormatException implements Exception {
  SubmarineOperationFormatException();
}
