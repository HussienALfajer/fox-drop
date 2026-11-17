import 'package:core_auth/testing.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:customer/src/account/account_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes.dart';
import 'fixtures.dart';

// CU §5.5, AP §8.8, §9.8 (slice 2.25a): the account's banners on home and
// the office's sheet.
void main() {
  final l10n = lookupAppLocalizations(const Locale('ar'));

  test('the block texts of CU §5.5 on the city clock', () {
    expect(
      blockText(l10n, null, 'مخالفة شروط الاستخدام'),
      'حسابك محظور: مخالفة شروط الاستخدام. تواصل مع الدعم.',
    );
    expect(
      blockText(l10n, DateTime.utc(2026, 11, 20, 15, 30), 'طلب لم يُستلم'),
      'حسابك محظور حتى 20/11/2026 6:30 م: طلب لم يُستلم',
    );
  });

  testWidgets('a blocked customer sees the banner with call and WhatsApp', (
    tester,
  ) async {
    final app = await browsingApp(
      tester,
      signedIn: true,
      before: (app) {
        app.accountState(
          block: {'until': null, 'reason': 'مخالفة شروط الاستخدام'},
        );
        app.server.on('/v1/customer/contact', [
          const FakeAnswer(200, {
            'phone': '+963944000000',
            'whatsapp': '+963944000001',
          }),
        ]);
      },
    );
    expect(
      find.text('حسابك محظور: مخالفة شروط الاستخدام. تواصل مع الدعم.'),
      findsOneWidget,
    );
    expect(
      app.server.to('/v1/customer/account-state').last.uri.queryParameters,
      {'latitude': '${azaz.latitude}', 'longitude': '${azaz.longitude}'},
    );
    await tester.tap(find.text('اتصال بالدعم'));
    await tester.pumpAndSettle();
    expect(app.launched.last, Uri(scheme: 'tel', path: '+963944000000'));
    // Browsing goes on (CU §5.5: «Browse: Yes»).
    expect(find.text('مطعم الشام'), findsOneWidget);
    await app.done(tester);
  });

  testWidgets('the dues banner opens the office with its hours and the map', (
    tester,
  ) async {
    final app = await browsingApp(
      tester,
      signedIn: true,
      before: (app) => app.accountState(
        dues: {'amount': '25000', 'currency': 'TRY'},
        office: {
          'latitude': 36.5866,
          'longitude': 37.0463,
          'hours': [
            {'weekday': 6, 'opensAt': 540, 'closesAt': 1020},
          ],
          'timeZone': 'Asia/Damascus',
          'open': true,
          'closesAt': '2026-11-17T14:00:00.000Z',
          'opensAt': null,
        },
      ),
    );
    expect(
      find.text(
        'عليك 250 ₺ لـ FOX DROP. ادفعه في المكتب ليُفك الحظر تلقائياً.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const Key('account-office')));
    await tester.pumpAndSettle();
    expect(find.text('المكتب مفتوح حتى 5:00 م'), findsOneWidget);
    expect(find.text('السبت: من 9:00 ص إلى 5:00 م'), findsOneWidget);
    expect(find.text('الأحد: مغلق'), findsOneWidget);
    await tester.tap(find.byKey(const Key('office-map')));
    await tester.pumpAndSettle();
    expect(app.launched.last.queryParameters['query'], '36.5866,37.0463');
    await app.done(tester);
  });

  testWidgets('a guest reads no account state', (tester) async {
    final app = await browsingApp(tester);
    expect(app.server.to('/v1/customer/account-state'), isEmpty);
    expect(find.byKey(const Key('account-blocked')), findsNothing);
    await app.done(tester);
  });
}
