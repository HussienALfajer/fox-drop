# 0. How to use this document

> Part of the [customer app spec](README.md) (CU). A bare "§n" here means CU §n.

- This document is the source of truth for everything a customer sees and does in FOX DROP V1. If it differs from the Arabic plan page, this document wins.
- Shared domain rules live in AP §8: order statuses, timers, money formulas, currencies, customer trust and outcomes. This document cites them instead of repeating them. Where this document changes a shared rule, the other three specs were updated in the same change; the repository history records each such change.
- **MUST**, **SHOULD** and **MAY** as in AP §0.
- `dotted.keys` are server settings. New keys are listed in Appendix A; existing keys are in AP Appendix A. Every number is the default value of a setting unless it is marked **fixed**.
- «Arabic text» is the UI label. Keep every label in a translation file, so V2 can add English without code changes. Appendix B collects the main strings.
- `OWN`, `OPS`, `SUP`, `FIN` and `DATA` are admin-panel roles (AP §6).
- Money examples use TRY as the base currency only to make them readable.
