import 'dart:async';

import 'package:core_auth/testing.dart';
import 'package:core_maps/core_maps.dart';
import 'package:customer/src/account/addresses.dart';
import 'package:customer/src/location/delivery_point.dart';
import 'package:customer/src/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support.dart';

const _homeId = '00000000-0000-4000-8000-000000000201';
const _workId = '00000000-0000-4000-8000-000000000202';
const _offId = '00000000-0000-4000-8000-000000000203';
const _street = GeoPoint(36.5901, 37.0412);

Map<String, Object?> _address(
  String id, {
  String label = 'home',
  String? customLabel,
  String street = 'شارع القلعة، بناء 4',
  bool isDefault = false,
  String? neighbourhood = 'الحي الشمالي',
  String? contactPhone,
  String? recipientName,
}) => {
  'id': id,
  'location': {'latitude': 36.5866, 'longitude': 37.0463},
  'label': label,
  'customLabel': customLabel,
  'street': street,
  'floor': null,
  'landmark': 'قرب جامع النور',
  'contactPhone': contactPhone,
  'recipientName': recipientName,
  'directions': null,
  'isDefault': isDefault,
  'neighbourhood': neighbourhood,
};

final _list = [
  _address(_homeId, isDefault: true),
  _address(_workId, label: 'work', street: 'شارع السوق'),
  _address(
    _offId,
    label: 'other',
    customLabel: 'بيت أهلي',
    street: 'شارع المطار',
    neighbourhood: null,
  ),
];

/// «حسابي» → «عناويني», the server answering the list with [lists] in turn.
Future<TestApp> _addresses(
  WidgetTester tester, {
  required List<List<Map<String, Object?>>> lists,
  void Function(TestApp app)? before,
}) async {
  final app = TestApp(signedIn: true);
  app.completedProfile();
  app.server.on('/v1/customer/contact', [
    const FakeAnswer(200, {'phone': null, 'whatsapp': null}),
  ]);
  app.server.on('/v1/customer/addresses', [
    for (final list in lists) FakeAnswer(200, {'addresses': list}),
  ]);
  app.server.on('/v1/customer/location', [
    const FakeAnswer(200, {
      'state': 'served',
      'zone': {
        'id': '00000000-0000-4000-8000-0000000000a1',
        'name': 'الحي الشمالي',
      },
    }),
  ]);
  before?.call(app);
  await app.pump(tester);
  await tester.tap(find.byKey(const Key('open-account')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('open-addresses')));
  await tester.pumpAndSettle();
  return app;
}

/// The requests to [path] with [method].
int _sent(TestApp app, String path, String method) =>
    app.server.to(path).where((r) => r.method == method).length;

Future<void> _pinAt(WidgetTester tester, TestApp app, GeoPoint point) async {
  await tester.tap(find.byKey(const Key('address-pin')));
  await tester.pumpAndSettle();
  app.pinMap.move(MapCamera(point, 17));
  await tester.pump();
  await tester.tap(find.byKey(const Key('confirm-pin')));
  await tester.pumpAndSettle();
}

// CU §7.3 and §13 (slice 2.29a): «عناويني» with add, edit (the pin
// included), delete after a confirmation and the default, up to 10.
void main() {
  testWidgets('lists the addresses, the default marked, one outside the zones '
      'never made the default', (tester) async {
    await _addresses(tester, lists: [_list]);

    expect(find.text('عناويني'), findsOneWidget);
    expect(
      find.text('شارع القلعة، بناء 4 · الحي الشمالي · العنوان الافتراضي'),
      findsOneWidget,
    );
    expect(find.text('شارع السوق · الحي الشمالي'), findsOneWidget);
    expect(
      find.text('شارع المطار · خارج منطقة التوصيل حالياً'),
      findsOneWidget,
    );
    expect(find.text('بيت أهلي'), findsOneWidget);
    expect(find.byKey(const Key('default-address-$_homeId')), findsNothing);
    expect(find.byKey(const Key('default-address-$_workId')), findsOneWidget);
    expect(find.byKey(const Key('default-address-$_offId')), findsNothing);
  });

  testWidgets('adds an address with its pin set on the map at street level', (
    tester,
  ) async {
    final app = await _addresses(
      tester,
      lists: [
        const [],
        [_address(_homeId, isDefault: true)],
      ],
      before: (app) => app.server.on('/v1/customer/addresses', [
        const FakeAnswer(200, {'addresses': <Object>[]}),
        FakeAnswer(201, _address(_homeId, isDefault: true)),
        FakeAnswer(200, {
          'addresses': [_address(_homeId, isDefault: true)],
        }),
      ]),
    );
    expect(find.text('لا توجد عناوين محفوظة'), findsOneWidget);
    await tester.tap(find.byKey(const Key('add-address')));
    await tester.pumpAndSettle();

    // The pin first: saving without it says so and sends nothing.
    await tester.tap(find.byKey(const Key('save-address')));
    await tester.pumpAndSettle();
    expect(find.text('حدّد الموقع على الخريطة'), findsOneWidget);

    await _pinAt(tester, app, _street);
    // The neighbourhood is the zone at the pin, read-only.
    expect(find.text('الحي الشمالي'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('address-street')), 'ش');
    await tester.tap(find.byKey(const Key('save-address')));
    await tester.pumpAndSettle();
    expect(find.text('اكتب من 3 إلى 100 حرفاً'), findsWidgets);
    expect(_sent(app, '/v1/customer/addresses', 'POST'), 0);

    await tester.enterText(
      find.byKey(const Key('address-street')),
      'شارع الجامع، بناء 7',
    );
    await tester.enterText(
      find.byKey(const Key('address-landmark')),
      'قرب الصيدلية',
    );
    await tester.tap(find.byKey(const Key('label-work')));
    await tester.tap(find.byKey(const Key('save-address')));
    await tester.pumpAndSettle();

    final post = app.server
        .to('/v1/customer/addresses')
        .singleWhere((r) => r.method == 'POST');
    final body = post.data as Map;
    expect(body['location'], {
      'latitude': _street.latitude,
      'longitude': _street.longitude,
    });
    expect(body['label'], 'work');
    expect(body['street'], 'شارع الجامع، بناء 7');
    expect(body['landmark'], 'قرب الصيدلية');
    expect(body['contactPhone'], isNull);
    // Back on the list, read again.
    expect(find.text('عناويني'), findsOneWidget);
    expect(find.text('لا توجد عناوين محفوظة'), findsNothing);
  });

  testWidgets('edits every field and moves the pin', (tester) async {
    final app = await _addresses(
      tester,
      lists: [
        [
          _address(
            _homeId,
            isDefault: true,
            contactPhone: '+905321234567',
            recipientName: 'محمد',
          ),
        ],
      ],
      before: (app) => app.server.on('/v1/customer/addresses/$_homeId', [
        FakeAnswer(200, _address(_homeId, isDefault: true)),
      ]),
    );
    await tester.tap(find.byKey(const Key('edit-address-$_homeId')));
    await tester.pumpAndSettle();
    expect(find.text('تعديل العنوان'), findsOneWidget);
    expect(find.text('+905321234567'), findsOneWidget);
    expect(find.text('محمد'), findsOneWidget);

    await _pinAt(tester, app, _street);
    expect(app.pinMap.initial, const MapCamera(GeoPoint(36.5866, 37.0463), 17));
    await tester.enterText(find.byKey(const Key('address-street')), 'شارع آخر');
    await tester.tap(find.byKey(const Key('save-address')));
    await tester.pumpAndSettle();

    final put = app.server.to('/v1/customer/addresses/$_homeId').single;
    expect(put.method, 'PUT');
    final body = put.data as Map;
    expect(body['location'], {
      'latitude': _street.latitude,
      'longitude': _street.longitude,
    });
    expect(body['street'], 'شارع آخر');
    expect(body['contactPhone'], '+905321234567');
    expect(body['recipientName'], 'محمد');
  });

  testWidgets('a pin outside the zones is refused with its sentence', (
    tester,
  ) async {
    await _addresses(
      tester,
      lists: [
        [_address(_homeId, isDefault: true)],
      ],
      before: (app) => app.server.on('/v1/customer/addresses/$_homeId', [
        const FakeAnswer(409, {'error': 'outside_zones'}),
      ]),
    );
    await tester.tap(find.byKey(const Key('edit-address-$_homeId')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-address')));
    await tester.pumpAndSettle();
    expect(find.text('العنوان خارج منطقة التوصيل'), findsOneWidget);
    expect(find.text('تعديل العنوان'), findsOneWidget);
  });

  testWidgets('deletes only after the confirmation', (tester) async {
    final app = await _addresses(
      tester,
      lists: [
        _list,
        [_address(_homeId, isDefault: true)],
      ],
      before: (app) => app.server.on('/v1/customer/addresses/$_workId', [
        const FakeAnswer(200, {'status': 'deleted'}),
      ]),
    );
    await tester.tap(find.byKey(const Key('delete-address-$_workId')));
    await tester.pumpAndSettle();
    expect(find.text('تأكيد حذف العنوان'), findsOneWidget);
    await tester.tap(find.text('إلغاء'));
    await tester.pumpAndSettle();
    expect(app.server.to('/v1/customer/addresses/$_workId'), isEmpty);

    await tester.tap(find.byKey(const Key('delete-address-$_workId')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('confirm-delete-address')));
    await tester.pumpAndSettle();
    expect(
      app.server.to('/v1/customer/addresses/$_workId').single.method,
      'DELETE',
    );
    expect(find.text('شارع السوق · الحي الشمالي'), findsNothing);
  });

  testWidgets('«اجعله الافتراضي» moves the default', (tester) async {
    final app = await _addresses(
      tester,
      lists: [_list, _list],
      before: (app) => app.server.on(
        '/v1/customer/addresses/$_workId/default',
        [FakeAnswer(200, _address(_workId, label: 'work', isDefault: true))],
      ),
    );
    await tester.tap(find.byKey(const Key('default-address-$_workId')));
    await tester.pumpAndSettle();
    expect(
      app.server.to('/v1/customer/addresses/$_workId/default').single.method,
      'PUT',
    );
    expect(_sent(app, '/v1/customer/addresses', 'GET'), 2);
  });

  testWidgets('at 10 addresses no more can be added', (tester) async {
    await _addresses(
      tester,
      lists: [
        [
          for (var n = 0; n < 10; n += 1)
            _address('00000000-0000-4000-8000-00000000030$n'),
        ],
      ],
    );
    expect(find.byKey(const Key('add-address')), findsNothing);
    await tester.scrollUntilVisible(
      find.text('يمكنك حفظ 10 عناوين كحد أقصى'),
      200,
    );
    expect(find.text('يمكنك حفظ 10 عناوين كحد أقصى'), findsOneWidget);
  });

  testWidgets('deleting the address the point came from keeps the point, '
      'unsaved', (tester) async {
    final app = await _addresses(
      tester,
      lists: [_list],
      before: (app) => app.server.on('/v1/customer/addresses/$_workId', [
        const FakeAnswer(200, {'status': 'deleted'}),
      ]),
    );
    final point = app.container.read(deliveryPointProvider.notifier);
    unawaited(point.useAddress(_workId, _street));
    await tester.pumpAndSettle();
    expect(
      (app.container.read(deliveryPointProvider) as PointChecked).addressId,
      _workId,
    );
    unawaited(app.container.read(addressBookProvider).delete(_workId));
    await tester.pumpAndSettle();
    final after = app.container.read(deliveryPointProvider) as PointChecked;
    expect(after.addressId, isNull);
    expect(after.point, _street);
  });

  testWidgets('an address deleted on another phone leaves the point unsaved', (
    tester,
  ) async {
    final app = await _addresses(
      tester,
      lists: [_list],
      before: (app) => app.server.on('/v1/customer/addresses/$_workId', [
        const FakeAnswer(404, {'error': 'unknown_address'}),
      ]),
    );
    final point = app.container.read(deliveryPointProvider.notifier);
    unawaited(point.useAddress(_workId, _street));
    await tester.pumpAndSettle();
    unawaited(app.container.read(addressBookProvider).delete(_workId));
    await tester.pumpAndSettle();
    final after = app.container.read(deliveryPointProvider) as PointChecked;
    expect(after.addressId, isNull);
  });

  testWidgets('the form of an address no longer listed closes', (tester) async {
    final app = await _addresses(tester, lists: [_list]);
    app.container
        .read(routerProvider)
        .push('/account/addresses/00000000-0000-4000-8000-000000000299');
    await tester.pumpAndSettle();
    expect(find.text('تعديل العنوان'), findsNothing);
    expect(find.text('عناويني'), findsOneWidget);
  });
}
