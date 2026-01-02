import 'package:flutter_test/flutter_test.dart';
import 'package:rust_monads/option.dart';

void main() {
  test('Test Option Type', () {
    final result = Option<int>.from(1);
    expect(result, isA<Some<int>>());
    expect((result as Some).value, 1);

    final result2 = Option<int>.from(0);
    expect(result2, isA<Some<int>>());
    expect((result2 as Some).value, 0);

    final result3 = Option.none();
    expect(result3, isA<None>());

    final result4 = ~Option.from(1);
    expect(result4, 1);

    final result5 = ~Option.none();
    expect(result5, isA<None>());
  });
}
