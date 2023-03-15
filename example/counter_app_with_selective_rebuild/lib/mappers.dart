// mappers.dart

import 'package:reduced/reduced.dart';

import 'props.dart';
import 'events.dart';
import 'state.dart';

class MyHomePagePropsMapper extends MyHomePageProps {
  MyHomePagePropsMapper(
    MyAppState state,
    EventProcessor<MyAppState> processor,
  ) : super(
          onPressed: EventCarrier(processor, CounterIncremented.instance),
          title: state.title,
        );
}

class MyCounterWidgetPropsMapper extends MyCounterWidgetProps {
  MyCounterWidgetPropsMapper(
    MyAppState state,
    EventProcessor<MyAppState> processor,
  ) : super(
          counterText: '${state.counter}',
        );
}
