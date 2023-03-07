// solidart_widgets.dart

import 'package:flutter/widgets.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
// ignore: implementation_imports
import 'package:solidart/src/core/signal_selector.dart';
import 'package:reduced/reduced.dart';

import 'solidart_store.dart';

class ReducedProvider<S> extends StatelessWidget {
  const ReducedProvider({
    super.key,
    required this.initialState,
    required this.child,
  });

  final S initialState;
  final Widget child;

  @override
  Widget build(BuildContext context) => Solid(
        signals: {S: () => createSignal<S>(initialState)},
        child: child,
      );
}

class ReducedConsumer<S, P> extends StatelessWidget {
  const ReducedConsumer({
    super.key,
    required this.transformer,
    required this.builder,
  });

  final ReducedTransformer<S, P> transformer;
  final ReducedWidgetBuilder<P> builder;

  @override
  Widget build(BuildContext context) => _build(context.signal<S>());

  Widget _build(Signal<S> signal) => SignalBuilder<P>(
        signal: SignalSelector<S, P>(
          signal: signal,
          selector: (_) => transformer(signal.store),
          options: SignalOptions(comparator: (a, b) => a == b),
        ),
        builder: (_, P value, ___) => builder(props: value),
      );
}
