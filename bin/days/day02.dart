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
        utf8.decoder.bind(File('./inputs/$day.txt').openRead());

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
  Future<void> run(List<Direction> directions) async {
    final Submarine submarine = Submarine();
    final Submarine aimedSubmarine = Submarine.withAim();

    submarine.moveMultipleTimes(directions);
    aimedSubmarine.moveMultipleTimes(directions);

    print('Day $day:');
    // part 1
    final submarineProduct = submarine.depth * submarine.horizon;
    print('  part 1: $submarineProduct');
    // part 2
    final submarine2Product = aimedSubmarine.depth * aimedSubmarine.horizon;
    print('  part 1: $submarine2Product');
  }
}
