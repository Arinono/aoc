import 'dart:math';

import 'package:aoc_2021/day11/day11.dart';
import 'package:test/test.dart';

void main() {
  group('\nday11\n', () {
    final List<List<int>> testInput = List.of([
      List.of([5, 4, 8, 3, 1, 4, 3, 2, 2, 3]),
      List.of([2, 7, 4, 5, 8, 5, 4, 7, 1, 1]),
      List.of([5, 2, 6, 4, 5, 5, 6, 1, 7, 3]),
      List.of([6, 1, 4, 1, 3, 3, 6, 1, 4, 6]),
      List.of([6, 3, 5, 7, 3, 8, 5, 4, 7, 8]),
      List.of([4, 1, 6, 7, 5, 2, 4, 6, 4, 5]),
      List.of([2, 1, 7, 6, 8, 4, 1, 7, 2, 1]),
      List.of([6, 8, 8, 2, 8, 8, 1, 1, 3, 4]),
      List.of([4, 8, 4, 6, 8, 4, 8, 5, 5, 4]),
      List.of([5, 2, 8, 3, 7, 5, 1, 5, 2, 6]),
    ]);
    group('given I see octopuses\n', () {
      test('I map them in a grid\n', () {
        // arrange
        final List<List<int>> input = testInput.toList();

        // act
        final Octopuses octo = Octopuses.from(input);

        // assert
        expect(octo.at(x: 0, y: 0).energy, equals(5));
        expect(octo.at(x: 9, y: 9).energy, equals(6));
      });
    });

    group('given I have an Octopuses map\n', () {
      test('I find adjacents octopuses\n', () {
        // arrange
        final Octopuses octo = Octopuses.from(testInput);

        // act
        Set<Point> adj00 = octo.adjacents(Point(0, 0));
        Set<Point> adj99 = octo.adjacents(Point(9, 9));
        Set<Point> adj11 = octo.adjacents(Point(1, 1));

        // assert
        expect(
          adj00,
          containsAll([
            Point(1, 0),
            Point(1, 1),
            Point(0, 1),
          ]),
        );
        expect(
          adj99,
          containsAll([
            Point(9, 8),
            Point(8, 8),
            Point(8, 9),
          ]),
        );
        expect(
          adj11,
          containsAll([
            Point(0, 0),
            Point(1, 0),
            Point(2, 0),
            Point(0, 1),
            Point(2, 1),
            Point(0, 2),
            Point(1, 2),
            Point(2, 2),
          ]),
        );
      });

      final List<List<int>> minTestInput = List.of([
        List.of([1, 1, 1, 1, 1]),
        List.of([1, 9, 9, 9, 1]),
        List.of([1, 9, 1, 9, 1]),
        List.of([1, 9, 9, 9, 1]),
        List.of([1, 1, 1, 1, 1]),
      ]);

      test('I wait for them to flash\n', () {
        // arrange
        final Octopuses octo = Octopuses.from(minTestInput);

        // act
        List<Point> flashed = octo.flashFor(step: 1);

        // assert
        expect(octo.at(x: 0, y: 0).energy, equals(3));
        expect(octo.at(x: 4, y: 1).energy, equals(4));
        expect(octo.at(x: 2, y: 4).energy, equals(5));
        expect(octo.at(x: 2, y: 2).energy, equals(0));

        expect(flashed.length, equals(9));
        expect(
          flashed,
          containsAll([
            Point(1, 1),
            Point(2, 1),
            Point(3, 1),
            Point(1, 2),
            Point(2, 2),
            Point(3, 2),
            Point(1, 3),
            Point(2, 3),
            Point(3, 3),
          ]),
        );

        // act
        flashed = octo.flashFor(step: 1);

        // assert
        expect(octo.at(x: 0, y: 0).energy, equals(4));
        expect(octo.at(x: 4, y: 1).energy, equals(5));
        expect(octo.at(x: 2, y: 4).energy, equals(6));
        expect(octo.at(x: 2, y: 2).energy, equals(1));

        expect(flashed.length, equals(9));
      });

      test('I wait for them to flash\n', () {
        // arrange
        final Octopuses octo = Octopuses.from(testInput);

        // act
        List<Point> flashed = octo.flashFor(step: 10);

        // assert
        expect(flashed.length, equals(204));

        // act
        flashed = octo.flashFor(step: 30);
        expect(octo.at(x: 6, y: 0).energy, equals(4));
        expect(octo.at(x: 6, y: 1).energy, equals(4));
        expect(octo.at(x: 7, y: 0).energy, equals(1));
        expect(octo.at(x: 7, y: 1).energy, equals(6));
        expect(octo.at(x: 8, y: 0).energy, equals(1));
        expect(octo.at(x: 8, y: 1).energy, equals(1));
        expect(octo.at(x: 9, y: 0).energy, equals(8));
        expect(octo.at(x: 9, y: 1).energy, equals(1));
        print(octo);

        // assert
        expect(flashed.length, equals(1656));
      });
    });
  });
}
