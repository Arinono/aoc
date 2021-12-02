import 'package:aoc_2021/day02/day02.dart';
import 'package:test/test.dart';

void main() {
  group('\nday02\n', () {
    group('when I initialise my submarine\n', () {
      test('has a initial position of 0:0\n', () {
        // act
        final Submarine submarine = Submarine();

        // assert
        expect(submarine.depth, equals(0));
        expect(submarine.horizon, equals(0));
      });
    });

    group('given I have an initialised submarine\n', () {
      late Submarine submarine;

      setUp(() => {
            // arrange
            submarine = Submarine()
          });

      group('when I ask it to move forward by 1\n', () {
        test('its position becomes 1:0\n', () {
          // act
          submarine.move(Forward(1));

          // assert
          expect(submarine.depth, equals(0));
          expect(submarine.horizon, equals(1));
        });
      });
      group('when I ask it to move up by 1\n', () {
        test('its throws a \'SubmarineCannotFlyException\'\n', () {
          // act/assert
          expect(
            () => submarine.move(Up(1)),
            throwsA(isA<SubmarineCannotFlyException>()),
          );
        });
      });
      group('when I ask it to move down by 2\n', () {
        test('its position becomes 0:2\n', () {
          // act
          submarine.move(Down(2));

          // assert
          expect(submarine.depth, equals(2));
          expect(submarine.horizon, equals(0));
        });
      });
      group('when I ask it to move down by 2, then up by 1\n', () {
        test('its position becomes 0:1\n', () {
          // act
          submarine.move(Down(2));
          submarine.move(Up(1));

          // assert
          expect(submarine.depth, equals(1));
          expect(submarine.horizon, equals(0));
        });
      });

      group('when I move the submarine multiple times\n', () {
        test('it has a final position\n', () {
          // act
          submarine.moveMultipleTimes(List.from([
            Forward(5),
            Down(5),
            Forward(8),
            Up(3),
            Down(8),
            Forward(2),
          ]));

          // assert
          expect(submarine.depth, equals(10));
          expect(submarine.horizon, equals(15));
        });
      });
    });

    group('when I received a an operations\n', () {
      test('it is translated to a direction\n', () {
        // arrange
        final String up = 'up 2';
        final String down = 'down 1';
        final String forward = 'forward 5';

        // act
        final Direction upDir = Direction.from(up);
        final Direction downDir = Direction.from(down);
        final Direction forwardDir = Direction.from(forward);

        // assert
        expect(upDir, isA<Up>());
        expect(upDir.by, equals(2));
        expect(downDir, isA<Down>());
        expect(downDir.by, equals(1));
        expect(forwardDir, isA<Forward>());
        expect(forwardDir.by, equals(5));
      });
    });
  });
}
