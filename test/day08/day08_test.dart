import 'package:aoc_2021/day08/day08.dart';
import 'package:test/test.dart';

void main() {
  group('\nday08\n', () {
    group('given a single input/output line\n', () {
      test('I parse the entries\n', () {
        // arrange
        final List<String> lines = List.from([
          'acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf'
        ]);

        // act
        final Notes notes = Notes.from(lines);

        // assert
        expect(
          notes.signals.first.keys,
          containsAllInOrder([
            <String>{'a', 'c', 'e', 'd', 'g', 'f', 'b'},
            <String>{'c', 'd', 'f', 'b', 'e'},
            <String>{'g', 'c', 'd', 'f', 'a'},
            <String>{'f', 'b', 'c', 'a', 'd'},
            <String>{'d', 'a', 'b'},
            <String>{'c', 'e', 'f', 'a', 'b', 'd'},
            <String>{'c', 'd', 'f', 'g', 'e', 'b'},
            <String>{'e', 'a', 'f', 'b'},
            <String>{'c', 'a', 'g', 'e', 'd', 'b'},
            <String>{'a', 'b'},
          ]),
        );
        expect(notes.signals.first.values,
            containsAllInOrder([8, 5, 2, 3, 7, 9, 6, 4, 0, 1]));

        expect(
          notes.outputs.first.keys,
          containsAllInOrder([
            <String>{'c', 'd', 'f', 'e', 'b'},
            <String>{'f', 'c', 'a', 'd', 'b'},
            <String>{'c', 'd', 'f', 'e', 'b'},
            <String>{'c', 'd', 'b', 'a', 'f'},
          ]),
        );
        expect(
          notes.outputs.first.values,
          containsAllInOrder([5, 3, 5, 3]),
        );
      });
    });

    group('given a multiple input/output lines\n', () {
      test('I get the unambiguous digits\n', () {
        // arrange
        final List<String> lines = List.of([
          'be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe',
          'edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc',
          'fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg',
          'fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb',
          'aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea',
          'fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb',
          'dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe',
          'bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef',
          'egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb',
          'gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce',
        ]);
        final Notes notes = Notes.from(lines);

        // act
        final List<Map<Set<String>, int>> outputs = notes.outputs;

        // assert
        expect(outputs.length, equals(10));
        expect(
          outputs.map((o) => o.values.toList()),
          containsAllInOrder([
            List.of([8, 3, 9, 4]),
            List.of([9, 7, 8, 1]),
            List.of([1, 1, 9, 7]),
            List.of([9, 3, 6, 1]),
            List.of([4, 8, 7, 3]),
            List.of([8, 4, 1, 8]),
            List.of([4, 5, 4, 8]),
            List.of([1, 6, 2, 5]),
            List.of([8, 7, 1, 7]),
            List.of([4, 3, 1, 5]),
          ]),
        );

        expect(notes.outputs.sum, equals(61229));
      });
    });
  });
}
