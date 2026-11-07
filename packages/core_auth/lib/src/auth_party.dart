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

  /// On this device's clock (see [AuthParty.localExpiry]).
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

  /// Any other failure, such as the secure store failing.
  static const failed = 'failed';

  final String error;
  final int? status;
  final int? retryAfterSec;
  final int? attemptsLeft;

  /// The server may have done the work without its answer reaching the app:
  /// no answer, or the proxy's 502, 503 or 504 with no error of the API's.
  bool get unanswered =>
      error == network ||
      (const {502, 503, 504}.contains(status) && error.startsWith('http_'));

  @override
  String toString() => 'AuthRefusal($error, $status)';
}

/// One app's sign-in routes on the generated client (E6). Its client must not
/// carry the session's interceptor: these calls run before a session exists,
/// or renew it.
abstract class AuthParty {
  AuthParty(this.api);

  final CoreApi api;

  /// Asks for a code; [appCheckToken] travels as `X-Firebase-AppCheck`
  /// (architecture §8.3.3 item 1), the only call that carries it.
  Future<CodeSent> requestCode({
    required String phone,
    required String deviceId,
    String? appCheckToken,
  });

  /// Signs in and returns the account id and the tokens.
  Future<(String, AuthTokens)> signIn({
    required String phone,
    required String deviceId,
    required String code,
  });

  Future<AuthTokens> refresh(String refreshToken, {CancelToken? cancelToken});

  Future<void> signOut(String accessToken);

  Future<SupportContact> contact();

  /// The bearer header of a call made with an explicit token.
  static Map<String, dynamic> bearer(String accessToken) => {
    'Authorization': 'Bearer $accessToken',
  };

  /// Runs [call], turning a refused or failed call into an [AuthRefusal].
  static Future<Response<T>> guard<T>(
    Future<Response<T>> Function() call,
  ) async {
    try {
      final response = await call();
      if (response.data == null) throw const AuthRefusal('empty_answer');
      return response;
    } on DioException catch (exception) {
      throw AuthRefusal.of(exception);
    }
  }

  /// The token's expiry on this device's clock: the server's expiry moved by
  /// the difference between the answer's `Server-Time` and this clock, so a
  /// phone whose clock is wrong renews on time (architecture §11.2).
  static DateTime localExpiry(Response<Object?> response, DateTime expiresAt) {
    final serverMs = int.tryParse(response.headers.value('server-time') ?? '');
    if (serverMs == null) return expiresAt;
    final offset = DateTime.fromMillisecondsSinceEpoch(
      serverMs,
      isUtc: true,
    ).difference(DateTime.now());
    return expiresAt.subtract(offset);
  }
}

AuthTokens _tokens(
  Response<Object?> response,
  String access,
  DateTime expiresAt,
  String refresh,
) => AuthTokens(
  accessToken: access,
  accessTokenExpiresAt: AuthParty.localExpiry(response, expiresAt),
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
    String? appCheckToken,
  }) async {
    final sent = await AuthParty.guard(
      () => _routes.customerAuthRequestCode(
        xFirebaseAppCheck: appCheckToken,
        customerCodeRequestDto: CustomerCodeRequestDto(
          (b) => b
            ..phone = phone
            ..deviceId = deviceId,
        ),
      ),
    );
    return CodeSent(resendAfterSec: sent.data!.resendAfterSec);
  }

  @override
  Future<(String, AuthTokens)> signIn({
    required String phone,
    required String deviceId,
    required String code,
  }) async {
    final r = await AuthParty.guard(
      () => _routes.customerAuthSignIn(
        customerSignInDto: CustomerSignInDto(
          (b) => b
            ..phone = phone
            ..deviceId = deviceId
            ..code = code,
        ),
      ),
    );
    final s = r.data!;
    return (
      s.accountId,
      _tokens(r, s.accessToken, s.accessTokenExpiresAt, s.refreshToken),
    );
  }

  @override
  Future<AuthTokens> refresh(
    String refreshToken, {
    CancelToken? cancelToken,
  }) async {
    final r = await AuthParty.guard(
      () => _routes.customerAuthRefresh(
        customerRefreshDto: CustomerRefreshDto(
          (b) => b..refreshToken = refreshToken,
        ),
        cancelToken: cancelToken,
      ),
    );
    final t = r.data!;
    return _tokens(r, t.accessToken, t.accessTokenExpiresAt, t.refreshToken);
  }

  @override
  Future<void> signOut(String accessToken) => AuthParty.guard(
    () => _routes.customerAuthSignOut(headers: AuthParty.bearer(accessToken)),
  );

  @override
  Future<SupportContact> contact() async =>
      _contact((await AuthParty.guard(_routes.customerContactGet)).data!);
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
    String? appCheckToken,
  }) async {
    final sent = await AuthParty.guard(
      () => _routes.merchantAuthRequestCode(
        xFirebaseAppCheck: appCheckToken,
        merchantCodeRequestDto: MerchantCodeRequestDto(
          (b) => b
            ..phone = phone
            ..deviceId = deviceId
            ..platform = platform,
        ),
      ),
    );
    return CodeSent(resendAfterSec: sent.data!.resendAfterSec);
  }

  @override
  Future<(String, AuthTokens)> signIn({
    required String phone,
    required String deviceId,
    required String code,
  }) async {
    final r = await AuthParty.guard(
      () => _routes.merchantAuthSignIn(
        merchantSignInDto: MerchantSignInDto(
          (b) => b
            ..phone = phone
            ..deviceId = deviceId
            ..code = code,
        ),
      ),
    );
    final s = r.data!;
    return (
      s.accountId,
      _tokens(r, s.accessToken, s.accessTokenExpiresAt, s.refreshToken),
    );
  }

  @override
  Future<AuthTokens> refresh(
    String refreshToken, {
    CancelToken? cancelToken,
  }) async {
    final r = await AuthParty.guard(
      () => _routes.merchantAuthRefresh(
        merchantRefreshDto: MerchantRefreshDto(
          (b) => b..refreshToken = refreshToken,
        ),
        cancelToken: cancelToken,
      ),
    );
    final t = r.data!;
    return _tokens(r, t.accessToken, t.accessTokenExpiresAt, t.refreshToken);
  }

  @override
  Future<void> signOut(String accessToken) => AuthParty.guard(
    () => _routes.merchantAuthSignOut(headers: AuthParty.bearer(accessToken)),
  );

  @override
  Future<SupportContact> contact() async =>
      _contact((await AuthParty.guard(_routes.merchantContactGet)).data!);
}

/// The captain app (CA §4.9).
class CaptainAuth extends AuthParty {
  CaptainAuth(super.api);

  CaptainApi get _routes => api.getCaptainApi();

  @override
  Future<CodeSent> requestCode({
    required String phone,
    required String deviceId,
    String? appCheckToken,
  }) async {
    final sent = await AuthParty.guard(
      () => _routes.captainAuthRequestCode(
        xFirebaseAppCheck: appCheckToken,
        captainCodeRequestDto: CaptainCodeRequestDto(
          (b) => b
            ..phone = phone
            ..deviceId = deviceId,
        ),
      ),
    );
    return CodeSent(resendAfterSec: sent.data!.resendAfterSec);
  }

  @override
  Future<(String, AuthTokens)> signIn({
    required String phone,
    required String deviceId,
    required String code,
  }) async {
    final r = await AuthParty.guard(
      () => _routes.captainAuthSignIn(
        captainSignInDto: CaptainSignInDto(
          (b) => b
            ..phone = phone
            ..deviceId = deviceId
            ..code = code,
        ),
      ),
    );
    final s = r.data!;
    return (
      s.accountId,
      _tokens(r, s.accessToken, s.accessTokenExpiresAt, s.refreshToken),
    );
  }

  @override
  Future<AuthTokens> refresh(
    String refreshToken, {
    CancelToken? cancelToken,
  }) async {
    final r = await AuthParty.guard(
      () => _routes.captainAuthRefresh(
        captainRefreshDto: CaptainRefreshDto(
          (b) => b..refreshToken = refreshToken,
        ),
        cancelToken: cancelToken,
      ),
    );
    final t = r.data!;
    return _tokens(r, t.accessToken, t.accessTokenExpiresAt, t.refreshToken);
  }

  @override
  Future<void> signOut(String accessToken) => AuthParty.guard(
    () => _routes.captainAuthSignOut(headers: AuthParty.bearer(accessToken)),
  );

  @override
  Future<SupportContact> contact() async =>
      _contact((await AuthParty.guard(_routes.captainContactGet)).data!);
}
