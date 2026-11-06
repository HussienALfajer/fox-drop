import 'package:core_storage/core_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'auth_party.dart';
import 'session.dart';
import 'sign_in.dart';

/// One app's sign-in and session providers. An app makes one, as a top-level
/// `final`, with its [AuthParty]; tests override [store] and [launch].
class AuthScope {
  AuthScope({
    required AuthParty Function(Ref ref) party,
    this.offersOperationsCode = false,
    DateTime Function()? clock,
    this.refreshAhead = const Duration(minutes: 1),
    this.refreshRetryDelays = const [
      Duration(seconds: 1),
      Duration(seconds: 3),
    ],
  }) : _party = party,
       clock = clock ?? DateTime.now;

  final AuthParty Function(Ref ref) _party;

  /// The captain and restaurant apps offer «لديّ رمز من العمليات» when no code
  /// can be sent (RA §5.2, CA §4.9); the customer app does not.
  final bool offersOperationsCode;

  final DateTime Function() clock;

  /// How long before its expiry the access token is renewed.
  final Duration refreshAhead;

  /// The waits between tries of a refresh that got no answer; they must stay
  /// within the server's 10-second retry grace.
  final List<Duration> refreshRetryDelays;

  late final party = Provider<AuthParty>(_party);

  final store = Provider<SecureStore>((ref) => PlatformSecureStore());

  /// Opens a `tel:` or WhatsApp link; false when nothing could open it.
  final launch = Provider<Future<bool> Function(Uri)>(
    (ref) =>
        (uri) => launchUrl(uri, mode: LaunchMode.externalApplication),
  );

  late final session = AsyncNotifierProvider<SessionController, SessionState>(
    () => SessionController(this),
  );

  late final signIn =
      NotifierProvider.autoDispose<SignInController, SignInState>(
        () => SignInController(this),
      );

  /// The support numbers (AP §9.13 contact info).
  late final contact = FutureProvider.autoDispose<SupportContact>(
    (ref) => ref.watch(party).contact(),
  );

  /// The interceptor for the app's client [dio], which must be another client
  /// than [party]'s.
  AuthInterceptor interceptor(Ref ref, Dio dio) =>
      AuthInterceptor(() => ref.read(session.notifier), dio);
}
