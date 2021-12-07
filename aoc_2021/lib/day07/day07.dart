import 'dart:math';

typedef Crab = int;
typedef GeoFunc = int Function(int);

int sumNaturalNumbers(int n) => ((n * (n + 1)) / 2).round();

class Crabs {
  late final List<Crab> _crabs;

  Crabs.from(List<Crab> crabs) {
    _crabs = crabs.toList();
  }

  int optimalMove({GeoFunc? geo}) {
    final Crabs orderedCrabs = Crabs.from(_crabs);
    List<int> fuels = List.empty(growable: true);
    orderedCrabs._sort();

    for (int i = orderedCrabs._crabs.first; i < orderedCrabs._crabs.last; i++) {
      fuels.add(orderedCrabs.moveTo(i, geo: geo));
    }

    return fuels.reduce(min);
  }

  int moveTo(int pos, {GeoFunc? geo}) {
    int fuel = 0;

    for (final c in _crabs) {
      final int abs = (c - pos).abs();
      fuel += geo != null ? geo(abs) : abs;
    }

    return fuel;
  }

  void _sort() {
    _crabs.sort();
  }

  int get length {
    return _crabs.length;
  }

  Crab get first {
    return _crabs.first;
  }
}
