# packages/core_storage

Device storage of the three Flutter apps (architecture §11.2).

## Rules

- Secrets (the session's tokens, the device id) go only through `SecureStore`: `PlatformSecureStore` in the apps (`flutter_secure_storage`: Android Keystore, iOS Keychain, Windows DPAPI), `MemorySecureStore` in tests. Never in shared preferences, a file or a log.
- Drift (SQLite) for caches and the command queue joins this package with its first use (§11.2).
