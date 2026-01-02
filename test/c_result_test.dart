import 'package:flutter_test/flutter_test.dart';

import 'package:rust_monads/result_types.dart';

sealed class CError {}

class TestError extends CError {}

class UnimplementedError extends CError {}

CResult<int, CError> testFunction(int value) {
  if (value == 0) {
    return CResult.from(1);
  } else if (value == 1) {
    return CResult.from(TestError());
  } else {
    return CResult.from(UnimplementedError());
  }
}

CResult<int, CError> testFunctionErr(CError value) => switch (value) {
      TestError() => CResult.from(TestError()),
      UnimplementedError() => CResult.from(UnimplementedError()),
    };

void main() {
  test('Test Result typedef', () {
    final result = Result<int, CError>.from(1);
    assert(result is Success);
    assert(~result == 1);

    final result1 = Result<int, CError>.from(TestError());
    assert(result1 is Failure);
    assert(~result1 is TestError);

    final result2 = Result<int, CError>.from(2);
    assert(result2 is Ok);
    assert(~result2 == 2);

    final result3 = Result<int, CError>.from(UnimplementedError());
    assert(result3 is Err);
    assert(~result3 is UnimplementedError);
  });

  test('Test CResult Type', () {
    final result = CResult<int, CError>.from(1);
    expect(result, isA<COk<int, CError>>());
    expect((result as COk).value, 1);

    final result2 = CResult<int, CError>.from(TestError());
    expect(result2, isA<CErr>());
    expect((result2 as CErr).error, isA<TestError>());

    final result3 = CResult<int, CError>.from(UnimplementedError());
    expect(result3, isA<CErr>());
    expect((result3 as CErr).error, isA<UnimplementedError>());

    final result4 = testFunction(0);
    expect(result4, isA<COk<int, CError>>());
    expect((result4 as COk).value, 1);

    final result5 = testFunction(1);
    expect(result5, isA<CErr>());
    expect((result5 as CErr).error, isA<TestError>());

    final result6 = testFunction(2);
    expect(result6, isA<CErr>());
    expect((result6 as CErr).error, isA<UnimplementedError>());

    final result7 = ~CResult.from(1);
    expect(result7, 1);

    final result8 = ~CResult.from(TestError());
    expect(result8, isA<TestError>());
  });
}
