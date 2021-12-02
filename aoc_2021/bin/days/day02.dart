import 'dart:convert';
import 'dart:io';

import 'package:aoc_2021/day02/day02.dart';

import '../aoc_2021.dart';

class Day02Runner extends DayRunner<List<Direction>> {
  Day02Runner() {
    day = '02';
  }

  @override
  Future<String> fetch() async {
    String content = '';
    Stream<String> fileStream =
        utf8.decoder.bind(File('../inputs/2021/$day.txt').openRead());

    await for (final chk in fileStream) {
      content += chk;
    }

    return content;
  }

  @override
  List<Direction> parse(String input) {
    final List<Direction> list = List.empty(growable: true);

    for (final line in input.split('\n')) {
      if (line.isEmpty) {
        continue;
      }
      try {
        final Direction direction = Direction.from(line);
        list.add(direction);
      } catch (e) {
        rethrow;
      }
    }

    return list;
  }

  @override
  void run(List<Direction> directions) {
    final Submarine submarine = Submarine();
    submarine.moveMultipleTimes(directions);

    print('Day 01:');
    // part 1
    final submarineProduct = submarine.depth * submarine.horizon;
    print('  part 1: $submarineProduct');
  }
}
