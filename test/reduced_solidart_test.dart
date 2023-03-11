import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reduced/reduced.dart';

import 'package:reduced_solidart/reduced_solidart.dart';

class CounterIncremented extends Event<int> {
  @override
  int call(int state) => state + 1;
}

void main() {
  test('Signal state 0', () {
    final objectUnderTest = Signal(0).store;
    expect(objectUnderTest.state, 0);
  });

  test('Signal state 1', () {
    final objectUnderTest = Signal(1).store;
    expect(objectUnderTest.state, 1);
  });

  test('Signal dispatch', () async {
    final objectUnderTest = Signal(0).store;
    objectUnderTest.dispatch(CounterIncremented());
    expect(objectUnderTest.state, 1);
  });
}
