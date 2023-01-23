library ednet_cms;

/// Basic Content abstraction
abstract class Content<T> {
  T get value;
}

abstract class TextContent implements Content<String> {}

class Text implements TextContent {
  @override
  final String value;

  const Text(this.value);
}

class Number implements Content<num> {
  @override
  final num value;

  const Number(this.value);
}

/// again Date and
class Date implements Content<DateTime> {
  @override
  final DateTime value;

  const Date(this.value);
}
