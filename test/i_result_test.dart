import 'package:flutter_test/flutter_test.dart';
import 'package:rust_monads/result_types.dart';

class TestError extends IError {}

class UnimplementedError extends IError {}

enum ErrorType implements IErrorType {
  testError,
  unimplementedError;

  @override
  IError from(dynamic value) {
    return switch (this) {
      ErrorType.testError => TestError(),
      ErrorType.unimplementedError => UnimplementedError(),
    };
  }
}

IResult<int> testFunction(int value) {
  if (value == 0) {
    return IResult.from(1);
  } else if (value == 1) {
    return IResult.from(TestError());
  } else {
    return IResult.from(UnimplementedError());
  }
}

IResult<int> testFunctionErr(ErrorType value) => IErr.from(value);

ErrorType testFunctionErrExhastiveness(ErrorType value) {
  return switch (value) {
    ErrorType.testError => ErrorType.testError,
    ErrorType.unimplementedError => ErrorType.unimplementedError,
  };
}

void main() {
  test('Test IResult Type', () {
    final result = IResult<int>.from(1);
    expect(result, isA<IOk<int>>());
    expect((result as IOk<int>).value, 1);

    final result2 = IResult<int>.from(TestError());
    expect(result2, isA<IErr>());
    expect((result2 as IErr).error, isA<TestError>());

    final result3 = IResult<int>.from(UnimplementedError());
    expect(result3, isA<IErr>());
    expect((result3 as IErr).error, isA<UnimplementedError>());

    final result4 = testFunction(0);
    expect(result4, isA<IOk<int>>());
    expect((result4 as IOk<int>).value, 1);

    final result5 = testFunction(1);
    expect(result5, isA<IErr>());
    expect((result5 as IErr).error, isA<TestError>());

    final result6 = testFunction(2);
    expect(result6, isA<IErr>());
    expect((result6 as IErr).error, isA<UnimplementedError>());

    final result7 = ~IResult.from(1);
    expect(result7, 1);

    final result8 = ~IResult.from(TestError());
    expect(result8, isA<TestError>());
  });

  test('Test IResult Type Exhaustiveness', () {
    final result = testFunctionErrExhastiveness(ErrorType.testError);
    expect(result, ErrorType.testError);

    final result2 = testFunctionErrExhastiveness(ErrorType.unimplementedError);
    expect(result2, ErrorType.unimplementedError);
  });
}
