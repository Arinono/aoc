import 'dart:convert';
import 'dart:io';

import 'package:aoc_2021/day06/day06.dart';

import '../aoc_2021.dart';

class Day06Runner extends DayRunner<List<Fish>> {
  Day06Runner() {
    day = '06';
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
  List<Fish> parse(String input) {
    final List<Fish> fishes = List.empty(growable: true);

    for (final l in input.split('\n').first.split(',')) {
      fishes.add(int.parse(l));
    }

    return fishes;
  }

  @override
  Future<void> run(List<Fish> fishes) async {
    final int fishesAfter80Days = fishes.waitFor(80);

    print('Day $day:');
    // part 1
    print('  part 1: $fishesAfter80Days');

    final int fishesAfter256Days = fishes.waitFor(256);

    // part 2
    print('  part 2: $fishesAfter256Days');
  }
}
