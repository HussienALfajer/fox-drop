import 'package:core_auth/testing.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures.dart';

// CA §12.5, §8.2 (AP §9.12.5, D15; slice 2.16): the peak windows on home and
// their screen, and the bonus on the offer.
const zone = {'id': '01900000-0000-7000-8000-0000000000e1', 'name': 'الشمال'};

Map<String, Object?> peakJson({bool active = true}) => {
  'windows': [
    {
      'days': [4, 5],
      'startMinute': 900,
      'endMinute': 1020,
      'amount': moneyJson('500'),
      'zones': <Object?>[],
    },
    {
      'days': [6],
      'startMinute': 1380,
      'endMinute': 60,
      'amount': moneyJson('800'),
      'zones': [zone],
    },
  ],
  'active': [
    if (active)
      {
        'amount': moneyJson('500'),
        'until': now.add(const Duration(hours: 2)).toIso8601String(),
        'zones': <Object?>[],
      },
  ],
};

void main() {
  testWidgets('shows the window running now on home, and the windows', (
    tester,
  ) async {
    final app = TestApp();
    app.work(availability: [availabilityJson()]);
    app.server.on('/v1/captain/peak-bonus', [FakeAnswer(200, peakJson())]);
    await app.pump(tester);
    await app.live(tester);
    // 12:00 UTC is 15:00 in Azaz; the window ends two hours later.
    expect(
      find.text('مكافأة الذروة الآن: +5 ₺ لكل طلب حتى 5:00 م'),
      findsOneWidget,
    );
    await app.tapVisible(tester, find.text('أوقات مكافأة الذروة'));
    await app.settle(tester);
    expect(
      find.text(
        'الخميس، الجمعة من 3:00 م إلى 5:00 م: +5 ₺ لكل طلب — كل المناطق',
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        'السبت من 11:00 م إلى 1:00 ص: +8 ₺ لكل طلب (تنتهي في اليوم التالي) — في: الشمال',
      ),
      findsOneWidget,
    );
    await app.done(tester);
  });

  testWidgets('shows nothing while the bonus is off', (tester) async {
    final app = TestApp();
    app.work(availability: [availabilityJson()]);
    app.server.on('/v1/captain/peak-bonus', [
      const FakeAnswer(200, {'windows': <Object?>[], 'active': <Object?>[]}),
    ]);
    await app.pump(tester);
    await app.live(tester);
    expect(find.textContaining('مكافأة الذروة'), findsNothing);
    await app.done(tester);
  });

  testWidgets('says the offer includes the peak bonus (CA §8.2)', (
    tester,
  ) async {
    final app = TestApp();
    app.work(
      availability: [availabilityJson(state: 'online_available')],
      offers: [offerJson(peakBonus: moneyJson('500'))],
    );
    await app.pump(tester);
    await app.live(tester);
    expect(find.text('يشمل مكافأة الذروة +5 ₺'), findsOneWidget);
    await app.done(tester);
  });
}
