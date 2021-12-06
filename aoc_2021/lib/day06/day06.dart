class Fish {
  late int timer;

  Fish() {
    timer = 8;
  }
  Fish.from(this.timer);

  Fish? wait() {
    if (timer == 0) {
      timer = 6;
      return Fish();
    }
    timer--;
  }

  @override
  String toString() {
    return timer.toString();
  }
}

extension WaitForFishes on List<Fish> {
  List<Fish> waitFor(int days) {
    if (days == 0) {
      return this;
    }

    List<Fish> newFishes = List.empty(growable: true);

    for (final f in this) {
      final Fish? newFish = f.wait();
      if (newFish != null) {
        newFishes.add(newFish);
      }
    }

    final List<Fish> fishes = List.from([...this, ...newFishes]);
    return fishes.waitFor(days - 1);
  }
}
