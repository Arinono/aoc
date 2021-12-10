import 'package:aoc_2021/day10/day10.dart';
import 'package:aoc_2021/utils/pair.dart';
import 'package:test/test.dart';

class UnexpectedTestFailureException implements Exception {
  final String reason;
  UnexpectedTestFailureException(this.reason);

  @override
  String toString() {
    return reason;
  }
}

void main() {
  group('\nday10\n', () {
    group('given I have a valid line input\n', () {
      test('it doesn\'t throw\n', () {
        // arrange
        final List<List<String>> inputs = List.from([
          List.of(['()[]{}<>']),
          List.of(['([])']),
          List.of(['{()()()}']),
          List.of(['<([{}])>']),
          List.of(['[<>({}){}[([])<>]]']),
          List.of(['(((((((((())))))))))']),
        ]);

        // act/assert
        try {
          for (final line in inputs) {
            Instructions.from(line);
          }
        } catch (e) {
          throw UnexpectedTestFailureException(
            'Expection constructor to succeed but failed.',
          );
        }
      });
    }, skip: true); // was a valid test until I had to handle the errors

    group('given I have an invalid line input\n', () {
      test('it doesn\'t throw\n', () {
        // arrange
        final List<Pair<Char, List<String>>> inputs = List.from([
          Pair(Bracket(), List.of(['(]'])),
          Pair(Chevron(), List.of(['{()()()>'])),
          Pair(Curly(), List.of(['(((()))}'])),
          Pair(Parenthesis(), List.of(['<([]){()}[{}])'])),
        ]);

        // act/assert
        for (final pair in inputs) {
          try {
            Instructions.from(pair.right);
          } on CorruptedLineError catch (e) {
            expect(e.received.runtimeType, equals(pair.left.runtimeType));
            continue;
          }
          throw UnexpectedTestFailureException(
            'Expection constructor to throw a \'CorruptedLineError\' but didn\'t.',
          );
        }
      });
    }, skip: true); // was a valid test until I had to handle the errors

    group('given I have multiple line inputs\n', () {
      test('I can count the syntax error score\n', () {
        // act
        final List<String> input = List.of([
          '[({(<(())[]>[[{[]{<()<>>',
          '[(()[<>])]({[<{<<[]>>(',
          '{([(<{}[<>[]}>{[]{[(<()>',
          '(((({<>}<{<{<>}{[]{[]{}',
          '[[<[([]))<([[{}[[()]]]',
          '[{[{({}]{}}([{[{{{}}([]',
          '{<[[]]>}<{[{[{[]{()[[[]',
          '[<(<(<(<{}))><([]([]()',
          '<{([([[(<>()){}]>(<<{{',
          '<{([{{}}[<[[[<>{}]]]>[]]',
        ]);

        // act
        final Instructions instructions = Instructions.from(input);

        // assert
        expect(instructions.syntaxErrorScore, equals(26397));
      });

      test('I can count the autocomplete score\n', () {
        // act
        final List<String> input = List.of([
          '[({(<(())[]>[[{[]{<()<>>',
          '[(()[<>])]({[<{<<[]>>(',
          '{([(<{}[<>[]}>{[]{[(<()>',
          '(((({<>}<{<{<>}{[]{[]{}',
          '[[<[([]))<([[{}[[()]]]',
          '[{[{({}]{}}([{[{{{}}([]',
          '{<[[]]>}<{[{[{[]{()[[[]',
          '[<(<(<(<{}))><([]([]()',
          '<{([([[(<>()){}]>(<<{{',
          '<{([{{}}[<[[[<>{}]]]>[]]',
        ]);

        // act
        final Instructions instructions = Instructions.from(input);

        // assert
        expect(instructions.autocompleteScore, equals(288957));
      });
    });
  });
}
