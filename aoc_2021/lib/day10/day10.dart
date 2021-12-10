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

      switch (c) {
        case '(':
          _stack.push(Parenthesis());
          _validClosing = Parenthesis();
          break;
        case '[':
          _stack.push(Bracket());
          _validClosing = Bracket();
          break;
        case '{':
          _stack.push(Curly());
          _validClosing = Curly();
          break;
        case '<':
          _stack.push(Chevron());
          _validClosing = Chevron();
          break;
        case ')':
          if (_validClosing is Parenthesis) {
            _stack.pop();
            _validClosing = _stack.top();
            break;
          }
          throw CorruptedLineError(_validClosing!, Parenthesis());
        case ']':
          if (_validClosing is Bracket) {
            _stack.pop();
            _validClosing = _stack.top();
            break;
          }
          throw CorruptedLineError(_validClosing!, Bracket());
        case '}':
          if (_validClosing is Curly) {
            _stack.pop();
            _validClosing = _stack.top();
            break;
          }
          throw CorruptedLineError(_validClosing!, Curly());
        case '>':
          if (_validClosing is Chevron) {
            _stack.pop();
            _validClosing = _stack.top();
            break;
          }
          throw CorruptedLineError(_validClosing!, Chevron());
        default:
          throw 'Invalid char'; // unreachable
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
