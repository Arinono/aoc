import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:aoc_2021/day09/day09.dart';

import '../aoc_2021.dart';

class Day09Runner extends DayRunner<List<List<int>>> {
  Day09Runner() {
    day = '09';
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
  List<List<int>> parse(String input) {
    final List<List<int>> list = List.empty(growable: true);

    for (final l in input.split('\n')) {
      if (l.isEmpty) continue;
      final List<int> row = List.empty(growable: true);

      for (final v in l.split('')) {
        row.add(int.parse(v));
      }

      list.add(row);
    }

    return list;
  }

  @override
  Future<void> run(List<List<int>> input) async {
    final Heightmap heightmap = Heightmap.from(input);

    final Set<Point> lows = heightmap.lowPoints;
    final List<Set<Point>> basins = heightmap.basins;

    print('Day $day:');
    // part 1
    print('  part 1: ${heightmap.riskLevel(lows)}');
    // part 2
    print('  part 2: ${heightmap.basinsSize(basins)}');
  }
}
