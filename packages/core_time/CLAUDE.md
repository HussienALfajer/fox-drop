# packages/core_time

The server clock of the three Flutter apps (architecture §11.2; RA §4.7). A plain Dart package, tested with `dart test`.

## Rules

- **Every countdown and every «منذ» timer runs on `ServerClock`** (`now`, `until`, `since`), never on `DateTime.now()`: a phone with a wrong clock must not change an auto-cancel, prep or pickup countdown (RA §4.7).
- The offset comes from the `Server-Time` header (Unix milliseconds) of every answer, refusals included: each app adds `ServerTimeInterceptor` to its main client, and keeps one `ServerClock` for the app (a provider in the app's `api.dart`). The latest answer wins; the trip time is not subtracted, since countdowns show whole seconds.
- Tests build `ServerClock(deviceNow: ...)` with a fixed time, so they never depend on the machine's clock.
