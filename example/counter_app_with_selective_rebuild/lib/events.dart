// events.dart

import 'package:reduced/reduced.dart';

import 'state.dart';

class CounterIncremented extends Event<MyAppState> {
  const CounterIncremented._();

  static const instance = CounterIncremented._();

  @override
  call(state) => state.copyWith(counter: state.counter + 1);
}
