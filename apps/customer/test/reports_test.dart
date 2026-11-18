import 'dart:typed_data';

import 'package:core_auth/testing.dart';
import 'package:customer/src/reports/report_photos.dart';
import 'package:customer/src/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures.dart';
import 'support.dart';

const _orderId = '00000000-0000-4000-8000-0000000000e2';
const _uploadId = '00000000-0000-4000-8000-0000000000f9';

// A delivered order of two shawarma, with the report's fields.
Map<String, Object?> _order({
  String status = 'delivered',
  Map<String, Object?>? report,
  String? reportUntil,
  List<Map<String, Object?>> redeliveries = const [],
}) => {
  'id': _orderId,
  'number': '10423',
  'redeliveryOf': null,
  'status': status,
  'version': 9,
  'placedAt': '2026-11-07T12:00:00.000Z',
  'report': report,
  'reportUntil': reportUntil,
  'redeliveries': redeliveries,
  'promisedAt': '2026-11-07T12:45:00.000Z',
  'cancellation': null,
  'rejection': null,
  'outcome': null,
  'delivery': null,
  'itemReport': null,
  'doorPing': null,
  'restaurant': {'id': shamId, 'nameAr': 'مطعم الشام', 'nameEn': null},
  'captain': null,
  'currency': 'TRY',
  'money': {
    'itemsValue': '13000',
    'deliveryFee': '1000',
    'deliveryFree': false,
    'discount': '0',
    'rounding': '0',
    'total': '14000',
  },
  'promoCode': null,
  'equivalents': <Object>[],
  'lines': [
    {
      'position': 0,
      'itemId': shawarmaId,
      'name': 'شاورما دجاج',
      'quantity': 2,
      'note': null,
      'options': <Object>[],
      'unitPrice': '6500',
      'lineTotal': '13000',
      'added': false,
      'quantityBefore': null,
    },
  ],
  'removedLines': <Object>[],
  'timeline': <Object>[],
  'edited': false,
  'payIn': null,
  'note': null,
  'estimate': {'fromMin': 30, 'toMin': 40},
  'address': {
    'location': {'latitude': 36.5862, 'longitude': 37.0463},
    'neighbourhood': 'الحي الشمالي',
    'label': null,
    'customLabel': null,
    'street': 'شارع القلعة، بناء 4',
    'floor': null,
    'landmark': 'قرب جامع النور',
    'recipientName': null,
    'directions': null,
  },
};

final _png = Uint8List.fromList(transparentPng);

/// The photos the app PUT, by URL.
class _Puts {
  final urls = <String>[];
}

void main() {
  final later = DateTime.now()
      .toUtc()
      .add(const Duration(hours: 20))
      .toIso8601String();

  Future<(TestApp, _Puts)> open(
    WidgetTester tester,
    List<FakeAnswer> answers,
  ) async {
    final puts = _Puts();
    final app = TestApp(
      signedIn: true,
      overrides: [
        photoPickerProvider.overrideWithValue(
          (source) async => PickedPhoto(_png, 'image/png'),
        ),
        photoPutProvider.overrideWithValue(
          (url, photo) async => puts.urls.add(url),
        ),
      ],
    );
    app.server.on('/v1/customer/content', [
      const FakeAnswer(200, {
        'reasons': {
          'customer_cancel': <Object?>[],
          'customer_problem': [
            {'code': 'missing_item', 'label': 'صنف ناقص', 'note': 'optional'},
            {'code': 'cold_food', 'label': 'الطعام بارد', 'note': 'optional'},
            {'code': 'other', 'label': 'أخرى', 'note': 'required'},
          ],
          'order_note': <Object?>[],
          'restaurant_rating_low': <Object?>[],
          'restaurant_rating_mid': <Object?>[],
          'restaurant_rating_high': <Object?>[],
          'captain_rating_low': <Object?>[],
          'captain_rating_mid': <Object?>[],
          'captain_rating_high': <Object?>[],
        },
        'faq': <Object?>[],
      }),
    ]);
    app.server.on('/v1/customer/contact', [
      const FakeAnswer(200, {
        'phone': '+963944000000',
        'whatsapp': '+963944000001',
      }),
    ]);
    app.server.on('/v1/customer/orders/$_orderId', answers);
    app.server.on('/v1/customer/orders/active', [
      const FakeAnswer(200, {'orders': <Object>[]}),
    ]);
    await app.pump(tester);
    app.container.read(routerProvider).go('/orders/$_orderId');
    await tester.pumpAndSettle();
    return (app, puts);
  }

  // CU §12.2, AP §9.9.1 (slice 2.24a).
  testWidgets(
    'reports a missing item with a photo and shows the report on the order',
    (tester) async {
      final (app, puts) = await open(tester, [
        FakeAnswer(200, {'order': _order(reportUntil: later)}),
        FakeAnswer(200, {
          'order': _order(
            report: {
              'ticketId': '00000000-0000-4000-8000-0000000000c7',
              'number': '17',
              'status': 'new',
              'message': null,
              'resolvedAt': null,
              'replyWithinMinutes': 1440,
            },
          ),
        }),
      ]);
      app.server.on('/v1/customer/uploads/report-photo', [
        const FakeAnswer(201, {
          'uploadId': _uploadId,
          'url': 'https://api.example.test/private-docs/incoming/a.jpg?X=1',
          'expiresAt': '2026-11-07T13:10:00.000Z',
        }),
      ]);
      app.server.on('/v1/customer/orders/$_orderId/report', [
        FakeAnswer(200, {
          'order': _order(
            report: {
              'ticketId': '00000000-0000-4000-8000-0000000000c7',
              'number': '17',
              'status': 'new',
              'message': null,
              'resolvedAt': null,
              'replyWithinMinutes': 1440,
            },
          ),
        }),
      ]);

      await tester.tap(find.byKey(const Key('order-report-problem')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('report-type-missing_item')));
      await tester.pumpAndSettle();
      // The type names the order's lines: nothing chosen, nothing sent.
      final send = find.byKey(const Key('report-send'));
      expect(tester.widget<FilledButton>(send).onPressed, isNull);
      await tester.tap(find.byKey(const Key('report-line-more-0')));
      await tester.enterText(
        find.byKey(const Key('report-note')),
        'نقصت واحدة',
      );
      await tester.tap(find.byKey(const Key('report-photo-gallery')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('report-photo-0')), findsOneWidget);
      await tester.ensureVisible(send);
      await tester.tap(send);
      await tester.pumpAndSettle();

      expect(app.bodyOf('/v1/customer/uploads/report-photo'), {
        'contentType': 'image/png',
        'sizeBytes': _png.length,
      });
      expect(puts.urls, [
        'https://api.example.test/private-docs/incoming/a.jpg?X=1',
      ]);
      expect(app.bodyOf('/v1/customer/orders/$_orderId/report'), {
        'typeCode': 'missing_item',
        'note': 'نقصت واحدة',
        'items': [
          {'position': 0, 'quantity': 1},
        ],
        'photoUploadIds': [_uploadId],
      });
      expect(
        find.text('استلمنا بلاغك T-17. سنرد عليك خلال 24 ساعة.'),
        findsOneWidget,
      );
      expect(find.text('بلاغك T-17: جديدة'), findsOneWidget);
      expect(find.byKey(const Key('order-report-problem')), findsNothing);
      await app.done(tester);
    },
  );

  testWidgets('a resolved report shows its message', (tester) async {
    final (app, _) = await open(tester, [
      FakeAnswer(200, {
        'order': _order(
          report: {
            'ticketId': '00000000-0000-4000-8000-0000000000c7',
            'number': '17',
            'status': 'resolved',
            'message': 'نعتذر، أرسلنا لك كود تعويض.',
            'resolvedAt': '2026-11-07T14:00:00.000Z',
            'replyWithinMinutes': 1440,
          },
          redeliveries: [
            {
              'orderId': '00000000-0000-4000-8000-0000000000e3',
              'number': '10430',
            },
          ],
        ),
      }),
    ]);
    expect(find.text('بلاغك T-17: محلولة'), findsOneWidget);
    expect(find.text('نعتذر، أرسلنا لك كود تعويض.'), findsOneWidget);
    // CU §12.3: the link to the re-delivery.
    expect(find.text('إعادة التوصيل: الطلب #10430'), findsOneWidget);
    await app.done(tester);
  });

  testWidgets('outside the window, «تواصل مع الدعم» calls or writes', (
    tester,
  ) async {
    final (app, _) = await open(tester, [
      FakeAnswer(200, {'order': _order()}),
    ]);
    expect(find.byKey(const Key('order-report-problem')), findsNothing);
    expect(find.text('تواصل مع الدعم'), findsOneWidget);
    await tester.ensureVisible(find.byKey(const Key('order-support-call')));
    await tester.tap(find.byKey(const Key('order-support-call')));
    expect(app.launched.single, Uri(scheme: 'tel', path: '+963944000000'));
    await app.done(tester);
  });

  testWidgets('a failed order offers «تواصل مع الدعم» too', (tester) async {
    final (app, _) = await open(tester, [
      FakeAnswer(200, {'order': _order(status: 'cancelled')}),
    ]);
    expect(find.text('تواصل مع الدعم'), findsOneWidget);
    expect(find.byKey(const Key('order-report-problem')), findsNothing);
    await app.done(tester);
  });

  // CU §9.5 (slice 2.24a).
  testWidgets('«أبلغ عن سعر مختلف» sends the item, the price and the note', (
    tester,
  ) async {
    final app = await browsingApp(tester, signedIn: true);
    app.server.on('/v1/customer/restaurants/$shamId/price-report', [
      const FakeAnswer(200, {'number': '18'}),
      const FakeAnswer(409, {
        'statusCode': 409,
        'error': 'already_reported_today',
      }),
    ]);
    await openSham(tester);
    await tester.tap(find.text('نفس أسعار المحل'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('report-price')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('price-shop')), '6.5x');
    await tester.pump();
    expect(find.text('اكتب السعر بالأرقام'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('price-shop')), '60');
    await tester.enterText(
      find.byKey(const Key('price-note')),
      'أرخص في المحل',
    );
    await tester.pump();
    await tester.tap(find.byKey(const Key('price-send')));
    await tester.pumpAndSettle();
    expect(app.bodyOf('/v1/customer/restaurants/$shamId/price-report'), {
      'itemId': null,
      'shopPrice': '6000',
      'note': 'أرخص في المحل',
      'photoUploadId': null,
    });
    expect(find.text('شكراً، سنتحقق من السعر'), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    await tester.tap(find.text('نفس أسعار المحل'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('report-price')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('price-send')));
    await tester.pumpAndSettle();
    expect(find.text('أرسلت بلاغاً عن هذا المطعم اليوم'), findsOneWidget);
  });

  // The server checks the stored bytes the same way (the files module).
  test('a photo is typed by its first bytes', () {
    expect(imageTypeOf(Uint8List.fromList(transparentPng)), 'image/png');
    expect(
      imageTypeOf(Uint8List.fromList([0xff, 0xd8, 0xff, 0xe0])),
      'image/jpeg',
    );
    expect(
      imageTypeOf(Uint8List.fromList('RIFF\x00\x00\x00\x00WEBPVP8 '.codeUnits)),
      'image/webp',
    );
    expect(imageTypeOf(Uint8List.fromList('<html>'.codeUnits)), isNull);
  });
}
