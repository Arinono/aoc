import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:aoc_2021/day10/day10.dart';

import '../aoc_2021.dart';

class Day10Runner extends DayRunner<List<String>> {
  Day10Runner() {
    day = '10';
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
    final List<String> list = List.empty(growable: true);

    for (final l in input.split('\n')) {
      if (l.isEmpty) continue;

      list.add(l);
    }

    return list;
  }

  @override
  Future<void> run(List<String> input) async {
    final Instructions instructions = Instructions.from(input);

    print('Day $day:');
    // part 1
    print('  part 1: ${instructions.syntaxErrorScore}');
    // part 2
    print('  part 2: ${instructions.autocompleteScore}');
  }
}
