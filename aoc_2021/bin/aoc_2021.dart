import 'dart:collection';
import 'dart:io';

import 'package:args/args.dart';

import 'days/day01.dart';
import 'days/day02.dart';

void main(List<String> arguments) async {
  final ArgParser parser = ArgParser()
    ..addOption(
      'day',
      abbr: 'd',
      help: 'The day you want to run.',
      valueHelp: '01',
    );

  parser.addFlag(
    'help',
    negatable: false,
    abbr: 'h',
    callback: (help) => usage(help, parser),
  );

  try {
    final ArgResults args = parser.parse(arguments);
    final DayRunnerPicker dayRunnerPicker = DayRunnerPicker();

    if (args['day'] == null) {
      for (final DayRunner runner in dayRunnerPicker.all) {
        final fileContent = await runner.fetch();
        final parsedContent = runner.parse(fileContent);
        await runner.run(parsedContent);
      }
    } else {
      final DayRunner runner = dayRunnerPicker.pick(args['day']);
      final fileContent = await runner.fetch();
      final parsedContent = runner.parse(fileContent);
      await runner.run(parsedContent);
    }
  } on DayNotFoundException {
    print('Day not found.');
  } catch (e) {
    print(e);
  } finally {
    exit(1);
  }
}

void usage(bool help, ArgParser parser) {
  if (help) {
    print(parser.usage);
    exit(0);
  }
}

abstract class DayRunner<T> {
  late final String day;

  Future<String> fetch();
  T parse(String input);
  Future<void> run(T parsedInput);
}

class DayRunnerPicker {
  final HashMap<String, DayRunner> days = HashMap.fromEntries([
    MapEntry('01', Day01Runner()),
    MapEntry('02', Day02Runner()),
  ]);

  DayRunner pick(String day) {
    final runner = days[day];

    if (runner != null) {
      return runner;
    }
    throw DayNotFoundException();
  }

  List<DayRunner> get all {
    return List.from(days.values);
  }
}

class DayNotFoundException implements Exception {
  DayNotFoundException();
}

class InvariantDayInputException implements Exception {
  final String expected;
  final String input;
  final Object reason;
  InvariantDayInputException(this.expected, this.input, this.reason);

  @override
  String toString() {
    return 'Expected an \'$expected\' in the input but got: $input\n${reason.toString()}';
  }
}
