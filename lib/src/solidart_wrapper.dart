// solidart_wrapper.dart

import 'package:flutter/widgets.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
// ignore: implementation_imports
import 'package:solidart/src/core/signal_selector.dart';
import 'package:reduced/reduced.dart';

import 'solidart_reducible.dart';

Widget wrapWithProvider<S>({
  required S initialState,
  required Widget child,
}) =>
    Solid(
      signals: {S: () => createSignal<S>(initialState)},
      child: child,
    );

Widget wrapWithConsumer<S, P>({
  required ReducedTransformer<S, P> transformer,
  required ReducedWidgetBuilder<P> builder,
}) =>
    Builder(
        builder: (context) => internalWrapWithConsumer(
              signal: context.signal<S>(),
              transformer: transformer,
              builder: builder,
            ));

@visibleForTesting
SignalBuilder<P> internalWrapWithConsumer<S, P>({
  required Signal<S> signal,
  required ReducedTransformer<S, P> transformer,
  required ReducedWidgetBuilder<P> builder,
}) =>
    SignalBuilder<P>(
      signal: SignalSelector<S, P>(
        signal: signal,
        selector: (_) => transformer(signal.reducible),
        options: SignalOptions(comparator: (a, b) => a == b),
      ),
      builder: (_, P value, ___) => builder(props: value),
    );
