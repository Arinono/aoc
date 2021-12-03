import 'dart:convert';
import 'dart:io';

import 'package:aoc_2021/day03/day03.dart';

import '../aoc_2021.dart';

class Day03Runner extends DayRunner<List<String>> {
  Day03Runner() {
    day = '03';
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

    for (final line in input.split('\n')) {
      if (line.isEmpty) {
        continue;
      }
      try {
        list.add(line);
      } catch (e) {
        rethrow;
      }
    }

    return list;
  }

  @override
  Future<void> run(List<String> report) async {
    final SubmarineDiagnostic diag = SubmarineDiagnostic.from(report);

    print('Day $day:');
    // part 1
    final powerConsumption =
        diag.rates.epsilon.toDec() * diag.rates.gamma.toDec();
    print('  part 1: $powerConsumption');
    // part 2
    final lifeSupportRate =
        diag.rates.oxyGenerator.toDec() * diag.rates.diOxyScrubber.toDec();
    print('  part 2: $lifeSupportRate');
  }
}
