import 'package:core_auth/testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures.dart';

// CA §11.2 (C14), CU Q16 (slice 2.26c): «تقييمي» from «المزيد», the average,
// the count and the reasons with counts, never a name or a comment.
Future<void> openRating(WidgetTester tester, TestApp app) async {
  await app.pump(tester);
  await app.live(tester);
  await tester.tap(find.text('المزيد'));
  await app.settle(tester);
  await tester.tap(find.byKey(const Key('more-rating')));
  await app.settle(tester);
}

void main() {
  testWidgets('shows the average, the count and the reasons with counts', (
    tester,
  ) async {
    final app = TestApp();
    app.work(availability: [availabilityJson()]);
    app.server.on('/v1/captain/ratings', [
      const FakeAnswer(200, {
        'count': 3,
        'average': 2.7,
        'reasons': [
          {'code': 'late', 'label': 'تأخر', 'count': 2},
          {'code': 'kind', 'label': 'لطيف', 'count': 1},
        ],
      }),
    ]);
    await openRating(tester, app);
    expect(find.text('2.7 من 5'), findsOneWidget);
    expect(find.text('عدد التقييمات: 3'), findsOneWidget);
    expect(find.text('ما اختاره الزبائن'), findsOneWidget);
    expect(find.text('تأخر: 2'), findsOneWidget);
    expect(find.text('لطيف: 1'), findsOneWidget);
    expect(
      find.text('لا تظهر هنا أسماء الزبائن ولا تعليقاتهم.'),
      findsOneWidget,
    );
    await app.done(tester);
  });

  testWidgets('says «لا تقييم بعد» before any rating, and retries', (
    tester,
  ) async {
    final app = TestApp();
    app.work(availability: [availabilityJson()]);
    app.server.on('/v1/captain/ratings', [
      const FakeAnswer(500, {}),
      const FakeAnswer(200, {'count': 0, 'average': null, 'reasons': <Object?>[]}),
    ]);
    await openRating(tester, app);
    await tester.tap(find.text('إعادة المحاولة'));
    await app.settle(tester);
    expect(find.text('لا تقييم بعد'), findsOneWidget);
    expect(find.text('عدد التقييمات: 0'), findsOneWidget);
    expect(find.text('ما اختاره الزبائن'), findsNothing);
    await app.done(tester);
  });
}
