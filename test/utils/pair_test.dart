import 'package:aoc_2021/utils/pair.dart';
import 'package:test/expect.dart';
import 'package:test/test.dart';

void main() {
  group('\npair\n', () {
    test('I can define and access a pair\n', () {
      final Pair<String, int> pair = Pair('coucou', 1);

      expect(pair.left, equals('coucou'));
      expect(pair.right, equals(1));
    });
  });
}
