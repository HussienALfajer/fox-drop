import 'dart:async';

import 'notification_permission.dart';
import 'push.dart';

/// A [Push] a test drives: its token, renewals and taps.
class FakePush implements Push {
  FakePush({this.currentToken = 'push-token-0', this.initial});

  String? currentToken;
  PushData? initial;

  /// How many [token] calls fail before one answers (no connection).
  int failures = 0;

  /// Whether [token] also gives the token on [tokenRefreshes], as
  /// `register()` makes `onRegistered` do.
  bool echo = false;
  final _refreshes = StreamController<String>.broadcast();
  final _taps = StreamController<PushData>.broadcast();
  final _received = StreamController<PushData>.broadcast();

  /// Firebase renews the token.
  void renew(String token) {
    currentToken = token;
    _refreshes.add(token);
  }

  /// The person taps a push while the app runs in the background.
  void tap(PushData data) => _taps.add(data);

  /// A push arrives while the app is in the foreground.
  void receive(PushData data) => _received.add(data);

  @override
  Future<String?> token() async {
    if (failures > 0) {
      failures--;
      throw StateError('offline');
    }
    if (echo && currentToken != null) _refreshes.add(currentToken!);
    return currentToken;
  }

  @override
  Stream<String> get tokenRefreshes => _refreshes.stream;

  @override
  Future<PushData?> initialTap() async => initial;

  @override
  Stream<PushData> get taps => _taps.stream;

  @override
  Stream<PushData> get received => _received.stream;
}

/// A [NotificationPermission] a test sets: what the phone answers.
class FakeNotificationPermission implements NotificationPermission {
  FakeNotificationPermission({this.allowed = false, this.answer = true});

  bool allowed;

  /// What the person answers when asked.
  bool answer;
  int requests = 0;
  int settingsOpened = 0;

  @override
  Future<bool> granted() async => allowed;

  @override
  Future<bool> request() async {
    requests++;
    return allowed = answer;
  }

  @override
  Future<void> openSettings() async => settingsOpened++;
}
