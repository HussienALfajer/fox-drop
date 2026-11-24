import 'package:core_auth/core_auth.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:customer/src/account/delete_account_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Slice D.11a: used-up attempts read as an expired code until D.11's code
// screen gives them words of their own.
void main() {
  final l10n = lookupAppLocalizations(const Locale('ar'));

  test('attempts_used shows the expired-code message', () {
    expect(
      deleteAccountMessage(
        l10n,
        const AuthRefusal('attempts_used', status: 400, attemptsLeft: 0),
      ),
      l10n.signInCodeExpired,
    );
  });
}
