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
      mandatory: true,
    );

  parser.addFlag(
    'help',
    negatable: false,
    abbr: 'h',
    callback: (help) => usage(help, parser),
  );

  try {
    final ArgResults args = parser.parse(arguments);
    final DayRunner runner = DayRunnerPicker.pick(args['day']);
    final fileContent = await runner.fetch();
    final parsedContent = runner.parse(fileContent);
    await runner.run(parsedContent);
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
  static DayRunner pick(String day) {
    final HashMap<String, DayRunner> days = HashMap.fromEntries([
      MapEntry('1', Day01Runner()),
      MapEntry('01', Day01Runner()),
      MapEntry('2', Day02Runner()),
      MapEntry('02', Day02Runner()),
    ]);

    final runner = days[day];

    if (runner != null) {
      return runner;
    }
    throw DayNotFoundException();
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
