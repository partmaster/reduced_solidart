import 'package:flutter/widgets.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reduced/reduced.dart';

import 'package:reduced_solidart/reduced_solidart.dart';

class Incrementer extends Reducer<int> {
  @override
  int call(int state) {
    return state + 1;
  }
}

void main() {
  test('Signal state 0', () {
    final objectUnderTest = Signal(0).reducible;
    expect(objectUnderTest.state, 0);
  });

  test('Signal state 1', () {
    final objectUnderTest = Signal(1).reducible;
    expect(objectUnderTest.state, 1);
  });

  test('Signal reduce', () async {
    final objectUnderTest = Signal(0).reducible;
    objectUnderTest.reduce(Incrementer());
    expect(objectUnderTest.state, 1);
  });

  test('wrapWithProvider', () {
    const child = SizedBox();
    final objectUnderTest = wrapWithProvider(
      initialState: 0,
      child: child,
    );
    expect(objectUnderTest, isA<Solid>());
    final solid = objectUnderTest as Solid;
    expect(solid.child, child);
  });

  test('wrapWithConsumer', () {
    final signal = Signal(0);
    const child = SizedBox();
    final objectUnderTest = signal.wrapWithConsumer(
      builder: ({Key? key, required int props}) => child,
      transformer: (reducible) => 1,
    );
    expect(objectUnderTest, isA<SignalBuilder<int>>());
  });
}
