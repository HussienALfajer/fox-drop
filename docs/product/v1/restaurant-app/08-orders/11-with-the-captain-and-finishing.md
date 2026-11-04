# 8.11 With the captain, and finishing

> Part of the [restaurant app spec](../README.md) (RA). A bare "§n" here means RA §n.

- The «مع الكابتن» column shows:
  - the captain's name
  - the time since pickup
  - «المبلغ غير صحيح», while the dispute window is open
  - the call button
- **Delivered:** the order moves to history without a sound.
- **Failed** (AP §8.9): owners get a silent push with the outcome. When the restaurant is the responsible party, the push shows the money effect, for example «يُسترد منك 400 ₺ في تسوية السبت».
- **Outcome changed later** (AP §8.9, within 7 days): owners get a silent push when the restaurant's money changes.
