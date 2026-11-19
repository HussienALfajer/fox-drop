import 'package:core_auth/testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures.dart';

// CA §11 «أدائي» (slice 2.36b): the rate with its warning and the offers
// counted, on time, the cancellations, online hours, the violations with
// their appeal, and home's warning below captain.acceptance_alert_pct.
Future<void> openPerformance(WidgetTester tester, TestApp app) async {
  await app.pump(tester);
  await app.live(tester);
  await tester.tap(find.text('المزيد'));
  await app.settle(tester);
  await tester.tap(find.byKey(const Key('more-performance')));
  await app.settle(tester);
}

Map<String, Object?> violationJson({
  String id = '00000000-0000-4000-8000-0000000000a1',
  String step = 'suspension_1d',
  Map<String, Object?>? appeal,
}) => {
  'id': id,
  'recordedAt': '2026-11-18T09:00:00.000Z',
  'type': 'تأخير متكرر',
  'step': step,
  'orderNumber': '10023',
  'suspendedUntil': step == 'suspension_1d' ? '2026-11-19T09:00:00.000Z' : null,
  'appeal': appeal,
};

void main() {
  testWidgets('shows the rate, its offers, the figures and the violations', (
    tester,
  ) async {
    final app = TestApp();
    app.work(availability: [availabilityJson()]);
    app.server.on('/v1/captain/ratings', [
      const FakeAnswer(200, {
        'count': 0,
        'average': null,
        'reasons': <Object?>[],
      }),
    ]);
    app.server.on('/v1/captain/performance', [
      FakeAnswer(
        200,
        performanceJson(
          rate: 67,
          warn: true,
          offers: [
            {
              'offeredAt': '2026-11-18T10:00:00.000Z',
              'restaurantName': 'مطعم الياسمين',
              'response': 'declined',
            },
          ],
          violations: [
            violationJson(),
            violationJson(
              id: '00000000-0000-4000-8000-0000000000a2',
              step: 'warning',
              appeal: {
                'ticketId': '00000000-0000-4000-8000-0000000000b1',
                'outcome': 'accepted',
              },
            ),
          ],
        ),
      ),
    ]);
    await openPerformance(tester, app);
    expect(find.text('نسبة القبول: 67%'), findsOneWidget);
    expect(find.text('قبلت 2 من 3 (آخر 50 عرضاً)'), findsOneWidget);
    expect(
      find.text('نسبة قبولك منخفضة (67%). حاول قبول العروض المناسبة لك.'),
      findsOneWidget,
    );
    expect(
      find.text('18/11/2026 1:00 م — مطعم الياسمين — رُفض'),
      findsOneWidget,
    );
    expect(find.text('في الوقت: 4 من 5'), findsOneWidget);
    expect(find.text('إلغاءاتك خلال 90 يوماً: 1'), findsOneWidget);
    expect(
      find.text('ساعات الاتصال: اليوم 1.5 س، هذا الأسبوع 10 س'),
      findsOneWidget,
    );
    expect(find.text('لا تقييم بعد'), findsOneWidget);
    expect(find.text('18/11/2026: تأخير متكرر — إيقاف يوم'), findsOneWidget);
    expect(find.text('الطلب #10023'), findsNWidgets(2));
    expect(find.text('موقوف حتى 19/11/2026 12:00 م'), findsOneWidget);
    expect(find.text('18/11/2026: تأخير متكرر — تنبيه'), findsOneWidget);
    expect(find.text('قُبل اعتراضك وأُلغيت المخالفة'), findsOneWidget);
    await app.done(tester);
  });

  testWidgets('home warns below the alert threshold and opens «أدائي»', (
    tester,
  ) async {
    final app = TestApp();
    app.work(availability: [availabilityJson()]);
    app.server.on('/v1/captain/ratings', [
      const FakeAnswer(200, {
        'count': 0,
        'average': null,
        'reasons': <Object?>[],
      }),
    ]);
    app.server.on('/v1/captain/performance', [
      FakeAnswer(200, performanceJson(rate: 60, warn: true)),
    ]);
    await app.pump(tester);
    await app.live(tester);
    final warning = find.byKey(const Key('home-acceptance-warning'));
    expect(warning, findsOneWidget);
    await app.tapVisible(tester, warning);
    await app.settle(tester);
    expect(find.text('نسبة القبول: 60%'), findsOneWidget);
    await app.done(tester);
  });

  testWidgets('«اعتراض» sends the text and shows the ticket', (tester) async {
    final app = TestApp();
    app.work(availability: [availabilityJson()]);
    app.server.on('/v1/captain/ratings', [
      const FakeAnswer(200, {
        'count': 0,
        'average': null,
        'reasons': <Object?>[],
      }),
    ]);
    // Home's read, «أدائي»'s, then the read after the appeal.
    app.server.on('/v1/captain/performance', [
      FakeAnswer(200, performanceJson(violations: [violationJson()])),
      FakeAnswer(200, performanceJson(violations: [violationJson()])),
      FakeAnswer(
        200,
        performanceJson(
          violations: [
            violationJson(
              appeal: {
                'ticketId': '00000000-0000-4000-8000-0000000000b1',
                'outcome': null,
              },
            ),
          ],
        ),
      ),
    ]);
    const url =
        '/v1/captain/violations/00000000-0000-4000-8000-0000000000a1/appeal';
    app.server.on(url, [
      const FakeAnswer(200, {
        'ticket': {
          'id': '00000000-0000-4000-8000-0000000000b1',
          'number': '5521',
          'typeLabel': 'اعتراض على مخالفة',
          'orderId': null,
          'orderNumber': '10023',
          'description': 'كان الطريق مغلقاً',
          'status': 'new',
          'openedAt': '2026-11-19T09:00:00.000Z',
          'openedBy': 'me',
          'replyWithinMinutes': 1440,
          'message': null,
          'resolvedAt': null,
        },
      }),
    ]);
    await openPerformance(tester, app);
    await app.tapVisible(
      tester,
      find.byKey(const Key('appeal-00000000-0000-4000-8000-0000000000a1')),
    );
    await app.settle(tester);
    await tester.enterText(
      find.byKey(const Key('appeal-text')),
      'كان الطريق مغلقاً',
    );
    await app.settle(tester);
    await tester.tap(find.byKey(const Key('appeal-send')));
    await app.settle(tester);
    final sent = app.server.to(url).single;
    expect(sent.data, containsPair('text', 'كان الطريق مغلقاً'));
    expect(sent.headers['Idempotency-Key'], isNotNull);
    expect(
      find.text('استلمنا اعتراضك T-5521. تابعه في «الدعم».'),
      findsOneWidget,
    );
    expect(find.text('اعتراضك قيد المراجعة'), findsOneWidget);
    await app.done(tester);
  });
}
