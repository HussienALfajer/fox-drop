import 'package:core_api/core_api.dart';
import 'package:core_auth/core_auth.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../api.dart';
import '../auth.dart';

/// Where «حذف الحساب» stands (CU §5.6): the explanation, then the fresh
/// code (Q20), then the closure.
class DeleteAccountState {
  const DeleteAccountState({
    this.codeSent = false,
    this.busy = false,
    this.refusal,
    this.closed = false,
  });

  final bool codeSent;
  final bool busy;

  /// The server's refusal of the last call: `active_order`, the code
  /// request's limits, `wrong_code`, `attempts_used` or `code_expired`.
  final AuthRefusal? refusal;

  /// The account is «مغلق»; this device signed out.
  final bool closed;
}

/// CU §5.6, D19 (slice 2.25c): a fresh code to the account's own number,
/// then `POST /v1/customer/account/close` with it. The server refuses both
/// with `active_order` while an order is active. Once closed, every session
/// of the account ended on the server, so this device signs out too.
class DeleteAccount extends Notifier<DeleteAccountState> {
  @override
  DeleteAccountState build() => const DeleteAccountState();

  Future<void> sendCode() async {
    if (state.busy) return;
    state = DeleteAccountState(codeSent: state.codeSent, busy: true);
    try {
      final appCheckToken = await ref.read(customerAuth.appCheck)();
      await ref
          .read(coreApiProvider)
          .getCustomerApi()
          .customerClosureRequestCode(xFirebaseAppCheck: appCheckToken);
      state = const DeleteAccountState(codeSent: true);
    } on DioException catch (exception) {
      state = DeleteAccountState(
        codeSent: state.codeSent,
        refusal: AuthRefusal.of(exception),
      );
    }
  }

  Future<void> close(String code) async {
    if (state.busy) return;
    state = const DeleteAccountState(codeSent: true, busy: true);
    try {
      await ref
          .read(coreApiProvider)
          .getCustomerApi()
          .customerClosureClose(
            customerCloseAccountDto: CustomerCloseAccountDto(
              (dto) => dto..code = code,
            ),
          );
    } on DioException catch (exception) {
      state = DeleteAccountState(
        codeSent: true,
        refusal: AuthRefusal.of(exception),
      );
      return;
    }
    await ref
        .read(customerAuth.session.notifier)
        .end(SessionEndReason.signedOut);
    state = const DeleteAccountState(codeSent: true, closed: true);
  }
}

final deleteAccountProvider =
    NotifierProvider.autoDispose<DeleteAccount, DeleteAccountState>(
      DeleteAccount.new,
    );

/// The sentence for a refusal of «حذف الحساب».
String deleteAccountMessage(AppLocalizations l10n, AuthRefusal refusal) =>
    switch (refusal.error) {
      'active_order' => l10n.customerDeleteAccountActiveOrder,
      'not_on_whatsapp' => l10n.signInNotOnWhatsapp,
      'unavailable' => l10n.signInUnavailable,
      'daily_limit' => l10n.signInDailyLimit,
      'hourly_limit' || 'ip_limit' => l10n.signInTryLater(
        ((refusal.retryAfterSec ?? 3600) / 60).ceil(),
      ),
      'resend_wait' => l10n.signInResendWait(refusal.retryAfterSec ?? 60),
      'wrong_code' => l10n.signInWrongCode(refusal.attemptsLeft ?? 0),
      // Slice D.11a: used-up attempts read as an expired code until D.11's
      // code screen gives them words of their own.
      'code_expired' || 'attempts_used' => l10n.signInCodeExpired,
      _ => l10n.customerDeleteAccountFailed,
    };

/// «حذف الحساب» (CU §5.6): what closing means, the fresh code and the
/// confirmation; home as a guest once closed. Unstyled until the design.
class DeleteAccountScreen extends ConsumerStatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  ConsumerState<DeleteAccountScreen> createState() =>
      _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends ConsumerState<DeleteAccountScreen> {
  final _code = TextEditingController();

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(deleteAccountProvider);
    final controller = ref.read(deleteAccountProvider.notifier);
    ref.listen(deleteAccountProvider, (_, next) {
      if (next.closed) context.go('/');
    });
    return Scaffold(
      appBar: AppBar(title: Text(l10n.customerDeleteAccount)),
      body: ListView(
        padding: const EdgeInsetsDirectional.all(16),
        children: [
          Text(l10n.customerDeleteAccountNoSignIn),
          Text(l10n.customerDeleteAccountLoses),
          Text(l10n.customerDeleteAccountPrivacy),
          if (!state.codeSent)
            ElevatedButton(
              key: const Key('send-delete-code'),
              onPressed: state.busy ? null : controller.sendCode,
              child: Text(l10n.customerDeleteAccountSendCode),
            )
          else ...[
            Text(l10n.customerDeleteAccountCodeSent),
            TextField(
              key: const Key('delete-code'),
              controller: _code,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(labelText: l10n.signInCodeLabel),
            ),
            ElevatedButton(
              key: const Key('confirm-delete-account'),
              onPressed: state.busy
                  ? null
                  : () => controller.close(westernDigits(_code.text.trim())),
              child: Text(l10n.customerDeleteAccountConfirm),
            ),
            TextButton(
              onPressed: state.busy ? null : controller.sendCode,
              child: Text(l10n.customerDeleteAccountSendCode),
            ),
          ],
          if (state.refusal case final refusal?)
            Text(
              deleteAccountMessage(l10n, refusal),
              key: const Key('delete-account-refusal'),
            ),
        ],
      ),
    );
  }
}
