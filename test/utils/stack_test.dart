import 'package:aoc_2021/utils/stack.dart';
import 'package:test/test.dart';

void main() {
  group('\nstack\n', () {
    group('given I initialise an empty stack\n', () {
      test('it is empty\n', () {
        final Stack<String> stack = Stack();

        expect(stack.size(), equals(0));
        expect(stack.isEmpty, true);
        expect(stack.isNotEmpty, false);
      });

      test('I add values to the stack\n', () {
        // arrange
        final Stack<int> stack = Stack();

        // act
        stack.push(0);
        stack.push(1);

        // assert
        expect(stack.size(), equals(2));
      });

      test('I observe the value on top of the stack\n', () {
        // arrange
        final Stack<int> empty = Stack();
        final Stack<int> stack = Stack();

        // act
        stack.push(0);
        stack.push(1);

        // assert
        expect(stack.top(), equals(1));
        expect(empty.top(), isNull);
      });

      test('I pop value out of the stack\n', () {
        // arrange
        final Stack<int> empty = Stack();
        final Stack<int> stack = Stack();
        stack.push(0);
        stack.push(1);

        // act
        final value = stack.pop();
        final nonValue = empty.pop();

        // assert
        expect(value, equals(1));
        expect(stack.size(), equals(1));
        expect(stack.top(), equals(0));

        expect(nonValue, isNull);
      });
    });
  });
}
