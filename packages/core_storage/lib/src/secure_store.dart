import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// A small key-value store for secrets, such as the session's tokens
/// (architecture §11.2, §15.1). The apps use [PlatformSecureStore]; tests use
/// [MemorySecureStore].
abstract interface class SecureStore {
  Future<String?> read(String key);

  Future<void> write(String key, String value);

  Future<void> delete(String key);
}

/// The Android Keystore, the iOS Keychain or Windows' DPAPI, through
/// `flutter_secure_storage`. Its values go when the app is removed.
class PlatformSecureStore implements SecureStore {
  PlatformSecureStore([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}

/// Keeps the values in memory, for tests.
class MemorySecureStore implements SecureStore {
  MemorySecureStore([Map<String, String>? values]) : values = values ?? {};

  final Map<String, String> values;

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async => values[key] = value;

  @override
  Future<void> delete(String key) async => values.remove(key);
}
