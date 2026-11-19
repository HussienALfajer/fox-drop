import 'dart:typed_data';

import 'package:captain/src/support/report_photo.dart';
import 'package:core_auth/testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures.dart';

// CA §5.5, §12.2–12.4 (slice 2.35a): the welcome tour after the activation,
// the documents with their expiry and «رفع نسخة جديدة», the contract, the
// kit and the deposit.
Map<String, Object?> documentJson(
  String kind,
  String state, {
  String? expiresOn,
  bool pending = false,
}) => {
  'kind': kind,
  'required': kind != 'driving_licence',
  'state': state,
  'valid': state == 'missing'
      ? null
      : {
          'issueDate': null,
          'expiresOn': expiresOn,
          'uploadedAt': '2026-11-19T08:00:00.000Z',
        },
  'pending': pending
      ? {
          'issueDate': '2026-11-19',
          'expiresOn': null,
          'uploadedAt': '2026-11-20T08:00:00.000Z',
        }
      : null,
  'rejection': null,
};

void carried(TestApp app) =>
    app.server.on('/v1/captain/settings/carried-currencies', [
      const FakeAnswer(200, {
        'baseCurrency': 'TRY',
        'carried': ['TRY'],
        'choices': [
          {'currency': 'TRY', 'name': 'ليرة تركية'},
        ],
      }),
    ]);

void main() {
  testWidgets('shows the welcome tour once, then «أقصى مبلغ أحمله» (CA §5.5)', (
    tester,
  ) async {
    final app = TestApp();
    app.work(availability: [availabilityJson()]);
    carried(app);
    app.server.on('/v1/captain/contract', [
      FakeAnswer(200, contractJson('probation')),
    ]);
    await app.pump(tester);
    await app.live(tester);
    await app.settle(tester);
    expect(find.text('مرحباً بك في FOX DROP!'), findsOneWidget);
    for (var page = 0; page < 5; page += 1) {
      await tester.tap(find.byKey(const Key('tour-next')));
      await app.settle(tester);
    }
    expect(
      find.text('قبل أن تبدأ: حدّد «أقصى مبلغ أحمله» و«العملات التي أحملها».'),
      findsOneWidget,
    );
    expect(find.text('أقصى مبلغ أحمله'), findsOneWidget);
    await tester.tap(find.byKey(const Key('tour-done')));
    await app.settle(tester);
    expect(find.text('مرحباً بك في FOX DROP!'), findsNothing);
    expect(app.deviceStore.values.keys, ['captain.welcome_tour.$captainId']);
  });

  testWidgets('warns of a document expiring on home and replaces it (CA '
      '§12.2)', (tester) async {
    final app = TestApp();
    app.work(availability: [availabilityJson()]);
    app.server.on('/v1/captain/documents', [
      FakeAnswer(200, {
        'documents': [
          documentJson('national_id', 'valid'),
          documentJson('criminal_record', 'expiring', expiresOn: '2026-12-10'),
        ],
      }),
    ]);
    app.server.on('/v1/captain/documents/upload', [
      const FakeAnswer(201, {
        'uploadId': '00000000-0000-4000-8000-0000000000d1',
        'url': 'https://storage.test/put',
        'expiresAt': '2026-11-19T09:00:00.000Z',
      }),
    ]);
    app.server.on('/v1/captain/documents/criminal_record', [
      FakeAnswer(200, {
        'documents': [
          documentJson('national_id', 'valid'),
          documentJson(
            'criminal_record',
            'expiring',
            expiresOn: '2026-12-10',
            pending: true,
          ),
        ],
      }),
    ]);
    app.picked.add(
      PickedPhoto(
        Uint8List.fromList([0xff, 0xd8, 0xff, 0xe0, 1, 2, 3]),
        'image/jpeg',
      ),
    );
    await app.pump(tester);
    await app.live(tester);
    await app.settle(tester);
    final banner = find.byKey(const Key('home-document-banner'));
    expect(banner, findsOneWidget);
    expect(find.text('تنتهي صلاحية لا حكم عليه في 10/12/2026'), findsOneWidget);
    await tester.tap(banner);
    await app.settle(tester);
    expect(find.textContaining('ينتهي قريباً'), findsOneWidget);
    await tester.tap(find.byKey(const Key('document-replace-criminal_record')));
    await app.settle(tester);
    await tester.tap(find.byKey(const Key('document-camera')));
    await app.settle(tester);
    await tester.tap(find.byKey(const Key('document-save')));
    await app.settle(tester);
    expect(
      app.server.to('/v1/captain/documents/criminal_record').single.method,
      'PUT',
    );
    expect(find.textContaining('نسخة جديدة بانتظار التحقق'), findsOneWidget);
  });

  testWidgets('shows the contract, the early exit, the kit and the deposit '
      '(CA §12.3–12.4)', (tester) async {
    final app = TestApp();
    app.work(availability: [availabilityJson()]);
    app.server.on('/v1/captain/contract', [
      FakeAnswer(200, contractJson('commitment')),
    ]);
    // Seen already: no tour.
    app.deviceStore.values['captain.welcome_tour.$captainId'] = 'seen';
    await app.pump(tester);
    await app.live(tester);
    await tester.tap(find.text('المزيد'));
    await app.settle(tester);
    await tester.tap(find.byKey(const Key('more-contract')));
    await app.settle(tester);
    expect(find.text('المرحلة: فترة التزام'), findsOneWidget);
    expect(find.text('نهاية فترة الالتزام: 19/03/2027'), findsOneWidget);
    expect(find.text('لا توجد غرامة مالية.'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('القسط الأسبوعي: 100 ₺، يُخصم كل خميس'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('سترة (L) × 1'), findsOneWidget);
    expect(find.text('التأمين: 500 ₺، المدفوع: 200 ₺'), findsOneWidget);
    expect(find.text('المتبقي من التأمين: 300 ₺'), findsOneWidget);
    expect(find.text('القسط الأسبوعي: 100 ₺، يُخصم كل خميس'), findsOneWidget);
  });
}
