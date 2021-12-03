import 'package:aoc_2021/day03/day03.dart';
import 'package:test/test.dart';

void main() {
  final List<String> testInput = List.from([
    '00100',
    '11110',
    '10110',
    '10111',
    '10101',
    '01111',
    '00111',
    '11100',
    '10000',
    '11001',
    '00010',
    '01010',
  ]);
  group('\nday03\n', () {
    group('given I have a diagnostic report\n', () {
      group('if the report is empty\n', () {
        test('it throws a \'SubmarineDianosticEmptyException\'\n', () {
          // arrange
          final List<String> report = List.empty();

          // act/assert
          expect(
            () => SubmarineDiagnostic.from(report),
            throwsA(isA<SubmarineDianosticEmptyException>()),
          );
        });
      });
      test('I determine the gamma rate\n', () {
        // arrange
        final List<String> report = testInput;

        // act
        final SubmarineDiagnostic diag = SubmarineDiagnostic.from(report);

        // assert
        expect(diag.rates.gamma.toString(), equals('10110'));
        expect(diag.rates.gamma.toDec(), equals(22));
      });

      test('I determine the epsilon rate\n', () {
        // arrange
        final List<String> report = testInput;

        // act
        final SubmarineDiagnostic diag = SubmarineDiagnostic.from(report);

        // assert
        expect(diag.rates.epsilon.toString(), equals('01001'));
        expect(diag.rates.epsilon.toDec(), equals(9));
      });

      test('I determine the oxygen generator rate\n', () {
        // arrange
        final List<String> report = testInput;

        // act
        final SubmarineDiagnostic diag = SubmarineDiagnostic.from(report);

        // assert
        expect(diag.rates.oxyGenerator.toString(), equals('10111'));
        expect(diag.rates.oxyGenerator.toDec(), equals(23));
      });

      test('I determine the CO2 scrubber rate\n', () {
        // arrange
        final List<String> report = testInput;

        // act
        final SubmarineDiagnostic diag = SubmarineDiagnostic.from(report);

        // assert
        expect(diag.rates.diOxyScrubber.toString(), equals('01010'));
        expect(diag.rates.diOxyScrubber.toDec(), equals(10));
      });
    });
  });
}