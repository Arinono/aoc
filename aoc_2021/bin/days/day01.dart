import 'dart:convert';
import 'dart:io';

import 'package:aoc_2021/day01/day01.dart';

import '../aoc_2021.dart';

class Day01Runner extends DayRunner<List<int>> {
  Day01Runner() {
    day = '01';
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
  List<int> parse(String input) {
    final List<int> list = List.empty(growable: true);

    for (final line in input.split('\n')) {
      if (line.isEmpty) {
        continue;
      }
      try {
        int nb = int.parse(line, radix: 10);
        list.add(nb);
      } catch (e) {
        throw InvariantDayInputException('int', line, e);
      }
    }

    return list;
  }

  @override
  void run(List<int> parsedInput) {
    final Measurements measurements = Measurements.classify(parsedInput);

    print('Day 01:');
    // part 1
    final countIncreased = measurements.filter(increased: true).length;
    print('  part1: $countIncreased');
  }
}
