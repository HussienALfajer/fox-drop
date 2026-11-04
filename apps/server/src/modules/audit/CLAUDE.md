# audit module

The append-only audit log (AP §4.6, §9.16; architecture §4.2, §15.3).

## Rules

- **Record every write action and every sensitive view** (a phone reveal, an export with phone numbers, a document file view) through `AuditService` from `index.ts`: `recordWrite` with the target's values before and after, `recordView` without them. No other module touches `audit.events`.
- **Same transaction:** pass the transaction of the write as the last argument, so the event commits or rolls back with the change it describes.
- **The actor** (owner decision 2026-11-04) is its kind (`admin`, `merchant`, `captain`, `customer`, `system`), its id (empty only for `system`) and its role at that moment (such as `OWN`, `OPS`). **The city** is empty only for an action on the whole platform (owner decision 2026-11-04).
- **The request context:** the caller passes the IP address and the device it got with the request; the system has neither.
- **Actions** are dotted names, `<target>.<verb>`, such as `setting.update` or `customer.phone.view`.
- **The changes** are computed here: only the changed fields, each as `{ before, after }` (`changes.ts`). Pass the whole before and after values; never write a diff by hand.
- **Append-only:** the application role can `INSERT` and `SELECT` only, on the table and on every partition (`migrations/0001_audit_events.sql`, proved by `src/database/migrations.test.ts`). Never grant it `UPDATE` or `DELETE`.
- **Partitions** are one per UTC month, created by `audit.create_month_partitions()`, which runs as the migration role. The `worker` role calls it at start and every day (`AuditWorkerModule`), so the next month's partition always exists.
