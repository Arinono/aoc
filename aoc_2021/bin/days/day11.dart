import 'dart:convert';
import 'dart:io';

import 'package:aoc_2021/day11/day11.dart';

import '../aoc_2021.dart';

class Day11Runner extends DayRunner<List<List<int>>> {
  Day11Runner() {
    day = '11';
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
    final Octopuses octo = Octopuses.from(input);

    final flashed = octo.flashFor();

    print('Day $day:');
    // part 1
    print('  part 1: ${flashed.length}');
  }
}
