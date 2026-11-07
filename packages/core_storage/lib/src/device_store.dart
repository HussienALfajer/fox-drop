import 'package:shared_preferences/shared_preferences.dart';

/// A small key-value store for values that are not secret and belong to this
/// device, such as the customer's cart (CU §10.1) or the last «سأدفع بـ»
/// choice (CU §10.5). The apps use [PreferencesDeviceStore]; tests use
/// [MemoryDeviceStore]. Secrets go in a `SecureStore`.
abstract interface class DeviceStore {
  Future<String?> read(String key);

  Future<void> write(String key, String value);

  Future<void> delete(String key);
}

/// Android's SharedPreferences or iOS' NSUserDefaults, through
/// `shared_preferences`. Its values go when the app is removed.
class PreferencesDeviceStore implements DeviceStore {
  PreferencesDeviceStore([SharedPreferencesAsync? preferences])
    : _preferences = preferences ?? SharedPreferencesAsync();

  final SharedPreferencesAsync _preferences;

  @override
  Future<String?> read(String key) => _preferences.getString(key);

  @override
  Future<void> write(String key, String value) =>
      _preferences.setString(key, value);

  @override
  Future<void> delete(String key) => _preferences.remove(key);
}

/// Keeps the values in memory, for tests.
class MemoryDeviceStore implements DeviceStore {
  MemoryDeviceStore([Map<String, String>? values]) : values = values ?? {};

  final Map<String, String> values;

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async => values[key] = value;

  @override
  Future<void> delete(String key) async => values.remove(key);
}
