import 'package:ednet_cms/ednet_cms.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('That Content have vale of correct type, be that ', () {
    test('Text', () {
      const name = Text('EDNetCMS');
      expect(name.value, 'EDNetCMS');

      // name is a string
      expect(name.value, isA<String>());
    });
    test('Number', () {
      const name = Number(10);
      expect(name.value, 10);

      // name is a string
      expect(name.value, isA<num>());
    });
    test('Or a Date', () {
      final now = DateTime.now();
      final date = Date(now);
      expect(date.value, now);

      // name is a string
      expect(date.value, isA<DateTime>());
    });
  });
}
