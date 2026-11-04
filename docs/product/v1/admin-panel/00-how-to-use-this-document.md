# 0. How to use this document

> Part of the [admin panel spec](README.md) (AP). A bare "§n" here means AP §n.

- This document is the source of truth for the V1 admin panel. If it differs from the earlier Arabic plan page, this document wins. The owner decided the differences on 2026-11-02 (§2).
- **MUST** means required for V1. **SHOULD** means expected unless there is a strong reason not to. **MAY** means optional.
- `dotted.keys` are server settings, listed in Appendix A. Every number in this document is the default value of a setting unless it is marked **fixed**. A fixed number is a product rule; changing it needs a code change.
- Ledger entry types such as `custody.hand_in`, `earn.payout` or `merchant.commission` are enum values of ledger entries, not settings, even though they are also written as dotted names.
- Where a table in §9 has a "Reason" or "Who" column, that column is authoritative. The lists in §4.5 and §6.3 summarise them.
- «Arabic text» is the UI label. Use these labels in the UI and keep them in a translation file, so V2 can add English without code changes.
- Role codes: `OWN` owner, `OPS` operations and dispatch, `SUP` support, `FIN` finance, `DATA` data entry (§6).
- Money examples use TRY as the base currency only to make them readable. The base currency is chosen per city (§8.6).
- Section 8 (domain reference) defines order states, money rules and ledgers. The restaurant, captain and customer app specs reuse it.
