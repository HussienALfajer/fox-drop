import 'package:core_auth/core_auth.dart';
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
  testWidgets('a guest who taps a heart is asked to sign in', (tester) async {
    final app = await browsingApp(tester);
    await tester.tap(_heart(shamId));
    await tester.pumpAndSettle();
    expect(find.byType(SignInScreen), findsOneWidget);
    expect(app.server.to('/v1/customer/favourites/$shamId'), isEmpty);
    await app.done(tester);
  });

  testWidgets('hearts a card at once and the page shows it', (tester) async {
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
    expect(_full(tester, shamId), isFalse);
    await tester.tap(_heart(shamId));
    await tester.pumpAndSettle();
    expect(_full(tester, shamId), isTrue);
    final sent = app.server.to('/v1/customer/favourites/$shamId');
    expect(sent.single.method, 'PUT');

    // The page keeps the heart this device set, whatever it read before.
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
}
