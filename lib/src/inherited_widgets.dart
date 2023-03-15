// inherited_widgets.dart

import 'package:flutter/widgets.dart';

class InheritedValueWidget<V> extends InheritedWidget {
  const InheritedValueWidget({
    super.key,
    required super.child,
    required this.value,
  });

  final V value;

  static U of<U>(BuildContext context) =>
      _widgetOf<InheritedValueWidget<U>>(context).value;

  static W _widgetOf<W extends InheritedValueWidget>(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<W>();
    if (result == null) {
      throw AssertionError('InheritedValueWidget._widgetOf<$W> return null');
    }
    return result;
  }

  @override
  bool updateShouldNotify(InheritedValueWidget oldWidget) =>
      value != oldWidget.value;
}
