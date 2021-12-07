import 'package:aoc_2021/day07/day07.dart';
import 'package:test/test.dart';

void main() {
  final List<int> testInput = List.from([16, 1, 2, 0, 4, 2, 7, 1, 2, 14]);
  group('\nday07\n', () {
    group('given I have a list of crab submarines\n', () {
      test('I can determine their horizontal position\n', () {
        // arrange
        final List<int> input = testInput;

        // act
        final Crabs crabs = Crabs.from(input);

        // assert
        expect(crabs.length, equals(input.length));
        expect(crabs.first, equals(16));
      });
    });

    group('when I compute the fuel needed to move them to 2\n', () {
      test('they consume 37 fuel\n', () {
        // arrange
        final Crabs crabs = Crabs.from(testInput);

        // act
        int fuel = crabs.moveTo(2);

        // assert
        expect(fuel, equals(37));
      });
    });

    group('when I compute the fuel needed to move them to 1\n', () {
      test('they consume 41 fuel\n', () {
        // arrange
        final Crabs crabs = Crabs.from(testInput);

        // act
        int fuel = crabs.moveTo(1);

        // assert
        expect(fuel, equals(41));
      });
    });

    group('when I compute the fuel needed to move them to 3\n', () {
      test('they consume 39 fuel\n', () {
        // arrange
        final Crabs crabs = Crabs.from(testInput);

        // act
        int fuel = crabs.moveTo(3);

        // assert
        expect(fuel, equals(39));
      });
    });

    group('when I compute the fuel needed to move them to 10\n', () {
      test('they consume 71 fuel\n', () {
        // arrange
        final Crabs crabs = Crabs.from(testInput);

        // act
        int fuel = crabs.moveTo(10);

        // assert
        expect(fuel, equals(71));
      });
    });

    group('when I try to find the optimal horizontal position\n', () {
      test('they end up consuming 37 fuel\n', () {
        // arrange
        final Crabs crabs = Crabs.from(testInput);

        // act
        int fuel = crabs.optimalMove();

        // assert
        expect(fuel, equals(37));
      });
    });

    group(
        'when I compute the fuel needed to move them to 5 with a geo function\n',
        () {
      test('they consume 168 fuel\n', () {
        // arrange
        final Crabs crabs = Crabs.from(testInput);

        // act
        int fuel = crabs.moveTo(
          5,
          geo: sumNaturalNumbers,
        );

        // assert
        expect(fuel, equals(168));
      });
    });
  });
}
