import 'package:aoc_2021/utils/pair.dart';

typedef Digits = Set<String>;
typedef Signals = List<Digits>;
typedef Outputs = List<Digits>;
typedef Entries = List<Pair<Signals, Outputs>>;

class Notes {
  late final Entries _entries;
  late final List<Map<Set<String>, int>> _signals;

  Notes.from(List<String> input) {
    _entries = List.of(input.map((l) {
      final sides = l.split(' | ').map((s) => s.split(' ')).toList();
      return Pair(
        sides.first.map(_strToCharSet).toList(),
        sides.last.map(_strToCharSet).toList(),
      );
    }));

    _signals = _getSignals();
  }

  Set<String> _strToCharSet(String s) {
    return s.split('').toSet();
  }

  Map<Set<String>, int> __signals(Signals input) {
    final Map<Set<String>, int?> signals = {};
    final Map<int, Set<String>> transposedSignals = {};

    for (final d in input) {
      try {
        signals[d] = _unambiguous(d);
        transposedSignals[_unambiguous(d)] = d;
      } catch (e) {
        signals[d] = null;
      }
    }

    final Map<Set<String>, int?> copy = Map.of(signals)
      ..removeWhere((_, v) => v != null);

    for (final k in copy.keys.where((k) => k.length == 5)) {
      if (k.intersection(transposedSignals[1]!).length == 2) {
        signals[k] = 3;
      } else if (k.intersection(transposedSignals[4]!).length == 2) {
        signals[k] = 2;
      } else {
        signals[k] = 5;
      }
    }

    for (final k in copy.keys.where((k) => k.length == 6)) {
      if (k.intersection(transposedSignals[1]!).length == 1) {
        signals[k] = 6;
      } else if (k.intersection(transposedSignals[4]!).length == 4) {
        signals[k] = 9;
      } else {
        signals[k] = 0;
      }
    }

    return Map.from(signals);
  }

  List<Map<Set<String>, int>> get outputs {
    final List<Map<Set<String>, int>> outputs = List.empty(growable: true);

    for (int i = 0; i < _entries.length; i++) {
      final Map<Set<String>, int> map = {};
      for (final d in _entries.elementAt(i).right) {
        for (final k in signals.elementAt(i).keys) {
          if (d.length == k.length && d.intersection(k).length == d.length) {
            map[d] = signals.elementAt(i)[k]!;
          }
        }
      }
      outputs.add(map);
    }

    return outputs;
  }

  List<Map<Set<String>, int>> _getSignals() {
    List<Map<Set<String>, int>> signals = List.empty(growable: true);

    for (final entry in _entries) {
      signals.add(__signals(entry.left));
    }

    return signals;
  }

  List<Map<Set<String>, int>> get signals => _signals;

  int _unambiguous(Set<String> digit) {
    switch (digit.length) {
      case 2:
        return 1;
      case 3:
        return 7;
      case 4:
        return 4;
      case 7:
        return 8;
      default:
        throw 'not unambiguous';
    }
  }
}

extension SumOutputs on List<Map<Set<String>, int>> {
  int get sum {
    int sum = 0;
    final outputsNbs = map((o) => o.values.toList()).toList();

    for (final nbs in outputsNbs) {
      int nb = 0;
      int mul = 1000;
      for (final n in nbs) {
        nb += n * mul;
        mul = (mul / 10).round();
      }
      sum += nb;
    }

    return sum;
  }
}
