// consumer.dart

import 'package:flutter/widgets.dart';
import 'package:reduced/reduced.dart';
import 'package:reduced_solidart/reduced_solidart.dart';

import 'props.dart';
import 'transformer.dart';

class MyHomePagePropsConsumer extends StatelessWidget {
  const MyHomePagePropsConsumer({
    super.key,
    required this.builder,
  });

  final ReducedWidgetBuilder<MyHomePageProps> builder;

  @override
  Widget build(BuildContext context) => ReducedConsumer(
        transformer: transformMyHomePageProps,
        builder: builder,
      );
}

class MyCounterWidgetPropsConsumer extends StatelessWidget {
  const MyCounterWidgetPropsConsumer({
    super.key,
    required this.builder,
  });

  final ReducedWidgetBuilder<MyCounterWidgetProps> builder;

  @override
  Widget build(context) => ReducedConsumer(
        transformer: transformMyCounterWidgetProps,
        builder: builder,
      );
}
