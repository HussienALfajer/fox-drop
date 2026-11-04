# 9.11 Marketing «التسويق»

> Part of the [admin panel spec](../README.md) (AP). A bare "§n" here means AP §n.

## 9.11.1 Promo codes «أكواد الخصم»

- **List columns:** code, type, value, status, uses compared with the limit, cost to date, end date.
- **Create or edit:**

| Field | Options |
|---|---|
| Code | Typed by hand, or a generated batch of unique codes |
| Type | Percentage · fixed amount · free delivery |
| Value and cap | For example 20% with a maximum of 50 |
| Minimum order | For example 150 |
| Validity | From and to dates, with optional hours of the day |
| Usage limits | Total and per customer |
| Audience | Everyone · new users only (first order) |
| Scope | All or selected restaurants · all or selected zones |
| Funding | Platform 100% · restaurant 100% · shared by ratio |
| Daily budget cap | The code pauses automatically when the day's cost reaches it |
| Visibility | Shown in the app · secret (shared outside the app) |

- **Rules:**
  - One code per order.
  - A new-user code works once per phone and once per device.
  - Closed and relinked accounts are not "new" (§8.8). A "new user" is an account with no `delivered` order.
  - **When a use counts:** a use, and its cost against the daily budget, is held when the order is placed. It is given back when the order ends `rejected` or `cancelled`, or `failed` with a responsible party other than the customer. Otherwise it is spent.
  - A personal code (compensation, late code) follows the same rule.
- **Code report:** orders, customers, cost, new customers acquired. From the report the code can be paused, resumed or extended.

## 9.11.2 Banners «البانرات»

- Image at the recommended size, with a crop preview.
- Title.
- Click target: a restaurant, a category, a list of restaurants or a code.
- Order, start and end dates, zones.
- Preview before publishing.

## 9.11.3 Home sections «أقسام الرئيسية»

- Drag to order the sections of the customer home screen, and show or hide each one.
- Built-in sections:
  - «البانرات» (banners) and «التصنيفات» (categories)
  - «الأقرب إليك» (nearest to you), «الأكثر طلباً» (most ordered) and «جديد على FOX DROP» (new on FOX DROP), all computed automatically
  - «العروض» (offers): restaurants with active visible codes
- **Custom sections:** a title the admin writes, for example «أفضل شاورما في أعزاز» (best shawarma in Azaz), and a hand-picked list of restaurants.

## 9.11.4 Mass push «الإشعارات الجماعية» (no daily limit, D20)

| Field | Options |
|---|---|
| Title and text | What appears on the phone |
| Audience | All customers · a zone · no order in the last N days · registered but never ordered |
| Target | Opens a restaurant, a code or the home screen |
| Timing | Now or scheduled |

- Before sending, the panel shows the audience size and asks for confirmation.
- History lists each push with its sender, audience, and how many were sent and delivered.
