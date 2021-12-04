class MarkedGridNumber extends GridNumber {
  MarkedGridNumber(int number) : super(number);

  @override
  String toString() {
    return '\x1B[32m${number.toString().padLeft(2)}\x1B[37m';
  }
}

class UnmarkedGridNumber extends GridNumber {
  UnmarkedGridNumber(int number) : super(number);

  @override
  String toString() {
    return '\x1B[31m${number.toString().padLeft(2)}\x1B[37m';
  }
}

abstract class GridNumber {
  final int number;

  GridNumber(this.number);
}

class Grid {
  late List<List<GridNumber>> _numbers;
  late int _lastNumber;

  Grid(this._numbers);

  Grid.unmarked(List<List<int>> numbers) {
    _numbers = numbers
        .map((e) => e.map((f) => UnmarkedGridNumber(f)).toList())
        .toList();
  }

  Grid.fromRaw(String input) {
    final List<String> rows = input.split('\n').discardEmpty();
    List<List<GridNumber>> _tempNumbers = List.empty(growable: true);

    for (int y = 0; y < rows.length; y++) {
      _tempNumbers.add(List.empty(growable: true));
      final List<String> row = rows.elementAt(y).split(RegExp(r"\s"));
      for (int x = 0; x < row.length; x++) {
        if (row.elementAt(x).isNotEmpty) {
          _tempNumbers
              .elementAt(y)
              .add(UnmarkedGridNumber(row.elementAt(x).toInt));
        }
      }
    }

    _numbers = List.from(_tempNumbers);
  }

  bool get hasWon {
    for (final row in _numbers) {
      if (row.every((number) => number.runtimeType == MarkedGridNumber)) {
        return true;
      }
    }
    for (int i = 0; i < _numbers.first.length; i++) {
      final col = _numbers.map((e) => e.elementAt(i));
      if (col.every((number) => number.runtimeType == MarkedGridNumber)) {
        return true;
      }
    }
    return false;
  }

  void mark(int number) {
    _lastNumber = number;
    for (int y = 0; y < _numbers.length; y++) {
      final row = _numbers.elementAt(y);
      for (int x = 0; x < row.length; x++) {
        final n = row.elementAt(x);
        if (n.runtimeType == UnmarkedGridNumber && n.number == number) {
          _numbers[y][x] = MarkedGridNumber(n.number);
        }
      }
    }
  }

  int get score {
    int score = 0;

    for (final row in _numbers) {
      for (final n in row) {
        if (n.runtimeType == UnmarkedGridNumber) {
          score += n.number;
        }
      }
    }

    return score * _lastNumber;
  }

  GridNumber at({required int y, required int x}) {
    return _numbers.elementAt(y).elementAt(x);
  }

  @override
  String toString() {
    String str = '';

    for (final row in _numbers) {
      for (final n in row) {
        str += '${n.toString()} ';
      }
      str += '\n';
    }

    return str;
  }
}

class Bingo {
  late final List<int> _numbers;
  late final List<Grid> _grids;

  Bingo.fromRaw(String input) {
    final List<String> sections = input.split('\n\n');

    if (sections.isEmpty) {
      throw BingoEmptyInputException();
    }

    _numbers = List.from(sections.first.split(',').map((n) => n.toInt));
    sections.removeAt(0);

    _grids = List.from(sections.map((g) => Grid.fromRaw(g)));
  }

  void play(int number) {
    for (Grid grid in _grids) {
      grid.mark(number);
    }
  }

  int? get _winningGrid {
    for (int i = 0; i < _grids.length; i++) {
      if (_grids.elementAt(i).hasWon) {
        return i;
      }
    }
  }

  int? playAll() {
    for (final n in _numbers) {
      for (Grid grid in _grids) {
        grid.mark(n);
        if (_winningGrid != null) {
          return _winningGrid!;
        }
      }
    }
  }

  List<int> get numbers {
    return _numbers;
  }

  List<Grid> get grids {
    return _grids;
  }

  @override
  String toString() {
    String str = '';

    for (final grid in _grids) {
      str += '${grid.toString()}\n';
    }

    return str;
  }
}

extension StringToInt on String {
  int get toInt {
    return int.parse(this);
  }
}

extension DiscardEmptyString on List<String> {
  List<String> discardEmpty() {
    final List<String> strs = List.empty(growable: true);

    for (final str in this) {
      if (str.isNotEmpty) {
        strs.add(str);
      }
    }

    return strs;
  }
}

class BingoEmptyInputException implements Exception {
  BingoEmptyInputException();
}
