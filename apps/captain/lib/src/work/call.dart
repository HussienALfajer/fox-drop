import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../auth.dart';

/// CA §9.11 «طوارئ»: the call to operations. On Android it calls directly
/// with the call permission (CA §4.5 check 8), else it opens the dialer
/// with the number; on iPhone iOS asks to confirm the call.
abstract interface class OperationsCaller {
  /// Asks for the call permission while the phone does not allow it.
  Future<void> prepare();

  /// Calls [phone].
  Future<void> call(String phone);
}

/// The phone's caller; tests give a fake.
final operationsCallerProvider = Provider<OperationsCaller>(
  (ref) => PhoneCaller(ref.read(captainAuth.launch)),
);

/// Asks for the call permission at «متصل» (check 8 of the device check,
/// CA §4.5, until it exists, as the notification permission is); the answer
/// never blocks going online.
Future<void> askCallPermission(Ref ref) =>
    ref.read(operationsCallerProvider).prepare();

class PhoneCaller implements OperationsCaller {
  const PhoneCaller(this._launch);

  final Future<bool> Function(Uri) _launch;

  // MainActivity's channel: ACTION_CALL with the permission, ACTION_DIAL
  // without it.
  static const _channel = MethodChannel('com.foxdrop.captain/call');

  bool get _android => defaultTargetPlatform == TargetPlatform.android;

  @override
  Future<void> prepare() async {
    if (!_android) return;
    try {
      if (!await Permission.phone.isGranted) await Permission.phone.request();
    } on Object catch (error) {
      debugPrint('Call permission: $error');
    }
  }

  @override
  Future<void> call(String phone) async {
    if (_android) {
      try {
        await _channel.invokeMethod<bool>('call', {'phone': phone});
        return;
      } on Object catch (error) {
        debugPrint('Direct call: $error');
      }
    }
    await _launch(Uri(scheme: 'tel', path: phone));
  }
}
