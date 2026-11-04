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
