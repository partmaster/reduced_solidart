// transformer.dart

import 'package:reduced/reduced.dart';

import 'props.dart';
import 'events.dart';
import 'state.dart';

MyHomePageProps transformMyHomePageProps(
  ReducedStore<MyAppState> store,
) =>
    MyHomePageProps(
      onPressed: CallableAdapter(store, CounterIncremented.instance),
      title: store.state.title,
    );

MyCounterWidgetProps transformMyCounterWidgetProps(
  ReducedStore<MyAppState> store,
) =>
    MyCounterWidgetProps(
      counterText: '${store.state.counter}',
    );
