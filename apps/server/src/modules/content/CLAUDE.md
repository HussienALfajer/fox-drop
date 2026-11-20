# content module

The texts and reason lists of AP §9.13, edited in the panel and read by the apps (architecture §4.2): reasons, FAQs, contact, notification templates, terms and privacy versions, categories.

## Rules

- **A new reason list** goes into `lists.ts`, the migration's seed and, when an app reads it, `app-content.controller.ts`; `content.test.ts` keeps the three equal. A `closed` list takes no added reasons, since the code acts on each one.
- **Never delete a reason:** removing sets `active` false, so past orders keep what was recorded. Two active reasons of a list never share a label. A `fixed` reason cannot be removed.
- **Choosing:** a module that records a reason calls `ContentService.choose(list, { code, note })` before its transaction and keeps the code, label (a copy, so a later rename leaves past orders as they were) and note. It refuses `unknown_reason`, `reason_note_required` and `reason_note_not_allowed`.
- **Customer texts:** `customerText(list, code)` falls back to `GENERIC_CUSTOMER_TEXT`; an order copies the text when it is cancelled.
- **Edits** take the list's or key's advisory lock and are audited in their transaction (`content.reason.*`, `content.text.update`, `content.terms.publish`, `content.category.*`). The edit routes set a value, so they take no `Idempotency-Key`.
- **Notification templates:** `notification-templates.ts` is the catalogue of every push with a text, keyed `<audience>.<event>`. A new push adds its row there and its event's name to the panel's `ar.json` (`content.notifications.event`; `notification-templates.test.ts` checks it). An edit may use only the template's variables (`400 unknown_variable`). Render with `NotificationTexts.render(key, values)`; show money and times in a push with `formatMoney` and `formatTime` (`push-format.ts`, the city's clock).
- **Terms:** `content.terms_versions` and `content.terms_acceptances` are append-only (`UPDATE` revoked); the newest version is in force. `TermsService.accept` answers `terms_outdated` when another version is in force. What a pending version blocks belongs to each party's module, not here.
- **Categories:** at most 200 active ones; names unique among active ones (`duplicate_label`); images use the upload purpose `category_image` (`prepare` before the transaction, `link` in it). Merchants calls `checkActive(ids)` before linking a restaurant.
- **Contact:** a missing or malformed number (not E.164) is left out of the answer and the app hides its button; its response fields are optional, not nullable (the OpenAPI document reads a nullable top-level type as a list).
- **Public reads** (`GET /v1/{merchant,captain,customer}/content`, `contact`, `terms`) are open before sign-in where the specs say so; the lists are read from PostgreSQL at each request (no cache yet).

## More

Behaviour, decisions and history: `docs/code/apps/server/src/modules/content.md`. Grep it for what you change; never read it whole.
