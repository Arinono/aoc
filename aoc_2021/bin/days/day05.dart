import 'dart:convert';
import 'dart:io';

import 'package:aoc_2021/day05/day05.dart';

import '../aoc_2021.dart';

class Day05Runner extends DayRunner<List<String>> {
  Day05Runner() {
    day = '05';
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
  List<String> parse(String input) {
    final List<String> lines = List.empty(growable: true);

    for (final l in input.split('\n')) {
      if (l.isEmpty) continue;
      lines.add(l);
    }

    return lines;
  }

  @override
  Future<void> run(List<String> input) async {
    final List<Line> lines = input.toLines;

    final Grid firstGrid =
        Grid(lines.filterBy(horizontal: true, vertical: true));

    print('Day $day:');
    // part 1
    print('  part 1: ${firstGrid.overlaps}');
  }
}
