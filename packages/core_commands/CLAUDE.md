# packages/core_commands

The outgoing command queue of the apps (architecture §11.2, §5.3; RA §4.7; slice 2.42). The restaurant app's board is its first user (`apps/merchant/lib/src/board/commands.dart`).

## Rules

- **What it keeps:** `QueuedCommand`, a command sent and not answered yet: its `Idempotency-Key`, its kind, its subject (an order), the account, its arguments as JSON values and when it was queued. `identity` (subject, kind, arguments) finds the key of the same command again, so pressing again after a lost answer replays it.
- **Where (decided by us, to confirm with the owner):** `CommandQueue` keeps the list as one JSON value under `command_queue` in the device store (`DeviceStore`, `shared_preferences`), never half written, its writes taking turns. Architecture §11.2 names Drift (SQLite); the `sqlite3` package now builds SQLite through native build hooks that download binaries, and the queue holds a few commands at most, so SQLite joins with the first cache that needs it.
- **Lifetime:** the server answers a repeated key for 24 hours (§5.3), so `pending` drops older commands (`keyLifetime`): sent again they would run as new.
- **Retries:** `unanswered(status)` (none, a 5xx, a 408, a 429) is the only case sent again, after `retryDelay` (exponential from 1 s to 15 s with jitter over its upper half); any other answer is the server's and the command leaves the queue.
- An app removes a command once answered and, at start, sends again the pending ones of the account signed in, dropping another account's.
