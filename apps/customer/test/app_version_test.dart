import 'dart:io';

import 'package:customer/src/device.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // The quote and the order send appVersion (CU §10.6): it must be the
  // pubspec's version without its build number.
  test('the app version is the pubspec\'s', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final version = RegExp(
      r'^version: (\S+?)(\+\d+)?$',
      multiLine: true,
    ).firstMatch(pubspec)!.group(1);
    expect(appVersion, version);
  });
}
