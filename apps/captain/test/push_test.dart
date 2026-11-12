import 'package:captain/src/push.dart';
import 'package:captain/src/router.dart';
import 'package:core_auth/testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures.dart';

String _location(TestApp app) => app.container
    .read(routerProvider)
    .routerDelegate
    .currentConfiguration
    .uri
    .toString();

// CA §14, architecture §8.1 (owner decision 2026-11-08): the token while
// signed in, the permission at «متصل», a tapped offer or order opening home.
void main() {
  testWidgets('a signed-in start registers the token', (tester) async {
    final app = TestApp();
    app.work(availability: [availabilityJson()]);
    await app.pump(tester);
    expect(app.server.to('/v1/captain/push-token').single.data, {
      'token': 'push-token-0',
      'platform': 'android',
    });
    await app.done(tester);
  });

  testWidgets('a renewed token is registered again', (tester) async {
    final app = TestApp();
    app.work(availability: [availabilityJson()]);
    await app.pump(tester);
    app.push.renew('push-token-1');
    await app.settle(tester);
    expect(
      (app.server.to('/v1/captain/push-token').last.data as Map)['token'],
      'push-token-1',
    );
    await app.done(tester);
  });

  testWidgets('«متصل» asks for notifications and goes online either way', (
    tester,
  ) async {
    final app = TestApp();
    app.permission
      ..allowed = false
      ..answer = false;
    app.work(availability: [availabilityJson()]);
    await app.pump(tester);
    await app.live(tester);
    expect(app.permission.requests, 0);

    app.server.on('/v1/captain/availability/online', [
      FakeAnswer(200, availabilityJson(state: 'online_available')),
    ]);
    app.work(availability: [availabilityJson(state: 'online_available')]);
    await tester.tap(find.byKey(const Key('online-switch')));
    await app.settle(tester);
    expect(app.permission.requests, 1);
    expect(app.server.to('/v1/captain/availability/online'), hasLength(1));
    expect(find.text('متصل متاح'), findsOneWidget);
    await app.done(tester);
  });

  testWidgets('a phone that allows notifications is not asked', (tester) async {
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
    expect(app.permission.requests, 0);
    await app.done(tester);
  });

  testWidgets('a tapped offer opens home', (tester) async {
    final app = TestApp();
    app.work(availability: [availabilityJson()]);
    await app.pump(tester);
    app.container.read(routerProvider).go('/faq');
    await app.settle(tester);
    app.push.tap({'target': 'offer', 'orderId': orderId, 'messageId': 'm'});
    await app.settle(tester);
    expect(_location(app), '/');
    await app.done(tester);
  });

  test('an offer or an order opens home; the others nothing yet', () {
    expect(pushTargetPath({'target': 'offer', 'orderId': orderId}), '/');
    expect(pushTargetPath({'target': 'order', 'orderId': orderId}), '/');
    expect(
      pushTargetPath({'target': 'custody', 'receiptId': orderId}),
      '/custody',
    );
    expect(pushTargetPath({'target': 'statement'}), isNull);
    expect(pushTargetPath({}), isNull);
  });
}
