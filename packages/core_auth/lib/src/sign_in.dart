import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_party.dart';
import 'auth_scope.dart';
import 'phone.dart';

enum SignInStep { phone, code }

/// Where the sign-in stands (CU §5.2, RA §5.2, CA §4.9). Presentation reads
/// it; [SignInController] changes it.
class SignInState {
  const SignInState({
    this.step = SignInStep.phone,
    this.country = PhoneCountry.syria,
    this.phone,
    this.busy = false,
    this.invalidPhone = false,
    this.refusal,
    this.resendAt,
    this.operationsCode = false,
  });

  final SignInStep step;
  final PhoneCountry country;

  /// The number in E.164, once the user entered a valid one.
  final String? phone;

  /// A call is on its way.
  final bool busy;
  final bool invalidPhone;

  /// The last refusal, shown until the next action.
  final AuthRefusal? refusal;

  /// When «إعادة الإرسال» becomes available; null when no code was sent.
  final DateTime? resendAt;

  /// The code screen opened from «لديّ رمز من العمليات»: no code was sent,
  /// the user types the emergency code operations gave (architecture §8.3.5).
  final bool operationsCode;

  /// No code can be sent now: the captain and restaurant apps offer
  /// «لديّ رمز من العمليات».
  bool get unavailable => refusal?.error == 'unavailable';
}

/// The sign-in steps: the number, the code request, the code and the
/// sign-in. On success the session starts and the app's router moves on.
class SignInController extends Notifier<SignInState> {
  SignInController(this._scope);

  final AuthScope _scope;

  @override
  SignInState build() => const SignInState();

  void selectCountry(PhoneCountry country) {
    state = SignInState(country: country);
  }

  /// Asks for a code for the number typed in the selected country.
  Future<void> requestCode(String input) async {
    final phone = e164Phone(state.country, input);
    if (phone == null) {
      state = SignInState(country: state.country, invalidPhone: true);
      return;
    }
    await _send(phone, step: SignInStep.phone);
  }

  /// «إعادة الإرسال» on the code step.
  Future<void> resend() async {
    final phone = state.phone;
    if (phone == null || state.busy) return;
    await _send(phone, step: SignInStep.code);
  }

  Future<void> _send(String phone, {required SignInStep step}) async {
    state = SignInState(
      step: step,
      country: state.country,
      phone: phone,
      busy: true,
      resendAt: state.resendAt,
    );
    final session = ref.read(_scope.session.notifier);
    try {
      final sent = await ref
          .read(_scope.party)
          .requestCode(phone: phone, deviceId: await session.deviceId());
      if (!ref.mounted) return;
      state = SignInState(
        step: SignInStep.code,
        country: state.country,
        phone: phone,
        resendAt: _scope.clock().add(Duration(seconds: sent.resendAfterSec)),
      );
    } on Object catch (error) {
      if (!ref.mounted) return;
      // The secure store or the session may fail too; never stay busy.
      final refusal = error is AuthRefusal
          ? error
          : const AuthRefusal(AuthRefusal.failed);
      // A code is still open for this number, such as an emergency code from
      // operations, which a request never replaces: enter it.
      if (refusal.error == 'resend_wait') {
        state = SignInState(
          step: SignInStep.code,
          country: state.country,
          phone: phone,
          refusal: step == SignInStep.code ? refusal : null,
          resendAt: _scope.clock().add(
            Duration(seconds: refusal.retryAfterSec ?? 60),
          ),
        );
        return;
      }
      state = SignInState(
        step: step,
        country: state.country,
        phone: phone,
        refusal: refusal,
        resendAt: state.resendAt,
      );
    }
  }

  /// «لديّ رمز من العمليات»: the code step for the number entered, with no
  /// code sent (RA §5.2, CA §4.9).
  void useOperationsCode() {
    final phone = state.phone;
    if (phone == null || !_scope.offersOperationsCode) return;
    state = SignInState(
      step: SignInStep.code,
      country: state.country,
      phone: phone,
      operationsCode: true,
    );
  }

  /// Signs in with a 6-digit code.
  Future<void> submitCode(String input) async {
    final code = westernDigits(input);
    final phone = state.phone;
    if (phone == null || code.length != 6 || state.busy) return;
    final operationsCode = state.operationsCode;
    state = SignInState(
      step: SignInStep.code,
      country: state.country,
      phone: phone,
      busy: true,
      resendAt: state.resendAt,
      operationsCode: operationsCode,
    );
    final session = ref.read(_scope.session.notifier);
    try {
      final (accountId, tokens) = await ref
          .read(_scope.party)
          .signIn(phone: phone, deviceId: await session.deviceId(), code: code);
      await session.start(accountId, tokens);
      if (!ref.mounted) return;
      state = SignInState(country: state.country);
    } on Object catch (error) {
      if (!ref.mounted) return;
      // The secure store or the session may fail too; never stay busy.
      final refusal = error is AuthRefusal
          ? error
          : const AuthRefusal(AuthRefusal.failed);
      state = SignInState(
        step: SignInStep.code,
        country: state.country,
        phone: phone,
        refusal: refusal,
        resendAt: state.resendAt,
        operationsCode: operationsCode,
      );
    }
  }

  /// «تعديل الرقم»: back to the number.
  void editPhone() {
    state = SignInState(country: state.country);
  }
}
