typedef Fish = int;

extension WaitForFishes on List<Fish> {
  int waitFor(int days) {
    Map<Fish, int> map = Map.from({
      0: 0,
      1: 0,
      2: 0,
      3: 0,
      4: 0,
      5: 0,
      6: 0,
      7: 0,
      8: 0,
    });

    for (final f in this) {
      map[f] = map[f]! + 1;
    }

    for (int d = days; d > 0; d--) {
      final int ones = map[1]!;
      for (int i = 1; i != 8; i++) {
        map[i] = map[i + 1]!;
      }
      map[6] = map[6]! + map[0]!;
      map[8] = map[0]!;
      map[0] = ones;
    }

    return map.values.reduce((value, element) => value + element);
  }
}
