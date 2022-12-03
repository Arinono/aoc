import 'package:aoc_2021/day06/day06.dart';
import 'package:test/test.dart';

void main() {
  group('\nday06\n', () {
    group('given I have multiple fishes\n', () {
      group('when I wait 18 days\n', () {
        test('I end up with 26 fishes\n', () {
          // arrange
          final List<Fish> fishes = List.from([
            3,
            4,
            3,
            1,
            2,
          ]);

          // act
          final int fishesNumber = fishes.waitFor(18);

          // assert
          expect(fishesNumber, equals(26));
        });
      });
      group('when I wait 80 days\n', () {
        test('I end up with 5934 fishes\n', () {
          // arrange
          final List<Fish> fishes = List.from([
            3,
            4,
            3,
            1,
            2,
          ]);

          // act
          final int fishesNumber = fishes.waitFor(80);

          // assert
          expect(fishesNumber, equals(5934));
        });
      });
    });
  });
}
