import 'package:captain/src/api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

// The debug default without API_BASE_URL (owner decision 2026-11-05).
void main() {
  tearDown(() => debugDefaultTargetPlatformOverride = null);

  test('reaches the development machine from the Android emulator', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    expect(apiBaseUrl(), 'http://10.0.2.2:3000');
  });

  test('reaches the development machine on localhost from iOS', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    expect(apiBaseUrl(), 'http://localhost:3000');
  });
}
