class Pair<T, U> {
  late final T left;
  late final U right;

  Pair(this.left, this.right);
}

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

  Mem(this.bytes);

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

typedef OxygenGeneratorCandidates = List<Byte>;
typedef DiOxyScrubberCandidates = List<Byte>;

class Rates {
  late final Byte gamma;
  late final Byte epsilon;
  late final Byte oxyGenerator;
  late final Byte diOxyScrubber;

  Rates.fromBytes(Mem mem) {
    final List<Bit> gammaValues = List.empty(growable: true);
    final List<Bit> epsilonValues = List.empty(growable: true);
    Pair<OxygenGeneratorCandidates, DiOxyScrubberCandidates> candidates = Pair(
      mem.bytes.toList(),
      mem.bytes.toList(),
    );

    for (int bitCriterionOffset = 0;
        bitCriterionOffset < mem.byteSize;
        bitCriterionOffset++) {
      final List<Bit> bitsAtCriterionOffset =
          mem.collectBits(offset: bitCriterionOffset);
      final Pair<int, int> commonBits =
          _defineCommonBits(bitsAtCriterionOffset);
      final Bit mostCommon =
          commonBits.left > commonBits.right ? Bit.zero : Bit.one;
      final Bit leastCommon =
          commonBits.left < commonBits.right ? Bit.zero : Bit.one;

      final List<Bit> bitsAtCriterionOffsetLeftCandidates =
          Mem(candidates.left).collectBits(offset: bitCriterionOffset);
      final Pair<int, int> commonBitsLeftCandidates =
          _defineCommonBits(bitsAtCriterionOffsetLeftCandidates);
      final Bit mostCommonLeftCandidates =
          commonBitsLeftCandidates.right >= commonBitsLeftCandidates.left
              ? Bit.one
              : Bit.zero;

      final List<Bit> bitsAtCriterionOffsetRightCandidates =
          Mem(candidates.right).collectBits(offset: bitCriterionOffset);
      final Pair<int, int> commonBitsRightCandidates =
          _defineCommonBits(bitsAtCriterionOffsetRightCandidates);
      final Bit leastCommonRightCandidates =
          commonBitsRightCandidates.right >= commonBitsRightCandidates.left
              ? Bit.zero
              : Bit.one;

      for (final byte in mem.bytes) {
        if (candidates.left.length > 1 &&
            byte.bits.elementAt(bitCriterionOffset) !=
                mostCommonLeftCandidates) {
          candidates.left.remove(byte);
        }
        if (candidates.right.length > 1 &&
            byte.bits.elementAt(bitCriterionOffset) !=
                leastCommonRightCandidates) {
          candidates.right.remove(byte);
        }
      }

      // for (final byte in mem.bytes) {
      //   _discardCandidates(
      //     candidates.left,
      //     byte,
      //     bitCriterionOffset,
      //     most: true,
      //   );
      //   _discardCandidates(
      //     candidates.right,
      //     byte,
      //     bitCriterionOffset,
      //     least: true,
      //   );
      // }

      gammaValues.add(mostCommon);
      epsilonValues.add(leastCommon);
    }

    gamma = Byte(gammaValues);
    epsilon = Byte(epsilonValues);
    oxyGenerator = candidates.left.first;
    diOxyScrubber = candidates.right.first;
  }

  // for later refactor idea
  // void _discardCandidates(
  //   List<Byte> candidates,
  //   Byte byte,
  //   int offset, {
  //   bool most = false,
  //   bool least = false,
  // }) {
  //   final List<Bit> bitsAtCriterionOffset =
  //       Mem(candidates).collectBits(offset: offset);
  //   final Pair<int, int> commonBits = _defineCommonBits(bitsAtCriterionOffset);
  //   final Bit mostCommon =
  //       commonBits.right >= commonBits.left ? Bit.one : Bit.zero;
  //   final Bit leastCommon =
  //       commonBits.right >= commonBits.left ? Bit.zero : Bit.one;

  //   final bool shouldDeleteLeft =
  //       most && byte.bits.elementAt(offset) != mostCommon;
  //   final bool shouldDeleteRight =
  //       least && byte.bits.elementAt(offset) != leastCommon;

  //   if (candidates.length > 1 && (shouldDeleteLeft || shouldDeleteRight)) {
  //     candidates.remove(byte);
  //   }
  // }

  Pair<int, int> _defineCommonBits(List<Bit> bits) {
    int zeros = 0;
    int ones = 0;

    for (final bit in bits) {
      if (bit == Bit.zero) {
        zeros++;
      } else if (bit == Bit.one) {
        ones++;
      }
    }

    return Pair(zeros, ones);
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
