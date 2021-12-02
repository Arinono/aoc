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
  UnderwaterPosition move({
    required UnderwaterPosition start,
    int? towards,
  }) {
    final int depth =
        towards != null ? start.depth + towards * by : start.depth;

    if (depth < 0) {
      throw SubmarineCannotFlyException();
    }

    return UnderwaterPosition.from(
      depth: depth,
      horizon: start.horizon + by,
    );
  }
}

class Up extends Direction {
  Up(int by) : super(by);

  @override
  UnderwaterPosition move({
    required UnderwaterPosition start,
    int? towards,
  }) {
    if (towards != null) {
      return UnderwaterPosition.from(
          horizon: start.horizon, depth: start.depth);
    } else {
      if (start.depth - by < 0) {
        throw SubmarineCannotFlyException();
      }

      return UnderwaterPosition.from(
        depth: start.depth - by,
        horizon: start.horizon,
      );
    }
  }
}

class Down extends Direction {
  Down(int by) : super(by);

  @override
  UnderwaterPosition move({
    required UnderwaterPosition start,
    int? towards,
  }) {
    return towards != null
        ? UnderwaterPosition.from(horizon: start.horizon, depth: start.depth)
        : UnderwaterPosition.from(
            depth: start.depth + by,
            horizon: start.horizon,
          );
  }
}

abstract class Direction {
  final int by;
  Direction(this.by);

  UnderwaterPosition move({
    required UnderwaterPosition start,
    int towards,
  });

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
  int _aim = 0;
  late final bool _aimEnabled;

  Submarine() {
    _aimEnabled = false;
  }
  Submarine.withAim() {
    _aimEnabled = true;
  }
  Submarine.from({
    bool aimEnabled = false,
    int depth = 0,
    int horizon = 0,
    int aim = 0,
  }) {
    _aimEnabled = aimEnabled;
    _aim = aim;
    _pos = UnderwaterPosition.from(depth: depth, horizon: horizon);
  }

  void move(Direction direction) {
    if (_aimEnabled) {
      switch (direction.runtimeType) {
        case Up:
          _aim -= direction.by;
          break;
        case Down:
          _aim += direction.by;
          break;
      }
    }

    try {
      _pos = _aimEnabled
          ? direction.move(start: _pos, towards: aim)
          : direction.move(start: _pos);
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

  int get aim {
    if (_aimEnabled) {
      return _aim;
    }
    throw SubmarineAimNotEnabledException();
  }

  @override
  String toString() {
    return _aimEnabled ? '->$aim:$horizon:$depth' : '$horizon:$depth';
  }
}

class SubmarineCannotFlyException implements Exception {
  SubmarineCannotFlyException();
}

class SubmarineOperationFormatException implements Exception {
  SubmarineOperationFormatException();
}

class SubmarineAimNotEnabledException implements Exception {
  SubmarineAimNotEnabledException();
}
