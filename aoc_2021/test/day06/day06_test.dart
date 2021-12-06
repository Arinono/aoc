import 'package:aoc_2021/day06/day06.dart';
import 'package:test/test.dart';

void main() {
  group('\nday06\n', () {
    group('given I have a Fish\n', () {
      group('when I wait for a day\n', () {
        test('its internal timer decrements by 1\n', () {
          // arrange
          final Fish fish = Fish.from(3);

          // act
          fish.wait();

          // assert
          expect(fish.timer, equals(2));
        });

        group('and its timer is at 0\n', () {
          test('it spawns a new fish\n', () {
            // arrange
            final Fish fish = Fish.from(0);

            // act
            final Fish? newFish = fish.wait();

            // assert
            expect(fish.timer, equals(6));
            expect(newFish, isA<Fish>());
            expect(newFish!.timer, equals(8));
          });
        });
      });
    });

    group('given I have multiple fishes\n', () {
      group('when I wait 18 days\n', () {
        test('I end up with 26 fishes\n', () {
          // arrange
          final List<Fish> fishes = List.from([
            Fish.from(3),
            Fish.from(4),
            Fish.from(3),
            Fish.from(1),
            Fish.from(2),
          ]);

          // act
          final List<Fish> finalFishes = fishes.waitFor(18);

          // assert
          expect(finalFishes.length, equals(26));
        });
      });
      group('when I wait 80 days\n', () {
        test('I end up with 5934 fishes\n', () {
          // arrange
          final List<Fish> fishes = List.from([
            Fish.from(3),
            Fish.from(4),
            Fish.from(3),
            Fish.from(1),
            Fish.from(2),
          ]);

          // act
          final List<Fish> finalFishes = fishes.waitFor(80);

          // assert
          expect(finalFishes.length, equals(5934));
        });
      });
    });
  });
}
