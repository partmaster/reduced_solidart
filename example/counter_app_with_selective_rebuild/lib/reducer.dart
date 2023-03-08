// reducer.dart

import 'package:reduced/reduced.dart';

import 'state.dart';

class Incrementer extends Reducer<MyAppState> {
  const Incrementer._();

  static final instance = Incrementer._();

  @override
  call(state) => state.copyWith(counter: state.counter + 1);
}
