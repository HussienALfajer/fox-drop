# 9.6 Restaurants «المطاعم»

> Part of the [admin panel spec](../README.md) (AP). A bare "§n" here means AP §n.

## 9.6.1 Restaurant states

| Dimension                  | Values                                                                                                                                                                          |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Account status             | `draft` «مسودة» · `test` «تجريبي» · `active` «فعّال» · `suspended` «معلّق» · `terminated` «منتهي»                                                                               |
| Operating state (computed) | `open` «مفتوح» · `busy` «مشغول» (open, but at the maximum active orders the restaurant set) · `paused` «موقوف مؤقتاً» · `closed` «مغلق» (from hours, or a holiday until a date) |
| Busy mode (flag on `open`) | «وضع الضغط» +10 or +20 min added to the time customers see (restaurant-app spec §7.3)                                                                                           |
| Visibility                 | `visible` · `hidden` «مخفي»                                                                                                                                                     |

Customers see only `active` + `visible` restaurants, plus `test` restaurants for admin test accounts.

## 9.6.2 Restaurant list

- **Columns:**
  - name and category
  - account status and operating state
  - rating
  - orders today
  - acceptance rate (7 days)
  - commission %
  - account balance (owed this week: commission, discounts and exceptions)
  - last order time
- **Filters:** status, category, zone. Search by name or phone.

## 9.6.3 Onboarding wizard «إضافة مطعم» (8 steps; draft saved at every step)

| Step                     | Fields                                                                                                                                                                                                                                                                                                                          | Who                              |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------- |
| 1. Basics                | Arabic name (required), optional English name, category, short description, logo, cover image                                                                                                                                                                                                                                   | DATA, OPS, OWN                   |
| 2. Location and contacts | Map pin (required), address text, restaurant phone, owner name and phone                                                                                                                                                                                                                                                        | DATA, OPS, OWN                   |
| 3. Operations            | Opening hours (several periods per day, days off), default prep time (`merchant.default_prep_min`), minimum order (`merchant.default_min_order`), delivery coverage (a radius in km or chosen zones)                                                                                                                            | DATA, OPS, OWN                   |
| 4. Money                 | Commission % (default `merchant.default_commission_pct`); optional launch commission with an end date, for example 10% until 01/02, then the standard rate automatically. The screen states the settlement terms: the captain pays the full items value at pickup, and the restaurant pays the commission every Saturday (D26). | **OWN only**                     |
| 5. Contract              | Signing date, duration, contract scan, commercial registration or licence scan, price-parity pledge (in-app prices ≤ in-store prices), required checkbox                                                                                                                                                                        | DATA (upload), OWN/OPS (confirm) |
| 6. Accounts              | Owner phone for the restaurant app (sign-in by OTP); optional further phones with the role «مالك» (owner) or «كاشير» (cashier). Owners can be added or removed only here, by OPS or OWN. Owners add cashiers from the app (restaurant-app spec §5.1).                                                                           | OPS, OWN                         |
| 7. Menu                  | The menu editor (§9.6.6)                                                                                                                                                                                                                                                                                                        | DATA, OPS, OWN                   |
| 8. Review and activation | Checklist (below); actions «تشغيل الوضع التجريبي» (start test mode) and «تفعيل وإظهار للزبائن» (activate and show to customers)                                                                                                                                                                                                 | OPS, OWN                         |

**Activation checklist.** All items are required:

- Commission set by OWN.
- Contract and price-parity pledge confirmed.
- Hours set.
- At least one category with available items, and images on at least 80% of items (fixed). OWN can waive the image requirement.
- An owner account created.
- At least one restaurant device passed the device check (restaurant-app spec §4.5).
- A test order completed end to end.

**Test mode «الوضع التجريبي»:**

- The restaurant is visible only to customer accounts flagged «حساب تجريبي للإدارة» (admin test account).
- Test orders run the full real flow, including real cash between the captain and the restaurant.
- **Money on test orders:**
  - Custody is posted normally, because the cash really moves.
  - No `merchant.commission` or `merchant.discount_share` is posted, because the platform placed the order itself.
  - Captain pay is posted to earnings as usual and booked to `platform.test_cost`.
- Test orders are flagged and excluded from KPIs, dashboards and revenue reports by default.

## 9.6.4 Restaurant profile (tabs)

- «نظرة عامة» (overview): orders, sales, acceptance rate, average actual prep time compared with the chosen time, late rate, rejection rate and reasons, rating, and unanswered orders. Each for today, 7 days or 30 days.
- «البيانات» (data), «الموقع» (location), «الأوقات» (hours), «الحسابات» (accounts).
  - On the accounts tab an admin can add or remove owners and cashiers and force-sign-out the restaurant's devices.
  - It lists every device: name, platform, user, app version, ringing on or off, connected now or last seen, and the last device-check result.
  - It shows the restaurant's maximum active orders and its pickup currencies, which OPS or OWN MAY change on the restaurant's request.
- «القائمة» (menu) (§9.6.6).
- «الطلبات» (orders): this restaurant's orders.
- «الكشف المالي» (statement): see Finance §9.10.5.
- «التقييمات» (ratings): customer ratings, reasons and comments. Customer names are hidden.
- «العقد والمستندات» (contract and documents).
- «ملاحظات» (notes) and «سجل التغييرات» (change log): every change to prices, commission, hours or state.

## 9.6.5 Restaurant actions

| Action                                  | Detail                                                                                                                                   | Who                                    | Reason   |
| --------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------- | -------- |
| Pause «إيقاف مؤقت»                      | 15, 30 or 60 min (fixed choices), until a time, or until manually resumed; with a customer-facing message. Auto-resumes when it expires. | OWN, OPS                               | Required |
| Resume «استئناف»                        | Ends a pause                                                                                                                             | OWN, OPS                               | —        |
| End busy mode «إنهاء وضع الضغط»         | Removes the extra time customers see                                                                                                     | OWN, OPS                               | —        |
| Max active orders and pickup currencies | Change them on the restaurant's request (restaurant-app spec §7.4 and restaurant-app spec §12.7)                                         | OWN, OPS                               | —        |
| Holiday close                           | Closed until a date, with a message                                                                                                      | OWN, OPS                               | Required |
| Suspend «تعليق»                         | Hidden from customers until reactivated (for violations)                                                                                 | OWN, OPS                               | Required |
| Reactivate                              | Back to active                                                                                                                           | OWN, OPS                               | Required |
| Hide or show                            | Visibility only                                                                                                                          | OWN, OPS                               | —        |
| Pin or sort weight «تثبيت»              | Position in a home section or in the category list                                                                                       | OWN, OPS                               | —        |
| Change commission                       | Effective for new orders only, immediately or at a set time (D16)                                                                        | OWN                                    | Required |
| Edit menu prices                        | Allowed; the restaurant is notified of every change (D17)                                                                                | OWN, OPS (DATA only before activation) | —        |
| Terminate                               | Ends the contract. Requires the restaurant account settled to zero.                                                                      | OWN                                    | Required |

- **Auto-pause rule:** if a restaurant leaves `merchant.auto_pause_unanswered_count` (3) orders unanswered in one business day, it is paused automatically until OPS resumes it. OPS gets a warning.
- **Who ends a pause:**
  - A pause set by OPS or by the auto-pause rule can be ended only by OWN or OPS. A timed OPS pause also ends when it expires.
  - The auto-pause holds across opening periods until OPS resumes it. It can start after closing time and still applies at the next opening.
  - A pause the restaurant set can be ended by the restaurant or by OWN or OPS.
  - Only one pause exists at a time. An OPS pause or the auto-pause replaces a restaurant pause, and the restaurant cannot pause over them.
- Restaurant pauses and their source (restaurant, ops or auto) are logged for reports.

## 9.6.6 Menu editor

| Part                              | What the admin can do                                                                                                                                                                                                                                                                                                                                                                                    |
| --------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Categories                        | Add, rename, reorder by drag and drop, hide, and set availability windows (for example breakfast until 12:00)                                                                                                                                                                                                                                                                                            |
| Items                             | Item code (unique within the restaurant, generated if left empty), name, description, price, image (upload with crop and automatic resize), category, order, available or unavailable, hidden, badge («جديد» new, «الأكثر طلباً» most ordered, «حار» spicy)                                                                                                                                              |
| Option groups                     | Name, required or optional, min and max choices, options with price deltas; link one group to many items at once                                                                                                                                                                                                                                                                                         |
| Add-ons                           | Free or priced extras, as option groups with min 0                                                                                                                                                                                                                                                                                                                                                       |
| Bulk price change «تعديل جماعي»   | Raise or lower by % or by a fixed amount, for one category or the whole menu, with rounding to the base currency's rounding unit and a before-and-after preview. One notification to the restaurant summarises the change.                                                                                                                                                                               |
| Bulk availability                 | Mark many items available or unavailable at once                                                                                                                                                                                                                                                                                                                                                         |
| Excel import «استيراد من Excel»   | Download a template (item code, category, item, description, price, option groups) → upload → validation report (errors per row) → dry-run preview showing what will be added, changed or left alone → commit. Re-import updates items matched by item code and adds rows with a new code. It never deletes items. Price changes from an import notify the restaurant like any other admin price change. |
| Preview «معاينة كما يراها الزبون» | The menu exactly as the customer app shows it                                                                                                                                                                                                                                                                                                                                                            |
| Price log «سجل الأسعار»           | Every price change: item, old price, new price, who, when                                                                                                                                                                                                                                                                                                                                                |

- Menu changes apply immediately to new orders. Orders already placed keep their snapshot prices.
- Every price change made by an admin notifies the restaurant app (D17) with the item, the old and new price, and who changed it.
- **Restaurant edits:** availability, prices, hiding and ordering made in the restaurant app publish immediately and appear in the price log and change log with the restaurant user's name. New items, new photos, text changes, new categories and option-group changes arrive as change requests (§9.6.7).

## 9.6.7 Menu change requests «طلبات تعديل القائمة» (OWN, OPS)

- **Queue:** every pending request from every restaurant, oldest first, with the restaurant, the item, the type of change and its age. Requests SHOULD be reviewed within 24 hours.
- **Request view:** before and after side by side (photo, text, option group), plus the customer preview.
- **Actions:**
  - «قبول» (approve): the change publishes immediately.
  - «رفض» (reject): requires a reason, which the restaurant sees.
  - An admin MAY correct the text or crop the photo before approving; the restaurant sees the approved version.
- The restaurant may withdraw a pending request. A newer edit to the same field replaces the pending value (restaurant-app spec §9.5).
- Every decision is audited.
