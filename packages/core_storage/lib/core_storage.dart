/// Device storage of the FOX DROP apps (architecture §11.2): secrets in the
/// platform's secure store, and small device values in its preferences.
/// Drift caches and queues join with their first use.
library;

export 'src/device_store.dart';
export 'src/secure_store.dart';
