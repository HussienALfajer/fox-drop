# 13. Ratings (owners)

> Part of the [restaurant app spec](README.md) (RA). A bare "§n" here means RA §n.

- **Summary:** the average stars, the number of ratings and the distribution by stars.
- **Each rating:** stars, the reasons the customer picked, the comment and the date. Neither the customer's name nor the order number is shown, so a comment cannot be traced back to a customer (customer-app spec U15, AP §9.6.4).
- **Filters:** stars and period. The periods are the reports' (§11), business days: «الكل» (the default), «اليوم», «أمس», «آخر 7 أيام», «آخر 30 يوماً»; the portal adds a custom range (owner decision 2026-11-17). The summary counts every star of the period; the stars filter the list.
- **Exclusions:** test orders' ratings never show, as they never count in the customers' average (owner decision 2026-11-17).
- **Replies:** none in V1 (R16).
