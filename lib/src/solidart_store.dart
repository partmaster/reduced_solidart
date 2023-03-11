// solidart_store.dart

import 'package:flutter/widgets.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:reduced/reduced.dart';

/// Extension on class [Signal] with support of the [ReducedStore] interface.
extension ReducedStoreSignal<S> on Signal<S> {
  S getState() => value;

  void dispatch(Event<S> event) => value = event(value);

  ReducedStore<S> get store => ReducedStoreProxy(getState, dispatch, this);
}

extension ExtensionSignalOnBuildContext on BuildContext {
  /// Convenience method for getting a [Signal] instance.
  Signal<S> signal<S>() => get<Signal<S>>(S);
}
