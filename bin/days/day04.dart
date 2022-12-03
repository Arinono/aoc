import 'dart:convert';
import 'dart:io';

import 'package:aoc_2021/day04/day04.dart';

import '../aoc_2021.dart';

class Day04Runner extends DayRunner<String> {
  Day04Runner() {
    day = '04';
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
  String parse(String input) {
    return input;
  }

  @override
  Future<void> run(String input) async {
    final Bingo game = Bingo.fromRaw(input);

    final int? winningGridIdx = game.playAll();
    final Grid winningGrid = game.grids.elementAt(winningGridIdx!);
    final int? lastWinningGridIdx = game.playUntilAllGridsWon();
    final Grid lastWinningGrid = game.grids.elementAt(lastWinningGridIdx!);

    print('Day $day:');
    // part 1
    print('  part 1: ${winningGrid.score}');
    // part 1
    print('  part 2: ${lastWinningGrid.score}');
  }
}
