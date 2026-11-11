import 'dart:async';

import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_party.dart';
import 'auth_scope.dart';
import 'phone.dart';
import 'sign_in.dart';

/// The number and code steps (CU §5.2, RA §5.2, CA §4.9). Unstyled until the
/// design (the design stop in the root `CLAUDE.md`): plain Material widgets,
/// with the logic in [SignInController].
class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key, required this.scope, this.notice});

  final AuthScope scope;

  /// Shown above the number, such as «سُجّل دخولك من جهاز آخر».
  final String? notice;

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _phone = TextEditingController();
  final _code = TextEditingController();
  Timer? _ticker;

  AuthScope get _scope => widget.scope;

  @override
  void initState() {
    super.initState();
    // Redraws the resend countdown.
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      final resendAt = ref.read(_scope.signIn).resendAt;
      if (resendAt != null && mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _phone.dispose();
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(_scope.signIn);
    final controller = ref.read(_scope.signIn.notifier);
    ref.listen(_scope.signIn.select((s) => s.step), (previous, next) {
      if (next == SignInStep.code) _code.clear();
    });
    return Scaffold(
      appBar: AppBar(title: Text(l10n.signInTitle)),
      body: ListView(
        padding: const EdgeInsetsDirectional.all(16),
        children: switch (state.step) {
          SignInStep.phone => _phoneStep(l10n, state, controller),
          SignInStep.code => _codeStep(l10n, state, controller),
        },
      ),
    );
  }

  List<Widget> _phoneStep(
    AppLocalizations l10n,
    SignInState state,
    SignInController controller,
  ) {
    final refusal = state.refusal;
    return [
      if (widget.notice != null) Text(widget.notice!),
      DropdownButton<PhoneCountry>(
        value: state.country,
        onChanged: state.busy
            ? null
            : (country) {
                if (country != null) controller.selectCountry(country);
              },
        items: [
          DropdownMenuItem(
            value: PhoneCountry.syria,
            child: Text(l10n.signInCountrySyria),
          ),
          DropdownMenuItem(
            value: PhoneCountry.turkey,
            child: Text(l10n.signInCountryTurkey),
          ),
        ],
      ),
      TextField(
        key: const Key('sign-in-phone'),
        controller: _phone,
        keyboardType: TextInputType.phone,
        textDirection: TextDirection.ltr,
        enabled: !state.busy,
        decoration: InputDecoration(
          labelText: l10n.signInPhoneLabel,
          errorText: state.invalidPhone ? l10n.signInInvalidPhone : null,
        ),
        onSubmitted: controller.requestCode,
      ),
      FilledButton(
        onPressed: state.busy
            ? null
            : () => controller.requestCode(_phone.text),
        child: Text(l10n.signInSendCode),
      ),
      if (refusal != null) Text(_message(l10n, refusal)),
      if (state.unavailable && _scope.offersOperationsCode) ...[
        OutlinedButton(
          onPressed: controller.useOperationsCode,
          child: Text(l10n.signInOperationsCode),
        ),
        _ContactButtons(scope: _scope, whatsapp: false),
      ],
      if (refusal?.error == 'not_registered' &&
          ref.read(_scope.party) is MerchantAuth)
        _ContactButtons(scope: _scope, whatsapp: true),
    ];
  }

  List<Widget> _codeStep(
    AppLocalizations l10n,
    SignInState state,
    SignInController controller,
  ) {
    final phone = state.phone ?? '';
    final refusal = state.refusal;
    final resendAt = state.resendAt;
    final wait = resendAt == null
        ? 0
        : resendAt.difference(_scope.clock()).inMilliseconds;
    final waitSeconds = wait <= 0 ? 0 : (wait / 1000).ceil();
    return [
      Text(
        state.operationsCode
            ? l10n.signInOperationsCodeHint(phone)
            : l10n.signInCodeSent(phone),
        textDirection: TextDirection.rtl,
      ),
      TextField(
        key: const Key('sign-in-code'),
        controller: _code,
        keyboardType: TextInputType.number,
        textDirection: TextDirection.ltr,
        enabled: !state.busy,
        maxLength: 6,
        decoration: InputDecoration(labelText: l10n.signInCodeLabel),
        onChanged: (value) {
          if (westernDigits(value).length == 6) controller.submitCode(value);
        },
      ),
      FilledButton(
        onPressed: state.busy ? null : () => controller.submitCode(_code.text),
        child: Text(l10n.signInConfirm),
      ),
      TextButton(
        onPressed: state.busy ? null : () => _paste(controller),
        child: Text(l10n.signInPasteCode),
      ),
      if (refusal != null) Text(_message(l10n, refusal)),
      if (!state.operationsCode)
        TextButton(
          onPressed: state.busy || waitSeconds > 0 ? null : controller.resend,
          child: Text(
            waitSeconds > 0
                ? l10n.signInResendIn(waitSeconds)
                : l10n.signInResend,
          ),
        ),
      if (state.operationsCode ||
          (state.unavailable && _scope.offersOperationsCode))
        _ContactButtons(scope: _scope, whatsapp: false)
      else if (refusal?.error == 'not_registered' &&
          ref.read(_scope.party) is MerchantAuth)
        _ContactButtons(scope: _scope, whatsapp: true),
      TextButton(
        onPressed: state.busy ? null : controller.editPhone,
        child: Text(l10n.signInEditPhone),
      ),
    ];
  }

  // CU §5.2 item 2: the code field accepts paste, and the app offers to paste
  // a 6-digit code from the clipboard.
  Future<void> _paste(SignInController controller) async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final match = RegExp(r'\d{6}').firstMatch(westernDigits(data?.text ?? ''));
    if (match == null || !mounted) return;
    _code.text = match.group(0)!;
    await controller.submitCode(_code.text);
  }

  String _message(AppLocalizations l10n, AuthRefusal refusal) {
    final merchant = ref.read(_scope.party) is MerchantAuth;
    return switch (refusal.error) {
      'not_on_whatsapp' => l10n.signInNotOnWhatsapp,
      'unavailable' =>
        _scope.offersOperationsCode
            ? l10n.signInUnavailableOperations
            : l10n.signInUnavailable,
      'daily_limit' => l10n.signInDailyLimit,
      'hourly_limit' || 'ip_limit' => l10n.signInTryLater(
        ((refusal.retryAfterSec ?? 3600) / 60).ceil(),
      ),
      'resend_wait' => l10n.signInResendWait(refusal.retryAfterSec ?? 60),
      'wrong_code' => l10n.signInWrongCode(refusal.attemptsLeft ?? 0),
      'code_expired' => l10n.signInCodeExpired,
      'not_registered' =>
        merchant ? l10n.merchantNotRegistered : l10n.captainNotRegistered,
      'restaurant_draft' => l10n.merchantRestaurantDraft,
      'restaurant_terminated' => l10n.merchantRestaurantTerminated,
      'contract_ended' => l10n.captainContractEnded,
      'active_order_elsewhere' => l10n.captainActiveOrderElsewhere,
      _ => l10n.signInError,
    };
  }
}

/// «اتصال بالعمليات», and «واتساب العمليات» when [whatsapp], from the
/// support numbers (AP §9.13); a missing number hides its button.
class _ContactButtons extends ConsumerWidget {
  const _ContactButtons({required this.scope, required this.whatsapp});

  final AuthScope scope;
  final bool whatsapp;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final contact = ref.watch(scope.contact).value;
    final launch = ref.read(scope.launch);
    final phone = contact?.phone;
    final whatsappNumber = contact?.whatsapp;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (phone != null)
          OutlinedButton(
            onPressed: () => launch(Uri(scheme: 'tel', path: phone)),
            child: Text(l10n.signInCallOperations),
          ),
        if (whatsapp && whatsappNumber != null)
          OutlinedButton(
            onPressed: () =>
                launch(Uri.https('wa.me', '/${whatsappNumber.substring(1)}')),
            child: Text(l10n.signInWhatsappOperations),
          ),
      ],
    );
  }
}
