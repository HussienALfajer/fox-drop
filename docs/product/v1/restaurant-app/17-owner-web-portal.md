# 17. Owner web portal «بوابة المطعم» (R15)

> Part of the [restaurant app spec](README.md) (RA). A bare "§n" here means RA §n.

- **Access:** owners only. Sign-in by phone and OTP, as in the app (§5.2). Sessions last 30 days (§5.3).
- **Layout:** Arabic, right to left. Built for desktop and laptop, and usable on a phone.
- **What it has:** everything an owner can do in the app (§5.4), plus:
  - Excel export for reports and history
  - PDF and Excel for statements
  - a custom date range in reports
- **Live orders, read-only:**
  - the same four columns, updated in real time, with timers and captain lines
  - no sound, and no accept, reject, ready, pickup or edit actions
  - a banner explains: «لاستقبال الطلبات استخدم تطبيق أندرويد أو ويندوز»
- **Status:** pause, resume, busy mode and holiday close work from the portal, because they are not receiving orders.
- **Not a receiving device:** the portal never counts as one (§4.6).
