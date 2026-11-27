import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_party.dart';
import 'auth_scope.dart';
import 'phone.dart' show westernDigits;
import 'phone_rules.dart' show foxReadPhone;

enum SignInStep { phone, code }

/// Where the sign-in stands (CU §5.2, RA §5.2, CA §4.9). Presentation reads
/// it; [SignInController] changes it.
class SignInState {
  const SignInState({
    this.step = SignInStep.phone,
    this.country = 'SY',
    this.phone,
    this.busy = false,
    this.invalidPhone = false,
    this.refusal,
    this.resendAt,
    this.operationsCode = false,
  });

  final SignInStep step;

  /// The phone field's country (ISO); Syria until the user picks another
  /// or types a number of another (D.11b).
  final String country;

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

  /// The captain app's «انضم ككابتن» (CA §5.1): the code goes to a number
  /// without an account too, and its sign-in makes the applicant's account.
  bool _join = false;

  @override
  SignInState build() => const SignInState();

  void selectCountry(String country) {
    state = SignInState(country: country);
  }

  /// Asks for a code for the number typed in the selected country; [join]
  /// is «انضم ككابتن» (CA §5.1), kept for «إعادة الإرسال».
  Future<void> requestCode(String input, {bool join = false}) async {
    _join = join;
    // Any country's mobile, read by the shared rules (D.11b): a number of
    // another country moves the field's country to it.
    final reading = foxReadPhone(input, state.country);
    final phone = reading.e164;
    if (phone == null) {
      state = SignInState(country: reading.country, invalidPhone: true);
      return;
    }
    state = SignInState(country: reading.country);
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
      final deviceId = await session.deviceId();
      final appCheckToken = await ref.read(_scope.appCheck)();
      final sent = await ref
          .read(_scope.party)
          .requestCode(
            phone: phone,
            deviceId: deviceId,
            appCheckToken: appCheckToken,
            join: _join,
          );
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
