// state.dart

class MyAppState {
  MyAppState({this.counter = 0, required this.title});

  final int counter;
  final String title;

  MyAppState copyWith({int? counter, String? title}) => MyAppState(
        counter: counter ?? this.counter,
        title: title ?? this.title,
      );

  @override
  get hashCode => Object.hash(counter, title);

  @override
  operator ==(other) =>
      other is MyAppState && counter == other.counter && title == other.title;
}
