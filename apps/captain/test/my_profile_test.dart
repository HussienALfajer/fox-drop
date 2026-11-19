import 'package:captain/src/profile/my_profile.dart';
import 'package:core_auth/testing.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures.dart';

// CA §12.1, §12.5 «ملفي» (slice 2.36c): the data read-only with «طلب
// تعديل», the pay table for the vehicle with the one announced, and
// «احسب أجري», priced by the server.
Future<void> openProfile(WidgetTester tester, TestApp app) async {
  await app.pump(tester);
  await app.live(tester);
  await tester.tap(find.text('المزيد'));
  await app.settle(tester);
  await tester.tap(find.byKey(const Key('more-profile')));
  await app.settle(tester);
}

// Scrolls «ملفي» down until the text shows, then expects it once.
Future<void> see(WidgetTester tester, String text) async {
  await tester.scrollUntilVisible(
    find.text(text),
    100,
    scrollable: find.byType(Scrollable).last,
  );
  expect(find.text(text), findsOneWidget);
}

Map<String, Object?> partsJson(String base, String total) => {
  'base': {'amount': base, 'currency': 'TRY'},
  'distance': {'amount': '1700', 'currency': 'TRY'},
  'topUp': {'amount': '0', 'currency': 'TRY'},
  'orderPay': {'amount': '2700', 'currency': 'TRY'},
  'waiting': {'amount': '1500', 'currency': 'TRY'},
  'total': {'amount': total, 'currency': 'TRY'},
};

void main() {
  group('the sample typed', () {
    test('takes km with up to three decimals, 0 to 100 km', () {
      expect(metresOf('4'), 4000);
      expect(metresOf(' 4.5 '), 4500);
      expect(metresOf('6,401'), 6401);
      expect(metresOf('0'), 0);
      expect(metresOf('100'), 100000);
      expect(metresOf('100.001'), isNull);
      expect(metresOf('1.2345'), isNull);
      expect(metresOf('-1'), isNull);
      expect(metresOf(''), isNull);
      expect(metresOf('أربعة'), isNull);
      // An Arabic keyboard's digits and decimal mark.
      expect(metresOf('٦٫٤'), 6400);
    });

    test('shows the included distance exact to the metre', () {
      final l10n = lookupAppLocalizations(const Locale('ar'));
      expect(includedText(l10n, 3000), '3 كم');
      expect(includedText(l10n, 3250), '3.25 كم');
      expect(includedText(l10n, 800), '800 م');
    });

    test('takes whole minutes up to a day, none being 0', () {
      expect(waitedOf(''), 0);
      expect(waitedOf('25'), 25);
      expect(waitedOf('1440'), 1440);
      expect(waitedOf('1441'), isNull);
      expect(waitedOf('2.5'), isNull);
      expect(waitedOf('٢٥'), 25);
    });
  });

  testWidgets('shows the data read-only, and «طلب تعديل» opens the request', (
    tester,
  ) async {
    final app = TestApp();
    app.work(availability: [availabilityJson()]);
    await openProfile(tester, app);
    await see(tester, 'رقم الهوية في FOX DROP: C-00000002');
    await see(tester, 'الاسم: أحمد محمد علي');
    await see(tester, '+963912345678');
    await see(tester, 'الحي: الحي الشمالي');
    await see(tester, 'المركبة: دراجة نارية');
    await see(tester, 'رقم اللوحة: 12345');
    await see(tester, 'لم يُحدَّد جدول الأجور بعد.');
    expect(find.byKey(const Key('pay-calculate')), findsNothing);
    await app.tapVisible(
      tester,
      find.byKey(const Key('profile-request-change')),
    );
    await app.settle(tester);
    final chosen = tester.widget<RadioGroup<String>>(
      find.byType(RadioGroup<String>),
    );
    expect(chosen.groupValue, 'data_change');
    await app.done(tester);
  });

  testWidgets('shows the table and the one announced, and «احسب أجري»', (
    tester,
  ) async {
    final app = TestApp();
    app.work(availability: [availabilityJson()]);
    app.server.on('/v1/captain/pay-table', [
      FakeAnswer(
        200,
        payTableJson(
          current: payRateJson('2026-11-01T00:00:00.000Z', '1000'),
          announced: [payRateJson('2026-11-28T09:00:00.000Z', '2500')],
        ),
      ),
    ]);
    app.server.on('/v1/captain/pay-table/calculate', [
      FakeAnswer(200, {
        'current': partsJson('1000', '4200'),
        'announced': [
          {
            'effectiveFrom': '2026-11-28T09:00:00.000Z',
            ...partsJson('2500', '5700'),
          },
        ],
      }),
    ]);
    await openProfile(tester, app);
    await see(tester, 'الأجر الأساسي: 10 ₺ يشمل أول 3 كم');
    for (final (key, text) in [
      ('pay-current-per-km', 'لكل كم إضافي: 5 ₺'),
      ('pay-current-waiting', 'الانتظار: 1 ₺ لكل دقيقة بعد 10 د'),
      ('pay-current-minimum', 'الحد الأدنى للأجر: 20 ₺'),
    ]) {
      expect(
        find.descendant(of: find.byKey(Key(key)), matching: find.text(text)),
        findsOneWidget,
      );
    }
    await see(tester, 'الجدول الجديد من 28/11/2026 12:00 م');
    await see(tester, 'الأجر الأساسي: 25 ₺ يشمل أول 3 كم');

    await tester.scrollUntilVisible(
      find.byKey(const Key('pay-calculate')),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.enterText(find.byKey(const Key('pay-distance')), '200');
    await app.tapVisible(tester, find.byKey(const Key('pay-calculate')));
    await app.settle(tester);
    await see(tester, 'اكتب المسافة بالكيلومتر، حتى 100 كم.');
    expect(app.server.to('/v1/captain/pay-table/calculate'), isEmpty);

    await tester.enterText(find.byKey(const Key('pay-distance')), '6.401');
    await tester.enterText(find.byKey(const Key('pay-waited')), '25');
    await app.tapVisible(tester, find.byKey(const Key('pay-calculate')));
    await app.settle(tester);
    final asked = app.server.to('/v1/captain/pay-table/calculate').single;
    expect(asked.uri.queryParameters, {
      'metres': '6401',
      'waitedMinutes': '25',
    });
    await see(tester, 'المجموع: 42 ₺');
    await see(tester, 'بالجدول الجديد من 28/11/2026 12:00 م:');
    await see(tester, 'المجموع: 57 ₺');
    // The waiting past the 10 minutes, by both tables.
    expect(find.text('أجر الانتظار: 15 ₺'), findsNWidgets(2));
    await app.done(tester);
  });
}
