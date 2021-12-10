import 'dart:convert';
import 'dart:io';

import 'package:aoc_2021/day08/day08.dart';

import '../aoc_2021.dart';

class Day08Runner extends DayRunner<List<String>> {
  Day08Runner() {
    day = '08';
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

    return lines.toList();
  }

  @override
  Future<void> run(List<String> lines) async {
    final Notes notes = Notes.from(lines);
    final ezOutputs = notes.outputs
        .map(
          (element) =>
              element.values.where((e) => [1, 4, 7, 8].contains(e)).toList(),
        )
        .toList()
        .fold<List<int>>(
          List.empty(growable: true),
          (l, e) => [...l, ...e],
        );

    print('Day $day:');
    // part 1
    print('  part 1: ${ezOutputs.length}');
    // part 2
    print('  part 2: ${notes.outputs.sum}');
  }
}
