import 'dart:convert';

import 'package:core_auth/testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures.dart';

Map<String, Object?> bodyOf(TestApp app, String path) {
  final data = app.server.to(path).last.data;
  return (data is String ? jsonDecode(data) : data) as Map<String, Object?>;
}

const path = '/v1/captain/settings/max-pickup-amount';

void main() {
  testWidgets('sets «أقصى مبلغ أحمله» on «الإعدادات», then no limit (CA '
      '§10.5, C4)', (tester) async {
    final app = TestApp();
    app.work(availability: [availabilityJson()]);
    app.server.on('/v1/captain/settings/carried-currencies', [
      const FakeAnswer(200, {
        'baseCurrency': 'TRY',
        'carried': ['TRY'],
        'choices': [
          {'currency': 'TRY', 'name': 'ليرة تركية'},
        ],
      }),
    ]);
    await app.pump(tester);
    await app.live(tester);
    app.server.on(path, [
      FakeAnswer(200, maxPickupJson()),
      FakeAnswer(200, maxPickupJson(limit: '50000')),
      FakeAnswer(200, maxPickupJson()),
    ]);
    await tester.tap(find.text('الإعدادات'));
    await app.settle(tester);
    expect(find.text('أقصى مبلغ أحمله'), findsOneWidget);
    expect(find.text('بلا حد الآن'), findsOneWidget);

    // Not an amount: nothing is sent.
    await tester.enterText(find.byKey(const Key('max-pickup-field')), '0');
    await tester.tap(find.text('حفظ'));
    await app.settle(tester);
    expect(find.text('اكتب مبلغاً أكبر من صفر.'), findsOneWidget);
    expect(app.server.to(path).where((r) => r.method == 'PUT'), isEmpty);

    await tester.enterText(find.byKey(const Key('max-pickup-field')), '500');
    await tester.tap(find.text('حفظ'));
    await app.settle(tester);
    expect(bodyOf(app, path), {'amount': '50000'});
    expect(find.text('الحد الآن: 500 ₺'), findsOneWidget);

    await tester.tap(find.text('بلا حد'));
    await app.settle(tester);
    expect(bodyOf(app, path), {'amount': null});
    expect(find.text('بلا حد الآن'), findsOneWidget);
    await app.done(tester);
  });

  testWidgets('asks «أقصى مبلغ أحمله» at «متصل» while unanswered, then goes '
      'online (K2)', (tester) async {
    final app = TestApp();
    app.work(availability: [availabilityJson()], maxPickupAnswered: false);
    await app.pump(tester);
    await app.live(tester);
    app.server.on(path, [
      FakeAnswer(200, maxPickupJson(answered: false)),
      FakeAnswer(200, maxPickupJson()),
    ]);
    app.server.on('/v1/captain/availability/online', [
      FakeAnswer(200, availabilityJson(state: 'online_available')),
    ]);
    app.work(
      availability: [availabilityJson(state: 'online_available')],
      maxPickupAnswered: false,
    );
    await tester.tap(find.byKey(const Key('online-switch')));
    await app.settle(tester);
    expect(find.byKey(const Key('max-pickup-question')), findsOneWidget);
    expect(app.server.to('/v1/captain/availability/online'), isEmpty);

    await tester.tap(find.text('بلا حد'));
    await app.settle(tester);
    expect(bodyOf(app, path), {'amount': null});
    expect(find.byKey(const Key('max-pickup-question')), findsNothing);
    expect(app.server.to('/v1/captain/availability/online'), hasLength(1));
    expect(find.text('متصل متاح'), findsOneWidget);
    await app.done(tester);
  });

  testWidgets('goes online without asking once answered (K2)', (tester) async {
    final app = TestApp();
    app.work(availability: [availabilityJson()]);
    await app.pump(tester);
    await app.live(tester);
    app.server.on('/v1/captain/availability/online', [
      FakeAnswer(200, availabilityJson(state: 'online_available')),
    ]);
    app.work(availability: [availabilityJson(state: 'online_available')]);
    await tester.tap(find.byKey(const Key('online-switch')));
    await app.settle(tester);
    expect(find.byKey(const Key('max-pickup-question')), findsNothing);
    expect(app.server.to('/v1/captain/availability/online'), hasLength(1));
    await app.done(tester);
  });

  testWidgets('warns on a manual offer above the limit (CA §8.4, K2)', (
    tester,
  ) async {
    final app = TestApp();
    app.work(
      availability: [availabilityJson(state: 'online_available')],
      offers: [offerJson(aboveMaxPickup: true)],
    );
    await app.pump(tester);
    await app.live(tester);
    expect(
      find.text(
        'المبلغ أكبر من الحد الذي حددته — اقبل فقط إذا كان معك ما يكفي',
      ),
      findsOneWidget,
    );
    await app.done(tester);
  });
}
