import 'dart:convert';

import 'package:captain/src/push.dart';
import 'package:core_auth/testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures.dart';

Map<String, Object?> bodyOf(TestApp app, String path) {
  final data = app.server
      .to(path)
      .lastWhere((request) => request.method == 'POST')
      .data;
  return (data is String ? jsonDecode(data) : data) as Map<String, Object?>;
}

const ticketId = '00000000-0000-4000-8000-0000000000d1';

Map<String, Object?> ticketJson({
  String typeLabel = 'مشكلة في التطبيق',
  String status = 'new',
  String openedBy = 'me',
  String? orderNumber,
  String? message,
  int replyWithinMinutes = 1440,
}) => {
  'id': ticketId,
  'number': '17',
  'typeLabel': typeLabel,
  'orderId': orderNumber == null ? null : orderId,
  'orderNumber': orderNumber,
  'description': '',
  'status': status,
  'openedAt': now.toIso8601String(),
  'openedBy': openedBy,
  'replyWithinMinutes': replyWithinMinutes,
  'message': message,
  'resolvedAt': message == null ? null : now.toIso8601String(),
};

void main() {
  testWidgets('«الدعم» lists «بلاغاتي» and sends «إبلاغ عن مشكلة» (CA §13)', (
    tester,
  ) async {
    final app = TestApp();
    app.work(availability: [availabilityJson()]);
    app.server.on('/v1/captain/reports', [
      FakeAnswer(200, {
        'tickets': [
          ticketJson(
            typeLabel: 'مشكلة في العهدة أو الأرباح',
            status: 'resolved',
            openedBy: 'operations',
            message: 'صُحّحت أرباحك',
          ),
        ],
      }),
    ]);
    await app.pump(tester);
    await app.live(tester);
    await tester.tap(find.text('المزيد'));
    await app.settle(tester);
    await tester.tap(find.byKey(const Key('more-support')));
    await app.settle(tester);
    expect(find.text('T-17 · مشكلة في العهدة أو الأرباح'), findsOneWidget);
    expect(find.text('من العمليات\nالرد: صُحّحت أرباحك'), findsOneWidget);
    expect(find.text('محلولة'), findsOneWidget);

    await tester.tap(find.byKey(const Key('report-problem')));
    await app.settle(tester);
    // No active order: nothing to name.
    expect(find.byKey(const Key('report-about-order')), findsNothing);
    await tester.tap(find.byKey(const Key('type-app_problem')));
    await tester.enterText(find.byKey(const Key('report-note')), 'يتوقف');
    await tester.pump();
    app.server.on('/v1/captain/reports', [
      FakeAnswer(200, {'ticket': ticketJson()}),
    ]);
    await tester.tap(find.byKey(const Key('report-send')));
    await app.settle(tester);
    final sent = app.server
        .to('/v1/captain/reports')
        .lastWhere((request) => request.method == 'POST');
    expect(sent.headers['Idempotency-Key'], isNotNull);
    expect(bodyOf(app, '/v1/captain/reports'), {
      'typeCode': 'app_problem',
      'orderId': null,
      'note': 'يتوقف',
      'photoUploadId': null,
    });
    expect(
      find.text('استلمنا بلاغك T-17. سنرد عليك خلال 24 ساعة.'),
      findsOneWidget,
    );
    await app.done(tester);
  });

  testWidgets('«مشكلة» reports a quick reason on the active order (CA §9.11)', (
    tester,
  ) async {
    final app = TestApp();
    app.work(
      availability: [availabilityJson(state: 'busy')],
      orders: [orderJson(track: 'at_merchant')],
    );
    app.server.on('/v1/captain/orders/$orderId/problem', [
      FakeAnswer(200, {
        'ticket': ticketJson(
          typeLabel: 'المطعم متأخر',
          orderNumber: '10423',
          replyWithinMinutes: 15,
        ),
      }),
    ]);
    await app.pump(tester);
    await app.live(tester);
    await app.tapVisible(tester, find.text('مشكلة'));
    await app.settle(tester);
    await tester.tap(find.byKey(const Key('problem-report')));
    await app.settle(tester);
    // Before the pickup the pickup amount is not offered.
    expect(find.text('مشكلة في مبلغ الاستلام'), findsNothing);
    await tester.tap(find.text('المطعم متأخر'));
    await app.settle(tester);
    await tester.tap(find.text('إرسال'));
    await app.settle(tester);
    expect(bodyOf(app, '/v1/captain/orders/$orderId/problem'), {
      'reasonCode': 'restaurant_late',
      'note': null,
      'paidLines': null,
    });
    expect(
      find.text('استلمنا بلاغك T-17. سنرد عليك خلال 15 دقيقة.'),
      findsOneWidget,
    );
    await app.done(tester);
  });

  testWidgets('«مشكلة في مبلغ الاستلام» sends the lines the captain handed '
      'over (CA §9.4 item 6)', (tester) async {
    final app = TestApp();
    app.work(
      availability: [availabilityJson(state: 'busy')],
      orders: [
        orderJson(
          status: 'picked_up',
          track: 'picked_up',
          pickedUp: true,
          request: requestJson(status: 'confirmed', outcome: 'restaurant'),
        ),
      ],
    );
    app.server.on('/v1/captain/orders/$orderId/problem', [
      FakeAnswer(200, {
        'ticket': ticketJson(
          typeLabel: 'خلاف على دفعة الاستلام',
          orderNumber: '10423',
          replyWithinMinutes: 15,
        ),
      }),
    ]);
    await app.pump(tester);
    await app.live(tester);
    await app.tapVisible(tester, find.text('مشكلة'));
    await app.settle(tester);
    await tester.tap(find.byKey(const Key('problem-report')));
    await app.settle(tester);
    await tester.tap(find.text('مشكلة في مبلغ الاستلام'));
    await app.settle(tester);
    await tester.tap(find.text('إرسال'));
    await app.settle(tester);
    expect(find.text('المسجّل عند الاستلام: 400 ₺'), findsOneWidget);
    final field = find.byKey(const Key('paid-TRY'));
    expect(tester.widget<TextField>(field).controller!.text, '400');
    await tester.enterText(field, 'abc');
    await tester.tap(find.byKey(const Key('paid-send')));
    await tester.pump();
    expect(find.text('اكتب ما دفعته بأرقام صحيحة.'), findsOneWidget);
    await tester.enterText(field, '410');
    await tester.enterText(
      find.byKey(const Key('paid-note')),
      'لم يرجع الباقي',
    );
    await tester.tap(find.byKey(const Key('paid-send')));
    await app.settle(tester);
    expect(bodyOf(app, '/v1/captain/orders/$orderId/problem'), {
      'reasonCode': 'pickup_amount',
      'note': 'لم يرجع الباقي',
      'paidLines': [
        {'amount': '41000', 'currency': 'TRY'},
      ],
    });
    expect(
      find.text('استلمنا بلاغك T-17. سنرد عليك خلال 15 دقيقة.'),
      findsOneWidget,
    );
    await app.done(tester);
  });

  testWidgets('«مشكلة في مبلغ الاستلام» is not offered once the restaurant '
      'disputed the pickup', (tester) async {
    final app = TestApp();
    app.work(
      availability: [availabilityJson(state: 'busy')],
      orders: [
        orderJson(
          status: 'picked_up',
          track: 'picked_up',
          pickedUp: true,
          disputedAt: now,
          request: requestJson(status: 'confirmed', outcome: 'restaurant'),
        ),
      ],
    );
    await app.pump(tester);
    await app.live(tester);
    await app.tapVisible(tester, find.text('مشكلة'));
    await app.settle(tester);
    await tester.tap(find.byKey(const Key('problem-report')));
    await app.settle(tester);
    expect(find.text('المطعم متأخر'), findsOneWidget);
    expect(find.text('مشكلة في مبلغ الاستلام'), findsNothing);
    await app.done(tester);
  });

  test('a resolved ticket\'s push opens «الدعم» (CA §14 #30)', () {
    expect(
      pushTargetPath({'target': 'ticket', 'ticketId': ticketId}),
      '/support',
    );
  });
}
