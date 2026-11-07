import 'dart:convert';

import 'package:core_auth/testing.dart';
import 'package:core_storage/core_storage.dart';
import 'package:customer/src/api.dart';
import 'package:customer/src/app.dart';
import 'package:customer/src/auth.dart';
import 'package:customer/src/device.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes.dart';

const accountId = '00000000-0000-4000-8000-000000000001';

/// The customer app on a [FakeServer], with memory stores: no server or
/// device needed.
class TestApp {
  TestApp({bool signedIn = false, this.overrides = const []}) {
    server.on('/v1/customer/content', [
      const FakeAnswer(200, {
        'reasons': {
          'customer_cancel': <Object?>[],
          'customer_problem': <Object?>[],
          'order_note': [
            {
              'code': 'call_on_arrival',
              'label': 'اتصل بي عند الوصول',
              'note': 'none',
            },
          ],
          'restaurant_rating_low': <Object?>[],
          'restaurant_rating_mid': <Object?>[],
          'restaurant_rating_high': <Object?>[],
          'captain_rating_low': <Object?>[],
          'captain_rating_mid': <Object?>[],
          'captain_rating_high': <Object?>[],
        },
        'faq': [
          {
            'question': 'كيف أدفع ثمن طلبي؟',
            'answer': 'نقداً للكابتن عند الباب.',
          },
        ],
      }),
    ]);
    server.on('/v1/customer/status', [
      const FakeAnswer(200, {'status': 'ok', 'serverTime': 1}),
    ]);
    if (signedIn) {
      secure.values['session'] = jsonEncode({
        'accessToken': 'access-0',
        'accessTokenExpiresAt': DateTime.now()
            .add(const Duration(hours: 1))
            .toUtc()
            .toIso8601String(),
        'refreshToken': 'refresh-0',
        'accountId': accountId,
      });
      completedProfile();
    }
  }

  final server = FakeServer();
  final secure = MemorySecureStore();
  final device = MemoryDeviceStore();
  final List<Override> overrides;
  final transport = FakeTransport();
  late final ProviderContainer container;

  /// The profile answer of a customer who completed «أكمل بياناتك».
  void completedProfile() => server.on('/v1/customer/profile', [
    const FakeAnswer(200, {
      'completed': true,
      'profile': {
        'firstName': 'سارة',
        'lastName': null,
        'gender': 'female',
        'birthday': null,
      },
    }),
  ]);

  Future<void> pump(WidgetTester tester) async {
    // A tall phone, so a sheet's last button is on screen.
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    container = ProviderContainer(
      overrides: [
        authApiProvider.overrideWithValue(server.client()),
        coreApiProvider.overrideWith((ref) {
          final api = server.client();
          api.dio.interceptors.add(customerAuth.interceptor(ref, api.dio));
          return api;
        }),
        customerAuth.store.overrideWithValue(secure),
        deviceStoreProvider.overrideWithValue(device),
        realtimeTransportProvider.overrideWithValue(transport),
        ...overrides,
      ],
      retry: (retryCount, error) => null,
    );
    addTearDown(() {
      if (!_done) container.dispose();
    });
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const CustomerApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Ends the app inside the test, so live order screens stop their polling
  /// before Flutter checks for pending timers.
  Future<void> done(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    container.dispose();
    _done = true;
  }

  bool _done = false;

  /// The JSON body of the only request to [path].
  Map<String, dynamic> bodyOf(String path, {int index = 0}) {
    final data = server.to(path)[index].data;
    return (data is String ? jsonDecode(data) : data) as Map<String, dynamic>;
  }
}
