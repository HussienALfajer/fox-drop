# 8.5 Accept

> Part of the [restaurant app spec](../README.md) (RA). A bare "§n" here means RA §n.

- **Prep time chooser:**
  - chips from `merchant.prep_time_options` (10, 15, 20, 30, 45 minutes)
  - «−» and «+» buttons in steps of `merchant.prep_time_step_min` (5)
  - limited to `merchant.prep_time_floor_min` (5) and `merchant.prep_time_ceiling_min` (90)
- **Preselected value:** the restaurant's default prep time (§10), plus the busy-mode minutes when busy mode is on (§7.3). The accept button shows the chosen time, «قبول — 20 د», so one tap accepts with the default.
- **Effect:**
  - the order becomes `accepted` with the chosen prep time
  - the customer sees «المطعم يحضّر طلبك» with the time
  - the server computes the search-start moment for dispatch (AP §8.3)
  - the ring stops on every device, and the card moves to «قيد التحضير»
