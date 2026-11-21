import 'dart:async';

import 'package:core_auth/testing.dart';
import 'package:core_storage/core_storage.dart';
import 'package:customer/src/browsing/browse_cache.dart';
import 'package:customer/src/browsing/browsing.dart';
import 'package:customer/src/location/position.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes.dart';
import 'fixtures.dart';
import 'support.dart';

/// Home's answer with one restaurant named [name].
Map<String, Object?> _home(String name) => {
  'restaurants': [card(shamId, name)],
  'sections': <Object?>[],
};

/// A kept read [age] old, as the cache writes it.
String _kept(
  Object? body, {
  Duration age = const Duration(days: 1),
  String? account,
  GeoPoint point = azaz,
}) => BrowseEntry(
  savedAt: DateTime.now().subtract(age),
  accountId: account,
  point: point,
  body: body,
).encode();

/// The app started with no connection (the zone check fails) and [kept]
/// in the device store.
Future<TestApp> _coldOffline(WidgetTester tester, Map<String, String> kept) =>
    browsingApp(
      tester,
      before: (app) {
        app.server.on('/v1/customer/location', [const FakeAnswer.none()]);
        app.server.on('/v1/customer/restaurants', [const FakeAnswer.none()]);
        app.server.on('/v1/customer/restaurants/$shamId', [
          const FakeAnswer.none(),
        ]);
        app.device.values.addAll(kept);
      },
    );

Future<void> _back(WidgetTester tester) async {
  await tester.tap(find.byType(BackButton));
  await tester.pumpAndSettle();
}

// CU §4.5 «Caching», «Lost connection» and §19 item 28 (slice L.1c).
void main() {
  test('an entry fits its account, within 1 km and 7 days', () {
    final now = DateTime(2026, 11, 21, 12);
    BrowseEntry entry({Duration age = Duration.zero, String? account}) =>
        BrowseEntry(
          savedAt: now.subtract(age),
          accountId: account,
          point: azaz,
          body: null,
        );
    bool fits(BrowseEntry e, {String? account, GeoPoint point = azaz}) =>
        e.fits(accountId: account, point: point, now: now);
    // About 900 m and 1.8 km east.
    final near = GeoPoint(azaz.latitude, azaz.longitude + 0.01);
    final far = GeoPoint(azaz.latitude, azaz.longitude + 0.02);

    expect(fits(entry(age: const Duration(days: 7))), isTrue);
    expect(fits(entry(age: const Duration(days: 7, minutes: 1))), isFalse);
    expect(fits(entry(), point: near), isTrue);
    expect(fits(entry(), point: far), isFalse);
    expect(fits(entry(account: 'a')), isFalse);
    expect(fits(entry(account: 'a'), account: 'a'), isTrue);
    expect(entry().fits(accountId: null, point: null, now: now), isTrue);
    expect(BrowseEntry.decode('not json'), isNull);
  });

  test('the 21st page drops the oldest', () async {
    final store = MemoryDeviceStore();
    final cache = BrowseCache(store);
    final entry = BrowseEntry(
      savedAt: DateTime(2026, 11, 21),
      accountId: null,
      point: azaz,
      body: const {},
    );
    for (var n = 0; n < 21; n++) {
      await cache.writePage('r$n', entry);
    }
    expect(store.values.containsKey(browsePageKey('r0')), isFalse);
    expect(store.values.containsKey(browsePageKey('r1')), isTrue);
    // Reading one again makes it the newest, so r2 goes next, not r1.
    await cache.writePage('r1', entry);
    await cache.writePage('r21', entry);
    expect(store.values.containsKey(browsePageKey('r1')), isTrue);
    expect(store.values.containsKey(browsePageKey('r2')), isFalse);
    expect(await cache.pageIds(), hasLength(browseCachePages));
  });

  testWidgets('the kept home shows before the live read, which replaces it', (
    tester,
  ) async {
    final app = await browsingApp(tester);
    expect(find.text('مطعم الشام'), findsOneWidget);

    app.server.on('/v1/customer/restaurants', [
      FakeAnswer(200, _home('مطعم الشام الجديد')),
    ]);
    final gate = app.server.gate = Completer<void>();
    app.container.invalidate(homeProvider);
    await tester.pump();
    await tester.pump();
    // The kept read at once, no spinner, not marked offline.
    expect(find.text('مطعم الشام'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byKey(const Key('offline')), findsNothing);

    gate.complete();
    app.server.gate = null;
    await tester.pumpAndSettle();
    expect(find.text('مطعم الشام الجديد'), findsOneWidget);
    expect(find.text('مطعم الشام'), findsNothing);
  });

  testWidgets('offline, home and a page read before show from the device, '
      'marked, and an item goes in the cart', (tester) async {
    final app = await browsingApp(tester);
    await openSham(tester);
    await _back(tester);

    app.server.on('/v1/customer/restaurants', [const FakeAnswer.none()]);
    app.server.on('/v1/customer/restaurants/$shamId', [
      const FakeAnswer.none(),
    ]);
    app.container.invalidate(homeProvider);
    await tester.pumpAndSettle();
    expect(find.text('لا يوجد اتصال بالإنترنت'), findsOneWidget);
    expect(find.text('مطعم الشام'), findsOneWidget);

    await openSham(tester);
    expect(find.byKey(const Key('offline')), findsOneWidget);
    expect(find.text('شاورما دجاج'), findsOneWidget);
    await addShawarma(tester);
    expect(find.byKey(const Key('open-cart')), findsOneWidget);
  });

  testWidgets('pull to refresh waits for the live read, not the kept one', (
    tester,
  ) async {
    final app = await browsingApp(tester);
    app.server.on('/v1/customer/restaurants', [
      FakeAnswer(200, _home('مطعم الشام الجديد')),
    ]);
    final gate = app.server.gate = Completer<void>();
    var refreshed = false;
    unawaited(
      tester
          .state<RefreshIndicatorState>(find.byType(RefreshIndicator))
          .show()
          .then((_) => refreshed = true),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('مطعم الشام'), findsOneWidget);
    expect(refreshed, isFalse);

    gate.complete();
    app.server.gate = null;
    await tester.pumpAndSettle();
    expect(refreshed, isTrue);
    expect(find.text('مطعم الشام الجديد'), findsOneWidget);
  });

  testWidgets('a page that answers 404 is no longer kept', (tester) async {
    final app = await browsingApp(tester);
    await openSham(tester);
    await _back(tester);
    app.server.on('/v1/customer/restaurants/$shamId', [
      const FakeAnswer(404, {'error': 'unknown_restaurant'}),
      const FakeAnswer.none(),
    ]);
    await openSham(tester);
    await _back(tester);
    await openSham(tester);
    expect(find.byKey(const Key('offline')), findsNothing);
    expect(find.text('شاورما دجاج'), findsNothing);
    expect(app.device.values.containsKey(browsePageKey(shamId)), isFalse);
  });

  testWidgets('a page never read offline fails as before', (tester) async {
    final app = await browsingApp(tester);
    app.server.on('/v1/customer/restaurants/$shamId', [
      const FakeAnswer.none(),
    ]);
    await openSham(tester);
    expect(find.text('حاول مجدداً'), findsOneWidget);
    expect(find.byKey(const Key('offline')), findsNothing);
  });

  testWidgets('a cold start offline shows the last kept home and its pages; '
      'pull to refresh brings live browsing back', (tester) async {
    final app = await _coldOffline(tester, {
      browseHomeKey: _kept(_home('مطعم الشام')),
      browsePageKey(shamId): _kept(shamPage()),
    });
    expect(find.text('لا يوجد اتصال بالإنترنت'), findsOneWidget);
    expect(find.text('مطعم الشام'), findsOneWidget);
    await openSham(tester);
    expect(find.byKey(const Key('offline')), findsOneWidget);
    expect(find.text('شاورما دجاج'), findsOneWidget);
    await _back(tester);

    app.server.on('/v1/customer/location', [
      const FakeAnswer(200, {
        'state': 'served',
        'zone': {
          'id': '00000000-0000-4000-8000-0000000000a1',
          'name': 'الحي الشمالي',
        },
      }),
    ]);
    app.server.on('/v1/customer/restaurants', [
      FakeAnswer(200, _home('مطعم الشام الجديد')),
    ]);
    // Pull to refresh.
    unawaited(
      tester.state<RefreshIndicatorState>(find.byType(RefreshIndicator)).show(),
    );
    await tester.pumpAndSettle();
    expect(app.server.to('/v1/customer/location'), hasLength(2));
    expect(find.text('مطعم الشام الجديد'), findsOneWidget);
    expect(find.byKey(const Key('offline')), findsNothing);
  });

  testWidgets('a kept home 8 days old is not shown', (tester) async {
    await _coldOffline(tester, {
      browseHomeKey: _kept(_home('مطعم الشام'), age: const Duration(days: 8)),
    });
    expect(find.text('مطعم الشام'), findsNothing);
    expect(find.text('حاول مجدداً'), findsOneWidget);
  });

  testWidgets("another account's kept home is not shown", (tester) async {
    await _coldOffline(tester, {
      browseHomeKey: _kept(_home('مطعم الشام'), account: 'another'),
    });
    expect(find.text('مطعم الشام'), findsNothing);
    expect(find.byKey(const Key('offline')), findsNothing);
  });
}
