# 0. How to use this document

> Part of the [captain app spec](README.md) (CA). A bare "§n" here means CA §n.

- This document is the source of truth for everything a captain sees and does in FOX DROP V1. If it differs from the Arabic plan page, this document wins.
- Shared domain rules live in AP §8: order statuses, the captain track, timers, money formulas, custody and earnings ledgers, currencies and outcomes. This document cites them instead of repeating them. Where this document changes a shared rule, the admin panel and restaurant app specs were updated in the same change; the repository history records each such change.
- **MUST**, **SHOULD** and **MAY** as in AP §0.
- `dotted.keys` are server settings. New keys are listed in Appendix A; existing keys are in AP Appendix A. Every number is the default value of a setting unless it is marked **fixed**.
- Ledger entry types such as `custody.pay_merchant` or `earn.order_pay` are enum values of ledger entries, not settings (AP §0).
- «Arabic text» is the UI label. Keep every label in a translation file. Appendix B collects the main strings.
- `OWN`, `OPS`, `SUP`, `FIN` and `DATA` are admin-panel roles (AP §6).
- Money examples use TRY as the base currency only to make them readable.
