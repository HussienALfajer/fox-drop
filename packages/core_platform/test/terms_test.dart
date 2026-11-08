import 'dart:async';

import 'package:core_platform/core_platform.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

const pending = Terms(version: 2, body: 'الشروط', pending: true);
const accepted = Terms(version: 2, body: 'الشروط', pending: false);
const newer = Terms(version: 3, body: 'الأحدث', pending: true);

DioException conflict() => DioException(
  requestOptions: RequestOptions(path: '/v1/customer/terms/accept'),
  response: Response(
    requestOptions: RequestOptions(path: '/v1/customer/terms/accept'),
    statusCode: 409,
  ),
);

void main() {
  late List<Terms> answers;
  late List<int> sent;
  late Object? refusal;
  late TermsCheck check;

  setUp(() {
    sent = [];
    refusal = null;
    check = TermsCheck(
      read: () async => answers.removeAt(0),
      accept: (version) async {
        sent.add(version);
        if (refusal case final error?) throw error;
      },
    );
  });

  tearDown(() => check.dispose());

  testWidgets('waits on nothing until the first answer', (tester) async {
    answers = [pending];
    expect(check.pending, isFalse);
    check.start();
    await tester.pump();
    expect(check.terms, pending);
    expect(check.pending, isTrue);
  });

  testWidgets('accepts the version shown (CU §15)', (tester) async {
    answers = [pending, accepted];
    await check.check();
    expect(await check.accept(2), TermsAcceptance.accepted);
    expect(sent, [2]);
    expect(check.pending, isFalse);
    await tester.pump();
    expect(check.terms, accepted);
  });

  testWidgets('shows a newer version published meanwhile', (tester) async {
    answers = [pending, newer];
    await check.check();
    refusal = conflict();
    expect(await check.accept(2), TermsAcceptance.outdated);
    expect(check.terms, newer);
    expect(check.pending, isTrue);
  });

  testWidgets('drops an answer that arrives after a sign-out', (tester) async {
    final gate = Completer<Terms>();
    final slow = TermsCheck(read: () => gate.future, accept: (_) async {});
    addTearDown(slow.dispose);
    final read = slow.check();
    slow.clear();
    gate.complete(pending);
    await read;
    expect(slow.terms, isNull);
    expect(slow.pending, isFalse);
  });

  testWidgets('keeps an acceptance over a read sent before it', (tester) async {
    var reads = 0;
    final gate = Completer<Terms>();
    final racing = TermsCheck(
      read: () {
        reads++;
        return reads == 1 ? gate.future : Future.value(accepted);
      },
      accept: (_) async {},
    );
    addTearDown(racing.dispose);
    final before = racing.check();
    expect(await racing.accept(2), TermsAcceptance.accepted);
    gate.complete(pending);
    await before;
    expect(racing.pending, isFalse);
  });
}
