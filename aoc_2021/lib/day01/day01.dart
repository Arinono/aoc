class First extends Measurement {
  First(int value) : super(value);

  @override
  String toString() {
    return value.toString();
  }
}

class Increased extends Measurement {
  Increased(int value) : super(value);

  @override
  String toString() {
    return value.toString();
  }
}

class Decreased extends Measurement {
  Decreased(int value) : super(value);

  @override
  String toString() {
    return value.toString();
  }
}

class Unchanged extends Measurement {
  Unchanged(int value) : super(value);

  @override
  String toString() {
    return value.toString();
  }
}

abstract class Measurement {
  int value;

  Measurement(this.value);

  static Measurement firstMeasure(int value) {
    return First(value);
  }

  factory Measurement.classify({
    required int previous,
    required int value,
  }) {
    return previous == value
        ? Unchanged(value)
        : previous < value
            ? Increased(value)
            : Decreased(value);
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

  Measurements.classifyByWindow(List<int> values, {int of = 3}) {
    if (of <= 0) {
      throw RequestedWindowNegativeException();
    } else if (of > values.length) {
      throw RequestedWindowTooLargeException(values.length, of);
    }

    final int window = of - 1;
    _measurements = List.empty(growable: true);

    for (var i = window; i < values.length; i++) {
      if (i == window) {
        _measurements.add(
          Measurement.firstMeasure(
            _sum(
              values.sublist(i - window, i + 1),
            ),
          ),
        );
        continue;
      }

      _measurements.add(
        Measurement.classify(
          previous: _measurements.last.value,
          value: _sum(
            values.sublist(i - window, i + 1),
          ),
        ),
      );
    }
  }

  int _sum(List<int> numbers) {
    return numbers.reduce((value, element) => value += element);
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

class RequestedWindowTooLargeException implements Exception {
  final int max;
  final int requested;

  RequestedWindowTooLargeException(this.max, this.requested);

  @override
  String toString() {
    return 'Requested window is too large. List size is $max but got: $requested';
  }
}

class RequestedWindowNegativeException implements Exception {
  RequestedWindowNegativeException();

  @override
  String toString() {
    return 'Requested window must be positive.';
  }
}
