// solidart_widgets.dart

import 'package:flutter/widgets.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
// ignore: implementation_imports
import 'package:solidart/src/core/signal_selector.dart';
import 'package:reduced/reduced.dart';

import 'inherited_widgets.dart';
import 'solidart_store.dart';

typedef EventListener<S> = void Function(
  ReducedStore<S> store,
  Event<S> event,
  DateTime timestamp,
);

class EventListenerDecorator<S> {
  final EventListener<S> decorated;
  DateTime? _timestamp;
  Event<S>? _event;

  EventListenerDecorator(this.decorated);
  void call(
      ReducedStore<S> store, Event<S> event, DateTime timestamp) {
    if (timestamp != _timestamp || event != _event) {
      _timestamp = timestamp;
      _event = event;
      decorated(store, event, timestamp);
    }
  }
}

class ReducedStoreProxyDecorator<S> extends ReducedStoreProxy<S> {
  ReducedStoreProxyDecorator(
      ReducedStoreProxy decorated, this.onEventDispatched)
      : super(
          () => decorated.state,
          decorated.dispatch,
          decorated.identity,
        );
  final EventListener<S>? onEventDispatched;

  @override
  dispatch(event) {
    super.dispatch(event);
    onEventDispatched?.call(this, event, DateTime.now());
  }
}

EventListener<S>? _decorate<S>(EventListener<S>? decorated) {
  if (decorated == null) {
    return null;
  }
  return EventListenerDecorator<S>(decorated);
}

class ReducedProvider<S> extends StatelessWidget {
  ReducedProvider({
    super.key,
    required this.initialState,
    EventListener<S>? onEventDispatched,
    required this.child,
  }) : _onEventDispatched = _decorate(onEventDispatched);

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
    required this.transformer,
    required this.builder,
  });

  final ReducedTransformer<S, P> transformer;
  final ReducedWidgetBuilder<P> builder;

  @override
  Widget build(BuildContext context) => _build(
        context.signal<S>(),
        context.onEventDispatched<S>(),
      );

  Widget _build(
          Signal<S> signal, EventListener<S>? onEventDispatched) =>
      SignalBuilder<P>(
        signal: SignalSelector<S, P>(
          signal: signal,
          selector: (_) => transformer(
            ReducedStoreProxyDecorator(
              signal.proxy,
              onEventDispatched,
            ),
          ),
          options: SignalOptions(comparator: (a, b) => a == b),
        ),
        builder: (_, P value, ___) => builder(props: value),
      );
}
