# settings module

The typed settings of AP §4.4 and Appendix A, cached in Valkey (architecture §5.7).

## Rules

- **The catalogue is Appendix A** (`catalogue.ts`): `catalogue.test.ts` reads the appendix and fails when a key, scope, edit role or plain default differs. A new setting goes into the appendix first, then into the catalogue in the same order. A new key prefix needs a group in `settingGroupOf`.
- **Every key needs Arabic words:** `panel-labels.test.ts` fails a key (but `app.*`) without its `settings.name` and `settings.description` in `apps/admin/src/locales/ar.json`, and an enum choice without `settings.choice`. Add them in the same change.
- **Money** is `{ amountMinor, currency }` in integer minor units; only a zero amount may leave the currency empty. A city setting's currency must be one of the city's currencies, and an amount must be in its base currency, else `wrong_currency`; the check runs in the change's transaction on `lockCityCurrencies`.
- **"Before launch"** values have no default and read as null until entered; a reset needs a default.
- **Parameter keys** (`<vehicle>`, `<app>`, `<code>`) are one catalogue entry and one setting per parameter: pass `{ cityId, parameter }`; the stored key is the concrete one, such as `currency.TRY.rounding_unit`.
- **Read** with `SettingsService.get(key, target)`; inside a transaction pass it as the third argument. Never read `settings.values` from another module.
- **Change** with `update` or `reset`: in one transaction it writes the value, appends to `settings.changes` and records `setting.update` or `setting.reset` through the audit module. A change that leaves the effective value as it was writes nothing. Changes of one setting take turns on an advisory lock. The history is append-only, and a reset keeps the row and sets `is_default`.
- **Reason required** where the entry says `reasonRequired` (the settings with money impact); refusals are `SettingRefusedError`, mapped to `404` (`unknown_key`), `403` (`role_may_not_edit`) or `400`.
- **Roles:** the Appendix A edit roles decide both reading and editing, key by key. Routes are `@SignedIn()` and the service checks the roles; do not add a `settings.*` permission check on the routes.
- **Listeners:** a module that must act on a change in its transaction registers with `onChanged`; this module imports none of them. fx registers with `useCityCurrencies` and geo with `useCityAmounts`; a process that changes settings must import `FxModule`.
- **Cache:** `settings:<fingerprint>:<city or global>:<key>` for ten minutes, written through `SET_IF_NEWER`; the fingerprint hashes the default and schema. Without Valkey commands fail at once and reads go to PostgreSQL.
- **Version comparison:** `versionBelow` (`app-versions.ts`) is the server's only version comparison; the apps never compare versions.
- **The system** (`editor: 'system'`) sets the placeholder values of development and staging: no role check, actor `system` in the audit log.

## More

Behaviour, decisions and slice history: `docs/code/apps/server/src/modules/settings.md`. Grep it for the feature, route, table or label you are changing and read only those lines; never read it whole.
