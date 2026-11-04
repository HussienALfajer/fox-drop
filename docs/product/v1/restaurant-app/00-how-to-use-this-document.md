# 0. How to use this document

> Part of the [restaurant app spec](README.md) (RA). A bare "§n" here means RA §n.

- This document is the source of truth for everything a restaurant sees and does in FOX DROP V1. If it differs from the Arabic plan page, this document wins.
- Shared domain rules live in AP §8: order statuses, timers, money formulas, ledgers, currencies and outcomes. This document cites them instead of repeating them. Where this document changes a shared rule, the admin panel spec was updated in the same change; the repository history records each such change.
- **MUST** means required for V1. **SHOULD** means expected unless there is a strong reason not to. **MAY** means optional.
- `dotted.keys` are server settings. New keys are listed in Appendix A; existing keys are in AP Appendix A. Every number is the default value of a setting unless it is marked **fixed**. A fixed number is a product rule; changing it needs a code change.
- Ledger entry types such as `merchant.commission` or `custody.pay_merchant` are enum values of ledger entries, not settings (AP §0).
- «Arabic text» is the UI label. Keep every label in a translation file, so V2 can add English without code changes. Appendix B collects the main strings.
- Role codes in this document: `MO` restaurant owner «مالك» and `MC` cashier «كاشير» (§5). `OWN`, `OPS`, `SUP`, `FIN` and `DATA` are admin-panel roles (AP §6).
- "The app" means the Android and Windows apps, which have the same features. "The portal" means the owner web portal (§17).
- Money examples use TRY as the base currency only to make them readable, as in AP.
