import 'dart:async';

import 'package:core_auth/core_auth.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('gives the token of its source', () async {
    expect(await guardedAppCheckToken(() async => 'token'), 'token');
  });

  test('gives none when attestation fails', () async {
    expect(
      await guardedAppCheckToken(() async => throw StateError('no play')),
      isNull,
    );
  });

  test('gives none when attestation takes too long', () async {
    final never = Completer<String?>();
    expect(
      await guardedAppCheckToken(
        () => never.future,
        timeout: const Duration(milliseconds: 10),
      ),
      isNull,
    );
  });

  test('waits 10 seconds by default', () {
    expect(appCheckTokenTimeout, const Duration(seconds: 10));
  });
}
