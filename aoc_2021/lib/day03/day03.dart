enum Bit { zero, one }

class Byte {
  late final List<Bit> bits;

  Byte(this.bits);

  Byte.from(List<int> values) {
    if (values.isEmpty) {
      throw ByteCannotBeEmptyException();
    }
    bits = List.from(values.map((i) => i.toBit()));
  }

  int get length {
    return bits.length;
  }

  int toDec() {
    return int.parse(toString(), radix: 2);
  }

  @override
  String toString() {
    String str = '';
    for (final bit in bits) {
      str += bit.str;
    }
    return str;
  }
}

class Mem {
  late final List<Byte> bytes;

  Mem.from(List<List<int>> values) {
    bytes = List.empty(growable: true);
    for (final value in values) {
      bytes.add(Byte.from(value));
    }
  }

  List<Bit> collectBits({required int offset}) {
    List<Bit> bits = List.empty(growable: true);

    for (final byte in bytes) {
      bits.add(byte.bits.elementAt(offset));
    }

    return bits;
  }

  int get byteSize {
    return bytes.first.length;
  }

  @override
  String toString() {
    String str = '';

    for (final byte in bytes) {
      str += '$byte\n';
    }

    return str;
  }
}

class Rates {
  late final Byte gamma;
  late final Byte epsilon;

  Rates.fromBytes(Mem bytes) {
    final List<Bit> gammaValues = List.empty(growable: true);
    final List<Bit> epsilonValues = List.empty(growable: true);

    for (int i = 0; i < bytes.byteSize; i++) {
      final List<Bit> bits = bytes.collectBits(offset: i);
      int ones = 0;
      int zeros = 0;

      for (final bit in bits) {
        if (bit == Bit.zero) {
          zeros++;
        } else if (bit == Bit.one) {
          ones++;
        }
      }
      gammaValues.add(zeros > ones ? Bit.zero : Bit.one);
      epsilonValues.add(zeros < ones ? Bit.zero : Bit.one);
    }
    gamma = Byte(gammaValues);
    epsilon = Byte(epsilonValues);
  }
}

class SubmarineDiagnostic {
  late final Rates rates;

  SubmarineDiagnostic.from(List<String> report) {
    if (report.isEmpty) {
      throw SubmarineDianosticEmptyException();
    }

    final Mem bytes = Mem.from(report.map((l) => l.toInts()).toList());
    rates = Rates.fromBytes(bytes);
  }
}

extension BitToString on Bit {
  String get str {
    return this == Bit.zero ? '0' : '1';
  }
}

extension StringToListInt on String {
  List<int> toInts() {
    final List<int> ints = List.empty(growable: true);

    for (final char in split('')) {
      ints.add(int.parse(char));
    }

    return ints;
  }
}

extension IntToBit on int {
  Bit toBit() {
    if (this != 0 && this != 1) {
      throw BitHasToBeOneOrZeroException();
    }
    return this == 0 ? Bit.zero : Bit.one;
  }
}

class SubmarineDianosticEmptyException implements Exception {
  SubmarineDianosticEmptyException();
}

class ByteCannotBeEmptyException implements Exception {
  ByteCannotBeEmptyException();
}

class BitHasToBeOneOrZeroException implements Exception {
  BitHasToBeOneOrZeroException();
}
