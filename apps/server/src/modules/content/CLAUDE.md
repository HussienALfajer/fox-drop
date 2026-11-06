# content module

Texts, terms versions and reason lists (architecture §4.2, AP §9.13). So far only the support contact numbers.

## Rules

- **Contact info** (AP §9.13, owner decision 2026-11-07): `GET /v1/{merchant,captain,customer}/contact` (public) answers `{ phone, whatsapp }` from `SUPPORT_PHONE_NUMBER` and `SUPPORT_WHATSAPP_NUMBER`, read at each request; a missing or malformed number (not E.164) is `null`, and the app hides its button. Content's panel screen replaces the variables with stored values, with no change to the route.
