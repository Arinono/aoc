class First extends Measurement {
  final int value;

  First(this.value) : super();

  @override
  String toString() {
    return value.toString();
  }
}

class Increased extends Measurement {
  final int value;

  Increased(this.value) : super();

  @override
  String toString() {
    return value.toString();
  }
}

class Decreased extends Measurement {
  final int value;

  Decreased(this.value) : super();

  @override
  String toString() {
    return value.toString();
  }
}

abstract class Measurement {
  Measurement();

  static Measurement firstMeasure(int value) {
    return First(value);
  }

  factory Measurement.classify({
    required int previous,
    required int value,
  }) {
    return previous < value ? Increased(value) : Decreased(value);
  }

  First asFirst() {
    return this as First;
  }

  Increased asIncreased() {
    return this as Increased;
  }

  Decreased asDecreased() {
    return this as Decreased;
  }
}

class Measurements {
  late final List<Measurement> _measurements;

  Measurements.classify(List<int> values) {
    _measurements = List.empty(growable: true);
    for (var i = 0; i < values.length; i++) {
      if (i == 0) {
        _measurements.add(
          Measurement.firstMeasure(values.elementAt(i)),
        );
        continue;
      }

      _measurements.add(
        Measurement.classify(
          previous: values.elementAt(i - 1),
          value: values.elementAt(i),
        ),
      );
    }
  }

  int get length {
    return _measurements.length;
  }

  Measurement get first {
    return _measurements.first;
  }

  Measurement get last {
    return _measurements.last;
  }

  List<Measurement> get all {
    return _measurements;
  }

  Measurement atIndex(int index) {
    return _measurements.elementAt(index);
  }

  List<Measurement> filter({
    bool first = false,
    bool increased = false,
    bool decreased = false,
  }) {
    final List<Measurement> list = List.empty(growable: true);

    for (Measurement measurement in _measurements) {
      bool isFirst = measurement.runtimeType == First;
      bool isIncreased = measurement.runtimeType == Increased;
      bool isDecreased = measurement.runtimeType == Decreased;

      if ((first && isFirst) ||
          (increased && isIncreased) ||
          (decreased && isDecreased)) {
        list.add(measurement);
      }
    }

    return list;
  }
}
