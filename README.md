![GitHub release (latest by date)](https://img.shields.io/github/v/release/partmaster/reduced_solidart)
![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/partmaster/reduced_solidart/dart.yml)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/partmaster/reduced_solidart)
![GitHub last commit](https://img.shields.io/github/last-commit/partmaster/reduced_solidart)
![GitHub commit activity](https://img.shields.io/github/commit-activity/m/partmaster/reduced_solidart)
# reduced_solidart

Implementation of the 'reduced' API for the 'Solidart' state management framework with following features:

1. Implementation of the ```ReducedStore``` interface 
2. Extension on the ```BuildContext``` for convenient access to the  ```ReducedStore``` instance.
3. Register a state for management.
4. Trigger a rebuild on widgets selectively after a state change.

## Features

#### 1. Implementation of the ```ReducedStore``` interface 

```dart
extension ReducedStoreSignal<S> on Signal<S> {
  S getState() => value;

  void reduce(Reducer<S> reducer) => value = reducer(value);

  ReducedStore<S> get store =>
      ReducedStoreProxy(getState, reduce, this);
}
```

#### 2. Extension on the ```BuildContext``` for convenient access to the  ```ReducedStore``` instance.

```dart
extension ExtensionSignalOnBuildContext on BuildContext {
  Signal<S> signal<S>() => get<Signal<S>>(S);
}
```

#### 3. Register a state for management.

```dart
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
```

#### 4. Trigger a rebuild on widgets selectively after a state change.

```dart
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
```

## Getting started

In the pubspec.yaml add dependencies on the package 'reduced' and on the package  'reduced_solidart'.

```
dependencies:
  reduced: 0.2.1
  reduced_solidart: 0.2.1
```

Import package 'reduced' to implement the logic.

```dart
import 'package:reduced/reduced.dart';
```

Import package 'reduced_solidart' to use the logic.

```dart
import 'package:reduced_solidart/reduced_solidart.dart';
```

## Usage

Implementation of the counter demo app logic with the 'reduced' API without further dependencies on state management packages.

```dart
// logic.dart

import 'package:flutter/material.dart';
import 'package:reduced/reduced.dart';

class Incrementer extends Reducer<int> {
  @override
  int call(int state) => state + 1;
}

class Props {
  Props({required this.counterText, required this.onPressed});
  final String counterText;
  final Callable<void> onPressed;
}

class PropsTransformer {
  static Props transform(ReducedStore<int> store) => Props(
        counterText: '${store.state}',
        onPressed: CallableAdapter(store, Incrementer()),
      );
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.props});

  final Props props;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('reduced_solidart example')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(props.counterText),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: props.onPressed,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      );
}
```

Finished counter demo app using logic.dart and 'reduced_solidart' package:

```dart
// main.dart

import 'package:flutter/material.dart';
import 'package:reduced_solidart/reduced_solidart.dart';
import 'logic.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => ReducedProvider(
        initialState: 0,
        child: MaterialApp(
          theme: ThemeData(primarySwatch: Colors.blue),
          home: const ReducedConsumer(
            transformer: PropsTransformer.transform,
            builder: MyHomePage.new,
          ),
        ),
      );
}
```

# Additional information

Implementations of the 'reduced' API are available for the following state management frameworks:

|framework|implementation package for 'reduced' API|
|---|---|
|[Binder](https://pub.dev/packages/binder)|[reduced_binder](https://github.com/partmaster/reduced_binder)|
|[Bloc](https://bloclibrary.dev/#/)|[reduced_bloc](https://github.com/partmaster/reduced_bloc)|
|[FlutterCommand](https://pub.dev/packages/flutter_command)|[reduced_fluttercommand](https://github.com/partmaster/reduced_fluttercommand)|
|[FlutterTriple](https://pub.dev/packages/flutter_triple)|[reduced_fluttertriple](https://github.com/partmaster/reduced_fluttertriple)|
|[GetIt](https://pub.dev/packages/get_it)|[reduced_getit](https://github.com/partmaster/reduced_getit)|
|[GetX](https://pub.dev/packages/get)|[reduced_getx](https://github.com/partmaster/reduced_getx)|
|[MobX](https://pub.dev/packages/mobx)|[reduced_mobx](https://github.com/partmaster/reduced_mobx)|
|[Provider](https://pub.dev/packages/provider)|[reduced_provider](https://github.com/partmaster/reduced_provider)|
|[Redux](https://pub.dev/packages/redux)|[reduced_redux](https://github.com/partmaster/reduced_redux)|
|[Riverpod](https://riverpod.dev/)|[reduced_riverpod](https://github.com/partmaster/reduced_riverpod)|
|[Solidart](https://pub.dev/packages/solidart)|[reduced_solidart](https://github.com/partmaster/reduced_solidart)|
|[StatesRebuilder](https://pub.dev/packages/states_rebuilder)|[reduced_statesrebuilder](https://github.com/partmaster/reduced_statesrebuilder)|
