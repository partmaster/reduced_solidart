// solidart_reducible.dart

import 'package:flutter/widgets.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:reduced/reduced.dart';

/// Extension on class [Signal] with support of the [Reducible] interface.
extension ReducibleSignal<S> on Signal<S> {
  S getState() => value;

  void reduce(Reducer<S> reducer) => value = reducer(value);

  Reducible<S> get reducible => ReducibleProxy(getState, reduce, this);
}

extension ExtensionSignalOnBuildContext on BuildContext {
  /// Convenience method for getting a [Signal] instance.
  Signal<S> signal<S>() => get<Signal<S>>(S);
}
