import 'package:aoc_2021/day01/day01.dart';
import 'package:test/test.dart';

void main() {
  group('\nday01\n', () {
    group('given there is only 1 measuremment\n', () {
      group('when I try to classify it\n', () {
        test('it returns a \'FirstMeasure\' measure type\n', () {
          // arrange
          final List<int> values = List.from([100]);

          // act
          final measurements = Measurements.classify(values);

          // assert
          expect(measurements.length, equals(1));
          expect(measurements.first, isA<First>());
          expect(measurements.first.asFirst().value, 100);
        });
      });
    });

    group('given there are 2 values\n', () {
      group('and the 2nd one is greater than the first one\n', () {
        group('when I try to classify them\n', () {
          test('it returns an \'Increased\' for the 2nd value\n', () {
            // arrange
            final List<int> values = List.from([100, 111]);

            // act
            final measurements = Measurements.classify(values);

            // assert
            expect(measurements.length, equals(2));
            expect(measurements.last, isA<Increased>());
            expect(measurements.last.asIncreased().value, 111);
          });
        });
      });

      group('and the 2nd one is lower than the first one\n', () {
        group('when I try to classify them\n', () {
          test('it returns an \'Deceased\' for the 2nd value\n', () {
            // arrange
            final List<int> values = List.from([111, 100]);

            // act
            final measurements = Measurements.classify(values);

            // assert
            expect(measurements.length, equals(2));
            expect(measurements.last, isA<Decreased>());
            expect(measurements.last.asDecreased().value, 100);
          });
        });
      });
    });

    group('given there are several values\n', () {
      group('when I try to classify them\n', () {
        test('it returns the proper classifications\n', () {
          // arrange
          final List<int> values = List.from([
            199,
            200,
            208,
            210,
            200,
            207,
            240,
            269,
            260,
            263,
          ]);

          // act
          final measurements = Measurements.classify(values);

          // assert
          expect(measurements.length, equals(10));

          expect(measurements.atIndex(2), isA<Increased>());
          expect(measurements.atIndex(2).asIncreased().value, 208);

          expect(measurements.atIndex(4), isA<Decreased>());
          expect(measurements.atIndex(4).asDecreased().value, 200);
        });
      });
    });

    group('given there are several values\n', () {
      group('and I already classified them\n', () {
        group('when I filter by \'Increased\' measurements\n', () {
          test('it returns the \'Increased\' measurements\n', () {
            // arrange
            final List<int> values = List.from([
              199,
              200,
              208,
              210,
              200,
              207,
              240,
              269,
              260,
              263,
            ]);
            final measurements = Measurements.classify(values);

            // act
            final allIncreased = measurements.filter(
              increased: true,
            );

            // assert
            expect(allIncreased.length, equals(7));
          });
        });
      });
    });
  });
}
