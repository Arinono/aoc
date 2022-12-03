import 'dart:math';

import 'package:aoc_2021/day09/day09.dart';
import 'package:test/test.dart';

void main() {
  group('\nday09\n', () {
    group('given I have a heightmap\n', () {
      test('I can get adjacents locations from any point\n', () {
        // arrange
        final Heightmap heightmap = Heightmap.from(List.of([
          List.of([2, 1, 9, 9, 9, 4, 3, 2, 1, 0]),
          List.of([3, 9, 8, 7, 8, 9, 4, 9, 2, 1]),
          List.of([9, 8, 5, 6, 7, 8, 9, 8, 9, 2]),
          List.of([8, 7, 6, 7, 8, 9, 6, 7, 8, 9]),
          List.of([9, 8, 9, 9, 9, 6, 5, 6, 7, 8]),
        ]));

        // act
        final Set<Point> adjacents00 = heightmap.adjacents(x: 0, y: 0);
        final Set<Point> adjacents92 = heightmap.adjacents(x: 9, y: 2);
        final Set<Point> adjacents22 = heightmap.adjacents(x: 2, y: 2);

        // assert
        expect(heightmap.atPoints(adjacents00), containsAll([1, 3]));
        expect(heightmap.atPoints(adjacents92), containsAll([1, 9, 9]));
        expect(heightmap.atPoints(adjacents22), containsAll([8, 8, 6, 6]));
      });

      test('I determine if a location is low\n', () {
        // arrange
        final Heightmap heightmap = Heightmap.from(List.of([
          List.of([2, 1, 9, 9, 9, 4, 3, 2, 1, 0]),
          List.of([3, 9, 8, 7, 8, 9, 4, 9, 2, 1]),
          List.of([9, 8, 5, 6, 7, 8, 9, 8, 9, 2]),
          List.of([8, 7, 6, 7, 8, 9, 6, 7, 8, 9]),
          List.of([9, 8, 9, 9, 9, 6, 5, 6, 7, 8]),
        ]));

        // act
        final LocStatus pos00 = heightmap.status(Point(0, 0));
        final LocStatus pos10 = heightmap.status(Point(1, 0));

        // assert
        expect(pos00, isA<NotLow>());
        expect(pos00.value, equals(2));

        expect(pos10, isA<Low>());
        expect(pos10.value, equals(1));
      });

      test('I can determine all low positions\n', () {
        // arrange
        final Heightmap heightmap = Heightmap.from(List.of([
          List.of([2, 1, 9, 9, 9, 4, 3, 2, 1, 0]),
          List.of([3, 9, 8, 7, 8, 9, 4, 9, 2, 1]),
          List.of([9, 8, 5, 6, 7, 8, 9, 8, 9, 2]),
          List.of([8, 7, 6, 7, 8, 9, 6, 7, 8, 9]),
          List.of([9, 8, 9, 9, 9, 6, 5, 6, 7, 8]),
        ]));

        // act
        final Set<Point> lows = heightmap.lowPoints;

        // assert
        expect(
            lows.map((pt) => heightmap.atPoint(pt)), containsAll([1, 0, 5, 5]));
      });

      test('I determine the risk level\n', () {
        // arrange
        final Heightmap heightmap = Heightmap.from(List.of([
          List.of([2, 1, 9, 9, 9, 4, 3, 2, 1, 0]),
          List.of([3, 9, 8, 7, 8, 9, 4, 9, 2, 1]),
          List.of([9, 8, 5, 6, 7, 8, 9, 8, 9, 2]),
          List.of([8, 7, 6, 7, 8, 9, 6, 7, 8, 9]),
          List.of([9, 8, 9, 9, 9, 6, 5, 6, 7, 8]),
        ]));
        final Set<Point> lows = heightmap.lowPoints;

        // act
        final int risk = heightmap.riskLevel(lows);

        // assert
        expect(risk, equals(15));
      });

      test('I find all basins\n', () {
        // arrange
        final Heightmap heightmap = Heightmap.from(List.of([
          List.of([2, 1, 9, 9, 9, 4, 3, 2, 1, 0]),
          List.of([3, 9, 8, 7, 8, 9, 4, 9, 2, 1]),
          List.of([9, 8, 5, 6, 7, 8, 9, 8, 9, 2]),
          List.of([8, 7, 6, 7, 8, 9, 6, 7, 8, 9]),
          List.of([9, 8, 9, 9, 9, 6, 5, 6, 7, 8]),
        ]));

        // act
        final List<Set<Point>> basins = heightmap.basins;

        // assert
        expect(basins.length, equals(4));
        expect(heightmap.basinsSize(basins), equals(1134));

        expect(basins.first.length, equals(3));
        expect(
          basins.first,
          containsAll([Point(1, 0), Point(0, 0), Point(0, 1)]),
        );

        expect(basins.elementAt(1).length, equals(9));
        expect(
          basins.elementAt(1),
          containsAll([
            Point(5, 0),
            Point(6, 0),
            Point(7, 0),
            Point(8, 0),
            Point(9, 0),
            Point(6, 1),
            Point(8, 1),
            Point(9, 1),
            Point(9, 2),
          ]),
        );

        expect(basins.elementAt(2).length, equals(14));
        expect(
          basins.elementAt(2),
          containsAll([
            Point(2, 1),
            Point(3, 1),
            Point(4, 1),
            Point(1, 2),
            Point(2, 2),
            Point(3, 2),
            Point(4, 2),
            Point(5, 2),
            Point(0, 3),
            Point(1, 3),
            Point(2, 3),
            Point(3, 3),
            Point(4, 3),
            Point(1, 4),
          ]),
        );

        expect(basins.elementAt(3).length, equals(9));
        expect(
          basins.elementAt(3),
          containsAll([
            Point(7, 2),
            Point(6, 3),
            Point(7, 3),
            Point(8, 3),
            Point(9, 4),
            Point(8, 4),
            Point(7, 4),
            Point(6, 4),
            Point(5, 4),
          ]),
        );
      });
    });
  });
}
