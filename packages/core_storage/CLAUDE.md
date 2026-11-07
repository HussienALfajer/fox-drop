# packages/core_storage

Device storage of the three Flutter apps (architecture §11.2).

## Rules

- Secrets (the session's tokens, the device id) go only through `SecureStore`: `PlatformSecureStore` in the apps (`flutter_secure_storage`: Android Keystore, iOS Keychain, Windows DPAPI), `MemorySecureStore` in tests. Never in shared preferences, a file or a log.
- Small device values that are not secret (the customer's cart, the last «سأدفع بـ» choice; slice 1.14d, owner decision 2026-11-07) go through `DeviceStore`: `PreferencesDeviceStore` in the apps (`shared_preferences`), `MemoryDeviceStore` in tests. Each value is one string under its key, JSON for a structure, so a value is never half written.
- Drift (SQLite) for caches and the command queue joins this package with its first use (§11.2).
