# 11. Reports (owners)

> Part of the [restaurant app spec](README.md) (RA). A bare "§n" here means RA §n.

- **Periods:** «اليوم» (today), «أمس» (yesterday), «آخر 7 أيام» (last 7 days), «آخر 30 يوماً» (last 30 days). The portal adds a custom range. All periods are business days.
- **Comparison:** each number is compared with the previous period of the same length, with an up or down arrow.
- **Exclusions:** test orders are excluded everywhere.

| Metric | Definition |
|---|---|
| Orders received | Orders that reached the restaurant (`placed`) |
| Accepted by you | Accepted by a restaurant user |
| Accepted by operations | Accepted on the restaurant's behalf (§8.15) |
| Rejected | By reason, and whether the restaurant or operations rejected it |
| Unanswered | Cancelled automatically for no response (§8.3) |
| Acceptance rate | Accepted by you ÷ (orders received − orders the customer cancelled before any answer) |
| Delivered orders | Orders that reached `delivered` |
| Sales | Items value of delivered orders, after any edits |
| Average order | Sales ÷ delivered orders |
| Commission, restaurant-funded discounts, net | From the restaurant account entries of the period (§12) |
| Average time to accept | From placed to accepted, restaurant users only |
| Average actual prep time | From acceptance to ready, or to pickup when ready was not pressed, compared with the average chosen time |
| Late rate | Orders that became ready (or were picked up, when ready was not pressed) after the chosen prep time ÷ accepted orders |
| Ready not pressed | Orders picked up without «الطلب جاهز» |
| Average captain wait | From the captain's arrival to pickup |
| Rating | Average stars and number of ratings in the period |
| Top items | Top 10 items by quantity and by sales, in delivered orders |
| Orders by hour | Delivered orders per hour of the business day |
| Pause and busy time | Minutes paused (by source) and minutes in busy mode or at the limit |

- **Definitions:** an info icon next to each metric explains its definition.
- **Daily summary image:** the app builds an image of a chosen day's key numbers and shares it through the system share sheet.
- **Excel export:** in the portal (§17).
