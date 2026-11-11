import 'package:core_auth/testing.dart';
import 'package:core_push/testing.dart';
import 'package:customer/src/notifications/push.dart';
import 'package:customer/src/router.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support.dart';

const _orderId = '00000000-0000-4000-8000-0000000000e1';

TestApp _app(FakePush push, {bool signedIn = true}) {
  final app = TestApp(
    signedIn: signedIn,
    overrides: [pushProvider.overrideWithValue(push)],
  );
  app.server.on('/v1/customer/push-token', [
    const FakeAnswer(200, {'status': 'registered'}),
  ]);
  return app;
}

String _location(TestApp app) => app.container
    .read(routerProvider)
    .routerDelegate
    .currentConfiguration
    .uri
    .toString();

// CU §14, architecture §8.1: the token is registered while signed in, and a
// tapped push opens its target.
void main() {
  testWidgets('a signed-in start registers the token', (tester) async {
    final app = _app(FakePush());
    await app.pump(tester);
    expect(app.bodyOf('/v1/customer/push-token'), {
      'token': 'push-token-0',
      'platform': 'android',
    });
  });

  testWidgets('a renewed token is registered again', (tester) async {
    final push = FakePush();
    final app = _app(push);
    await app.pump(tester);
    push.renew('push-token-1');
    await tester.pumpAndSettle();
    expect(
      app.bodyOf('/v1/customer/push-token', index: 1)['token'],
      'push-token-1',
    );
  });

  testWidgets('a guest registers nothing', (tester) async {
    final push = FakePush();
    final app = _app(push, signedIn: false);
    await app.pump(tester);
    push.renew('push-token-1');
    await tester.pumpAndSettle();
    expect(app.server.to('/v1/customer/push-token'), isEmpty);
  });

  testWidgets('signing out stops the registrations', (tester) async {
    final push = FakePush();
    final app = _app(push);
    await app.pump(tester);
    await tester.tap(find.text('تسجيل الخروج'));
    await tester.pumpAndSettle();
    expect(find.text('تسجيل الدخول'), findsWidgets);
    push.renew('push-token-1');
    await tester.pumpAndSettle();
    expect(app.server.to('/v1/customer/push-token'), hasLength(1));
  });

  testWidgets('the push that started the app opens its order', (tester) async {
    final app = _app(
      FakePush(initial: {'target': 'order', 'orderId': _orderId}),
    );
    await app.pump(tester);
    expect(_location(app), '/orders/$_orderId');
    await app.done(tester);
  });

  testWidgets('a push tapped in the background opens its order', (
    tester,
  ) async {
    final push = FakePush();
    final app = _app(push);
    await app.pump(tester);
    push.tap({'target': 'order', 'orderId': _orderId, 'messageId': 'm-1'});
    await tester.pumpAndSettle();
    expect(_location(app), '/orders/$_orderId');
    await app.done(tester);
  });

  testWidgets('a door ping arriving while the app is open opens its order '
      '(CU §11.7)', (tester) async {
    final push = FakePush();
    final app = _app(push);
    await app.pump(tester);
    // Another push while open opens nothing.
    push.receive({'target': 'order', 'orderId': _orderId});
    await tester.pumpAndSettle();
    expect(_location(app), isNot('/orders/$_orderId'));
    final ping = {'target': 'order', 'orderId': _orderId, 'kind': 'door_ping'};
    push.receive(ping);
    await tester.pumpAndSettle();
    final router = app.container.read(routerProvider);
    // Over the screen the customer was on, which stays below.
    expect(router.state.uri.toString(), '/orders/$_orderId');
    expect(router.canPop(), isTrue);
    // Already on the order: it is read again, no second screen.
    final reads = app.server.to('/v1/customer/orders/$_orderId').length;
    push.receive(ping);
    await tester.pumpAndSettle();
    expect(
      app.server.to('/v1/customer/orders/$_orderId').length,
      greaterThan(reads),
    );
    router.pop();
    await tester.pumpAndSettle();
    expect(router.canPop(), isFalse);
    await app.done(tester);
  });

  test('only an order target has a route yet', () {
    expect(
      pushTargetPath({'target': 'order', 'orderId': 'a b'}),
      '/orders/a%20b',
    );
    expect(pushTargetPath({'target': 'order'}), isNull);
    expect(pushTargetPath({'target': 'codes'}), isNull);
    // CU §14 #19: «الخدمة عادت» opens home.
    expect(pushTargetPath({'target': 'home'}), '/');
    expect(pushTargetPath({}), isNull);
  });
}
