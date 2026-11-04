# settings module

The typed settings of AP §4.4 and Appendix A, cached in Valkey (architecture §5.7).

## Rules

- **The catalogue is Appendix A** (`catalogue.ts`): each key with its type, unit, value schema, default, scope (`global` or `city`) and edit roles. `catalogue.test.ts` reads the appendix and fails when a key, scope or edit role differs, so a new setting goes into the appendix first, then into the catalogue in the same order.
- **Types:** the eight of AP §4.4, plus `distance`, `speed` and `time_of_day`, which Appendix A needs. Money is `{ amountMinor, currency }` in integer minor units; only a zero amount may leave the currency empty. A rounding unit is in minor units of its key's currency.
- **"Before launch"** values have no default (`beforeLaunch`): they read as null until the owner enters them. "—" in the appendix is a nullable value whose default is null.
- **Keys with a parameter** (`<vehicle>`, `<app>`, `<code>`) are one entry in the catalogue and one setting per parameter: pass the parameter in the target, such as `{ cityId, parameter: 'TRY' }`. The stored key is the concrete one, such as `currency.TRY.rounding_unit`.
- **Read** with `SettingsService.get(key, target)`: the stored value of that scope, or the default. Never read `settings.values` from another module.
- **Change** with `update` or `reset` («استعادة القيمة الافتراضية»). Each one, in one transaction, writes the value, appends to `settings.changes` (the value in effect before and after, the editor and their roles, the reason) and records `setting.update` or `setting.reset` through the `audit` module. A change that leaves the value as it was writes nothing. Changes of one setting take turns on an advisory lock.
- **Refusals** throw `SettingRefusedError` with its `refusal`: a role outside the entry's edit roles, a missing reason where `reasonRequired` (owner decision 2026-11-05: the settings with money impact), a value its schema rejects, a city on a global setting or none on a city setting, a wrong parameter. Routes map them to HTTP errors.
- **Cache:** `settings:<city or global>:<key>` holds `<version>:<JSON>` for ten minutes. Every stored row counts its changes in `version`; a read and a change both write the cache through `SET_IF_NEWER`, so a slow read never puts back a value a change replaced. When Valkey cannot be reached, reads go to PostgreSQL and a change stays stale in other servers' cache for at most ten minutes.
- **No effective dates yet:** no Appendix A key is effective-dated. Captain pay tables are (AP §9.12.5), and live in their own screen.
- **No deletes:** the application role cannot delete, so a reset keeps the row and sets `is_default`. The history is append-only (`migrations/0002_settings_values.sql`, proved by `src/database/migrations.test.ts`).
