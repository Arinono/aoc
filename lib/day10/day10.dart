import 'package:aoc_2021/utils/stack.dart';

class Parenthesis extends Char {
  Parenthesis() : super(3, 1);

  @override
  String toString() => '()';
}

class Bracket extends Char {
  Bracket() : super(57, 2);

  @override
  String toString() => '[]';
}

class Curly extends Char {
  Curly() : super(1197, 3);

  @override
  String toString() => '{}';
}

class Chevron extends Char {
  Chevron() : super(25137, 4);

  @override
  String toString() => '<>';
}

abstract class Char {
  final int syntaxErrorPoints;
  final int autocompletePoints;

  Char(this.syntaxErrorPoints, this.autocompletePoints);

  factory Char.from(String c) {
    assert(c.length == 1);
    switch (c) {
      case '(':
      case ')':
        return Parenthesis();
      case '[':
      case ']':
        return Bracket();
      case '{':
      case '}':
        return Curly();
      case '<':
      case '>':
        return Chevron();
      default:
        throw 'unreachable';
    }
  }
}

class Instructions {
  final List<String> _lines;
  Stack<Char> _stack = Stack();
  Char? _validClosing;

  Instructions.from(this._lines);

  int get syntaxErrorScore {
    int score = 0;

    for (final l in _lines) {
      if (l.isEmpty) continue;

      try {
        _parseLine(l);
      } on CorruptedLineError catch (e) {
        score += e.received.syntaxErrorPoints;
        _stack = Stack();
      } on IncompleteLineError {
        _stack = Stack();
      } catch (e) {
        rethrow;
      }
    }

    return score;
  }

  int get autocompleteScore {
    final List<BigInt> scores = List.empty(growable: true);

    for (final l in _lines) {
      BigInt score = BigInt.from(0);
      if (l.isEmpty) continue;

      try {
        _parseLine(l);
      } on CorruptedLineError {
        // discard
        _stack = Stack();
      } on IncompleteLineError {
        while (_stack.isNotEmpty) {
          final missing = _stack.pop();
          if (missing != null) {
            score *= BigInt.from(5);
            score += BigInt.from(missing.autocompletePoints);
          }
        }
        scores.add(score);
      } catch (e) {
        rethrow;
      }
    }

    scores.sort();

    return scores.elementAt((scores.length / 2).truncate()).toInt();
  }

  void _parseLine(String line) {
    for (final c in line.split('')) {
      if (_stack.isEmpty && [')]>}'].contains(c)) {
        throw InvalidStartLineError();
      }

      final char = Char.from(c);

      if (['(', '[', '{', '<'].contains(c)) {
        _stack.push(char);
        _validClosing = char;
        continue;
      }

      if ([')', ']', '}', '>'].contains(c)) {
        if (_validClosing.runtimeType == char.runtimeType) {
          _stack.pop();
          _validClosing = _stack.top();
          continue;
        }
        throw CorruptedLineError(_validClosing!, char);
      }
    }

    if (_stack.isNotEmpty) {
      throw IncompleteLineError();
    }
  }
}

class IncompleteLineError implements Exception {
  IncompleteLineError();
}

class InvalidStartLineError implements Exception {
  InvalidStartLineError();
}

class CorruptedLineError implements Exception {
  final Char excepted;
  final Char received;

  CorruptedLineError(this.excepted, this.received);
}
