import 'package:aoc_2021/day04/day04.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  final String testInput = '''
7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7
''';

  group('\nday04\n', () {
    group('given I have the bingo input\n', () {
      test('I extract the drawn numbers\n', () {
        // arrange
        final Bingo game = Bingo.fromRaw(testInput);

        // act
        final List<int> numbers = game.numbers;

        // assert
        expect(
          numbers,
          equals(
            List.from([
              7,
              4,
              9,
              5,
              11,
              17,
              23,
              2,
              0,
              14,
              21,
              24,
              10,
              16,
              13,
              6,
              15,
              25,
              12,
              22,
              18,
              20,
              8,
              19,
              3,
              26,
              1,
            ]),
          ),
        );
      });

      test('I extract some grids\n', () {
        // arrange
        final Bingo game = Bingo.fromRaw(testInput);

        // act
        final List<Grid> grids = game.grids;

        // assert
        expect(grids.length, equals(3));
        expect(
          grids.first.at(y: 0, x: 3),
          isA<UnmarkedGridNumber>(),
        );
        expect(
          grids.first.at(y: 0, x: 3).number,
          equals(11),
        );
      });

      group('when I play 1 round\n', () {
        test('some numbers become marked\n', () {
          // arrange
          final Bingo game = Bingo.fromRaw(testInput);

          // act
          game.play(7);

          // assert
          expect(
            game.grids.first.at(y: 2, x: 4),
            isA<MarkedGridNumber>(),
          );
          expect(
            game.grids.elementAt(1).at(y: 2, x: 2),
            isA<MarkedGridNumber>(),
          );
          expect(
            game.grids.last.at(y: 4, x: 4),
            isA<MarkedGridNumber>(),
          );
        });
      });
      group('when I play until a grid wins\n', () {
        test('I know which will be the first winning grid\n', () {
          // arrange
          final Bingo game = Bingo.fromRaw(testInput);

          // act
          final int? winningGrid = game.playAll();

          // assert
          expect(winningGrid, equals(2));
          expect(
            game.grids.elementAt(winningGrid!).score,
            equals(4512),
          );
        });
      });

      group('when I play until all grids have won\n', () {
        test('I know which will be the first winning grid\n', () {
          // arrange
          final Bingo game = Bingo.fromRaw(testInput);

          // act
          final int? lastWinningGrid = game.playUntilAllGridsWon();

          // assert
          expect(lastWinningGrid, equals(1));
          expect(
            game.grids.elementAt(lastWinningGrid!).score,
            equals(1924),
          );
        });
      });
    });
  });
}
