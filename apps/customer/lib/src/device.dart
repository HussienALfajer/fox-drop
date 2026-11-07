import 'package:core_storage/core_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The device's values that are not secret (`packages/core_storage`); tests
/// override it with a `MemoryDeviceStore`.
final deviceStoreProvider = Provider<DeviceStore>(
  (ref) => PreferencesDeviceStore(),
);

/// The phone's clock; tests fix it.
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

/// The app's version, sent with every quote and order so the server can ask
/// for an update (CU §10.6, `app.customer.min_version`). It is the pubspec's
/// `version` without the build number; `test/app_version_test.dart` keeps
/// them equal.
const appVersion = '0.1.0';
