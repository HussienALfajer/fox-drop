# 12. After the order

> Part of the [customer app spec](README.md) (CU). A bare "§n" here means CU §n.

## 12.1 Ratings (U15, Q16)

- **When:** the rating sheet opens once after delivery. Afterwards it is available from the order detail for `customer.rating_window_days` (3) days.
- **Which orders:** delivered orders only, whatever the outcome. Failed and cancelled orders and free re-deliveries cannot be rated.
- **Two parts on one screen, rated separately:**
  - «قيّم المطعم» (rate the restaurant)
  - «قيّم الكابتن» (rate the captain): the captain who delivered, after a handover
- **Each part has:**
  - stars from 1 to 5 (required to send that part)
  - reason chips for the chosen stars (Content; defaults in AP Appendix B)
  - a comment, up to 300 characters (optional)
- The customer can send one part and skip the other. A sent part cannot be edited (Q16).
- **Who sees what:**

  | Viewer | Sees |
  |---|---|
  | Customers | The restaurant's average and number of ratings, or «جديد» until it has 5 ratings (Q16). Nothing about captains. |
  | The restaurant | Stars, reasons and comments, without the customer's name (RA §13) |
  | The captain | Their average, and reasons with counts. No comments (CA §11.2) |
  | Admins | Everything, in the restaurant, captain and customer profiles (AP §9.6.4, AP §9.7.4 and AP §9.8) |

- **No replies** to ratings in V1 (RA R16).

## 12.2 Reporting a problem (U16, Q17, Q23)

- **«الإبلاغ عن مشكلة»** is on the detail of a delivered order, for `customer.report_problem_window_hours` (24) hours after delivery.
- **The form:**

  | Field | Rule |
  |---|---|
  | Type | One of the customer problem list (AP Appendix B): «صنف ناقص» · «صنف خطأ» · «الطعام بارد» · «الطلب تالف» · «تأخير» · «سلوك الكابتن» · «مشكلة في المبلغ أو الباقي» · «أخرى» |
  | Items | Required for «صنف ناقص», «صنف خطأ» and «الطلب تالف»: picked from the order's lines, with the quantity |
  | Note | Optional, up to 300 characters. Required for «أخرى» |
  | Photos | Optional, up to 3 (fixed) |

- **Sending** creates a ticket in the panel (AP §9.9.1), resolved within `support.resolution_post_delivery_hours` (24) hours. The app answers «استلمنا بلاغك T-{رقم}. سنرد عليك خلال 24 ساعة.»
- **One report per order** (Q17). After that, the order shows «بلاغك T-{رقم}: {الحالة}».
- **On resolution** (AP §9.9.3):
  - the customer gets the resolution message as a push, and it appears on the order
  - a compensation code goes to «أكوادي»
  - a free re-delivery appears as a new active order (§11.2)
- **Outside the window**, or for a failed or cancelled order, the detail shows «تواصل مع الدعم» with call and WhatsApp.

## 12.3 «طلباتي» and reorder (U18)

- **The list:** active orders first, then past orders, newest first, loaded in pages. Each shows the restaurant, the date, the status and the total.
- **The order detail:**
  - the items with options and notes, and the marks of edits by operations
  - the money lines: items value, delivery fee, discount, rounding when not 0, and total
  - the pay-in currency, and what the captain recorded (Q23)
  - the address used
  - the captain's first name
  - a short timeline
  - a link to the re-delivery order, if any
  - the actions: rate (§12.1), report a problem (§12.2), «اطلب مرة أخرى»
- **«اطلب مرة أخرى»** (U18):
  - available on delivered, rejected and cancelled orders (not on free re-deliveries), while the restaurant is visible
  - it rebuilds the cart from the restaurant's current menu at current prices, after confirming that the current cart will be replaced
  - lines whose item or options are no longer available are skipped and listed: «لم نضف: {الأصناف} لأنها غير متوفرة»
  - item notes are copied; the code is not
  - if the restaurant cannot take orders now, the cart is still built, and checkout shows the state (§9.2)

## 12.4 «أكوادي» (my codes)

- **«متاحة» (available):**
  - personal codes: compensation and automatic late codes
  - the visible codes this customer is eligible for. A new-user code is shown only to an account that is still a new user (AP §9.11.1).
- **Each code shows:**
  - its value
  - its conditions: minimum order, restaurants, zones, hours
  - its expiry, «ينتهي {التاريخ}»
  - the uses left
  - «استخدم», which opens the restaurant when the code is for one restaurant, and home otherwise
- **«منتهية» (used or expired):** codes used or expired in the last 30 days (fixed). A use that is given back (§10.4) returns the code to «متاحة» if it has not expired.
- **A new personal code** arrives with a push (§14).
