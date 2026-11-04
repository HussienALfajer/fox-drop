# 9.12 Failed orders and the food (C11)

> Part of the [captain app spec](../README.md) (CA). A bare "§n" here means CA §n.

- **When an order fails after pickup** (`fake`, `wrong_refused`, `failed_other`, or `damaged` as failed), OPS record where the food goes (K10, AP §8.9):
  - «يبقى مع الكابتن» (stays with the captain), the default
  - «أُعيد إلى المطعم» (returned to the restaurant)
  - «أُتلف» (disposed of)
- «أُعيد إلى المطعم» is allowed only when the restaurant is the responsible party, which means it also returns the pickup payment (AP §8.9) (K10).
- The captain sees the instruction in the app.
- **Money:** the captain's custody shows what really happened. If they paid the restaurant and collected nothing, their custody goes negative, and the office pays them back the same business day (AP §8.9). Their pay follows the outcome: they are paid unless they are the responsible party.
