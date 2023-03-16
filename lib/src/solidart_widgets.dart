// solidart_widgets.dart

import 'package:flutter/widgets.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:reduced/proxy.dart';
// ignore: implementation_imports
import 'package:solidart/src/core/signal_selector.dart';
import 'package:reduced/reduced.dart';

import 'inherited_widgets.dart';
import 'solidart_store.dart';

class ReducedProvider<S> extends StatelessWidget {
  ReducedProvider({
    super.key,
    required this.initialState,
    required this.child,
    EventListener<S>? onEventDispatched,
  }) : _onEventDispatched = DistinctEventListener.decorate(onEventDispatched);

  final S initialState;
  final Widget child;
  final EventListener<S>? _onEventDispatched;

  @override
  Widget build(BuildContext context) => InheritedValueWidget(
        value: _onEventDispatched,
        child: Solid(
          signals: {S: () => createSignal<S>(initialState)},
          child: child,
        ),
      );
}

extension EventListenerOnBuildContext on BuildContext {
  EventListener<S>? onEventDispatched<S>() =>
      InheritedValueWidget.of<EventListener<S>?>(this);
}

class ReducedConsumer<S, P> extends StatelessWidget {
  const ReducedConsumer({
    super.key,
    required this.mapper,
    required this.builder,
  });

  final StateToPropsMapper<S, P> mapper;
  final WidgetFromPropsBuilder<P> builder;

  @override
  Widget build(BuildContext context) => _build(
        context.signal<S>(),
        context.onEventDispatched<S>(),
      );

  Widget _build(Signal<S> signal, EventListener<S>? onEventDispatched) =>
      SignalBuilder<P>(
        signal: SignalSelector<S, P>(
          signal: signal,
          selector: (_) => mapper(
            signal.getState(),
            StoreProxy(
              () => signal.getState(),
              signal.proxy.process,
              signal,
              onEventDispatched,
            ),
          ),
          options: SignalOptions(comparator: (a, b) => a == b),
        ),
        builder: (_, P value, ___) => builder(props: value),
      );
}

/// A decorator for an [EventListener] that skips events if they are equal to the previous event.
///
///
class DistinctEventListener<S> {
  final EventListener<S> decorated;
  UniqueKey? _key;

  DistinctEventListener(this.decorated);

  void call(Store<S> store, Event<S> event, UniqueKey key) {
    if (key != _key) {
      _key = key;
      decorated(store, event, key);
    }
  }

  static EventListener<S>? decorate<S>(
    EventListener<S>? decorated,
  ) =>
      decorated == null ? null : DistinctEventListener<S>(decorated).call;
}
