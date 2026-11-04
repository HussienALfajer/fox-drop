# 11. Performance and rules «أدائي»

> Part of the [captain app spec](README.md) (CA). A bare "§n" here means CA §n.

## 11.1 Acceptance rate

- **Calculation:** over the last `captain.acceptance_window_offers` (50) offers. Rejected and expired offers lower it (AP §9.7.6).
- **Shown** as a percentage, with the last 50 offers listed: time, restaurant, and the response (accepted, rejected or expired).
- **Below `captain.acceptance_alert_pct` (70%):** a warning in the app, «نسبة قبولك منخفضة ({النسبة}%). حاول قبول العروض المناسبة لك.»
- **Below `captain.acceptance_review_pct` (50%):** operations review the captain (AP §9.7.6). There is no automatic suspension in V1.

## 11.2 On time, cancellations and rating

- **On-time rate:** delivered orders at or before the promised time ÷ delivered orders, over the last 50 delivered orders.
- **Cancellations:** the number of captain cancellations in the last `captain.violation_window_days` (90) days (§9.11).
- **Rating (C14):**
  - the average stars and the number of ratings
  - the reasons customers picked, with counts, for example «لطيف» or «تأخر»
  - no customer names and no comments. Comments are visible to admins only (customer-app spec Q16).
- **Online hours:** today and this week.

## 11.3 Violations and appeals (C16)

- **Each violation** (AP §9.7.6) shows the date, the type, the step on the ladder, the order if any, and the consequence:
  - «تنبيه» (warning)
  - «إيقاف يوم» (1-day suspension)
  - «إيقاف 7 أيام» (7-day suspension)
  - «إنهاء التعاقد» (termination)
- **Window:** the ladder counts violations within 90 days. Serious violations (theft, harassment, violence) mean immediate termination.
- **Appeal:** «اعتراض» on each violation opens a ticket for the supervisor, with a text field and an optional photo. The captain sees its status and the decision in Support. OPS record the appeal result on the violation (AP §9.7.5).

## 11.4 Work rules

The work rules page (Content, AP §9.13) is always one tap away. It covers at least:

- free work hours, with no mandatory shifts in V1
- the item check, and responsibility after it
- never asking a customer for more than the app shows
- carrying enough cash for pickups (C4)
- the daily hand-in, the Thursday payout and the cash limit
- the acceptance rate and the conduct ladder
- packaging care (hot and cold apart, bag closed)
- customer data used for delivery only
- the helmet for motorbikes
