class StackItem<T> {
  final T _value;
  final StackItem<T>? _prev;

  StackItem(this._value, this._prev);

  T get value => _value;
  StackItem<T>? get prev => _prev;
}

class Stack<T> {
  int _size = 0;
  StackItem<T>? _top;

  Stack();

  void push(T value) {
    _top = StackItem(value, _top);
    _size++;
  }

  T? top() => _top?.value;

  T? pop() {
    if (_top != null) {
      final cpy = _top!;

      _top = _top!.prev;

      _size--;
      return cpy.value;
    }
  }

  int size() => _size;
  bool get isEmpty => _size == 0;
  bool get isNotEmpty => _size != 0;
}
