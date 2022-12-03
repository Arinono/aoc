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
          expect(measurements.first.value, 100);
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
            expect(measurements.last.value, 111);
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
            expect(measurements.last.value, 100);
          });
        });
      });
    });

    group('given there are several values\n', () {
      group('when I try to classify them one by one\n', () {
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
          expect(measurements.atIndex(2).value, 208);

          expect(measurements.atIndex(4), isA<Decreased>());
          expect(measurements.atIndex(4).value, 200);
        });
      });

      group('and they are already classified one by one\n', () {
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

      group('when I try to classify them by windows\n', () {
        test('it returns measurements by windows', () {
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
          final measurements = Measurements.classify(values, byWindowOf: 3);

          // assert
          expect(measurements.length, equals(8));

          expect(measurements.first, isA<First>());
          expect(measurements.first.value, 607);

          expect(measurements.atIndex(1), isA<Increased>());
          expect(measurements.atIndex(1).value, 618);

          expect(measurements.atIndex(2), isA<Unchanged>());
          expect(measurements.atIndex(2).value, 618);

          expect(measurements.atIndex(3), isA<Decreased>());
          expect(measurements.atIndex(3).value, 617);
        });
      });
    });
  });
}
