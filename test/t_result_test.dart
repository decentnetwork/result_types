import 'package:flutter_test/flutter_test.dart';
import 'package:rust_monads/result_types.dart';

class TestError extends TError {
  @override
  TError from(dynamic value) {
    return TestError();
  }
}

class UnimplementedError extends TError {
  @override
  TError from(dynamic value) {
    return UnimplementedError();
  }
}

TResult<int> testFunction(int value) {
  if (value == 0) {
    return TResult.from(1);
  } else if (value == 1) {
    return TResult.from(TestError());
  } else {
    return TResult.from(UnimplementedError());
  }
}

TResult<int> testFunctionErr(TError value) => TErr.from(value);

TError testFunctionErrExhastiveness(TError value) {
  switch (value) {
    case TestError():
      return TestError();
    default:
      return UnimplementedError();
  }
}

void main() {
  test('Test TResult Type', () {
    final result = TResult<int>.from(1);
    expect(result, isA<TOk<int>>());
    expect((result as TOk<int>).value, 1);

    final result2 = TResult<int>.from(TestError());
    expect(result2, isA<TErr>());
    expect((result2 as TErr).error, isA<TestError>());

    final result3 = TResult<int>.from(UnimplementedError());
    expect(result3, isA<TErr>());
    expect((result3 as TErr).error, isA<UnimplementedError>());

    final result4 = testFunction(0);
    expect(result4, isA<TOk<int>>());
    expect((result4 as TOk<int>).value, 1);

    final result5 = testFunction(1);
    expect(result5, isA<TErr>());
    expect((result5 as TErr).error, isA<TestError>());

    final result6 = testFunction(2);
    expect(result6, isA<TErr>());
    expect((result6 as TErr).error, isA<UnimplementedError>());

    final result7 = ~TResult.from(1);
    expect(result7, 1);

    final result8 = ~TResult.from(TestError());
    expect(result8, isA<TestError>());
  });
}
