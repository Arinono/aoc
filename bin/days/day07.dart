import 'dart:convert';
import 'dart:io';

import 'package:aoc_2021/day07/day07.dart';

import '../aoc_2021.dart';

class Day07Runner extends DayRunner<List<int>> {
  Day07Runner() {
    day = '07';
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
  List<int> parse(String input) {
    final List<int> crabs = List.empty(growable: true);

    for (final l in input.split('\n').first.split(',')) {
      crabs.add(int.parse(l));
    }

    return crabs;
  }

  @override
  Future<void> run(List<int> input) async {
    final Crabs crabs = Crabs.from(input);
    final int fuel = crabs.optimalMove();
    final int fuel2 = crabs.optimalMove(geo: sumNaturalNumbers);

    print('Day $day:');
    // part 1
    print('  part 1: $fuel');
    // part 2
    print('  part 2: $fuel2');
  }
}
