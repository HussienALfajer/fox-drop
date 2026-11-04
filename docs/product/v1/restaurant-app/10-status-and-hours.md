# 10. Status and hours (owners)

> Part of the [restaurant app spec](README.md) (RA). A bare "§n" here means RA §n.

- **Weekly schedule:**
  - each weekday has one or more opening periods, or «مغلق طوال اليوم» (closed all day)
  - a period may cross midnight, for example 18:00–02:00; it belongs to the day it starts
  - periods may not overlap, and each lasts at least 30 minutes (fixed)
  - the restaurant opens and closes automatically by the schedule
  - there is no manual "open now" outside the schedule in V1
- **Holiday close «إغلاق لعدة أيام»:**
  - from now, or from a chosen date and time, until a date and time
  - with an optional message to customers, up to 100 characters (fixed)
  - active orders are not affected
  - operations can end it too
- **Default prep time:** preselected on the accept prompt (§8.5). Within the chooser's limits.
- **Maximum active orders:** off, or 1–50 (§7.4).
- **Read-only, set by admins (R13):**
  - minimum order
  - delivery coverage
  - commission %
  - settlement day
  - contract dates

  A «طلب تعديل» button opens a support ticket of the type «طلب تعديل بيانات» (§15).
- **Effect of changes:** they apply immediately and are recorded in the restaurant change log that admins see (AP §9.6.4).
