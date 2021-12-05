import 'package:aoc_2021/day05/day05.dart';
import 'package:test/test.dart';

void main() {
  final List<String> testInput = List.from([
    '0,9 -> 5,9',
    '8,0 -> 0,8',
    '9,4 -> 3,4',
    '2,2 -> 2,1',
    '7,0 -> 7,4',
    '6,4 -> 2,0',
    '0,9 -> 2,9',
    '3,4 -> 1,4',
    '0,0 -> 8,8',
    '5,5 -> 8,2',
  ]);

  final List<String> simpleTestInput = List.from([
    '0,0 -> 2,0', // ➡️
    '0,0 -> 0,2', // ⬇️
    '2,0 -> 0,0', // ⬅️
    '2,2 -> 2,0', // ⬆️
    '0,0 -> 2,2', // ↘️
    '2,0 -> 0,2', // ↙️
    '2,2 -> 0,0', // ↖️
    '0,2 -> 2,0', // ↗️
  ]);

  group('\nday05\n', () {
    group('given I have a line descriptions\n', () {
      group('when I parse them\n', () {
        test('it gives back Lines\n', () {
          // arrange
          final List<String> lineDescs = simpleTestInput;

          // act
          final List<Line> lines = lineDescs.toLines;

          // assert
          expect(lines.elementAt(0), isA<ToEastLine>());
          expect(lines.elementAt(1), isA<ToSouthLine>());
          expect(lines.elementAt(2), isA<ToWestLine>());
          expect(lines.elementAt(3), isA<ToNorthLine>());
          expect(lines.elementAt(4), isA<ToSouthEastLine>());
          expect(lines.elementAt(5), isA<ToSouthWestLine>());
          expect(lines.elementAt(6), isA<ToNorthWestLine>());
          expect(lines.elementAt(7), isA<ToNorthEastLine>());
        });
      });
      test('I get the all the points between start and end of a line', () {
        // arrange
        List<Line> lines = simpleTestInput.toLines;

        // act
        List<List<Point>> points = lines
            .filterBy(horizontal: true, vertical: true)
            .map((l) => l.points)
            .toList();

        // assert
        expect(points.first.length, equals(3));
        expect(points.elementAt(0).elementAt(1).x, equals(1));
        expect(points.elementAt(1).elementAt(1).y, equals(1));
        expect(points.elementAt(2).elementAt(1).x, equals(1));
        expect(points.elementAt(3).elementAt(1).y, equals(1));
      });
    });

    group('given I have multiple lines\n', () {
      group('when I overlap them on a grid\n', () {
        test('I have overlap occurrences\n', () {
          // arrange
          final List<Line> lines =
              testInput.toLines.filterBy(horizontal: true, vertical: true);

          // act
          final Grid grid = Grid(lines);

          // assert
          expect(grid.at(x: 7, y: 4), equals(2));
          expect(grid.at(x: 3, y: 4), equals(2));
          expect(grid.at(x: 0, y: 9), equals(2));
          expect(grid.at(x: 1, y: 9), equals(2));
          expect(grid.at(x: 2, y: 9), equals(2));
        });

        test('I count overlap occurrences\n', () {
          // arrange
          final List<Line> lines =
              testInput.toLines.filterBy(horizontal: true, vertical: true);

          // act
          final Grid grid = Grid(lines);

          // assert
          expect(grid.overlaps, equals(5));
        });
      });
    });
  });
}
