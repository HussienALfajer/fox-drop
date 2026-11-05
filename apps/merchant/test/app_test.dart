import 'dart:convert';
import 'dart:typed_data';

import 'package:core_api/core_api.dart';
import 'package:merchant/src/api.dart';
import 'package:merchant/src/app.dart';
import 'package:merchant/src/router.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Answers every request with [statusCode] and records the requests.
class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.statusCode);

  final int statusCode;
  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromString(
      jsonEncode({'status': 'ok', 'serverTime': 1}),
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Future<ProviderContainer> _pumpApp(
  WidgetTester tester,
  _FakeAdapter adapter,
) async {
  final api = CoreApi(basePathOverride: 'https://api.example.test');
  api.dio.httpClientAdapter = adapter;
  final container = ProviderContainer(
    overrides: [coreApiProvider.overrideWithValue(api)],
    retry: (retryCount, error) => null,
  );
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const MerchantApp()),
  );
  return container;
}

void main() {
  testWidgets('shows the server status in Arabic, right to left', (
    tester,
  ) async {
    final adapter = _FakeAdapter(200);
    await _pumpApp(tester, adapter);

    expect(find.text('جارٍ الاتصال بالخادم…'), findsOneWidget);
    await tester.pumpAndSettle();

    expect(find.text('تطبيق المطعم'), findsOneWidget);
    final status = find.text('الخادم يعمل');
    expect(status, findsOneWidget);
    expect(Directionality.of(tester.element(status)), TextDirection.rtl);
    expect(
      adapter.requests.single.uri.toString(),
      'https://api.example.test/v1/merchant/status',
    );
  });

  testWidgets('says when the server cannot be reached', (tester) async {
    await _pumpApp(tester, _FakeAdapter(503));
    await tester.pumpAndSettle();

    expect(find.text('تعذّر الاتصال بالخادم'), findsOneWidget);
  });

  testWidgets('answers an unknown route with the not-found screen', (
    tester,
  ) async {
    final container = await _pumpApp(tester, _FakeAdapter(200));
    container.read(routerProvider).go('/unknown');
    await tester.pumpAndSettle();

    expect(find.text('الصفحة غير موجودة'), findsOneWidget);
  });
}
