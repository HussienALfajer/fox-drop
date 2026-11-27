import 'dart:async';

import 'package:core_auth/testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures.dart';

Finder _heart(String id) => find.byKey(Key('heart-$id'));

bool _full(WidgetTester tester, String id) =>
    (tester.widget<IconButton>(_heart(id)).icon as Icon).icon == Icons.favorite;

// CU §9.6, U18 (slice 2.28b): the heart on cards and pages, a guest signing
// in first, and «المفضلة» in «حسابي».
void main() {
  // Until the sign-in screen returns (deleted in D.R1, 2026-11-27), a guest's
  // heart saves nothing.
  testWidgets('a guest who taps a heart saves nothing', (tester) async {
    final app = await browsingApp(tester);
    await tester.tap(_heart(shamId));
    await tester.pumpAndSettle();
    expect(app.server.to('/v1/customer/favourites/$shamId'), isEmpty);
    // The guest stays where they were, the heart still empty.
    expect(_heart(shamId), findsOneWidget);
    expect(_full(tester, shamId), isFalse);
    await app.done(tester);
  });

  testWidgets('hearts a card at once and the page shows it', (tester) async {
    final app = await browsingApp(
      tester,
      signedIn: true,
      // The page is read after the heart: the server answers it.
      page: {...shamPage(), 'favourite': true},
      before: (app) {
        app.completedProfile();
        app.server.on('/v1/customer/favourites/$shamId', [
          const FakeAnswer(200, {'restaurantId': shamId, 'favourite': true}),
        ]);
      },
    );
    expect(_full(tester, shamId), isFalse);
    await tester.tap(_heart(shamId));
    await tester.pumpAndSettle();
    expect(_full(tester, shamId), isTrue);
    final sent = app.server.to('/v1/customer/favourites/$shamId');
    expect(sent.single.method, 'PUT');

    await openSham(tester);
    expect(_full(tester, shamId), isTrue);
    await app.done(tester);
  });

  testWidgets('a failed heart goes back as it was', (tester) async {
    final app = await browsingApp(
      tester,
      signedIn: true,
      page: shamPage(),
      before: (app) {
        app.completedProfile();
        app.server.on('/v1/customer/favourites/$shamId', [
          const FakeAnswer(500),
        ]);
      },
    );
    await tester.tap(_heart(shamId));
    await tester.pumpAndSettle();
    expect(_full(tester, shamId), isFalse);
    expect(find.byType(SnackBar), findsOneWidget);
    await app.done(tester);
  });

  testWidgets('«المفضلة» lists the favourites and removes one without asking', (
    tester,
  ) async {
    final app = await browsingApp(
      tester,
      signedIn: true,
      before: (app) {
        app.completedProfile();
        app.server.on('/v1/customer/favourites', [
          FakeAnswer(200, {
            'restaurants': [
              card(nourId, 'مطعم النور', state: 'closed', favourite: true),
            ],
          }),
          const FakeAnswer(200, {'restaurants': <Object?>[]}),
        ]);
        app.server.on('/v1/customer/favourites/$nourId', [
          const FakeAnswer(200, {'restaurantId': nourId, 'favourite': false}),
        ]);
      },
    );
    await tester.tap(find.byKey(const Key('open-account')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('open-favourites')));
    await tester.pumpAndSettle();
    expect(find.text('مطعم النور'), findsOneWidget);
    expect(_full(tester, nourId), isTrue);
    final asked = app.server.to('/v1/customer/favourites').single;
    expect(
      asked.uri.queryParameters.keys,
      containsAll(['latitude', 'longitude']),
    );

    await tester.tap(_heart(nourId));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    expect(
      app.server.to('/v1/customer/favourites/$nourId').single.method,
      'DELETE',
    );
    // The list is read again, without it.
    expect(
      find.text('لا توجد مطاعم مفضلة توصل إلى هذا العنوان'),
      findsOneWidget,
    );
    await app.done(tester);
  });

  testWidgets('a read after a change shows the account\'s heart again', (
    tester,
  ) async {
    final app = await browsingApp(
      tester,
      signedIn: true,
      before: (app) {
        app.completedProfile();
        // Removed here, then hearted again on another phone before the
        // list is read again.
        app.server.on('/v1/customer/favourites', [
          FakeAnswer(200, {
            'restaurants': [card(nourId, 'مطعم النور', favourite: true)],
          }),
        ]);
        app.server.on('/v1/customer/favourites/$nourId', [
          const FakeAnswer(200, {'restaurantId': nourId, 'favourite': false}),
        ]);
      },
    );
    await tester.tap(find.byKey(const Key('open-account')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('open-favourites')));
    await tester.pumpAndSettle();
    await tester.tap(_heart(nourId));
    await tester.pumpAndSettle();
    expect(app.server.to('/v1/customer/favourites'), hasLength(2));
    expect(_full(tester, nourId), isTrue);
    await app.done(tester);
  });

  testWidgets('a second tap while the first is on its way is ignored', (
    tester,
  ) async {
    final app = await browsingApp(
      tester,
      signedIn: true,
      before: (app) {
        app.completedProfile();
        app.server.on('/v1/customer/favourites/$shamId', [
          const FakeAnswer(200, {'restaurantId': shamId, 'favourite': true}),
        ]);
      },
    );
    final gate = Completer<void>();
    app.server.gate = gate;
    await tester.tap(_heart(shamId));
    await tester.pump();
    await tester.tap(_heart(shamId));
    await tester.pump();
    gate.complete();
    app.server.gate = null;
    await tester.pumpAndSettle();
    expect(app.server.to('/v1/customer/favourites/$shamId'), hasLength(1));
    expect(_full(tester, shamId), isTrue);
    await app.done(tester);
  });
}
