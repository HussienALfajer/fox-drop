import 'package:core_api/core_api.dart';
import 'package:dio/dio.dart';

/// A pair of tokens (architecture §15.1): the access token for 15 minutes and
/// the refresh token, used once.
class AuthTokens {
  const AuthTokens({
    required this.accessToken,
    required this.accessTokenExpiresAt,
    required this.refreshToken,
  });

  final String accessToken;
  final DateTime accessTokenExpiresAt;
  final String refreshToken;
}

/// A code went out over WhatsApp.
class CodeSent {
  const CodeSent({required this.resendAfterSec});

  /// When the app may offer «إعادة الإرسال».
  final int resendAfterSec;
}

/// The support numbers the apps show (AP §9.13 contact info); null hides its
/// button.
class SupportContact {
  const SupportContact({this.phone, this.whatsapp});

  final String? phone;
  final String? whatsapp;
}

/// The server refused a sign-in call with [error], such as `not_on_whatsapp`,
/// `unavailable`, `resend_wait`, `wrong_code` or `other_device` (the identity
/// module's `CLAUDE.md`). [status] is null when no answer came.
class AuthRefusal implements Exception {
  const AuthRefusal(
    this.error, {
    this.status,
    this.retryAfterSec,
    this.attemptsLeft,
  });

  /// From a failed call: the body's `error`, or [network] with no answer.
  factory AuthRefusal.of(DioException exception) {
    final response = exception.response;
    if (response == null) return const AuthRefusal(network);
    final body = response.data;
    String? error;
    int? retryAfterSec;
    int? attemptsLeft;
    if (body is Map) {
      final value = body['error'];
      if (value is String) error = value;
      final retry = body['retryAfterSec'];
      if (retry is int) retryAfterSec = retry;
      final attempts = body['attemptsLeft'];
      if (attempts is int) attemptsLeft = attempts;
    }
    retryAfterSec ??= int.tryParse(response.headers.value('retry-after') ?? '');
    return AuthRefusal(
      error ?? 'http_${response.statusCode}',
      status: response.statusCode,
      retryAfterSec: retryAfterSec,
      attemptsLeft: attemptsLeft,
    );
  }

  /// No answer came from the server.
  static const network = 'network';

  final String error;
  final int? status;
  final int? retryAfterSec;
  final int? attemptsLeft;

  @override
  String toString() => 'AuthRefusal($error, $status)';
}

/// One app's sign-in routes on the generated client (E6). Its client must not
/// carry the session's interceptor: these calls run before a session exists,
/// or renew it.
abstract class AuthParty {
  AuthParty(this.api);

  final CoreApi api;

  Future<CodeSent> requestCode({
    required String phone,
    required String deviceId,
  });

  /// Signs in and returns the account id and the tokens.
  Future<(String, AuthTokens)> signIn({
    required String phone,
    required String deviceId,
    required String code,
  });

  Future<AuthTokens> refresh(String refreshToken);

  Future<void> signOut(String accessToken);

  Future<SupportContact> contact();

  /// The bearer header of a call made with an explicit token.
  static Map<String, dynamic> bearer(String accessToken) => {
    'Authorization': 'Bearer $accessToken',
  };

  /// Runs [call], turning a refused or failed call into an [AuthRefusal].
  static Future<T> guard<T>(Future<Response<T>> Function() call) async {
    try {
      final response = await call();
      final data = response.data;
      if (data == null) throw const AuthRefusal('empty_answer');
      return data;
    } on DioException catch (exception) {
      throw AuthRefusal.of(exception);
    }
  }
}

AuthTokens _tokens(String access, DateTime expiresAt, String refresh) =>
    AuthTokens(
      accessToken: access,
      accessTokenExpiresAt: expiresAt,
      refreshToken: refresh,
    );

SupportContact _contact(ContactDtoOutput contact) =>
    SupportContact(phone: contact.phone, whatsapp: contact.whatsapp);

/// The customer app (CU §5.2–5.4).
class CustomerAuth extends AuthParty {
  CustomerAuth(super.api);

  CustomerApi get _routes => api.getCustomerApi();

  @override
  Future<CodeSent> requestCode({
    required String phone,
    required String deviceId,
  }) async {
    final sent = await AuthParty.guard(
      () => _routes.customerAuthRequestCode(
        customerCodeRequestDto: CustomerCodeRequestDto(
          (b) => b
            ..phone = phone
            ..deviceId = deviceId,
        ),
      ),
    );
    return CodeSent(resendAfterSec: sent.resendAfterSec);
  }

  @override
  Future<(String, AuthTokens)> signIn({
    required String phone,
    required String deviceId,
    required String code,
  }) async {
    final s = await AuthParty.guard(
      () => _routes.customerAuthSignIn(
        customerSignInDto: CustomerSignInDto(
          (b) => b
            ..phone = phone
            ..deviceId = deviceId
            ..code = code,
        ),
      ),
    );
    return (
      s.accountId,
      _tokens(s.accessToken, s.accessTokenExpiresAt, s.refreshToken),
    );
  }

  @override
  Future<AuthTokens> refresh(String refreshToken) async {
    final t = await AuthParty.guard(
      () => _routes.customerAuthRefresh(
        customerRefreshDto: CustomerRefreshDto(
          (b) => b..refreshToken = refreshToken,
        ),
      ),
    );
    return _tokens(t.accessToken, t.accessTokenExpiresAt, t.refreshToken);
  }

  @override
  Future<void> signOut(String accessToken) => AuthParty.guard(
    () => _routes.customerAuthSignOut(headers: AuthParty.bearer(accessToken)),
  );

  @override
  Future<SupportContact> contact() async =>
      _contact(await AuthParty.guard(() => _routes.customerContactGet()));
}

/// The restaurant app (RA §5.2–5.3). [platform] lets the server exempt
/// Windows from App Check (the identity module's `CLAUDE.md`).
class MerchantAuth extends AuthParty {
  MerchantAuth(super.api, {required this.platform});

  final MerchantCodeRequestDtoPlatformEnum platform;

  MerchantApi get _routes => api.getMerchantApi();

  @override
  Future<CodeSent> requestCode({
    required String phone,
    required String deviceId,
  }) async {
    final sent = await AuthParty.guard(
      () => _routes.merchantAuthRequestCode(
        merchantCodeRequestDto: MerchantCodeRequestDto(
          (b) => b
            ..phone = phone
            ..deviceId = deviceId
            ..platform = platform,
        ),
      ),
    );
    return CodeSent(resendAfterSec: sent.resendAfterSec);
  }

  @override
  Future<(String, AuthTokens)> signIn({
    required String phone,
    required String deviceId,
    required String code,
  }) async {
    final s = await AuthParty.guard(
      () => _routes.merchantAuthSignIn(
        merchantSignInDto: MerchantSignInDto(
          (b) => b
            ..phone = phone
            ..deviceId = deviceId
            ..code = code,
        ),
      ),
    );
    return (
      s.accountId,
      _tokens(s.accessToken, s.accessTokenExpiresAt, s.refreshToken),
    );
  }

  @override
  Future<AuthTokens> refresh(String refreshToken) async {
    final t = await AuthParty.guard(
      () => _routes.merchantAuthRefresh(
        merchantRefreshDto: MerchantRefreshDto(
          (b) => b..refreshToken = refreshToken,
        ),
      ),
    );
    return _tokens(t.accessToken, t.accessTokenExpiresAt, t.refreshToken);
  }

  @override
  Future<void> signOut(String accessToken) => AuthParty.guard(
    () => _routes.merchantAuthSignOut(headers: AuthParty.bearer(accessToken)),
  );

  @override
  Future<SupportContact> contact() async =>
      _contact(await AuthParty.guard(() => _routes.merchantContactGet()));
}

/// The captain app (CA §4.9).
class CaptainAuth extends AuthParty {
  CaptainAuth(super.api);

  CaptainApi get _routes => api.getCaptainApi();

  @override
  Future<CodeSent> requestCode({
    required String phone,
    required String deviceId,
  }) async {
    final sent = await AuthParty.guard(
      () => _routes.captainAuthRequestCode(
        captainCodeRequestDto: CaptainCodeRequestDto(
          (b) => b
            ..phone = phone
            ..deviceId = deviceId,
        ),
      ),
    );
    return CodeSent(resendAfterSec: sent.resendAfterSec);
  }

  @override
  Future<(String, AuthTokens)> signIn({
    required String phone,
    required String deviceId,
    required String code,
  }) async {
    final s = await AuthParty.guard(
      () => _routes.captainAuthSignIn(
        captainSignInDto: CaptainSignInDto(
          (b) => b
            ..phone = phone
            ..deviceId = deviceId
            ..code = code,
        ),
      ),
    );
    return (
      s.accountId,
      _tokens(s.accessToken, s.accessTokenExpiresAt, s.refreshToken),
    );
  }

  @override
  Future<AuthTokens> refresh(String refreshToken) async {
    final t = await AuthParty.guard(
      () => _routes.captainAuthRefresh(
        captainRefreshDto: CaptainRefreshDto(
          (b) => b..refreshToken = refreshToken,
        ),
      ),
    );
    return _tokens(t.accessToken, t.accessTokenExpiresAt, t.refreshToken);
  }

  @override
  Future<void> signOut(String accessToken) => AuthParty.guard(
    () => _routes.captainAuthSignOut(headers: AuthParty.bearer(accessToken)),
  );

  @override
  Future<SupportContact> contact() async =>
      _contact(await AuthParty.guard(() => _routes.captainContactGet()));
}
