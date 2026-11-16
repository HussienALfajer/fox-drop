import 'package:dio/dio.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:merchant/src/account/records.dart';

DioException _answer(int status) => DioException(
  requestOptions: RequestOptions(),
  response: Response(requestOptions: RequestOptions(), statusCode: status),
);

void main() {
  // RA §12.3: the status by its name, whichever generated enum carries it.
  test('a statement status is read by its name', () {
    expect(statusOf('unpaid'), StatementStatus.unpaid);
    expect(statusOf('partlyPaid'), StatementStatus.partlyPaid);
    expect(statusOf('paid'), StatementStatus.paid);
    expect(statusOf(null), isNull);
  });

  // R10: a cashier and another restaurant's record are not worth a retry.
  test('a failed read says who may read it or that it is unknown', () {
    expect(failureOf(_answer(403)), RecordsFailure.ownersOnly);
    expect(failureOf(_answer(404)), RecordsFailure.notFound);
    expect(failureOf(_answer(400)), RecordsFailure.notFound);
    expect(failureOf(_answer(500)), RecordsFailure.other);
    expect(failureOf(StateError('offline')), RecordsFailure.other);
  });

  // RA §12.3: a busy week's statement still renders as an image.
  test('a tall statement renders below the screen ratio', () {
    expect(imageRatio(2.75, const Size(400, 900)), 2.75);
    expect(imageRatio(2.75, const Size(400, 8192)), 1);
    expect(imageRatio(3, const Size(400, 16384)), 0.5);
    expect(imageRatio(2, Size.zero), 2);
  });
}
