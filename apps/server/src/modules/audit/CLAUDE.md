# audit module

The append-only audit log (AP §4.6, §9.16; architecture §4.2, §15.3).

## Rules

- **Record every write action and every sensitive view** (a phone reveal, an export with phone numbers, a document file view) through `AuditService` from `index.ts`: `recordWrite` with the target's values before and after, `recordView` without them. No other module touches `audit.events`.
- **Same transaction:** `recordWrite` requires the transaction of the write, so the event commits or rolls back with the change it describes. `recordView` takes one when the view is part of a write.
- **The actor** (AP D27) is its kind (`admin`, `merchant`, `captain`, `customer`, `system`), its id (empty only for `system`) and its role at that moment (such as `OWN`, `OPS`). **The city** is empty only for an action on the whole platform (AP D28).
- **The request context:** the caller passes the IP address and the device it got with the request; the system has neither.
- **Actions** are dotted names, `<target>.<verb>`, such as `setting.update` or `customer.phone.view`.
- **The changes** are computed here: only the changed fields, each as `{ before, after }` (`changes.ts`). Pass the before and after values of the target; never write a diff by hand.
- **No secrets or phone numbers in the log:** the log is read in the panel, which never shows a stored secret and masks phone numbers (AP §5.4, D3; architecture §15.3, §15.4). Leave password hashes, TOTP secrets, tokens, provider keys and phone numbers out of the before and after values; record the change with a field of the after values only, such as `passwordChanged: true`, and a phone by its masked form.
- **Append-only:** the application role can `INSERT` and `SELECT` only, on the table and on every partition (`migrations/0001_audit_events.sql`, proved by `src/database/migrations.test.ts`). Never grant it `UPDATE` or `DELETE`.
- **Partitions** are one per UTC month, created by `audit.create_month_partitions()`, which runs as the migration role. The `worker` role calls it at start and every day (`AuditWorkerModule`), so the next month's partition always exists.
- **A target's history (AP §9.6.4 «سجل التغييرات»; slice 2.30d):** `AuditService.history(targets, limit)` reads the write events of some targets (each a type with its ids), newest first, served by the index `events_target` (`target_type`, `target_id`, `occurred_at`; migration 0120). Callers name the actors themselves.
- **«سجل التدقيق» (AP §9.16; slice 2.38a):** `AuditService.search(filter, limit)` reads every event, writes and views, newest first, each filter (actor type, actor id, action, target type, target id, dates with `from` included and `to` excluded) matching all when null, and `after` (the last event of the page before: its `position`, the time to the microsecond as PostgreSQL keeps it, since a `Date` keeps milliseconds and the events of one transaction share their time; then its id) for the next page, compared as a row. The indexes `events_newest` (`occurred_at DESC, id DESC`) and `events_actor` (`actor_id, occurred_at DESC`; migration 0140) serve it on every partition. `GET /v1/admin/audit-log` (`audit_log.read`, OWN) in the reporting module serves it, 50 a page with `nextCursor`, naming the admins.
