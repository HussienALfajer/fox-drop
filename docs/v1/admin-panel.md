# FOX DROP V1 — Admin Panel Specification

| | |
|---|---|
| Product | FOX DROP, a food delivery platform launching in Azaz, Syria, then expanding city by city |
| Scope | V1, the first version that completes a full order cycle |
| Component | Admin panel «لوحة الإدارة», a web application |
| Status | Approved by the owner on 2026-11-02 (decisions in §2) |
| Audience | Engineers and coding agents (Claude Code) who build the panel and the server rules it controls |
| UI language | Arabic only, right to left |
| Related | Restaurant app spec: `docs/v1/restaurant-app.md`. Captain app spec: `docs/v1/captain-app.md`. Customer app spec: `docs/v1/customer-app.md`. Arabic V1 plan page: https://claude.ai/artifact/8XR91QrZHk73nRHdu7E1q6 (sections 17–32). BeeOrder research: `docs/beeorder-research/`. Technology stack: `docs/architecture/technology-stack.md` |

---

## 0. How to use this document

- This document is the source of truth for the V1 admin panel. If it differs from the earlier Arabic plan page, this document wins. The owner decided the differences on 2026-11-02 (§2).
- **MUST** means required for V1. **SHOULD** means expected unless there is a strong reason not to. **MAY** means optional.
- `dotted.keys` are server settings, listed in Appendix A. Every number in this document is the default value of a setting unless it is marked **fixed**. A fixed number is a product rule; changing it needs a code change.
- Ledger entry types such as `custody.hand_in`, `earn.payout` or `merchant.commission` are enum values of ledger entries, not settings, even though they are also written as dotted names.
- Where a table in §9 has a "Reason" or "Who" column, that column is authoritative. The lists in §4.5 and §6.3 summarise them.
- «Arabic text» is the UI label. Use these labels in the UI and keep them in a translation file, so V2 can add English without code changes.
- Role codes: `OWN` owner, `OPS` operations and dispatch, `SUP` support, `FIN` finance, `DATA` data entry (§6).
- Money examples use TRY as the base currency only to make them readable. The base currency is chosen per city (§8.6).
- Section 8 (domain reference) defines order states, money rules and ledgers. The restaurant, captain and customer app specs reuse it.

---

## 1. Context and principles

### 1.1 V1 in one paragraph

V1 serves one city, Azaz, inside service zones that the admin draws on a map. Partners are restaurants and ready-food shops: restaurants, sweets, bakeries, cafés and juice shops. Supermarkets and stores come in V3. Orders are instant delivery only, paid in cash on delivery. There are four products: the customer app (Android and iOS; `docs/v1/customer-app.md`), the restaurant app (Android and Windows, with an owner web portal; `docs/v1/restaurant-app.md`), the captain app (Android and iOS; `docs/v1/captain-app.md`) and this admin panel (web).

The cash model works in five steps (D11, D12, D26):

1. At pickup, the captain pays the restaurant the **full items value** in cash. No commission is deducted.
2. At the door, the captain collects the full order total from the customer.
3. Every business day, the captain hands the office the platform's cash: what they collected minus what they paid the restaurant.
4. Every Thursday, the captain is paid their earnings.
5. Every Saturday, each restaurant settles its account with the platform: the week's commission, any discounts it funded, and any exceptions.

### 1.2 What the panel is

The admin panel is the single control plane of the platform. From it the owner and staff:

- watch every live order and step into any order at any stage
- manage restaurants, menus, captains and customers
- run the cash desk
- set every price, fee, timer, limit and policy without a code change or an app update

### 1.3 Principles (MUST)

1. **Configurable without code.** Every timer, threshold, fee, pay rate, commission and text is data that the panel edits. The apps read it from the server.
2. **Real time.** Panel screens update live without reloading: new orders, status changes, captain positions and alerts.
3. **The server is the authority.** The server computes every amount: totals, the pickup payment, commission, captain pay and ledger entries. The panel only displays them and previews them.
4. **Everything is audited.** Every write action records who did it, when, from which device, and the values before and after.
5. **Ledgers are append-only.** Financial entries are never edited or deleted. A mistake is fixed with a reversing entry that has a reason.
6. **City scope.** Every record belongs to a city from day one, even though V1 has only Azaz.
7. **Permissions are checked on the server.** The UI hides actions the user is not allowed to take, but the server enforces the rule.
8. **Reasons are required.** Sensitive actions require a reason (§4.5).
9. **Preview before money moves.** An action that creates ledger entries shows its exact money effect before the user confirms it.
10. **Never accept an order we cannot deliver.** Before an order is placed, the server checks the restaurant (including its maximum active orders, when set), the zone, the items and captain capacity.

---

## 2. Owner decisions (2026-11-02)

| ID | Topic | Decision |
|---|---|---|
| D1 | Launch staffing | The owner works in the panel, with at least one dispatcher on duty during all operating hours and one cash/finance person (the dispatcher may do this at first, by holding both the OPS and FIN roles, §6.1). One data-entry person works during restaurant onboarding. |
| D2 | Roles | The five fixed roles and the permission matrix in §6 are approved. |
| D3 | Customer phone numbers | Only OWN, OPS and SUP can see them, and every reveal is logged. |
| D4 | Compensation cap | SUP may give up to 30% of the order's customer total without approval. Anything above goes to the owner for approval. |
| D5 | Admin sign-in | Password plus a time-based one-time code from Google Authenticator (TOTP). WhatsApp or SMS codes are not used for admin sign-in. |
| D6 | Dispatch at launch | Manual dispatch for the first 1–2 weeks, then mixed mode: automatic, with a manual fallback. |
| D7 | Emergency stop | OWN and OPS can stop new orders across the city, with a message to customers. Customers with active orders get a notice that their order may be a little late, with the reason. |
| D8 | Admin order editing | Admins can add items, remove items and change quantities. The rules are in §9.3.3. |
| D9 | Platform hours | 24 hours a day, 7 days a week. Each restaurant keeps its own hours. |
| D10 | Captain cash limit | Set per captain in the panel. There is no single global value. |
| D11 | Daily cash hand-in | Captains MUST hand in the platform's cash every business day. A captain who still holds cash from a previous business day cannot go online until they hand it in. |
| D12 | Captain pay | Every Thursday the captain's account is fully settled and the week's earnings are paid out. |
| D13 | Restaurant settlement | Each restaurant's account (commission, restaurant-funded discounts and exceptions) is settled every Saturday, at the office or during a staff visit to the restaurant. |
| D14 | Rounding | The rounding unit and rounding mode are set per currency in the panel. |
| D15 | Peak-hour bonus | Built in V1 and disabled by default. The owner turns it on when needed. |
| D16 | Commission changes | Owner only. A change applies to new orders only. |
| D17 | Admin price edits | Admins may change a restaurant's menu prices. The restaurant is notified of every change. |
| D18 | Max concurrent orders per restaurant | Not an admin-panel setting. Decided in the restaurant-app spec (R5): the restaurant owner MAY set a maximum number of active orders, off by default, and the restaurant becomes «مشغول» (busy) while it is at that number. A busy mode «وضع الضغط» adds 10 or 20 minutes to the time customers see instead of pausing. |
| D19 | Customer account deletion | The account is closed: the customer can no longer sign in, and the account no longer counts as active. The customer's data is kept (see the compliance note in §13). |
| D20 | Mass push notifications | No daily limit. |
| D21 | Panel language | Arabic only in V1. |
| D22 | Alert sound | Alerts cannot be muted. The mute feature has been removed. |
| D23 | Customer trust | A new account can have 1 active order at a time. After 3 delivered orders the account becomes trusted. |
| D24 | Captain onboarding | Adds the civil registry extract «إخراج قيد», the criminal record certificate «لا حكم عليه», an optional driving licence «شهادة قيادة», and a signed contract: 1 month of probation, then a minimum commitment of 3 months. |
| D25 | Currencies | USD, TRY and SYP are supported, with exchange rates set in the panel. Each city picks its base currency when it is created. |
| D26 | Pickup payment and commission | The captain pays the restaurant the full items value at pickup, without deducting commission. The captain hands in the cash they collected from the customer (net of what they paid the restaurant) every business day. The owner collects the commission from each restaurant every Saturday. This replaces the plan page's model, where the captain paid the restaurant its net after commission. |

**Additions accepted without objection.** These were proposed during the review and are in V1 scope:

- the platform emergency stop
- restaurant test mode
- Excel menu import
- bulk price change by percentage
- the daily cash-drawer close
- compensation caps per role

---

## 3. Glossary

| Term | Meaning |
|---|---|
| Restaurant / merchant | A partner that prepares orders. "Merchant" is the generic code term (it covers V3 stores). |
| Captain «كابتن» | A courier who picks up orders and delivers them. |
| Customer «زبون» | A person who orders through the customer app. |
| Items value | The sum of item prices, including options and add-ons, multiplied by quantity, before any discount. |
| Customer total | What the customer pays at the door (§8.4). |
| Pickup payment «دفعة الاستلام» | What the captain pays the restaurant in cash at pickup: the full items value, with nothing deducted (D26, §8.4). |
| Commission | The platform's share of the items value, as a percentage set per restaurant. The restaurant pays it on Saturday. |
| Merchant net «صافي المطعم» | What the restaurant keeps from an order after the Saturday settlement: items value − commission − restaurant-funded discount (§8.4). |
| Base currency «عملة الأساس» | The currency a city uses for menu prices, fees, ledgers and reports (§8.6). |
| Accepted currency | A currency customers may pay in and captains may hold. The base currency is always accepted. |
| Exchange rate | How many base-currency units one unit of another currency is worth. The panel sets it, and each order keeps a snapshot of it. |
| Custody «العهدة النقدية» | Platform cash that a captain physically holds, tracked per currency (§8.5). |
| Earnings «المستحقات» | What the platform owes the captain for their work, in the base currency (§8.5). |
| Hand-in «تسليم النقد» | The captain handing custody cash to the cash desk. Required every business day. |
| Thursday settlement «تصفية الخميس» | The weekly full settlement and payout of a captain's earnings. |
| Restaurant account «حساب المطعم» | The running balance between the platform and a restaurant: commission, restaurant-funded discounts and exceptions (§8.7). It is settled every Saturday. |
| Business day | A city's operating day, from `finance.business_day_cutoff` to the same time on the next day (§4.3). |
| Outcome | The financial result of an order that ends after pickup: `normal`, `free`, `fake`, `damaged`, `wrong_refused` or `failed_other` (§8.9). |
| Responsible party | Who is at fault for a problem: restaurant, captain, customer or platform. It decides who bears the cost. |
| Compensation | A remedy given to a customer: a discount code for a next order, or a free re-delivery of missing or wrong items. V1 has no wallet or credit balance. |
| Zone | A polygon on the map where the platform delivers. |
| Offer | A dispatch proposal sent to one captain for a set time. |
| Probation «فترة التجربة» | The first month of a captain's contract. |
| Commitment period «فترة الالتزام» | The minimum 3 months a captain commits to after probation. |

---

## 4. Platform foundations the panel relies on

### 4.1 City scope

- A city selector sits in the top bar. V1 has only Azaz, but every screen, query, setting and report is filtered by the selected city.
- Some settings are global, such as admin security and app versions. Most are per city. Appendix A marks the scope of each one.

### 4.2 Real time

- The panel keeps a WebSocket connection per signed-in user. It subscribes to city channels: orders, captain positions, alerts, tickets and the cash desk.
- If the connection drops, a red bar shows «انقطع الاتصال المباشر — يُعاد الاتصال…». The panel reconnects automatically and then re-fetches the current state, so no event is missed.
- Captain positions update on the map at least every 10 seconds while a captain is online (fixed).

### 4.3 Business day

- Each city has `finance.business_day_cutoff` (default 06:00, city time). The platform runs 24/7, so this cutoff defines what "today" means for:
  - reports
  - the daily cash hand-in rule
  - the restaurant auto-pause counter
  - menu items a restaurant marked «غير متوفر حتى الغد» (unavailable until tomorrow), which become available again at the cutoff
  - drawer sessions
  - the weekly days: the Thursday payout and the Saturday restaurant settlement are business days. For example, with a 06:00 cutoff, "Thursday" runs from Thursday 06:00 to Friday 06:00.
- Dates in reports mean business days unless they are labelled as calendar dates.

### 4.4 Settings model

- Settings are typed values (duration, percentage, money, count, enum, boolean, text or schedule) with a default, a scope (global or city) and a list of roles allowed to edit them.
- Every change records the old value, the new value, the editor, the time and an optional reason.
- A change takes effect immediately, unless the setting is effective-dated. Captain pay tables are effective-dated (§9.12.5).
- Each settings screen has «استعادة القيمة الافتراضية» (reset to default) per field.

### 4.5 Reasons and notes

These actions require a reason, chosen from a list (Appendix B) or written as free text:

- cancelling an order
- accepting or rejecting an order on behalf of a restaurant
- editing an order
- reassigning a captain
- setting an outcome
- issuing compensation
- blocking or unblocking a customer
- suspending a captain or a restaurant
- any manual ledger entry
- changing a commission
- closing a customer account
- granting a hand-in grace
- an off-cycle payout
- confirming a pickup on a restaurant's behalf
- recording a captain's arrival or a delivery on their behalf
- releasing a captain's device
- closing an item-unavailable report without an edit
- rejecting a menu change request
- activating or deactivating the emergency stop

Internal notes are free text attached to an order, customer, captain, restaurant or ticket. Only panel users can see them.

### 4.6 Audit

Every write action and every sensitive view (such as revealing a customer phone number) creates an audit event. The audit log is append-only (§9.16).

### 4.7 Formatting

- Layout and text direction: Arabic, right to left. Numbers use Western digits (0–9).
- Money shows its currency symbol or code, for example `410 ₺` or `10.00 $`.
- Dates show as `dd/mm/yyyy`. Times use the 12-hour clock with «ص/م» in the UI. Exports use ISO 8601.
- Durations show as «12 د» for minutes and «45 ث» for seconds.

### 4.8 Identifiers

- **Order number:** sequential per city, shown as `#10423`.
- **Receipt number:** one sequence per city per year for every cash-desk receipt, formatted as `{CITY}-{YYYY}-{000001}`, for example `AZ-2026-000123`. The receipt type is printed on the receipt.
- **Ticket number:** sequential per city, shown as `T-5521`.

---

## 5. Access and security

### 5.1 Sign-in

1. The user enters their email or phone number and a password. The password must be at least `admin.password_min_length` (10) characters.
2. The user enters the 6-digit TOTP code from Google Authenticator, or any TOTP app that follows RFC 6238. TOTP is mandatory for every panel user.
3. **First sign-in:** the user sets their password from a one-time setup link (valid 24 hours, fixed), then enrols TOTP by scanning a QR code. The panel shows 10 single-use backup codes once (fixed).
4. **Failed attempts:** after `admin.login_max_attempts` (5) failures, the account is locked for `admin.lockout_min` (15) minutes.

### 5.2 Sessions

- A session ends after `admin.session_idle_min` (30) minutes of inactivity, and in any case after `admin.session_max_hours` (12) hours.
- Each session records its device, browser, IP address, sign-in time and last activity.
- OWN can see every open session and can force a user to sign out of all sessions.

### 5.3 Account administration (OWN)

- Create a user and generate a setup link. The owner shares the link with the person; no email infrastructure is needed.
- Change a user's roles.
- Disable a user. This takes effect immediately and ends all of their sessions.
- Reset a user's TOTP. The user must enrol again at their next sign-in.
- The first OWN account is created by a server command or seed during deployment, never from the UI.

### 5.4 Sensitive data

- **Customer phone numbers** are masked by default, as in `0944 *** 123`. The «إظهار الرقم» (show number) button and the call action appear only for OWN, OPS and SUP, and every reveal is logged (D3).
- **Provider keys** (WhatsApp sending-number sessions, maps and similar) are stored on the server only. The panel never displays a stored secret. OWN can replace a key, which is write-only.
- Exports that contain phone numbers are available only to OWN, OPS and SUP, and each export is logged.

---

## 6. Roles and permissions

### 6.1 Roles

V1 has five fixed roles. Permissions are stored as data, so V2 can add custom roles.

- A user holds **one or more** roles, and their permissions are the union of those roles. At launch the dispatcher MAY hold OPS + FIN, so they can also run the cash desk (D1).
- With several roles, the highest compensation cap among them applies (§6.4).
- An alert reaches a user if any of their roles is a recipient (§9.1.3).

| Code | Role | Arabic label | Main job |
|---|---|---|---|
| OWN | Owner | «المالك» | Everything, including money rules, commissions, the team, the audit log and approvals |
| OPS | Operations and dispatch | «العمليات والتوزيع» | Live orders, dispatch, restaurants (except commission), captains (except money), customers |
| SUP | Support | «الدعم» | Tickets, customer problems and compensation within the cap |
| FIN | Finance | «المالية» | The cash desk, ledgers, settlements, statements, exchange rates and financial reports |
| DATA | Data entry | «إدخال البيانات» | Creating restaurants and menus before activation, banners and categories |

### 6.2 Module access matrix

"Full" means every action in the module, subject to the special permissions in §6.3. "—" means no access.

| Module | OWN | OPS | SUP | FIN | DATA |
|---|---|---|---|---|---|
| Dashboard | Full | Full | Read | Read | — |
| Operations room and order actions | Full | Full | Read and compensation | Read | — |
| Live map | Full | Full | Read | — | — |
| Order history | Full | Full | Read | Read and financial corrections | — |
| Restaurants | Full | Edit, except commission | Read | Statements and settlement | Create and edit menus, without activation or commission |
| Captains | Full | Full, except money | Read | Ledgers, cash limit, deposit and hand-in | — |
| Customers | Full | Full | Read and compensation | Read and dues payments | — |
| Support | Full | Full | Full | Read, and resolve pickup-dispute tickets | — |
| Finance | Full | — | — | Full | — |
| Marketing | Full | Read | — | Read costs | Banners |
| Zones and pricing | Full | Read | — | Read | — |
| Content | Full | Read | FAQs and canned replies | — | Categories |
| Settings | Full | Dispatch mode only | — | — | — |
| Admin team | Full | — | — | — | — |
| Audit log | Full | — | — | — | — |
| Reports | Full | Operations reports | Support reports | Financial reports | — |

### 6.3 Special permissions

| Permission | Roles |
|---|---|
| See or call a customer's phone number | OWN, OPS, SUP |
| Emergency stop on or off | OWN, OPS |
| Switch dispatch mode | OWN, OPS |
| Change a restaurant's commission or launch commission | OWN |
| Activate a restaurant (make it visible) | OWN, OPS |
| Edit menu prices | OWN, OPS, DATA (DATA only before activation) |
| Set or change a captain's cash limit | OWN, FIN |
| Record cash-desk transactions (hand-in, reimbursement, payout, deposit, settlement, customer dues) | OWN, FIN |
| Grant a hand-in grace to one captain (§8.5.4) | OWN, FIN |
| Grant a bulk hand-in grace for one business day | OWN |
| Off-cycle captain payout | OWN |
| Change an outcome or responsible party after it was set (§8.9) | OWN |
| Hand an order over to another captain after pickup (§9.3.2) | OWN, OPS |
| Confirm a pickup on a restaurant's behalf (§8.1) | OWN, OPS |
| Record a captain's arrival at the restaurant, or a delivery on their behalf (§9.3.2) | OWN, OPS |
| Release a captain's device (§9.7.5) | OWN, OPS |
| Activate a captain flagged «خروج مبكر» (§9.7.1) | OWN |
| Resolve a pickup-dispute ticket with account corrections (§9.9.3) | OWN, OPS, FIN |
| Review menu change requests from restaurants (§9.6.7) | OWN, OPS |
| Add or remove a restaurant owner account (§9.6.3) | OWN, OPS |
| Manual ledger adjustment or reversal | OWN, FIN |
| Edit exchange rates | OWN, FIN |
| Approve compensation above the cap | OWN |
| Edit captain pay tables, delivery fee rules and the peak bonus | OWN |
| Close a customer account | OWN, OPS, SUP |
| Clear customer strikes or end a review stop | OWN, OPS, SUP |
| Block or unblock a customer | OWN, OPS |
| Suspend or terminate a captain | OWN, OPS (the final earnings payout at termination needs OWN, §9.7.5) |
| Export data that contains phone numbers | OWN, OPS, SUP |

### 6.4 Compensation caps and approvals (D4)

- Each role has a cap as a percentage of the order's customer total: `support.compensation_cap_pct.SUP` (30), `support.compensation_cap_pct.OPS` (30). OWN has no cap. FIN and DATA cannot issue compensation.
- Every compensation MUST be linked to an order, including when it is issued from the customer profile or a ticket.
- The cap is **cumulative per order**: the sum of all compensation codes on one order, by anyone, counts against the issuer's cap.
- A percentage code MUST have a maximum amount, and that maximum is what counts against the cap.
- A free re-delivery of missing or wrong items is **not** capped, because it only restores what the customer already paid for. The same applies to a wrong-change code (§8.10). The automatic late-delivery code is not capped either, and does not count toward the cumulative total.
- **Above the cap:**
  1. The request goes to «طلبات الموافقة» (the approvals queue), and OWN gets an alert.
  2. OWN approves, edits the value or rejects.
  3. The customer is notified only after approval.
- The automatic late-delivery code (§8.3) is issued by the system and is not subject to caps.

---

## 7. Global layout and navigation

### 7.1 Main navigation (right-side sidebar, RTL)

| # | Module | Arabic label | Section |
|---|---|---|---|
| 1 | Dashboard | «لوحة التحكم» | §9.1 |
| 2 | Operations room | «غرفة العمليات» | §9.2–9.3 |
| 3 | Live map | «الخريطة الحية» | §9.4 |
| 4 | Order history | «سجل الطلبات» | §9.5 |
| 5 | Restaurants | «المطاعم» | §9.6 |
| 6 | Captains | «الكباتن» | §9.7 |
| 7 | Customers | «الزبائن» | §9.8 |
| 8 | Support | «الدعم» | §9.9 |
| 9 | Finance | «المالية» | §9.10 |
| 10 | Marketing | «التسويق» | §9.11 |
| 11 | Zones and pricing | «المناطق والتسعير» | §9.12 |
| 12 | Content | «المحتوى» | §9.13 |
| 13 | Settings | «الإعدادات» | §9.14 |
| 14 | Admin team | «فريق الإدارة» | §9.15 |
| 15 | Audit log | «سجل التدقيق» | §9.16 |
| 16 | Reports | «التقارير» | §9.17 |

Each user sees only the modules their roles allow.

### 7.2 Top bar

- City selector.
- **Platform status:** «المنصة تعمل» (platform running, green) or «إيقاف طارئ» (emergency stop, red, flashing).
- Dispatch mode: «يدوي» (manual), «آلي» (automatic) or «مختلط» (mixed).
- Global search by order number, restaurant name, captain name or phone, ticket number, or customer phone. Searching by customer phone is available to OWN, OPS and SUP only, the same rule as order history (§9.5), and results show masked numbers until revealed.
- Alerts bell with a count of open alerts.
- Approvals badge (OWN).
- User menu: profile, sessions, sign out.

### 7.3 Alerts system

- An alert is created by a rule (§9.1.3) and has a severity: «حرج» (critical), «تحذير» (warning) or «معلومة» (information).
- **Recipients:** each alert rule has recipient roles (§9.1.3). Only signed-in users with a recipient role see the alert, hear its sound and can acknowledge it. A FIN or DATA user at the desk does not hear operations alarms.
- **Sound:**
  - Critical alerts play a repeating sound until a user acknowledges them.
  - Warnings play a single sound.
  - Information alerts are silent.
  - Sound cannot be muted (D22).
  - Browsers block audio until the user interacts with the page, so after sign-in the panel shows a blocking banner, «اضغط لتفعيل صوت التنبيهات» (tap to enable alert sound), until sound is enabled.
- **Acknowledge** «استلام»: the alert is assigned to the recipient who acknowledges it, and the other recipients see who took it. The repeating sound stops for everyone once one recipient acknowledges.- **Auto-resolve:** an alert closes itself when its condition clears, for example when the restaurant accepts. A resolved alert stays in the alerts history.
- Browser desktop notifications SHOULD be requested, so critical alerts appear when the tab is in the background.

### 7.4 Common UI patterns

- Tables have filters, sorting, a search box, pagination and, where noted, Excel export (XLSX with Arabic headers).
- Detail pages have tabs. Side drawers give quick views from tables.
- Every destructive or financial action opens a confirmation dialog with:
  - the reason field
  - the money-effect preview, when ledgers are affected
  - the list of who will be notified
- Empty states explain what to do, for example «لا توجد طلبات حية الآن».
- Each form field shows its validation error next to the field.

### 7.5 Devices

- Desktop and laptop are the primary devices: everything MUST work there.
- Tablet: everything SHOULD work.
- Phone: the dashboard, operations room, order detail, live map, alerts and tickets MUST be usable for monitoring and simple actions. The cash desk's restaurant settlement MUST also work on a phone, for field visits (§9.10.3).

---

## 8. Domain reference

### 8.1 Order statuses

| Status | Arabic label (panel) | What the customer sees | Changed by | Next statuses |
|---|---|---|---|---|
| `placed` | «بانتظار المطعم» | «بانتظار تأكيد المطعم» | System when the order is placed | `accepted`, `rejected`, `cancelled` |
| `accepted` | «قيد التحضير» | «المطعم يحضّر طلبك» | Restaurant, or OPS on its behalf | `ready`, `picked_up` (pickup confirmed before ready was pressed; `ready` is recorded at the same moment), `cancelled` |
| `ready` | «جاهز» | «طلبك جاهز» | Restaurant | `picked_up`, `cancelled`, `accepted` (only when OPS adds items, §9.3.3) |
| `picked_up` | «مع الكابتن» | «في الطريق إليك» | Pickup confirmation: the restaurant confirms the captain's pickup request, the server confirms it automatically, or OPS confirms it on the restaurant's behalf | `arrived`, `delivered` (OPS via «تحديد النتيجة»), `failed` |
| `arrived` | «الكابتن وصل» | «الكابتن عند الباب» | Captain | `delivered`, `failed`, `picked_up` (handover to another captain, §9.3.2) |
| `delivered` | «تم التسليم» | «تم التسليم» | Captain, or OPS via «تحديد النتيجة» | Final |
| `rejected` | «مرفوض» | Apology with the reason | Restaurant, or OPS on its behalf | Final |
| `cancelled` | «ملغى» | «أُلغي الطلب» with the reason | Customer (only while `placed`), OPS, or the system (no restaurant response) | Final |
| `failed` | «فشل التسليم» | «تعذّر التسليم» | OPS (after pickup) | Final |

- A finished order (`delivered` or `failed`) always has an **outcome** (§8.9).
- A `cancelled` order also records whether food had been prepared.
- **Pickup is one atomic server action, confirmed by the restaurant** (restaurant-app spec §8.10).
  1. The captain's «دفعت للمطعم واستلمت الطلب» (paid the restaurant and picked up) creates a pickup request with the payment lines. The captain track becomes `pickup_pending`.
  2. The restaurant confirms it with one tap. If it does not answer within `order.pickup_confirm_timeout_sec` (60) seconds, the server confirms it automatically. OPS MAY confirm it on the restaurant's behalf (§9.3.2).
  3. On confirmation the server posts `custody.pay_merchant` and sets `picked_up` together. There is no state where the pickup payment is booked but the order is not yet `picked_up`. If the restaurant had not pressed ready, `ready` is recorded at the same moment and flagged «لم يُضغط جاهز».
  4. From that moment the pickup payment, and the base of the commission and the restaurant's discount share, are frozen. Later changes never edit them; they post `merchant.debit`, a reversing `merchant.commission` or other entries (§9.3.3). A pickup dispute after confirmation is resolved through a ticket (§9.9.3).
- **When a pickup request is refused:** while the order has an open item-unavailable report, or an edit that added items and was not yet acknowledged.
- **While a request is open** (at most 60 seconds): edits, reassignment and the restaurant's item-unavailable report are blocked. A cancellation voids the request.
- **Payment lines:** the server proposes lines for the current pickup payment (§8.6). Lines whose converted total differs from it by more than half the largest rounding unit among their currencies are refused.
- **Cash handed over without a pickup.** The captain pays before tapping, so cash can change hands without a confirmed pickup. This covers a rejected or voided request, or a cancellation or reassignment after the captain reached the restaurant, even before any request.
  - The restaurant and the captain settle any difference in person before the captain sends a new request for the current amount. A captain who paid more and did not get the difference back opens a pickup-dispute ticket (§9.9.1).
  - When OPS cancels the order or reassigns the captain after the captain track reached `at_merchant`, the dialog asks «هل أعاد المطعم المبلغ للكابتن؟» (did the restaurant return the cash?), with «لم يدفع الكابتن بعد» (the captain had not paid yet) as an answer.
  - If not, the server posts `custody.pay_merchant` on that captain with the lines the restaurant received, and a `merchant.debit` of the same base amount, so the restaurant returns it on Saturday. The other money effects of the cancellation (§8.9) apply as usual.
- Each order snapshots the restaurant's `commission_pct`, the exchange rates (§8.6) and the captain pay table version when it is placed. Later changes to these never affect existing orders.

### 8.2 Captain track

The captain track is recorded separately from the order status:

`searching` «بحث» → `offered` «عرض» → `assigned` «معيّن» → `at_merchant` «عند المطعم» → `pickup_pending` «بانتظار تأكيد المطعم» → `picked_up` «استلم» → `at_customer` «عند الزبون» → `done` «انتهى»

A rejected or voided pickup request returns the track from `pickup_pending` to `at_merchant`.

"Ready" and "assigned" can happen in either order.

### 8.3 Timers (defaults, all editable)

| Timer | Key | Default | What happens when it fires |
|---|---|---|---|
| Restaurant acceptance alert | `order.merchant_accept_alert_min` | 3 min | Critical alert: «مطعم لم يقبل» |
| Auto-cancel for no restaurant response | `order.merchant_auto_cancel_min` | 7 min | The system cancels with reason «المطعم لم يستجب», apologises to the customer and counts an unanswered order for the restaurant |
| Captain offer | `dispatch.offer_timeout_sec` | 45 s | The offer expires, the response is logged as «انتهت المهلة», and the next captain gets the offer |
| No captain after the search-start moment | `dispatch.no_captain_alert_min` | 5 min | Critical alert: «طلب بلا كابتن» |
| No captain after the order is ready | `dispatch.no_captain_after_ready_min` | 15 min | Critical alert. OPS calls the customer: wait, or cancel with an apology and a code |
| Prep running late (ops) | `order.prep_late_ops_alert_min` | +10 min past the chosen prep time | Warning: «تحضير متأخر». The restaurant itself is alerted at +0. |
| Captain waiting at the restaurant | `captain.waiting_threshold_min` | 10 min | Waiting pay starts, if the pay table includes it. Warning: «كابتن ينتظر عند المطعم» |
| Customer not answering | `customer.no_answer_pings` × `customer.no_answer_ping_interval_min` | 3 × 5 min | After 15 min the captain gets the «الزبون لا يستجيب» button. Warning: «زبون لا يرد». OPS decides. |
| Late delivery | `order.delivery_late_alert_min` | +20 min past the promised time | Warning: «توصيل متأخر». The customer gets an apology. |
| Late delivery compensation | `order.delivery_late_compensation_min` | +45 min past the promised time | The system issues a next-order code worth `order.late_compensation_value` |
| Captain GPS lost on an active order | `captain.gps_stale_alert_min` | 2 min | Critical alert: «انقطع اتصال كابتن أثناء طلب» |
| Pickup confirmation | `order.pickup_confirm_timeout_sec` | 60 s | The server confirms the captain's pickup request automatically (§8.1) |
| Pickup dispute window | `order.pickup_dispute_window_min` | 10 min after pickup | The restaurant's «المبلغ غير صحيح» button disappears from the order |
| Open restaurant without a receiving device | `merchant.no_device_alert_min` | 5 min | Warning: «مطعم مفتوح بلا جهاز استقبال» (restaurant-app spec §4.6) |
| Customer self-cancel | **fixed** | Only while `placed` | After that, the customer asks support by call or WhatsApp, and OPS performs the cancellation (customer-app spec §11.4) |

**Dispatch modes and the "search start" moment.** The server computes the search-start moment for every order in every mode (§9.12.6).

- **Automatic or mixed mode:** offers start at that moment.
- **Manual mode** (the launch mode, D6): no offers are sent automatically. At that moment the order is flagged «بحاجة لتعيين» (needs assignment), and the no-captain timer starts. A manual offer that is declined or expires returns the order to «بحاجة لتعيين».
- The capacity check applies in all modes.

**Delivery estimate and promised time** (customer-app spec Q7). The server computes both, and every app shows them from the server:

```
trip_min          = distance(restaurant → delivery pin, pricing.distance_method) ÷ order.eta_speed_kmh × 60
estimate_min      = restaurant default prep + busy-mode minutes + trip_min + order.eta_buffer_min
promised_time     = accepted_at + chosen prep time + trip_min + order.eta_buffer_min, rounded up to the next 5 minutes
```

- Before an order is placed, the customer sees `estimate_min` as a 10-minute range (customer-app spec §8.4).
- The promised time is set when the restaurant accepts, or OPS accept on its behalf. Before acceptance an order has no promised time.
- «تعديل الوقت» (§9.3.2) changes the promised time.
- The late-delivery alert, the automatic late code (above) and the captain's on-time rate (captain-app spec §11.2) all count from the promised time.

### 8.4 Order money

All amounts are in the city's base currency. Each order stores every component and the exchange-rate snapshot taken when it was placed.

```
customer_total      = items_value + delivery_fee − discount_total + rounding_adjustment
pickup_payment      = items_value                  // the captain pays the restaurant in full (D26)
custody_delta       = customer_total − pickup_payment   // cash the captain hands in for this order
commission          = commission_pct × (items_value − merchant_funded_item_discount)
merchant_weekly_due = commission + merchant_funded_discount   // the restaurant pays this on Saturday
merchant_net        = items_value − commission − merchant_funded_discount   // what the restaurant keeps

order_pay           = max(min_pay, base_pay + extra_km × per_km_rate)     // earn.order_pay
waiting_pay         = waiting_minutes_after_threshold × waiting_rate       // earn.waiting_pay
peak_bonus          = window_amount if delivered inside an active window   // earn.peak_bonus
captain_pay         = order_pay + waiting_pay + peak_bonus

platform_margin     = commission + delivery_fee − platform_funded_discount
                      − captain_pay + rounding_adjustment
```

- `discount_total` = `platform_funded_discount` + `merchant_funded_discount`. A shared code splits by the code's funding ratio.
- **Discount caps:** a percentage or fixed-amount code discounts the items value and is capped at it. A free-delivery code discounts the delivery fee and is capped at it. So `customer_total` is never below 0. The unused part of a fixed-amount code is lost, and the customer app says so before confirming (customer-app spec §10.4).
- `merchant_funded_discount` = `merchant_funded_item_discount` (a discount on items) + `merchant_funded_delivery_discount` (a free- or reduced-delivery code funded by the restaurant).
- **The captain never deducts anything at pickup.** They pay exactly the items value shown on the order. Commission and the restaurant's share of any discount go to the restaurant account (§8.7) and are collected on Saturday.
- Commission is calculated on the items value after restaurant-funded **item** discounts and before platform-funded discounts. A restaurant-funded delivery discount does not reduce the commission base; it only goes to `merchant.discount_share`.
- **Captain pay parts:**
  - `min_pay` applies to `order_pay` only, so it never absorbs waiting pay or the peak bonus.
  - Waiting pay counts from the later of the captain's arrival at the restaurant and `accepted_at` + the chosen prep time, after the first `captain.waiting_threshold_min` (10) minutes. A captain who arrives early is not paid for waiting before the food was due.
  - The peak bonus applies when the order is delivered inside an active peak window for the restaurant's zone (§9.12.5).
- `custody_delta` is usually small and can be negative, for example when a platform code is larger than the delivery fee. A negative custody is reimbursed at the desk (§8.5.1).
- The captain must carry enough cash to pay the full items value at pickup. The captain app shows the pickup payment on every offer before the captain accepts.
- `rounding_adjustment` comes from rounding the customer total to the base currency's rounding unit (§8.6). It may be positive or negative, and the platform books it in `platform.fx_rounding` (§8.11).
- There is no tax line in V1 (§13).

**Worked example** (base TRY, numbers for illustration):

| Line | Amount | Note |
|---|---|---|
| Items value | 400 | Menu prices, which equal in-store prices |
| Delivery fee | 40 | From the published fee table |
| Platform code (10%, capped at 30) | −30 | Funded by the platform |
| **Customer pays the captain** | **410** | Cash at the door |
| **Captain pays the restaurant** | **400** | Cash at pickup, the full items value. Nothing is deducted. |
| Custody gained | +10 | 410 − 400. Handed in at the desk the same business day. |
| Captain pay | 35 | Base 25 for the first 3 km, plus 2 extra km × 5. Added to earnings, paid on Thursday. |
| Commission 15% | 60 | On 400. Added to the restaurant account and collected on Saturday. |
| Restaurant keeps | 340 | 400 received − 60 paid on Saturday |
| Platform margin | 35 | 60 + 40 − 30 − 35, before fixed costs |

**When each amount reaches the platform:**

| When | Platform cash | From |
|---|---|---|
| Same business day | +10 | The captain hands in custody |
| Thursday | −35 | The captain is paid their earnings |
| Saturday | +60 | The restaurant pays its commission |
| **Total** | **+35** | Equals the platform margin |

**If a discount is funded by the restaurant**, the captain still pays the full items value, so custody is lower by the discount. The restaurant pays the discount back on Saturday, together with the commission (`merchant_weekly_due`).

### 8.5 Captain accounts: custody and earnings (D11, D12)

Each captain has two separate accounts. Both are append-only ledgers, and their balances are always the sum of their entries.

#### 8.5.1 Custody «العهدة النقدية» (per currency)

Custody is the platform's physical cash in the captain's hands.

- A **positive** balance means the captain must hand cash in.
- A **negative** balance means the captain paid from their own pocket and the platform owes them.

| Entry type | Sign | When |
|---|---|---|
| `custody.collect` | + | At delivery, one entry per currency the customer paid in |
| `custody.change_given` | − | At delivery, per currency of the change the captain gave back |
| `custody.pay_merchant` | − | At pickup: the full items value (D26), per currency the captain paid the restaurant in (normally the base currency) |
| `custody.hand_in` | − | Cash handed in at the desk (receipt) |
| `custody.reimburse` | + | The desk pays back a negative custody (receipt) |
| `custody.fx_convert` | ± | Cross-currency settlement at the desk at the current rate (§9.10.3) |
| `custody.pickup_correction` | ± | A pickup dispute resolved in the accounts (§9.9.3), per currency: + when the captain paid the restaurant less in that currency than recorded at pickup (they still hold that cash), − when they paid more |
| `custody.adjustment` | ± | Manual correction (OWN/FIN, reason) |

#### 8.5.2 Earnings «المستحقات» (base currency)

Earnings are what the platform owes the captain for their work.

| Entry type | Sign | When |
|---|---|---|
| `earn.order_pay` | + | Order finished with pay due to the captain (§8.9) |
| `earn.waiting_pay` | + | Waiting past the threshold, if the pay table includes it |
| `earn.peak_bonus` | + | Order delivered inside an active peak window (D15) |
| `earn.bonus` | + | Manual bonus (OWN/FIN, reason) |
| `earn.charge` | − | Cost charged to the captain as the responsible party (§8.9) |
| `earn.deposit_instalment` | − | Kit deposit instalment |
| `earn.payout` | − | Thursday payout, or an off-cycle payout (receipt) |
| `earn.adjustment` | ± | Manual correction (OWN/FIN, reason) |

#### 8.5.3 Cash limit (D10)

- Each captain has a `custody_limit` in the base currency, set by OWN or FIN. It is required before activation.
- `captain.custody_limit_suggested.<vehicle>` only prefills the field.
- **Usage** = the sum of positive custody positions, converted at current exchange rates.
- At `captain.custody_warn_pct` (80%) of the limit, the captain gets a warning.
- At 100% the captain gets no new offers until they hand cash in. They can still finish their current order.

#### 8.5.4 Daily hand-in rule (D11)

**What is due from closed days.** For each currency `c`:

```
closed_due_c = custody balance_c at the last business-day cutoff
               + desk entries in c posted since that cutoff
                 (custody.hand_in, custody.reimburse, custody.fx_convert, custody.adjustment)
closed_due   = Σ over currencies (closed_due_c × current rate to base)
```

- Desk entries after the cutoff settle the closed days first. Collections and pickup payments after the cutoff belong to the new day and do not count.
- Positive and negative currencies net against each other in `closed_due`, so a captain is not blocked for TRY while the platform owes them more in USD.
- Example: a captain pays a restaurant 400 at 05:50 and delivers for 410 at 06:20 (cutoff 06:00). At the cutoff their balance was −400, so `closed_due` is negative and they are not blocked. The +10 becomes due at the next cutoff.

**Blocking:**

- A captain cannot go online while `closed_due` > `captain.remit_tolerance` (0, base currency). The captain app shows «لديك نقد غير مسلّم من يوم {التاريخ}: {المبلغ}. سلّمه في المكتب لتتمكن من الاتصال.»
- A captain who is online when the cutoff passes is not forced offline and keeps receiving offers for `captain.remit_online_grace_hours` (4). After that they stop receiving new offers until they hand in. They can always finish their current order.
- The cash limit (§8.5.3) applies at all times as well.
- The custody tab (§9.7.4) and the cash desk (§9.10.3) show `closed_due` and today's custody separately.

**Hand-in grace:**

- OWN or FIN can grant a grace to one captain, with a reason, for example when the office was closed.
- OWN can grant a bulk grace for all captains for one business day, from the cash desk.
- A grace lifts the block until the next cutoff. It does not clear the custody, which stays due.

A hand-in is recorded at the cash desk (§9.10.3), and the receipt appears immediately in the captain app.

#### 8.5.5 Thursday settlement (D12)

On `captain.payout_weekday` (Thursday), the desk performs «تصفية الحساب الكامل» (full account settlement) for each captain who comes in:

1. Custody is settled to zero in every currency: the captain hands in or the desk reimburses.
2. Pending deposit instalments are posted.
3. The full positive earnings balance is paid out (`earn.payout`) in the base currency, or in another accepted currency at the current rate. The cashier records which.
4. A weekly statement is generated and appears in the captain app. It covers the period since the previous payout and shows:
   - the number of orders
   - pay broken down into base, distance, waiting and peak
   - bonuses, charges and instalments
   - the net amount paid

- If the earnings balance is negative, `captain.negative_earnings_policy` decides what happens. The default `carry_forward` deducts it from the next week. The desk MAY instead collect it in cash.
- A captain who misses Thursday keeps their balance until the next payout.
- Payouts on any other day need OWN, for example at termination.

### 8.6 Currencies and exchange rates (D14, D25)

- **Supported currencies** are data rows with code, Arabic name, symbol, decimals and status. V1 seeds TRY «ليرة تركية», USD «دولار أمريكي» and SYP «ليرة سورية». Because currencies are data, a redenomination can be handled by adding a new currency row.
- **Base currency:** chosen when the city is created (D25). It can be changed until the city's first order. After that it is locked, because changing it would break ledgers. All menu prices, fees, commissions, captain pay, earnings, restaurant accounts and reports use it.
- **Accepted currencies:** the base currency plus any other enabled currencies for the city. Each one has:
  - `rate`: base units per 1 unit of this currency. The UI accepts input in either direction, for example "1 USD = 41.20 TRY" or "1 TRY = 290 SYP", and stores one canonical value with high precision.
  - `rounding_unit`: for example 5 for TRY, 0.5 for USD, 500 for SYP. OWN or FIN sets these (§9.10.4).
  - `rounding_mode`: `nearest` (default), `up` or `down`.
  - Display order and an enabled flag.
- **Rate changes:**
  - Each change is a new rate version that takes effect immediately, with the editor, time and an optional reason.
  - A change larger than `fx.large_change_confirm_pct` (10%) needs a second confirmation, to catch typos.
  - A rate older than `fx.stale_alert_hours` (24) raises an information alert for OWN and FIN.
- **Order snapshot:**
  - When an order is placed it stores the rate of every accepted currency. These are the rates of the quote the customer confirmed; if any rate changed since that quote, placing is refused and the customer sees the new quote (customer-app spec §10.7).
  - Every later calculation for that order uses the snapshot, including admin edits and the money check at delivery.
  - New rates affect new orders only.
- **What the customer sees:** the total in the base currency, plus the equivalent in each other accepted currency, each rounded by that currency's rule.
- **Payment at the door:**
  - The captain records what was received (one or more currency lines) and the change given (currency lines).
  - The server converts the lines with the order snapshot.
  - The net received is the received lines minus the change lines. A difference from the amount due within half the largest rounding unit among the currencies of all the lines is booked as rounding. A net above the amount due beyond that is refused (captain-app spec §9.7).
  - A larger shortfall is flagged to OPS as «نقص في التحصيل». OPS resolves it by choosing the responsible party, with the §8.9 effects applied to the missing amount: captain (`earn.charge`), customer, or platform (operating cost). For the customer, the dues are the missing amount only (`dues.charge`), with a block until it is paid (§8.8). The fake-order dues rule, the strike and any trust change do not apply. Until it is resolved, it shows as an open shortfall on the order and on the dashboard.
- **Payment at pickup:** by default the captain pays the restaurant in the base currency. A restaurant MAY also accept other enabled currencies (restaurant-app spec §12.7). The payment lines are converted with the order snapshot and rounded per currency, as at the door. The rounding difference goes to `platform.fx_rounding`. The restaurant account always counts the pickup payment as the full items value.
- **Custody** is tracked per currency, so the captain hands back exactly the currencies they received. They carry no exchange risk and gain nothing from rate moves.
- **Rounding and FX** differences go to the platform account `platform.fx_rounding` «فروقات التقريب والصرف» (§8.11), which appears in the daily report.

### 8.7 Restaurant account «حساب المطعم» (D13, D26)

The restaurant receives the full items value in cash at pickup, so during the week it accumulates what it owes the platform: commission, plus its share of any discounts it funded. The account also records exceptions in both directions. The balance is normally negative, meaning the restaurant owes the platform, and the restaurant pays it every Saturday.

| Entry | Sign (from the restaurant's view) | When |
|---|---|---|
| `merchant.commission` | − (restaurant owes) | When an order finishes (delivered, or failed after pickup), unless the restaurant is the responsible party for a non-normal outcome (§8.9). A reversing entry (+) is posted when items are removed with the restaurant responsible (§9.3.3, §8.10). Never posted on test orders (§9.6.3). |
| `merchant.discount_share` | − (restaurant owes) | Same moment and same exceptions as the commission: the restaurant-funded part of a discount, because the captain paid the full items value |
| `merchant.credit` | + (platform owes) | The order was cancelled after the food was prepared and the restaurant was not responsible: the platform credits the merchant net (§8.9). Also a pickup dispute resolved in the accounts where the captain paid the restaurant less than the pickup payment (§9.9.3). |
| `merchant.debit` | − (restaurant owes) | The restaurant is responsible: it returns the full pickup payment for a failed or refused order (§8.9), the value of items removed after pickup (§9.3.3), or the value of items affected by a post-delivery problem (§8.10). Also a pickup dispute resolved in the accounts where the captain paid the restaurant more than the pickup payment (§9.9.3). |
| `merchant.settlement` | ± | The Saturday settlement: the restaurant pays the platform, or the platform pays the restaurant if the balance is positive (receipt) |
| `merchant.adjustment` | ± | Manual correction (OWN/FIN, reason) |

- **Settlement day:** `merchant.settlement_weekday` (Saturday, a business day, §4.3).
- **Statement cutoff:** the weekly statement closes at the business-day cutoff that starts the settlement day (Saturday 06:00 by default). It covers every entry since the previous statement closed. Entries posted after the cutoff, such as orders finished on Saturday, go to next week's statement.
- **Amount due** = the statement total + any unpaid balance from earlier statements.
- **Settlement method:** «في المكتب» (at the office) or «زيارة ميدانية» (field visit), recording the staff member who visited. Payment can be in any accepted currency, converted at the current rate. Payments can be recorded on any day, and partial payments are allowed.
- **Weekly statement:** generated at the cutoff and visible in the restaurant app. It lists:
  - each order: items value received from the captain, commission, restaurant-funded discount
  - exceptions (credits and debits) with the order number and reason
  - the earlier unpaid balance and the total due
- **Receipt:** each settlement gets a receipt, which appears in the restaurant app.
- **Overdue:** if a restaurant has not settled `merchant.settlement_overdue_days` (2) days after Saturday, OWN and FIN get a warning, «مطعم متأخر في التسوية». The panel does not pause the restaurant automatically. OWN decides what to do (§13).

### 8.8 Customer trust, strikes and dues

- **Trust (D23):**
  - New accounts may have `customer.new_max_active_orders` (1) active order at a time.
  - After `customer.trusted_after_delivered_orders` (3) orders that were delivered with outcome `normal`, the account becomes «موثوق» (trusted), with `customer.trusted_max_active_orders` (3).
  - A `fake` outcome removes trust and resets the count.
  - OWN or OPS can mark an account trusted, or remove trust, with a reason.
- **Late cancellation:** a cancellation after the restaurant accepted, at the customer's request. `customer.late_cancel_strikes` (2) within `customer.late_cancel_window_days` (30) blocks ordering «موقوف حتى مراجعة الدعم» until support reviews the account.
- **Fake order:**
  - When the outcome is set to fake, the customer is blocked until they pay their dues.
  - Dues follow `customer.fake_order_dues_rule`: `fee_plus_merchant_net` (default: delivery fee + merchant net), `fee_plus_items_value`, or `fixed` (an amount set by OWN).
  - FIN records the payment at the desk, which unblocks the customer automatically.
- **Dues ledger «مستحقات الزبون»** (base currency):

  | Entry | Sign | When |
  |---|---|---|
  | `dues.charge` | + | A fake order, or a collection shortfall with the customer responsible |
  | `dues.payment` | − | Payment recorded at the desk (receipt) |
  | `dues.adjustment` | ± | Manual correction (OWN/FIN, reason) |

  A dues block lifts automatically when the balance reaches 0 or less.
- **Account closure (D19):**
  - Closure happens from the customer app's own delete-account button, or from the panel on the customer's request. Both lead to the same result (app stores require deletion to be possible inside the app).
  - Closure is refused while the customer has an active order, in the app and in the panel.
  - Status becomes «مغلق»: the customer cannot sign in and drops out of active-customer lists.
  - All data is kept.
  - If the same phone number registers again, a new account is created and linked internally to the closed one. Blocks, unpaid dues, strikes, trust state and promo history carry over, so the new account is **not** a "new user" for promo codes.

### 8.9 Outcomes and responsibility (money effects)

Every order that ends after pickup gets an outcome. Every outcome except `normal` also needs a **responsible party**: restaurant, captain, customer or platform.

| Outcome | Arabic | Status | Customer pays |
|---|---|---|---|
| `normal` | «عادي» | delivered | Full total |
| `free` | «مجاني» | delivered | 0, or a reduced amount set by OPS |
| `fake` | «وهمي» | failed | 0 (customer at fault, dues apply) |
| `damaged` | «تالف» | failed or delivered with a reduction | 0, or a reduced amount |
| `wrong_refused` | «خطأ ورفضه الزبون» | failed | 0 |
| `failed_other` | «تعذّر التسليم» | failed | 0 (for example address unreachable or force majeure) |

**One rule computes the money effect of every non-normal outcome:**

1. **Custody** reflects what really happened: the pickup payment (the full items value) and whatever the captain actually collected. A negative position is reimbursed at the desk on the same business day.
2. **Commission and discount share** are posted to the restaurant account as usual, because the restaurant was paid in full at pickup. The only exception: when the restaurant is the responsible party, neither is posted.
3. **Loss amount** = merchant net − amount collected from the customer (floored at 0). Because the platform still collects the commission from the restaurant, its real loss on the food is the merchant net, not the full items value.
4. **Captain pay:** the captain receives `earn.order_pay` (and any waiting pay) unless the captain is the responsible party.
5. **The responsible party bears the cost:**
   - **Restaurant:** returns the full pickup payment (`merchant.debit`). No commission or discount share is posted, so the restaurant ends with nothing from the order. Whatever the customer paid stays with the platform and offsets the captain's pay; any remainder of the captain's pay is an operating cost.
   - **Captain:** `earn.charge` of the loss amount, and no pay.
   - **Customer:** a `dues.charge` per `customer.fake_order_dues_rule` (default delivery fee + merchant net), a block until paid, and a strike. The fake-order rule applies.
   - **Platform:** the loss amount and the captain's pay are booked to `platform.operating_cost` «كلفة تشغيلية».

**Check with the §8.4 example** (fake order, customer responsible): the captain paid the restaurant 400 and collected 0, so the desk reimburses 400. The restaurant still owes 60 commission on Saturday. The captain earns 35. The customer owes 40 + 340 = 380. Platform result once the customer pays: −400 + 60 − 35 + 380 = +5. The platform recovers its costs but does not earn its usual margin.

**Preview:** the outcome dialog MUST list each entry that will be posted, with its amount, account and party, before the user confirms. For example: «سيُعاد للكابتن 400 ₺ (عهدة) ويُقيَّد له أجر 35 ₺ (مستحقات). تُسجَّل عمولة 60 ₺ على المطعم. سيُحظر الزبون حتى دفع 380 ₺.»

**Food after a failed order.** OPS record where the food went: «يبقى مع الكابتن» (stays with the captain, the default), «أُعيد إلى المطعم» (returned to the restaurant) or «أُتلف» (disposed of) (captain-app spec C11). The record has no money effect of its own. «أُعيد إلى المطعم» is allowed only when the restaurant is the responsible party, which is the case where it returns the full pickup payment (rule 5 above).

**Changing an outcome.** OWN MAY change the outcome or the responsible party within `order.outcome_change_days` (7) of it being set, with a reason. The server reverses every entry and side effect of the old outcome (ledger entries, dues, block, strike, trust change), then posts the new ones. The same preview is shown first.

**Cancellation before pickup** (status `accepted` or `ready`). Normally the captain has not paid the restaurant yet (pickup is atomic, §8.1). If the captain had already reached the restaurant, the cash question in §8.1 is answered first. Then:

- OPS records whether food was prepared, and who is responsible.
- If food was prepared and the restaurant is not responsible, the platform credits the restaurant with the merchant net (`merchant.credit`), which is what it would have kept from a normal order.
- If the customer is responsible, the late-cancel strike applies.
- If no food was prepared, there is no money effect on the restaurant.
- **Captain:** if a captain was assigned and had already arrived at the restaurant, OPS MAY tick «تعويض الكابتن» (compensate the captain). This posts `earn.order_pay` equal to the order's base pay, booked to `platform.operating_cost`. There is no automatic pay otherwise.

### 8.10 Problems found after delivery (tickets)

A customer may report missing, wrong or damaged items after a normal delivery (§9.9). The order's outcome stays `normal`; the ticket handles the money.

- **Affected value `V`:** the value of the affected items from the order snapshot, chosen in the ticket.
- **Remedy:** a compensation code (capped, §6.4), a free re-delivery of the items (§9.9.3), or no remedy. Remedies are funded by the platform, and the cost of a code goes to `platform.compensation_cost`.
- **Responsible party:**
  - **Restaurant:** with a free re-delivery, the restaurant replaces the items for free and nothing else is posted. Otherwise it posts `merchant.debit` of `V` and a reversing `merchant.commission` on `V`, so the restaurant gives back the merchant net of the affected items.
  - **Captain** (for example items missing after the captain verified the order): `earn.charge` of the merchant net of `V`. With a free re-delivery, this charge is posted once, on the re-delivery order.
  - **Platform:** only the cost of the remedy.
  - **Customer** (complaint not justified): no remedy and no entries.
- **Wrong change «مشكلة في المبلغ أو الباقي»** (customer-app spec Q23). The resolver enters `M`, the amount the customer was short, compared with what the captain recorded.
  - **Captain responsible:** `earn.charge` of `M` on the captain. The customer gets `M` back as a code, or in person through the captain arranged by OPS (then no charge is posted).
  - **Platform responsible:** a code of `M`, booked to `platform.compensation_cost`.
  - **Customer** (complaint not justified): no remedy and no entries.
  - The code restores money the customer already paid, so it is not capped (§6.4).
  - The opposite case, where the captain recorded more than they received, is the collection-shortfall flow (§8.6).
- These are system entries created when OPS or SUP resolves the ticket, with a preview. They are not manual adjustments, so SUP may create them.

### 8.11 Platform accounts

The platform's own side of every entry is booked to one of these accounts, which feed the finance reports (§9.10):

| Account | Arabic | Receives |
|---|---|---|
| `platform.revenue_commission` | «عمولات» | Commission entries |
| `platform.revenue_delivery` | «رسوم التوصيل» | Delivery fees |
| `platform.discount_cost` | «كلفة الخصومات» | Platform-funded discounts on orders |
| `platform.compensation_cost` | «كلفة التعويضات» | Compensation codes when used, automatic late codes, free re-deliveries borne by the platform |
| `platform.operating_cost` | «كلفة تشغيلية» | Losses and captain pay borne by the platform under §8.9, captain cancellation compensation, shortfalls borne by the platform |
| `platform.captain_pay` | «أجور الكباتن» | All captain earnings entries except charges |
| `platform.fx_rounding` | «فروقات التقريب والصرف» | Rounding adjustments and FX conversion differences |
| `platform.test_cost` | «كلفة الطلبات التجريبية» | Captain pay and losses on test orders (§9.6.3) |

---

## 9. Modules

Each module below lists its purpose, its screens, what users see, what they can do, and the rules that apply.

### 9.1 Dashboard «لوحة التحكم»

**Purpose:** understand the state of the whole platform within 10 seconds of opening the panel.

#### 9.1.1 Status strip

- **Platform:** «تعمل» (running) or «إيقاف طارئ» (emergency stop), with the emergency message and its start time.
- **Dispatch mode** with a switch for OWN and OPS.
- **Captains:** online, available, busy, and blocked for unhanded cash, each with a count.
- **Restaurants:** open, busy (at their maximum active orders), paused, closed by schedule, and suspended, each with a count, plus how many open restaurants have no receiving device connected.

#### 9.1.2 Today tiles (current business day, compared with the same weekday last week)

- Orders delivered, in progress, cancelled and rejected.
- GMV (customer totals), items value, delivery fees, commissions and platform margin, all in the base currency.
- Average delivery time from placement to delivery, the on-time rate and the success rate (delivered ÷ placed).
- New customers and first orders.

#### 9.1.3 Alerts list (the most important part)

Alerts are sorted by severity, then by age. Each one has direct action buttons. Only users with a recipient role see an alert, hear it and can acknowledge it (§7.3).

| Alert | Severity | Recipients | Trigger | Actions on the alert |
|---|---|---|---|---|
| «مطعم لم يقبل» (restaurant has not accepted) | Critical | OWN, OPS | `placed` for 3 min | Call the restaurant · Accept on its behalf · Open the order |
| «طلب بلا كابتن» (order without a captain) | Critical | OWN, OPS | 5 min after the search-start moment (in every dispatch mode, §8.3) | Assign manually · Open the map |
| «جاهز بلا كابتن» (ready, no captain) | Critical | OWN, OPS | 15 min after ready, still unassigned | Call the customer · Assign · Cancel with a code |
| «انقطع اتصال كابتن أثناء طلب» (captain lost connection mid-order) | Critical | OWN, OPS | No GPS for 2 min during an active order | Call the captain · Reassign (before pickup) · Hand over (after pickup) |
| «المطعم لم يؤكد التعديل» (restaurant did not acknowledge an edit) | Critical | OWN, OPS | Items added and not acknowledged by the restaurant for 3 min (§9.3.3) | Call the restaurant · Open the order |
| «تذكرة عاجلة» (urgent ticket) | Critical | OWN, OPS, SUP; FIN as well for pickup-dispute tickets | A ticket on an active order, or any pickup-dispute ticket (§9.9.3) | Open the ticket |
| «صنف نفد بعد القبول» (item ran out after acceptance) | Critical | OWN, OPS | The restaurant reported an item unavailable on an accepted order (restaurant-app spec §8.12) | Call the customer · Edit the order · Cancel · Close the report |
| «خلاف على مبلغ الاستلام» (pickup amount dispute) | Critical | OWN, OPS | The restaurant disputed a pickup request before confirming it (§8.1) | Call the restaurant · Call the captain · Confirm pickup on its behalf · Open the order |
| «كابتن لا يستطيع إكمال الطلب» (captain cannot complete the order) | Critical | OWN, OPS | A captain pressed «لا أستطيع إكمال الطلب» with a reason (captain-app spec §9.11) | Call the captain · Reassign (before pickup) · Hand over (after pickup) |
| «طوارئ كابتن» (captain emergency) | Critical | OWN, OPS | A captain pressed «طوارئ» during an order; the alert carries their location (captain-app spec §9.11) | Call the captain · Open the map · Hand over · Reassign |
| «تحضير متأخر» (prep late) | Warning | OWN, OPS | 10 min past the chosen prep time | Call the restaurant · Update the ETA |
| «كابتن ينتظر عند المطعم» (captain waiting at the restaurant) | Warning | OWN, OPS | 10 min at the restaurant | Call the restaurant |
| «توصيل متأخر» (late delivery) | Warning | OWN, OPS | 20 min past the promised time | Call the captain · Send an apology |
| «زبون لا يرد» (customer not answering) | Warning | OWN, OPS | After 3 pings over 15 min | Call the customer · Decide: wait or fake |
| «نقص في التحصيل» (collection shortfall) | Warning | OWN, OPS, FIN | Collected less than due beyond rounding (§8.6) | Open the order · Call the captain · Resolve |
| «كابتن بلغ حد العهدة» (captain reached the cash limit) | Warning | OWN, OPS, FIN | 100% of the cash limit | Open the captain's custody |
| «مطعم أوقف تلقائياً» (restaurant auto-paused) | Warning | OWN, OPS | 3 unanswered orders in a business day | Call the restaurant · Resume |
| «مطعم مفتوح بلا جهاز استقبال» (open restaurant with no receiving device) | Warning | OWN, OPS | Open or busy for 5 min with no receiving device connected (restaurant-app spec §4.6) | Call the restaurant · Pause |
| «لا يمكن إرسال رموز الدخول» (sign-in codes cannot be sent) | Critical | OWN, OPS | No WhatsApp sending number is able to send (technology-stack §8.3.3). New sign-ins stop; existing sessions continue. | Open «أرقام إرسال الرموز» (OWN) · Call the owner (OPS) |
| «رقم إرسال الرموز متوقف» (a code-sending number stopped) | Warning | OWN | A WhatsApp sending number is disconnected, throttled or banned (technology-stack §8.3.3) | Open «أرقام إرسال الرموز» |
| «مطعم متأخر في التسوية» (restaurant overdue on settlement) | Warning | OWN, FIN | Account not settled 2 days after Saturday (§8.7) | Open the statement · Call the restaurant · Record a payment |
| «طلب موافقة تعويض» (compensation approval request) | Information | OWN | SUP or OPS asked for more than their cap | Approve · Edit · Reject |
| «طلب انضمام كابتن» (captain application) | Information | OWN, OPS | New application | Review |
| «نهاية فترة تجربة» (probation ending) | Information | OWN, OPS | 3 days before a captain's probation ends | Open the contract |
| «مستند ينتهي» (document expiring) | Information | OWN, OPS | 30 days before a document expires | Open the documents |
| «مراجعة نسبة القبول» (acceptance-rate review) | Information | OWN, OPS | A captain's acceptance rate fell below 50% | Open the captain |
| «سعر صرف قديم» (stale exchange rate) | Information | OWN, FIN | A rate not updated for 24 h | Update the rates |
| «تغيير أسعار كبير» (large price change) | Information | OWN, OPS | A restaurant changed a price by more than 30% in one edit or bulk change (restaurant-app spec §9.4) | Open the price log · Call the restaurant |
| «تسليم بعيد عن العنوان» (delivery away from the address) | Information | OWN, OPS | A captain recorded arrival or delivery more than `captain.customer_radius_m` (200) m from the customer's pin, with a reason (captain-app spec §9.6 and captain-app spec §9.8) | Open the order · Call the captain |

#### 9.1.4 Pending tasks «المهام»

A widget with counts and links, filtered to the user's roles:

- approvals waiting (OWN)
- menu change requests from restaurants (OWN, OPS; §9.6.7)
- applications to review
- probation reviews
- expiring documents
- acceptance-rate reviews
- open collection shortfalls
- captains blocked for unhanded cash
- Saturday restaurant settlements due, and overdue restaurants
- Thursday payouts due (on Thursday)

#### 9.1.5 Charts and lists

- Orders per hour today, compared with the same weekday last week.
- Top restaurants today by orders.
- Restaurants with the most rejections or delays today.

#### 9.1.6 Emergency stop «الإيقاف الطارئ» (D7; OWN, OPS)

**Starting the stop.** The dialog has these fields:

- an internal reason (required)
- the message shown to browsing customers (prefilled from `platform.emergency_default_message_browse`, editable)
- the delay notice for customers with active orders (prefilled from `platform.emergency_default_message_active`, editable). Its `{السبب}` placeholder is filled from the customer-facing reason below.
- the customer-facing reason text, for example «سوء الأحوال الجوية» (bad weather)
- an optional automatic resume time

**While the stop is on:**

1. New orders stop. Customers can browse, but the order button is disabled and the message is shown.
2. Every customer with an active order gets a push notification and an in-app banner on the tracking screen, such as «قد يتأخر طلبك قليلاً بسبب {السبب}».
3. Restaurant and captain apps show a banner: «المنصة متوقفة مؤقتاً عن استقبال طلبات جديدة. أكملوا الطلبات الحالية.» Active orders continue normally, including dispatch for orders that have no captain yet.
4. The top bar turns red. The dashboard shows how long the stop has lasted and how many orders customers tried to place during it: each customer who opens checkout during the stop counts once per stop (customer-app spec §10.6).

**Ending the stop:** «استئناف» (resume), with an option to send customers a push saying the service is back. An automatic resume never sends that push; OPS can send it afterwards from marketing. Starting and ending are both audited.

---

### 9.2 Operations room «غرفة العمليات»

**Purpose:** watch every live order and step in at any moment. This is the dispatcher's screen for the whole shift.

#### 9.2.1 Board

The board has five columns, laid out right to left:

«بانتظار المطعم» → «قيد التحضير» → «جاهز» → «مع الكابتن» → «الكابتن وصل»

Each column header shows its count and how many of its cards are late.

**An order card shows:**

- The order number, the restaurant name and the customer's neighbourhood.
- **Time in the current state**, with an SLA colour:
  - green: within the limit
  - amber: 80% or more of the limit used (fixed)
  - red: past the limit

  The limit for each column:

  | Column | Limit |
  |---|---|
  | «بانتظار المطعم» | The acceptance alert (3 min) |
  | «قيد التحضير» | The chosen prep time |
  | «جاهز» | The no-captain-after-ready limit (15 min) |
  | «مع الكابتن» | The promised delivery time |
  | «الكابتن وصل» | The no-answer window (15 min) |

- The captain's name, or a red «بلا كابتن» (no captain) when unassigned.
- The customer total in the base currency.
- Badges:
  - «زبون جديد» (new customer)
  - «كود خصم» (discount code)
  - «ملاحظة» (note)
  - «طلب ثانٍ اليوم» (customer's second order today)
  - «معدّل» (edited by admin)
  - «تجريبي» (test order)
  - «بحاجة لتعيين» (needs assignment, §8.3)
  - «بانتظار تأكيد الاستلام» (pickup request waiting for the restaurant, §8.1)
  - «صنف نفد» (open item-unavailable report)
  - «إيقاف طارئ» (the order was active while the emergency stop was on)

**Filters:** restaurant, captain, neighbourhood or zone, «المتأخر فقط» (late only), «بلا كابتن فقط» (no captain only), «لها تذكرة» (has a ticket), and test orders shown or hidden.

**Interaction:** clicking a card opens the order detail (§9.3) in a side panel, so the board stays visible.

---

### 9.3 Order detail and order actions

#### 9.3.1 Order detail

- **Header:**
  - order number, status and a step progress bar
  - promised time compared with the expected or actual time
  - outcome and responsible party, when the order is finished
  - badges
- **Customer:**
  - name and masked phone (reveal is logged, §5.4)
  - address on a mini map, with the details and the nearby landmark
  - the recipient's name and contact phone, when the order is for someone else (customer-app spec Q5). The contact phone is masked and revealed like the customer's phone (§5.4).
  - the pay-in currency «سأدفع بـ», when the customer chose one (customer-app spec U10)
  - delivered-order count and trust level
  - strikes and internal notes
- **Restaurant:** name, phone and current state.
- **Captain:**
  - name, phone and vehicle
  - live position and last GPS time
  - cash-limit usage
- **Items:** each item with its options, add-ons, quantity, note and line price. Items added or removed by admins are marked with who made the change.
- **Money:**
  - every line from §8.4: items value, delivery fee, discounts split by funder, rounding, customer total, pickup payment (paid by the captain), custody for this order, commission and restaurant-funded discount (owed by the restaurant on Saturday), merchant net, captain pay and platform margin
  - the exchange-rate snapshot
  - after delivery: the payment lines (currency and amount), the change given, and any shortfall
- **Timeline:** every event with its time and actor (system, restaurant user, captain or admin user). The events are:
  - created
  - restaurant notified
  - accepted (with prep time and who accepted)
  - rejected (with reason)
  - accepted on behalf by an admin
  - search started
  - each offer (captain and response: accepted, rejected or expired)
  - assigned (automatically, or manually by whom)
  - captain at the restaurant
  - ready
  - items verified
  - pickup requested (payment lines)
  - pickup disputed (the amount the restaurant says it received)
  - pickup confirmed, one event with the payment lines (§8.1): by the restaurant (user and device), automatically, or by OPS on its behalf
  - item reported unavailable, and how the report was closed
  - edit acknowledged by the restaurant (user and device)
  - restaurant called the captain
  - handed over to another captain
  - captain at the customer
  - each customer ping, and the customer's «أنا قادم» answer
  - each customer call to the captain
  - delivered (with payment lines)
  - edits (with the money difference)
  - ETA changes
  - cancellation (reason and party)
  - outcome
  - compensation
  - tickets linked
  - notes
  - emergency notices sent
- **Map:** the restaurant, the customer and the captain (live), with the captain's track after pickup.
- **Related:** tickets and compensations on this order.

#### 9.3.2 Actions

Each action is available only when the order's status and the user's role allow it. The server re-checks both.

**Who:** OWN and OPS can take every action below, except that changing an outcome after it was set is OWN only (§8.9). SUP can take only these: compensate the customer, call, internal note, open a ticket, resend a notification.

| Action | Arabic label | Allowed in | What happens | Reason |
|---|---|---|---|---|
| Accept for the restaurant | «قبول نيابة عن المطعم» | `placed` | The admin picks a prep time and the order continues normally. The restaurant app shows that ops accepted. | Required |
| Reject for the restaurant | «رفض نيابة عن المطعم» | `placed` | The order becomes `rejected`. The customer sees the reason and similar restaurants. | Required |
| Assign a captain | «تعيين كابتن» | No captain, before pickup | Opens the assignment picker (below) | — |
| Reassign | «سحب وإعادة تعيين» | Assigned, **before pickup only**, and no pickup request open | Takes the order from the captain. The admin chooses «بخطأ من الكابتن» (counts as a captain cancellation) or «دون خطأ» (no penalty), then the order goes back to dispatch or to a picked captain. If the captain had already reached the restaurant, the cash question in §8.1 comes first. | Required |
| Hand over after pickup | «تسليم لكابتن آخر» | `picked_up` or `arrived`, emergencies only (for example an accident or a breakdown) | The admin picks a second captain, who goes to the first captain and takes the order. The second captain's offer shows that they pay nothing, and the maximum pickup amount does not apply. The second captain confirms receipt near the first captain, which sets the status back to `picked_up` if it was `arrived`. The first captain's track ends and they go offline (captain-app spec §9.10.1). The pickup payment stays in the first captain's custody, where the desk reimburses it. The second captain collects at the door, so the collection goes to their custody. The second captain earns the order pay. OWN or FIN MAY add a manual bonus for the first captain. If the food cannot continue, use «تحديد النتيجة» instead. | Required |
| Record delivery for the captain | «تسجيل التسليم نيابة عن الكابتن» | `picked_up`, `arrived` | For when the captain has no working phone. The admin enters the payment lines and change as the captain reports them by phone. The order becomes `delivered` with outcome `normal`, with the same entries as a delivery from the app. | Required |
| Set the outcome | «تحديد النتيجة» | `picked_up`, `arrived` | Ends the order as `failed`, or as `delivered` with outcome `free` or `damaged`. The admin picks the outcome, the responsible party, the amount to collect from the customer and, for a failed order, where the food went (§8.9), and sees the money preview. If the amount to collect is above 0, the order stays active with «بانتظار تسجيل التحصيل», and the captain records the payment lines in the captain app (OPS MAY enter them instead when the captain cannot). The outcome is posted then, from the recorded net, so the preview is marked provisional until collection. A gap below the amount beyond rounding follows the collection-shortfall flow (§8.6). Problems found after a normal delivery go through tickets (§8.10), not outcomes. | Required |
| Record the captain's arrival | «تسجيل وصول الكابتن» | Assigned, before pickup, captain not yet `at_merchant` | Sets the captain track to `at_merchant`, for when GPS fails at the restaurant (captain-app spec §9.2) | Required |
| Change prep time or promised time | «تعديل الوقت» | `accepted`, `ready`, `picked_up` | The customer is notified of the new time | — |
| Edit the order | «تعديل الطلب» | §9.3.3 | Recalculates the money and notifies everyone involved | Required |
| Cancel | «إلغاء الطلب» | `placed`, `accepted`, `ready` | The admin picks a reason and a responsible party, says whether food was prepared, and may add compensation. If the captain had already reached the restaurant, the admin also answers the cash question (§8.1). Shows the money preview (§8.9). | Required |
| Change the outcome | «تغيير النتيجة» | Finished, within `order.outcome_change_days` (7) | OWN only. Reverses the old outcome's entries and side effects and posts the new ones (§8.9). | Required |
| Compensate the customer | «تعويض الزبون» | Any status | A next-order code (amount, or % with a maximum amount), within the role's cumulative cap for this order (§6.4) | Required |
| Call | «اتصال» | Any status | Reveals the number (logged) and opens `tel:` | — |
| Internal note | «ملاحظة داخلية» | Any status | Saved on the order, visible to panel users only | — |
| Open a ticket | «فتح تذكرة» | Any status | Creates a ticket linked to this order | — |
| Resend a notification | «إعادة إرسال الإشعار» | Active orders | Pushes the current state again to the customer, restaurant or captain | — |
| Manual dispatch for this order | «توزيع يدوي لهذا الطلب» | Before assignment | Takes this order out of automatic dispatch | — |
| Confirm pickup for the restaurant | «تأكيد الاستلام نيابة عن المطعم» | `accepted` or `ready`, the assigned captain at the restaurant, and no open item-unavailable report | The admin enters the payment lines, prefilled from the captain's last request, and the server performs the pickup (§8.1). It does not wait for an unacknowledged edit, because the admin confirmed it by phone. The restaurant app shows that ops confirmed. Used when the restaurant cannot answer, or a dispute or edit was settled by phone. | Required |
| Close an item-unavailable report | «إغلاق بلاغ صنف نفد» | A report is open (restaurant-app spec §8.12) | Clears the report without an edit, for example when the restaurant found the item. An edit or a cancellation clears it automatically. | Required |

**Assignment picker:**

- Lists eligible captains (§9.12.6 eligibility rules), sorted by distance to the restaurant. For each captain it shows:
  - distance and ETA to the restaurant
  - vehicle
  - orders today
  - cash-limit usage
  - acceptance rate
- Ineligible captains appear greyed out with the reason: busy, over the cash limit, blocked for unhanded cash, out of range, vehicle not allowed, or «المبلغ أكبر مما يحمله» (the pickup payment is above the captain's maximum pickup amount). OPS MAY still send a manual offer to a captain greyed out only for that last reason; the captain sees a warning and decides (captain-app spec §8.4).
- With `dispatch.manual_assign_requires_accept` (true), a manual assignment reaches the captain as an offer, and the admin sees whether they accept. With false, the assignment is direct.

#### 9.3.3 Editing rules (D8)

| Status | Add items | Remove items or lower quantity | Change options | Change delivery fee |
|---|---|---|---|---|
| `placed`, `accepted` | Yes | Yes | Yes | Yes |
| `ready` | Yes. The order goes back to `accepted` with an extra prep time that the admin enters. | Yes | Yes | Yes |
| `picked_up`, `arrived` | No | Yes (the customer refuses part of the order), with a responsible party | No | Lower only, with a responsible party |
| Finished | No edits. Use a ticket (§8.10), an outcome change (§8.9) or a ledger adjustment. | | | |

- **Adding items:**
  - Items come from the restaurant's current menu at current prices and must be available.
  - The restaurant app gets a sound alert, «تم تعديل الطلب», and must acknowledge it.
  - If the restaurant does not acknowledge within `order.merchant_accept_alert_min` (3 min), OPS gets the critical alert «المطعم لم يؤكد التعديل» (§9.1.3).
- **Every edit before pickup** opens a prompt in the restaurant app that the restaurant acknowledges.
  - Only an unacknowledged edit that adds items blocks pickup requests, and only additions raise the «المطعم لم يؤكد التعديل» alert.
  - Edits are blocked while a pickup request is open (§8.1).
  - After an edit, the restaurant and the captain settle any cash difference in person, and the captain's next request carries the new amount.
- **Every edit:**
  - shows a before-and-after money preview
  - recalculates the totals with the order's snapshots (§8.1). Before pickup this includes the pickup payment, commission and merchant net. After pickup, the pickup payment and the base of the commission and discount share are frozen (§8.1). Removals then post only the separate entries below.
  - notifies the customer of the new total and the captain of the new amounts to pay (before pickup) and to collect
- **Edits and discount codes:**
  - The code stays on the order.
  - A percentage discount is recomputed on the new items value, capped at the original discount amount.
  - Minimum-order and free-delivery thresholds are not re-checked after the order was placed.
- **After pickup**, the captain has already paid the restaurant the full items value, so removing items applies the §8.9 rule to the removed items only:
  - restaurant responsible: the restaurant returns the removed items' value (`merchant.debit`), and a reversing `merchant.commission` removes the commission on them
  - captain responsible: `earn.charge` of the removed items' merchant net
  - platform responsible: the removed items' merchant net goes to `platform.operating_cost`
  - customer responsible: not allowed. A customer who changes their mind at the door pays the full total, unless OPS gives a compensation code.
- **Lowering the delivery fee after pickup:** the reduction is borne by the responsible party, as in §8.9: captain (`earn.charge`), restaurant (`merchant.debit`) or platform (operating cost).

---

### 9.4 Live map «الخريطة الحية»

**Shows:**

- Service zones as polygons.
- Restaurants: green when open, amber when paused, grey when closed or suspended.
- Captains:
  - green: available
  - orange: busy, with an order number tooltip
  - grey: offline, showing the last known position and its time
  - red outline: blocked (unhanded cash or cash limit)
- Active orders as a line from the restaurant to the customer.

**Actions:**

- Click a captain to see a card with their name, phone (call), vehicle, current order, last GPS time, cash-limit usage and an «عيّنه لطلب» (assign to an order) button that lists orders without a captain.
- Click a restaurant to see its state and active orders.
- Filters: available only, vehicle type, layers (restaurants, captains, orders, zones).

**Purpose:** dispatch by eye in manual mode, and spot neighbourhoods with no captains.

---

### 9.5 Order history «سجل الطلبات»

- **Search and filters:**
  - order number
  - customer phone (for roles allowed to see phones)
  - restaurant, captain
  - date range (business days)
  - status, outcome, responsible party
  - code used
  - zone
  - test or real
- **Table columns:** number, time, restaurant, customer neighbourhood, captain, status, outcome, total and delivery time.
- **Detail:** any order opens the full detail and timeline (§9.3.1).
- **Finished orders are read-only.** OWN and FIN can post a financial correction, which is a reversing or adjusting ledger entry linked to the order, with a reason.
- **Export:** to Excel.

---

### 9.6 Restaurants «المطاعم»

#### 9.6.1 Restaurant states

| Dimension | Values |
|---|---|
| Account status | `draft` «مسودة» · `test` «تجريبي» · `active` «فعّال» · `suspended` «معلّق» · `terminated` «منتهي» |
| Operating state (computed) | `open` «مفتوح» · `busy` «مشغول» (open, but at the maximum active orders the restaurant set) · `paused` «موقوف مؤقتاً» · `closed` «مغلق» (from hours, or a holiday until a date) |
| Busy mode (flag on `open`) | «وضع الضغط» +10 or +20 min added to the time customers see (restaurant-app spec §7.3) |
| Visibility | `visible` · `hidden` «مخفي» |

Customers see only `active` + `visible` restaurants, plus `test` restaurants for admin test accounts.

#### 9.6.2 Restaurant list

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

#### 9.6.3 Onboarding wizard «إضافة مطعم» (8 steps; draft saved at every step)

| Step | Fields | Who |
|---|---|---|
| 1. Basics | Arabic name (required), optional English name, category, short description, logo, cover image | DATA, OPS, OWN |
| 2. Location and contacts | Map pin (required), address text, restaurant phone, owner name and phone | DATA, OPS, OWN |
| 3. Operations | Opening hours (several periods per day, days off), default prep time (`merchant.default_prep_min`), minimum order (`merchant.default_min_order`), delivery coverage (a radius in km or chosen zones) | DATA, OPS, OWN |
| 4. Money | Commission % (default `merchant.default_commission_pct`); optional launch commission with an end date, for example 10% until 01/02, then the standard rate automatically. The screen states the settlement terms: the captain pays the full items value at pickup, and the restaurant pays the commission every Saturday (D26). | **OWN only** |
| 5. Contract | Signing date, duration, contract scan, commercial registration or licence scan, price-parity pledge (in-app prices ≤ in-store prices), required checkbox | DATA (upload), OWN/OPS (confirm) |
| 6. Accounts | Owner phone for the restaurant app (sign-in by OTP); optional further phones with the role «مالك» (owner) or «كاشير» (cashier). Owners can be added or removed only here, by OPS or OWN. Owners add cashiers from the app (restaurant-app spec §5.1). | OPS, OWN |
| 7. Menu | The menu editor (§9.6.6) | DATA, OPS, OWN |
| 8. Review and activation | Checklist (below); actions «تشغيل الوضع التجريبي» (start test mode) and «تفعيل وإظهار للزبائن» (activate and show to customers) | OPS, OWN |

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

#### 9.6.4 Restaurant profile (tabs)

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

#### 9.6.5 Restaurant actions

| Action | Detail | Who | Reason |
|---|---|---|---|
| Pause «إيقاف مؤقت» | 15, 30 or 60 min (fixed choices), until a time, or until manually resumed; with a customer-facing message. Auto-resumes when it expires. | OWN, OPS | Required |
| Resume «استئناف» | Ends a pause | OWN, OPS | — |
| End busy mode «إنهاء وضع الضغط» | Removes the extra time customers see | OWN, OPS | — |
| Max active orders and pickup currencies | Change them on the restaurant's request (restaurant-app spec §7.4 and restaurant-app spec §12.7) | OWN, OPS | — |
| Holiday close | Closed until a date, with a message | OWN, OPS | Required |
| Suspend «تعليق» | Hidden from customers until reactivated (for violations) | OWN, OPS | Required |
| Reactivate | Back to active | OWN, OPS | Required |
| Hide or show | Visibility only | OWN, OPS | — |
| Pin or sort weight «تثبيت» | Position in a home section or in the category list | OWN, OPS | — |
| Change commission | Effective for new orders only, immediately or at a set time (D16) | OWN | Required |
| Edit menu prices | Allowed; the restaurant is notified of every change (D17) | OWN, OPS (DATA only before activation) | — |
| Terminate | Ends the contract. Requires the restaurant account settled to zero. | OWN | Required |

- **Auto-pause rule:** if a restaurant leaves `merchant.auto_pause_unanswered_count` (3) orders unanswered in one business day, it is paused automatically until OPS resumes it. OPS gets a warning.
- **Who ends a pause:**
  - A pause set by OPS or by the auto-pause rule can be ended only by OWN or OPS. A timed OPS pause also ends when it expires.
  - The auto-pause holds across opening periods until OPS resumes it. It can start after closing time and still applies at the next opening.
  - A pause the restaurant set can be ended by the restaurant or by OWN or OPS.
  - Only one pause exists at a time. An OPS pause or the auto-pause replaces a restaurant pause, and the restaurant cannot pause over them.
- Restaurant pauses and their source (restaurant, ops or auto) are logged for reports.

#### 9.6.6 Menu editor

| Part | What the admin can do |
|---|---|
| Categories | Add, rename, reorder by drag and drop, hide, and set availability windows (for example breakfast until 12:00) |
| Items | Item code (unique within the restaurant, generated if left empty), name, description, price, image (upload with crop and automatic resize), category, order, available or unavailable, hidden, badge («جديد» new, «الأكثر طلباً» most ordered, «حار» spicy) |
| Option groups | Name, required or optional, min and max choices, options with price deltas; link one group to many items at once |
| Add-ons | Free or priced extras, as option groups with min 0 |
| Bulk price change «تعديل جماعي» | Raise or lower by % or by a fixed amount, for one category or the whole menu, with rounding to the base currency's rounding unit and a before-and-after preview. One notification to the restaurant summarises the change. |
| Bulk availability | Mark many items available or unavailable at once |
| Excel import «استيراد من Excel» | Download a template (item code, category, item, description, price, option groups) → upload → validation report (errors per row) → dry-run preview showing what will be added, changed or left alone → commit. Re-import updates items matched by item code and adds rows with a new code. It never deletes items. Price changes from an import notify the restaurant like any other admin price change. |
| Preview «معاينة كما يراها الزبون» | The menu exactly as the customer app shows it |
| Price log «سجل الأسعار» | Every price change: item, old price, new price, who, when |

- Menu changes apply immediately to new orders. Orders already placed keep their snapshot prices.
- Every price change made by an admin notifies the restaurant app (D17) with the item, the old and new price, and who changed it.
- **Restaurant edits:** availability, prices, hiding and ordering made in the restaurant app publish immediately and appear in the price log and change log with the restaurant user's name. New items, new photos, text changes, new categories and option-group changes arrive as change requests (§9.6.7).

#### 9.6.7 Menu change requests «طلبات تعديل القائمة» (OWN, OPS)

- **Queue:** every pending request from every restaurant, oldest first, with the restaurant, the item, the type of change and its age. Requests SHOULD be reviewed within 24 hours.
- **Request view:** before and after side by side (photo, text, option group), plus the customer preview.
- **Actions:**
  - «قبول» (approve): the change publishes immediately.
  - «رفض» (reject): requires a reason, which the restaurant sees.
  - An admin MAY correct the text or crop the photo before approving; the restaurant sees the approved version.
- The restaurant may withdraw a pending request. A newer edit to the same field replaces the pending value (restaurant-app spec §9.5).
- Every decision is audited.

---

### 9.7 Captains «الكباتن»

#### 9.7.1 Application pipeline «طلبات الانضمام»

The pipeline is a board or list by stage:

«جديد» (new) → «قيد المراجعة» (under review) → «مقابلة وتدريب» (interview and training) → «بانتظار العدة» (awaiting kit) → «مفعّل» (active, on probation)

Two side stages: «مرفوض» (rejected) and «قائمة انتظار» (waitlist).

**Application review page:**

- Applicant data: full three-part name, phone (verified), date of birth (`captain.min_age` 18), neighbourhood, vehicle type (motorbike, car, bicycle or e-bike, walking), plate number for motor vehicles.
- **Documents (D24).** Each document has its file(s), number (where relevant), issue date, an optional expiry date, a status («بانتظار التحقق» pending, «مقبول» accepted, «مرفوض» rejected with a reason) and who verified it.

  | Document | Arabic | Required |
  |---|---|---|
  | National ID, front and back | «الهوية» | Yes |
  | Personal photo | «صورة شخصية» | Yes |
  | Civil registry extract | «إخراج قيد» | Yes |
  | Criminal record certificate | «لا حكم عليه» | Yes. Valid `captain.criminal_record_validity_months` (12) from its issue date, which sets its expiry date. |
  | Vehicle papers | «أوراق المركبة» | Yes for motor vehicles (licensed vehicles only) |
  | Driving licence | «شهادة قيادة» | Optional |
  | Signed contract | «العقد الموقّع» | Yes, before activation |

- Applicants upload documents from the captain app. The office can also upload paper scans from the panel.
- **Duplicate check:** an automatic warning appears if the ID number, phone or plate is already registered to another captain or applicant.
- Reviewer notes and the stage history.
- **Re-applying:** a rejected applicant can apply again after 30 days (fixed). A former captain flagged «خروج مبكر» can apply, and the duplicate check shows the flag. Their activation needs OWN's approval (captain-app spec C17).

**Pipeline actions:**

| Action | Effect | Who |
|---|---|---|
| Request a document or correction «طلب مستند» | The applicant is notified of what is missing | OPS, OWN |
| Schedule an interview «تحديد مقابلة» | Date and time sent to the applicant | OPS, OWN |
| Record training and test passed | Moves the application to «بانتظار العدة» | OPS, OWN |
| Issue the kit «تسليم العدة» | Items (thermal bag, vest, sizes) | OPS, OWN |
| Record the deposit | Paid in full or in instalments (deducted on Thursdays); receipt | FIN, OWN |
| Set the cash limit | Required before activation (D10) | FIN, OWN |
| Record the contract | Signing date and scan; computes probation and commitment dates (§9.7.2) | OPS, OWN |
| Activate «تفعيل» | Needs: required documents accepted, training passed, kit issued, deposit recorded, contract signed, vehicle set, cash limit set, and OWN's approval for a captain flagged «خروج مبكر». The captain can now go online. | OPS, OWN (OWN only for a flagged captain) |
| Reject «رفض» | With a reason that is sent to the applicant | OPS, OWN |
| Waitlist «قائمة انتظار» | For when no captains are needed now; the applicant is told | OPS, OWN |

#### 9.7.2 Contract «العقد» (D24)

- **Fields:**
  - signing date and start date
  - probation length `captain.probation_days` (30)
  - minimum commitment after probation `captain.min_commitment_months` (3)
  - computed: probation end date and commitment end date
  - contract scan
- **Contract phases:** «فترة تجربة» (probation) → «فترة التزام» (commitment) → «مفتوح» (open-ended after the commitment period). Each phase is shown on the captain's profile and in the captain app.
- **Phase changes:**
  - Probation → commitment needs OPS confirmation (below).
  - Commitment → open-ended happens automatically on the commitment end date.
  - Each phase change notifies the captain.
- **Probation review:**
  - `captain.probation_review_notice_days` (3) days before probation ends, OPS gets a task.
  - OPS either confirms, which moves the captain to the commitment period, or ends the contract, which starts offboarding.
  - If probation ends without a review, the captain keeps working, stays in «فترة تجربة» and the task turns into a warning for OWN and OPS until someone decides. The commitment period starts from the confirmation date.
- **Early exit (captain-app spec C17):** ending during the commitment period sets the flag «خروج مبكر».
  - There is no financial penalty in V1.
  - The kit must be returned. If it is not, the deposit is withheld in the offboarding checklist (§9.7.5).
  - A flagged captain can be rehired only with OWN's approval (§9.7.1).

#### 9.7.3 Captain list

- **Columns:**
  - name, phone, vehicle
  - status: «متصل متاح» (online, available), «مشغول» (busy), «غير متصل» (offline), «موقوف» (suspended), «محجوب لعدم تسليم النقد» (blocked for unhanded cash)
  - contract phase
  - custody (base equivalent) and limit-usage bar
  - earnings balance
  - orders today
  - acceptance rate (last 50 offers)
  - rating
- **Filters and sorting:** by any column, for example highest custody first.

#### 9.7.4 Captain profile (tabs)

- «نظرة عامة» (overview): orders, acceptance rate, cancellations, on-time rate, rating, earnings for the week and month, and online hours.
- «البيانات والمستندات» (data and documents): with document status, expiry and replacement. `captain.document_expiry_notice_days` (30) before expiry, OPS gets a task.
- «التطبيق» (app):
  - the captain's maximum pickup amount and carried currencies, set by the captain (captain-app spec §10.5)
  - the signed-in device, its app version and its last device-check result
  - the count of consecutive expired offers
- «المركبة» (vehicle).
- «العقد» (contract) (§9.7.2).
- «العدة والتأمين» (kit and deposit): items issued, deposit paid, instalments remaining, items returned.
- «العهدة» (custody): balance per currency with its base equivalent, `closed_due` (due from closed days) shown apart from today's custody (§8.5.4), the entries list, the hand-in status and any grace.
- «المستحقات» (earnings): balance, entries, and weekly statements.
- «الطلبات» (orders) and «سجل العروض» (offer log): every offer with the time, the order, the response (accepted, rejected or expired) and the response time.
- «التقييمات والشكاوى» (ratings and complaints), «المخالفات والإيقافات» (violations and suspensions), «ملاحظات» (notes) and «سجل التغييرات» (change log).

#### 9.7.5 Captain actions

| Action | Detail | Who | Reason |
|---|---|---|---|
| Suspend «إيقاف» | For a duration or until further notice. The reason is shown to the captain in the app. | OWN, OPS | Required |
| Reactivate | Ends a suspension | OWN, OPS | Required |
| Force offline «فصل من الاتصال» | Sets the captain offline immediately. With an active order, the captain enters last-order mode instead: tracking continues, and they go offline when the order ends. A suspension during an order works the same way. | OWN, OPS | Required |
| Release the device «تحرير الجهاز» | Signs out the captain's current device, so they can sign in on another phone, including during an active order (captain-app spec §4.9) | OWN, OPS | Required |
| Change the cash limit | New value, effective immediately | OWN, FIN | Required |
| Hand-in grace | Lifts the daily hand-in block until the next cutoff; the custody stays due (§8.5.4) | OWN, FIN | Required |
| Message or push | A direct notification to the captain | OWN, OPS | — |
| Record a violation | Pick the type; the system suggests the next ladder step (§9.7.6); the admin confirms; the captain sees it. The captain's «اعتراض» in the app opens a ticket, and its result is recorded on the violation. | OWN, OPS | Required |
| Terminate «إنهاء التعاقد» | Offboarding checklist (below) | OWN, OPS start it; the money steps follow the checklist | Required |

**Offboarding checklist:**

1. Kit returned (OPS).
2. Custody zero in every currency (FIN or OWN at the desk).
3. Earnings settled: by FIN in the Thursday settlement, or by OWN as an off-cycle payout on any other day.
4. Deposit refunded or withheld according to the contract (FIN or OWN).
5. Account closed. The captain can no longer go online.

#### 9.7.6 Performance and violations

- **Acceptance rate:**
  - It is calculated over the last `captain.acceptance_window_offers` (50) offers.
  - Below `captain.acceptance_alert_pct` (70%) the captain gets a warning in the app.
  - Below `captain.acceptance_review_pct` (50%) OPS gets a review task.
  - There is no automatic suspension in V1.
- **Conduct ladder:**
  1. «تنبيه» (warning)
  2. «إيقاف يوم» (1-day suspension)
  3. «إيقاف 7 أيام» (7-day suspension)
  4. «إنهاء التعاقد» (termination)

  Violations count within `captain.violation_window_days` (90). Severe violations (theft, harassment, violence) mean immediate termination. The system suggests the step and the admin decides.
- **Cancellation after acceptance:** a captain who cannot complete an accepted order presses «لا أستطيع إكمال الطلب» with a reason, which raises «كابتن لا يستطيع إكمال الطلب» (§9.1.3). The order stays with the captain until OPS reassign it (before pickup) or hand it over (after pickup) (§9.3.2). It is logged as a captain cancellation, unless OPS marks it as not the captain's fault.
- **Automatic offline:** after `captain.offer_expiry_offline_count` (3) offers in a row expire without an answer, the captain is set offline automatically (captain-app spec §7.4). Expired offers also count in the acceptance rate.

---

### 9.8 Customers «الزبائن»

- **Search:** by phone or name.
- **Customer profile:**
  - name and masked phone
  - gender, and birthday when given (customer-app spec U4)
  - addresses on a map
  - trust level (§8.8)
  - status: «نشط» (active), «موقوف حتى مراجعة الدعم» (stopped until support review), «محظور» (blocked, with the reason and dues), «مغلق» (closed)
  - orders: count, total spent, last order
  - tickets, ratings written, codes used
  - strikes (late cancellations, fake orders)
  - internal notes
  - linked closed accounts (§8.8)

**Actions:**

| Action | Detail | Who | Reason |
|---|---|---|---|
| Block «حظر» | For a duration, until further notice, or until dues of a set amount are paid | OWN, OPS | Required |
| Unblock «فك الحظر» | Manual unblock | OWN, OPS | Required |
| Record dues payment «تسجيل دفع المستحق» | Done at the cash desk with a receipt; unblocks automatically when the dues reach zero | OWN, FIN | — |
| Clear strikes or end a review stop | After a support review | OWN, OPS, SUP | Required |
| Compensation code | Amount, or % with a maximum amount; linked to one of the customer's orders and within the role's cumulative cap for that order (§6.4) | OWN, OPS, SUP | Required |
| Mark trusted or remove trust | Overrides the automatic rule (§8.8) | OWN, OPS | Required |
| Flag as an admin test account | Can see restaurants in test mode | OWN | — |
| Internal note | For example «يفضل الاتصال قبل الوصول» (prefers a call before arrival) | All with access | — |
| Close the account on request «إغلاق الحساب» | The customer can no longer sign in and the data is kept (D19, §8.8). Refused while the customer has an active order. | OWN, OPS, SUP | Required |
| Change the phone number «تغيير الرقم» | On the customer's request. The new Syrian or Turkish number must not belong to another open account. Every session ends, and the customer signs in again with the new number and a code (customer-app spec §5.4). | OWN, OPS | Required |
| Sign out every device «تسجيل الخروج من كل الأجهزة» | For example after a lost or sold phone. Active orders are not affected. | OWN, OPS, SUP | Required |

---

### 9.9 Support «الدعم»

#### 9.9.1 Ticket sources

- «الإبلاغ عن مشكلة» (report a problem) in the customer app: problem type, items concerned, note and up to 3 photos. It is available for `customer.report_problem_window_hours` (24) hours after delivery, once per order (customer-app spec §12.2).
- «أبلغ عن سعر مختلف» (report a different price) on a restaurant page in the customer app: a ticket of the type «سعر مختلف عن المحل», linked to the restaurant rather than an order, with the item, the shop price, a note and a photo, all optional (customer-app spec §9.5). Normal priority.
- The support button in the captain app, with quick reasons.
- The support button in the restaurant app, with ticket types (restaurant-app spec §15) and quick reasons on an order (restaurant-app spec §8.19).
- A pickup dispute after confirmation: the restaurant's «المبلغ غير صحيح» within `order.pickup_dispute_window_min` (10) minutes creates an urgent ticket «خلاف على دفعة الاستلام» automatically (§8.1). A captain's «مشكلة في مبلغ الاستلام» creates the same kind of ticket (captain-app spec §9.4).
- Manual tickets created by staff after a phone call or WhatsApp message «تذكرة يدوية».

#### 9.9.2 Ticket list

- **Columns:**
  - number and source
  - linked order
  - type
  - priority («عاجلة» urgent for any active order and for every pickup-dispute ticket; «عادية» normal)
  - status: «جديدة» (new), «قيد المعالجة» (in progress), «بانتظار رد» (waiting for reply), «محلولة» (resolved), «مغلقة» (closed)
  - assignee
  - SLA timer
- **SLA timers:**
  - First response for an active order: `support.first_response_active_min` (15 min).
  - Resolution after delivery: `support.resolution_post_delivery_hours` (24 h).
  - The timer turns amber at 80% (fixed) and red when it is breached.
- **Filters:** status, type, assignee, source, breached SLA.

#### 9.9.3 Ticket page

- The linked order (opens the full detail), problem type, photos and the customer's note.
- Internal handling notes and canned replies «ردود جاهزة».
- **Resolution:**
  - «كود تعويض» (compensation code): within the cap; above it, an approval request (§6.4).
  - «إعادة توصيل مجانية» (free re-delivery of missing or wrong items): creates a linked order with a customer total of 0 and the affected items.
    - Restaurant responsible: the restaurant replaces the items for free. The pickup payment is 0 and no commission is posted.
    - Captain or platform responsible: the captain pays the restaurant normally at pickup, commission is posted as usual, and the desk reimburses the captain's negative custody. The merchant net of the re-delivered items is borne by the responsible party per §8.9: captain (`earn.charge`) or platform (`platform.compensation_cost`).
    - Not available when the customer is responsible.
    - It goes to the original order's address snapshot. The customer cannot cancel or rate it, and it does not count toward the active-order limit or toward trust (§8.8).
    - The captain pay for the re-delivery goes to `platform.compensation_cost`, unless OPS charges it to the responsible restaurant or captain.
  - «لا شيء مع توضيح» (no remedy, with an explanation).
- **Responsible party** (required to resolve, except for price-difference tickets): restaurant, captain, customer or platform. The money effect follows §8.10, including the wrong-change rule, and is previewed before the ticket is resolved.
- **Pickup dispute «خلاف على دفعة الاستلام»** (resolved by OWN, OPS or FIN). The ticket shows the pickup payment, the captain's payment lines, the amount the restaurant says it received, and whether the restaurant confirmed manually or the confirmation was automatic. Resolutions:
  - «دفع الكابتن الفرق» (the captain paid the difference in person): no entries.
  - «تصحيح في الحسابات» (correct the accounts). The ticket holds the currency lines the restaurant says it actually received, and OPS may correct them.
    - **Captain:** for each currency, the difference between the lines recorded at pickup (`custody.pay_merchant`) and the received lines is posted as `custody.pickup_correction` in that currency. It is + when the captain paid less than recorded, because they still hold that cash and hand it in. It is − when they paid more, and the desk reimburses them.
    - **Restaurant:** take `D` = recorded total − received total in the base currency, converted with the order snapshot. If `D` > 0, post `merchant.credit` of `D`. If `D` < 0, post `merchant.debit` of |`D`|.
    - **Example:** the captain recorded 5 $ + 195 ₺, and the restaurant received only 195 ₺. The server posts +5 $ custody on the captain and a 206 ₺ credit to the restaurant.
    - The entries are shown in a preview first.
  - «الدفعة صحيحة» (the payment was correct): no entries; the restaurant gets the explanation.
- **Price difference «سعر مختلف عن المحل»** (from the customer app, linked to a restaurant, not an order). It needs no responsible party and gives no compensation. Resolutions:
  - «تم تصحيح السعر» (the price was corrected): OPS corrected the menu price with the restaurant (§9.6.6)
  - «السعر صحيح» (the price is correct)

  The customer gets the resolution message. The ticket follows `support.resolution_post_delivery_hours` (24) as its SLA.
- **Close:** a resolution message is sent to the customer as a notification. For restaurant and captain tickets, it is sent to the restaurant or captain instead.

> In V1, real conversations with customers happen by phone or WhatsApp outside the system, and the ticket documents them. In-app chat comes in V2.

---

### 9.10 Finance «المالية»

#### 9.10.1 Daily report «التقرير اليومي» (per business day; Excel export)

- Orders: count, GMV (customer totals), items value.
- Delivery fees; discounts split by funder (platform, restaurant); commissions earned today.
- Captain pay (base, distance, waiting, peak, bonuses); compensation costs; operating costs from outcomes; rounding and FX differences.
- **Platform margin.**
- **Cash from captains, per currency:**
  - custody created today
  - handed in today
  - reimbursed today
  - open custody at the cutoff
  - captains blocked
- **Owed by restaurants:**
  - commission and restaurant-funded discounts posted today
  - the total open restaurant balances, to be collected on Saturday
  - overdue restaurants
- Comparison with previous days.

The margin is earned when orders finish, but the cash arrives at different times: custody daily, earnings paid on Thursday, commission collected on Saturday (§8.4). The report shows both: what was earned, and what cash actually came in or went out.

#### 9.10.2 Captain balances «أرصدة الكباتن»

- **Columns:**
  - captain
  - custody per currency and base equivalent
  - `closed_due` (due from closed days, §8.5.4)
  - cash limit and usage %
  - blocked flag, and any grace
  - earnings balance
  - last hand-in
  - last payout
- Sorted by highest custody by default. «سجّل تسليماً» (record a hand-in) opens the cash desk for that captain.

#### 9.10.3 Cash desk «الصندوق»

The cash desk is used at the office counter. Every transaction gets a numbered receipt (§4.8). Receipts are printable on an 80 mm thermal printer or on A4, and appear immediately in the other party's app.

**Tabs:**

1. **«تسليم النقد اليومي»** (daily hand-in):
   1. Find the captain by name or phone.
   2. See their custody per currency, split into `closed_due` (blocks going online, §8.5.4) and today's custody, with the expected amount.
   3. Enter what is physically received per currency.
   4. Confirm.
   5. The receipt is issued.

   - If custody is negative in a currency, the desk pays it back (`custody.reimburse`).
   - **Cross-currency settlement:** if the captain holds one currency and settles in another, the desk converts at the current rate, shown on screen (`custody.fx_convert`). FIN and OWN only.
   - A difference between expected and received stays as open custody. It is not hidden.
2. **«تصفية الخميس»** (Thursday settlement):
   - Lists the captains with an earnings balance or open custody.
   - Performs the full settlement in §8.5.5 in one flow and issues the weekly statement.
   - On other days the tab is read-only, except for OWN.
3. **«تسوية المطاعم»** (restaurant settlement, Saturdays):
   - Lists every restaurant with a non-zero account balance: the week's commission, restaurant-funded discounts, exceptions and the total due. Overdue restaurants are shown first.
   - Opening a restaurant shows its weekly statement (§8.7), entry by entry.
   - Record the settlement: the amount collected from the restaurant per currency (or paid to it, if the balance is positive), the method («في المكتب» or «زيارة ميدانية» plus the staff member), and the receipt.
   - A partial payment is allowed. The rest stays on the account and counts as overdue.
   - **Field visit:**
     - If the visitor is an OWN or FIN user, they record the payment on the spot from their phone, in a field drawer session opened with a zero float. The receipt is issued and reaches the restaurant app immediately. They close the field session when they hand the cash to the office.
     - If the visitor has no FIN role, the payment is recorded when the cash reaches the desk, naming the visitor, and the receipt is issued then.
4. **«مستحقات الزبائن»** (customer dues): find the customer, see the dues, record the payment (`dues.payment`, any accepted currency at the current rate), issue a receipt and unblock automatically.
5. **«التأمينات»** (deposits): kit deposits and instalments, and refunds at termination.

**Bulk hand-in grace** (OWN): a button on the daily hand-in tab grants a grace for one business day to all captains (§8.5.4), with a reason, for example when the office was closed.

**Drawer sessions «جلسة الصندوق»:**

- Every desk user opens a drawer session with an opening float counted per currency. Every transaction belongs to the open session. A user can have one office session and one field session (§9.10.3, field visit) open at a time.
- **Close «إقفال الصندوق»:**
  - the system shows the expected cash per currency
  - the user enters the counted cash
  - any variance is recorded with a note
- A session cannot be closed while a transaction is unconfirmed.
- OWN sees all sessions and variances.

#### 9.10.4 Exchange rates «أسعار الصرف» (OWN, FIN)

- The current rate for each accepted currency, with its last update, the editor and the history.
- Edit a rate with a large-change confirmation (§8.6).
- Rounding unit and mode for each currency (D14).

#### 9.10.5 Restaurant statements «كشوف المطاعم»

For any restaurant and any period:

- orders and items value received in cash from captains (the pickup payments), with the currency lines when the restaurant accepted another currency
- commission per order
- restaurant-funded discounts
- exceptions (credits and debits) with the order and reason
- Saturday settlements with receipts
- the opening and closing balance

Exportable to Excel and printable.

#### 9.10.6 Compensation and discount costs

The cost of codes, compensations and operating costs for a period, split by reason, by code, by responsible party and by restaurant.

#### 9.10.7 Adjustments and reversals «القيود التصحيحية» (OWN, FIN)

- Post a manual entry on any ledger (custody, earnings, restaurant account, customer dues) with a reason, or reverse an existing entry. The reversal links to the original.
- A list of all manual entries: who posted it, when, why, and what it corrects.
- Nothing can be deleted.

---

### 9.11 Marketing «التسويق»

#### 9.11.1 Promo codes «أكواد الخصم»

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

#### 9.11.2 Banners «البانرات»

- Image at the recommended size, with a crop preview.
- Title.
- Click target: a restaurant, a category, a list of restaurants or a code.
- Order, start and end dates, zones.
- Preview before publishing.

#### 9.11.3 Home sections «أقسام الرئيسية»

- Drag to order the sections of the customer home screen, and show or hide each one.
- Built-in sections:
  - «البانرات» (banners) and «التصنيفات» (categories)
  - «الأقرب إليك» (nearest to you), «الأكثر طلباً» (most ordered) and «جديد على FOX DROP» (new on FOX DROP), all computed automatically
  - «العروض» (offers): restaurants with active visible codes
- **Custom sections:** a title the admin writes, for example «أفضل شاورما في أعزاز» (best shawarma in Azaz), and a hand-picked list of restaurants.

#### 9.11.4 Mass push «الإشعارات الجماعية» (no daily limit, D20)

| Field | Options |
|---|---|
| Title and text | What appears on the phone |
| Audience | All customers · a zone · no order in the last N days · registered but never ordered |
| Target | Opens a restaurant, a code or the home screen |
| Timing | Now or scheduled |

- Before sending, the panel shows the audience size and asks for confirmation.
- History lists each push with its sender, audience, and how many were sent and delivered.

---

### 9.12 Zones and pricing «المناطق والتسعير»

#### 9.12.1 Cities «المدن» (OWN)

- **Fields:**
  - name and city code (used in receipts)
  - time zone (default `Asia/Damascus`)
  - **base currency** (D25; locked after the first order)
  - accepted currencies, with their rates and rounding (§8.6)
  - business-day cutoff
  - office location (a map pin) and desk hours, shown to captains (captain-app spec C13) and to customers blocked for dues (customer-app spec Q21)
  - platform hours (`platform.hours`, default 24/7, D9)
  - status (active or not)

#### 9.12.2 Service zones «مناطق الخدمة»

- Draw polygons on the map, name each one (neighbourhood), and activate or deactivate it.
- A customer outside every active zone sees «قريباً في منطقتك» (coming soon to your area) and a vote button.
- **Votes from outside the zones** appear as dots or a heatmap, to guide expansion.

#### 9.12.3 Delivery fees «رسوم التوصيل» (OWN)

- **Rule type:**
  - «ثابت» (flat): one fee for every order.
  - «شرائح مسافة» (distance bands): for example 0–2 km = X, 2–4 km = Y, and so on.
- **Also:**
  - a minimum fee
  - an optional free-delivery threshold, compared with the items value (for example free delivery for orders of 500 or more)
  - per-restaurant overrides
- **Distance:** `pricing.distance_method` (default `road`, using the routing service, with straight-line × 1.3 (fixed) as a fallback).
- **Preview calculator:** pick a restaurant and a point on the map to see the fee the customer would pay.
- Fees are published: the customer sees the fee on the restaurant page before ordering.

#### 9.12.4 Defaults

- `merchant.default_commission_pct` (15%, OWN)
- `merchant.default_min_order`
- `merchant.default_prep_min` (20)
- `captain.custody_limit_suggested.<vehicle>`

#### 9.12.5 Captain pay «أجور الكباتن» (OWN; effective-dated)

For each vehicle type (motorbike, car, bicycle or e-bike, walking):

- base pay, which includes the first N km
- a rate per extra km
- a waiting rate per minute after `captain.waiting_threshold_min` (10)
- a minimum pay per order
- the maximum distance allowed (`dispatch.max_distance_km.<vehicle>`)

**Effective date:** any change to the pay table takes effect no earlier than 7 days after it is published, a **fixed** policy. Captains get an automatic announcement and see the new table in the app. A preview calculator shows the pay for a sample trip.

**Peak-hour bonus «مكافأة ساعة الذروة» (D15, disabled by default):**

- On/off switch, off by default.
- Windows: days of the week and hours, for example 20:00–22:00.
- Amount per delivered order inside a window, optionally limited to zones. The window is matched on the delivery time and the restaurant's zone (§8.4).
- Enabling or raising the bonus can take effect immediately. Lowering or disabling an announced bonus takes effect at the end of the current announced window.
- Captains see the active windows in the app.

#### 9.12.6 Dispatch rules (OWN; OPS can only switch the mode)

- **Mode:** `dispatch.mode`:
  - «يدوي» (manual) at launch (D6)
  - «آلي» (automatic)
  - «مختلط» (mixed): automatic, then manual after `dispatch.max_offers_before_manual` (5) failed offers or the no-captain alert
- **Eligibility:**
  - online and active
  - no active order (no stacking in V1)
  - custody under the cash limit
  - not blocked for unhanded cash, and not past `captain.remit_online_grace_hours` since a cutoff with `closed_due` still open (§8.5.4)
  - within `dispatch.search_radius_km` (3) of the restaurant
  - vehicle allowed for the trip distance
  - the order's pickup payment is not above the captain's maximum pickup amount, when the captain set one (captain-app spec C4). The capacity check below ignores this condition, so a large order is never refused only because of it.
- **Ranking:** nearest to the restaurant first; on a tie, fewest orders today.
- **Offers:** one captain at a time, for `dispatch.offer_timeout_sec` (45). Every offer and response is logged. After `captain.offer_expiry_offline_count` (3) consecutive expired offers, the captain is set offline (§9.7.6).
- **Search start:** when the remaining prep time is no more than the nearest eligible captain's ETA to the restaurant plus `dispatch.search_start_buffer_min` (5). If that is already true at acceptance, the search starts immediately. The moment is computed in every mode; in manual mode it raises «بحاجة لتعيين» instead of sending offers (§8.3).
- **Capacity check** (`dispatch.capacity_check`, on): if no eligible captain is within range when the customer places the order, the order is not accepted. The customer sees «الضغط عالٍ الآن، جرّب بعد دقائق» (busy right now, try again in a few minutes). The customer app runs this check in every quote, so the refusal is logged as lost demand once per customer checkout session (customer-app spec §10.6).

---

### 9.13 Content «المحتوى»

| Item | What the admin edits |
|---|---|
| Categories «التصنيفات» | Name, icon or image, order |
| FAQs «الأسئلة الشائعة» | Three separate sets: customer, captain, restaurant |
| Terms and privacy «الشروط والخصوصية» | One document per audience, versioned. Publishing a new version requires users to accept it again on their next app open. |
| Reason lists «قوائم الأسباب» | Restaurant rejection, restaurant problems on an order, restaurant ticket types, the optional note for an item unavailable after acceptance, captain cannot-complete reasons, captain away-from-pin reasons, collection-shortfall reasons, food after a failed order, captain ticket types, customer cancellation, ops cancellation, reassignment, customer problems, captain problems, captain suspension, customer block, and rating reasons per star count (Appendix B holds the defaults) |
| Preset order notes «الملاحظات الجاهزة» | What the customer can pick at checkout (defaults in Appendix B) |
| Customer-facing reason texts «نصوص الأسباب للزبون» | The text the customer sees for each restaurant rejection reason, ops cancellation reason, failed outcome and block reason (defaults in customer-app spec Appendix C). A reason added without a customer text shows a generic apology. |
| Notification templates «نصوص الإشعارات» | Text per event and audience, with variables such as `{اسم_الكابتن}`, `{الوقت}`, `{رقم_الطلب}`, `{السبب}` |
| Captain work rules page | The rules and pay table text shown in the captain app |
| Contact info | Support WhatsApp and phone as shown in the apps |
| Canned replies «الردود الجاهزة» | Used in tickets (SUP can edit) |

---

### 9.14 Settings «الإعدادات»

- **Grouped screens:** timers and limits, dispatch, customers, captains, restaurants, support, finance, security, apps. Every setting from Appendix A appears on its group screen with its default, current value, unit, description, and «استعادة الافتراضي» (restore default).
- **Apps «التطبيقات»:** for each of the customer, restaurant and captain apps:
  - minimum version: older versions are forced to update
  - latest version: suggest updating
  - update message
  - maintenance mode with its message, per app
- **OTP and messaging:**
  - channel for app sign-in codes: WhatsApp only in V1 (technology-stack T4, T5). SMS and voice are not offered. Codes have 6 digits in every app (fixed, customer-app spec Q4).
  - OTP validity, attempts and resend wait, and the request and sending limits (Appendix A)
  - «أرقام إرسال الرموز» (code-sending numbers, OWN): add a WhatsApp number and pair it by scanning a QR code, see its state (warming, active, standby, throttled, disconnected, banned) and its daily counts, set it active or standby, and disable it (technology-stack §8.3.3)
  - provider keys (OWN, write-only)
- Every change is audited, and settings with money impact ask for a reason.

---

### 9.15 Admin team «فريق الإدارة» (OWN)

- **User list:** name, phone, email, roles, status, TOTP enrolled, last sign-in, open sessions.
- **Actions:**
  - create (generates a setup link)
  - change roles (one or more per user, §6.1)
  - disable or enable
  - force sign-out
  - reset TOTP
- **Role matrix view:** read-only in V1 (§6), with the compensation cap per role editable.

---

### 9.16 Audit log «سجل التدقيق» (OWN)

- **Each event records:**
  - time and actor (user, role)
  - action, target type and ID
  - values before and after (as a diff)
  - reason
  - IP address and device
- **Sensitive views are events too:** phone reveals, exports containing phone numbers, and document file views.
- **Filters:** actor, action type, target (order, restaurant, captain, customer, setting), date range.
- **Immutable:** nobody can edit or delete the log, including OWN. This is enforced at the database level (append-only table, no update or delete grants).

---

### 9.17 Reports «التقارير» (all exportable to Excel)

| Report | Content |
|---|---|
| Orders | By day, hour, zone and restaurant; success rate; cancellations and rejections by reason and party; outcomes |
| Timings | Average restaurant acceptance time; actual prep time compared with the chosen time; time to find a captain; captain wait at the restaurant; delivery leg; total time; late rate |
| Restaurants | Ranking by orders, sales, acceptance, rejections, late rate, rating, unanswered orders, pause minutes |
| Captains | Orders, acceptance, cancellations, on-time rate, earnings, online hours, cash hand-in punctuality |
| Customers | New, returning, repeat rate, top customers, blocked customers; split by gender and age band where known (customer-app spec U4) |
| Lost demand | Outside-zone votes, searches with no results, suggested restaurants, orders blocked by the capacity check, attempts during an emergency stop |
| Codes | Use, cost and new customers per code |
| Finance | Daily and period summaries, cash per currency, rounding and FX, compensation costs |

---

## 10. What the panel pushes to the apps

| Panel action | Customer | Restaurant | Captain |
|---|---|---|---|
| Accept or reject on behalf | Status and time, or the reason plus alternatives | «قبلت العمليات الطلب» / «رفضت العمليات الطلب» | — |
| Edit the order | New total | «تم تعديل الطلب» (sound; acknowledgement needed when items are added) | New amounts to pay and to collect |
| Change the time | New ETA | New prep time (if changed) | — |
| Cancel | Reason | «أوقف التحضير» (stop preparing) | «أُلغيت المهمة» (task cancelled) |
| Outcome set or changed | Result; if blocked, the dues and how to pay them | Commission or return of the pickup payment, when it applies | Reimbursement due at the desk, pay or charge |
| Hand over after pickup | «تغيّر الكابتن: {الاسم} يكمل توصيل طلبك» | — | First captain: «سُلّم الطلب لكابتن آخر». Second captain: the task. |
| Customer blocked, unblocked or account closed | Status with the reason | — | — |
| Ticket resolved | Resolution message | Debit, when the restaurant is responsible | Charge, when the captain is responsible |
| Assign or reassign | Captain name and photo | Captain and ETA | Offer or assignment / «سُحب الطلب» (order withdrawn) |
| Compensation | The code and its message | — | — |
| Emergency stop on or off | Message, or a delay notice for active orders / service back | Banner | Banner |
| Menu price change by admin | — | Change notice (D17) | — |
| Menu change request approved or rejected | — | Decision, with the reason when rejected | — |
| Pickup confirmed on the restaurant's behalf | — | «أكّدت العمليات استلام الكابتن للطلب» | Pickup complete |
| Captain's arrival recorded by OPS | — | «وصل الكابتن» | Arrival recorded; pickup can start |
| Captain set offline after expired offers | — | — | «لم ترد على 3 عروض متتالية، فأصبحت غير متصل» |
| Item-unavailable report closed | — | The report is closed, with the reason | Pickup allowed again |
| Commission change (D16) | — | New rate and its start date | — |
| Restaurant pause, suspend or resume; busy mode ended | Restaurant state | State with the reason | — |
| Captain suspend, force offline, limit change, grace | — | — | State with the reason |
| Cash-desk receipt | Dues receipt | Settlement receipt | Hand-in, reimbursement, payout, deposit |
| Weekly statement generated | — | Restaurant statement before Saturday: commission, discounts, exceptions, total due | Captain statement on Thursday: orders, pay breakdown, deductions, net paid |
| Restaurant overdue on settlement | — | Reminder of the amount due | — |
| Pay table change or peak bonus | — | — | Announcement and new table |
| Application stage change | — | — | Stage, missing documents, interview time, rejection reason |
| Contract phase change | — | — | New phase and its dates |
| Terms version published | Re-accept on next open | Re-accept | Re-accept |
| Force update or maintenance | Update or maintenance screen | Same | Same |

---

## 11. Operating rhythm

- **Start of each shift:**
  - check the dashboard
  - confirm restaurants are open and captains are coming online
  - check for captains blocked for unhanded cash
  - review new applications and tasks
- **During the shift:**
  - the dispatcher watches the operations room and alerts
  - acknowledge every critical alert, call, act, and leave a note on the order
- **Every business day:**
  - captains hand in custody at the desk
  - the desk closes its drawer session and matches counted cash
  - the owner reads the daily report
- **Thursday:** full captain settlement and payouts, and weekly statements issued.
- **Saturday:** restaurant settlements: each restaurant pays the week's commission, restaurant-funded discounts and exceptions, at the office or during a staff visit. On Monday, follow up with any restaurant that is still overdue.
- **Weekly:**
  - review violations and acceptance-rate tasks
  - review lost demand and zone votes
  - plan codes and banners
  - update exchange rates as often as the market requires (the stale-rate alert fires after 24 h)

---

## 12. Not in the V1 admin panel

| Feature | Version |
|---|---|
| In-panel chat with customers and captains | V2 |
| A full automatic penalties engine (V1 suggests and a person decides) | V2 |
| Custom roles in the UI | V2 |
| English UI | V2 |
| Central catalogue for supermarkets, errands pricing, order stacking | V3 |
| Advanced campaigns with ROI, loyalty, referral, captain incentive programmes beyond the peak bonus | V4 |
| Electronic payments, wallet, refunds reconciliation | V5 |
| Smart dispatch, demand forecasting, multi-city coordinators | V6 |

---

## 13. Open items (these do not block the build)

1. **Early exit from a captain's contract.** *Decided* (captain-app spec C17): no financial penalty in V1, the kit is returned or the deposit is withheld, and rehiring needs OWN's approval (§9.7.2).
2. **A restaurant that does not pay on Saturday.** With D26 the platform collects commission from restaurants after the fact, so a restaurant can fall behind. The panel raises the overdue alert (§8.7) and leaves the action to OWN. Still to decide: should the restaurant be paused automatically after a number of days, or above a maximum unpaid amount?
3. **Captain cash at pickup.** *Decided* (captain-app spec C4): each captain sets the most they can pay a restaurant, and dispatch does not offer them larger orders (§9.12.6). Operations should still brief captains on carrying enough cash.
4. **Azaz base currency.** Chosen when the city is created (D25). Verify on the ground which currency restaurants price in.
5. **Values to enter before launch:**
   - default commission and launch commission (proposed 15%, and 10% for the first 20 restaurants for 3 months)
   - the delivery fee table
   - captain pay tables
   - suggested cash limits per vehicle
   - the late-delivery compensation value
   - the fake-order dues rule (proposed: delivery fee + merchant net)
   - rounding units
   - minimum order
6. **Data retention after account closure (D19).** App store rules expect personal data to be deleted when a user deletes their account, unless retention is needed for fraud prevention, security or legal and financial records. Before submitting to the stores, check that keeping all data is acceptable. If not, keep only what fraud prevention and financial records need (phone, device, orders, ledgers, blocks), and say so in the privacy policy.
7. **Document validity.** *Decided* (captain-app spec C18): the criminal record certificate is valid for 12 months from its issue date, with the usual 30-day expiry task.
8. **Distance service.** *Decided* (technology-stack §7.1, 2026-11-04): self-hosted OSRM with OpenStreetMap data for Syria. The straight-line fallback stays for when OSRM does not answer.
9. **Tax.** V1 has no tax line. If local rules require one, it will be added to the order money (§8.4) as its own line.

---

## 14. Definition of done (V1 admin panel)

The panel is complete when all of the following can be demonstrated on a staging environment:

1. Sign-in requires a password and TOTP. Lockout, session expiry, force sign-out and TOTP reset work.
2. Each role sees only its modules and actions, and the server rejects forbidden calls made directly to the API. A user with two roles (for example OPS + FIN) gets the union of both.
3. The dashboard shows live tiles and every alert in §9.1.3 fires on its trigger, reaches only its recipient roles, plays its sound (critical alerts repeat until acknowledged), can be acknowledged and resolves itself.
4. The emergency stop blocks new orders, sends the delay notice to every active-order customer, shows banners in all apps, and resumes cleanly.
5. The operations board updates in real time, SLA colours change at the right moments, and filters work.
6. Every order action in §9.3.2 works in the allowed statuses only, with reasons, previews, notifications and timeline events, including the post-pickup handover.
7. Order edits follow §9.3.3, including adding items to a `ready` order (back to `accepted`), the edit acknowledgement alert, and post-pickup removals with a responsible party. The pickup payment and `picked_up` happen as one action when the restaurant confirms, when the 60-second automatic confirmation fires, or when OPS confirms on the restaurant's behalf (§8.1).
8. Outcomes post exactly the entries their preview showed, for each responsible party (§8.9). OWN can change an outcome within 7 days, and every side effect is reversed.
9. Dispatch works in all three modes: manual («بحاجة لتعيين» at the search-start moment), automatic (eligibility, ranking, one offer at a time, 45 s timeout) and mixed (falls back to manual after 5 failed offers). The capacity check refuses orders with no eligible captain.
10. Tickets follow §9.9 and §8.10: SLA timers, every resolution type, the free re-delivery order, and the money effect for each responsible party.
11. Restaurant auto-pause triggers after 3 unanswered orders in a business day.
12. The live map shows zones, restaurants, captains and orders, and manual assignment from the map works.
13. The restaurant wizard enforces the activation checklist. Test mode hides the restaurant from normal customers, and test orders are excluded from KPIs.
14. The menu editor supports option groups, bulk price change with preview, Excel import with validation and dry run, and the price log. Every admin price change notifies the restaurant.
15. Commission changes are OWN-only and affect new orders only.
16. The captain pipeline enforces every required document, the contract, kit, deposit and cash limit before activation. Duplicate detection warns.
17. Probation and document-expiry tasks appear on time.
18. Custody is tracked per currency. The daily hand-in rule blocks going online exactly as in §8.5.4, and grace works.
19. Thursday settlement settles custody, posts instalments, pays earnings and issues the weekly statement. Off-cycle payouts need OWN.
20. The captain pays the full items value at pickup. Commission and restaurant-funded discounts accrue on the restaurant account. The weekly statement appears in the restaurant app before Saturday. The Saturday settlement works at the office or by visit, accepts partial payments, issues receipts in the restaurant app, and raises the overdue alert on time.
21. Cash-desk receipts are numbered without gaps, are printable and appear in the other party's app. Drawer sessions open and close with variance.
22. Exchange rates are versioned. Orders keep their snapshot. Customer equivalents and door payments in USD, TRY and SYP convert and round correctly. Shortfalls raise alerts.
23. Customer trust, strikes, the fake-order block and dues, and account closure with re-registration linking behave as in §8.8.
24. Compensation caps per role work, and above-cap requests go through OWN approval.
25. Promo codes enforce every field in §9.11.1, including the new-user once-per-phone-and-device rule and the daily budget cap.
26. Mass push sends to each audience type, now or scheduled, and shows the audience size first.
27. Zones, delivery fees (flat and bands) and captain pay tables (effective-dated) have working preview calculators. The peak bonus is off by default and pays correctly when on.
28. Every setting in Appendix A is editable by the right roles and audited.
29. The audit log records every write and sensitive view and cannot be modified.
30. Every report in §9.17 renders and exports to Excel with Arabic headers.
31. Restaurant-app integration:
    - The new alerts fire on their triggers: «صنف نفد بعد القبول», «خلاف على مبلغ الاستلام», «مطعم مفتوح بلا جهاز استقبال» and «تغيير أسعار كبير».
    - Pickup disputes resolve through tickets with the correct per-currency entries.
    - Cancelling or reassigning after a pickup request asks the cash question and posts the entries when the cash was not returned.
    - Removing items after pickup never cuts the commission twice.
    - Menu change requests can be approved or rejected.
    - The busy state and busy mode show correctly.
    - Restaurant users' actions appear in timelines and change logs with the user and device.
32. Captain-app integration:
    - The alerts «كابتن لا يستطيع إكمال الطلب», «طوارئ كابتن» and «تسليم بعيد عن العنوان» fire on their triggers.
    - Dispatch respects the maximum pickup amount, with the manual override.
    - Three expired offers in a row set a captain offline.
    - «تسجيل وصول الكابتن» works.
    - «تحديد النتيجة» with an amount to collect waits for the captain's payment lines, or for OPS to enter them, and posts from the recorded net.
    - The handover leg works from `picked_up` and `arrived`.
    - «تسجيل التسليم نيابة عن الكابتن» and «تحرير الجهاز» work.
    - The cash question appears after the captain reached the restaurant.
    - Failed orders record where the food went.
    - Re-application and the early-exit approval work.
33. Customer-app integration:
    - The delivery estimate and the promised time follow §8.3, and late alerts count from the promised time.
    - The order detail shows the pay-in currency and the recipient of an order for someone else.
    - Customer problem reports respect the 24-hour window and one report per order. Price reports «سعر مختلف عن المحل» arrive as restaurant-linked tickets.
    - The customer profile shows gender and birthday, and the customers report splits by them.
    - Sign-in codes have 6 digits in every app.
    - Discounts never take the customer total below 0. Code uses come back when an order is rejected, cancelled, or failed without the customer at fault.
    - The quote's exchange rates become the order's snapshot, and a changed rate refuses the order.
    - Account closure is refused while an order is active. «تغيير الرقم» and «تسجيل الخروج من كل الأجهزة» work.
    - Wrong-change tickets and price-difference tickets resolve as in §8.10 and §9.9.3.

---

## Appendix A. Settings catalogue

Scope: **G** global, **C** per city. "Before launch" means the owner enters the value before going live.

| Key | Default | Scope | Edit | Description |
|---|---|---|---|---|
| `platform.hours` | 24/7 | C | OWN | Platform operating schedule (D9) |
| `platform.emergency_default_message_browse` | «نعتذر، توقفنا مؤقتاً عن استقبال الطلبات. نعود قريباً.» | C | OWN | Default emergency message for browsing customers |
| `platform.emergency_default_message_active` | «قد يتأخر طلبك قليلاً بسبب {السبب}. نعتذر عن الانتظار.» | C | OWN | Default delay notice for active orders |
| `order.merchant_accept_alert_min` | 3 | C | OWN | Restaurant acceptance alert |
| `order.merchant_auto_cancel_min` | 7 | C | OWN | Auto-cancel for no response |
| `order.prep_late_ops_alert_min` | 10 | C | OWN | Prep-late alert to ops, after the chosen time |
| `order.delivery_late_alert_min` | 20 | C | OWN | Late-delivery alert after the promised time |
| `order.delivery_late_compensation_min` | 45 | C | OWN | Automatic compensation after the promised time |
| `order.late_compensation_value` | Before launch | C | OWN | Value of the automatic late code (amount or %) |
| `order.outcome_change_days` | 7 | C | OWN | Days during which OWN can change an outcome (§8.9) |
| `order.pickup_confirm_timeout_sec` | 60 | C | OWN | Seconds before a pickup request is confirmed automatically (§8.1) |
| `order.pickup_dispute_window_min` | 10 | C | OWN | Minutes after pickup during which the restaurant can dispute the amount |
| `order.eta_buffer_min` | 10 | C | OWN | Minutes added to prep and trip time in the delivery estimate and the promised time (§8.3) |
| `order.eta_speed_kmh` | 20 | C | OWN | Average speed that turns the trip distance into minutes (§8.3) |
| `merchant.auto_pause_unanswered_count` | 3 | C | OWN | Unanswered orders per business day before auto-pause |
| `merchant.settlement_weekday` | Saturday | C | OWN | Restaurant account settlement day (D13, D26) |
| `merchant.settlement_overdue_days` | 2 | C | OWN | Days after the settlement day before the overdue alert |
| `merchant.default_commission_pct` | 15 | C | OWN | Prefill for new restaurants |
| `merchant.default_prep_min` | 20 | C | OWN | Prefill for new restaurants |
| `merchant.default_min_order` | Before launch | C | OWN | Prefill for new restaurants |
| `merchant.prep_time_options` | 10, 15, 20, 30, 45 | C | OWN | Prep-time choices in the restaurant app (minutes) |
| `merchant.prep_time_step_min` | 5 | C | OWN | Step of the prep-time «−» and «+» buttons |
| `merchant.prep_time_floor_min` | 5 | C | OWN | Shortest prep time a restaurant can choose |
| `merchant.prep_time_ceiling_min` | 90 | C | OWN | Longest prep time a restaurant can choose |
| `merchant.busy_extra_options_min` | 10, 20 | C | OWN | Minutes a restaurant's busy mode can add |
| `merchant.busy_mode_reminder_min` | 60 | C | OWN | Reminder interval while busy mode is on |
| `merchant.no_device_alert_min` | 5 | C | OWN | Minutes an open restaurant may have no receiving device before the alert |
| `merchant.price_change_alert_pct` | 30 | C | OWN | Restaurant price change that raises «تغيير أسعار كبير» |
| `merchant.web_session_days` | 30 | G | OWN | Restaurant owner portal session length |
| `dispatch.mode` | manual | C | OWN, OPS | manual · auto · mixed (D6) |
| `dispatch.offer_timeout_sec` | 45 | C | OWN | Offer duration |
| `dispatch.search_radius_km` | 3 | C | OWN | Eligibility radius around the restaurant |
| `dispatch.ranking` | nearest_then_fewest_today | C | OWN | Ranking rule |
| `dispatch.max_offers_before_manual` | 5 | C | OWN | Mixed mode: failed offers before manual |
| `dispatch.no_captain_alert_min` | 5 | C | OWN | Alert after the search-start moment, in every dispatch mode |
| `dispatch.no_captain_after_ready_min` | 15 | C | OWN | Alert after ready, still unassigned |
| `dispatch.search_start_buffer_min` | 5 | C | OWN | Buffer added to the captain ETA for search start |
| `dispatch.manual_assign_requires_accept` | true | C | OWN | Manual assignment is sent as an offer |
| `dispatch.capacity_check` | true | C | OWN | Refuse orders with no eligible captain nearby |
| `dispatch.max_distance_km.walking` | 1.5 | C | OWN | Max trip distance |
| `dispatch.max_distance_km.bicycle` | 4 | C | OWN | Max trip distance (bicycle and e-bike) |
| `dispatch.max_distance_km.motorbike` | 10 | C | OWN | Max trip distance |
| `dispatch.max_distance_km.car` | 15 | C | OWN | Max trip distance |
| `pricing.distance_method` | road | G | OWN | road (routing service) · straight-line × 1.3 fallback |
| `captain.waiting_threshold_min` | 10 | C | OWN | Waiting pay start and ops alert |
| `captain.custody_warn_pct` | 80 | C | OWN | Cash-limit warning threshold |
| `captain.custody_limit_suggested.<vehicle>` | Before launch | C | OWN | Prefill only (D10) |
| `captain.remit_tolerance` | 0 | C | OWN | Allowed `closed_due` before blocking (base currency, §8.5.4) |
| `captain.remit_online_grace_hours` | 4 | C | OWN | Hours a captain online across the cutoff keeps getting offers while `closed_due` is open |
| `captain.payout_weekday` | Thursday | C | OWN | Weekly settlement day (D12) |
| `captain.negative_earnings_policy` | carry_forward | C | OWN | carry_forward · collect_at_desk |
| `captain.acceptance_window_offers` | 50 | C | OWN | Window for the acceptance rate |
| `captain.acceptance_alert_pct` | 70 | C | OWN | Warning to the captain below this |
| `captain.acceptance_review_pct` | 50 | C | OWN | Ops review task below this |
| `captain.probation_days` | 30 | C | OWN | Probation length (D24) |
| `captain.min_commitment_months` | 3 | C | OWN | Commitment after probation (D24) |
| `captain.probation_review_notice_days` | 3 | C | OWN | Task before probation ends |
| `captain.document_expiry_notice_days` | 30 | C | OWN | Task before a document expires |
| `captain.violation_window_days` | 90 | C | OWN | Window for the conduct ladder |
| `captain.min_age` | 18 | G | OWN | Minimum applicant age |
| `captain.gps_stale_alert_min` | 2 | C | OWN | No GPS during an active order |
| `captain.offer_expiry_offline_count` | 3 | C | OWN | Consecutive expired offers that set a captain offline (captain-app C3) |
| `captain.merchant_arrival_radius_m` | 150 | C | OWN | Distance from the restaurant within which the captain can confirm arrival (captain-app C6) |
| `captain.customer_radius_m` | 200 | C | OWN | Distance from the customer's pin within which arrival and delivery need no reason (captain-app C9) |
| `captain.criminal_record_validity_months` | 12 | C | OWN | Validity of the criminal record certificate from its issue date (captain-app C18) |
| `customer.no_answer_pings` | 3 | C | OWN | App pings to a customer who does not answer |
| `customer.no_answer_ping_interval_min` | 5 | C | OWN | Interval between pings |
| `customer.new_max_active_orders` | 1 | C | OWN | Active orders for a new account (D23) |
| `customer.trusted_after_delivered_orders` | 3 | C | OWN | Delivered orders to become trusted (D23) |
| `customer.trusted_max_active_orders` | 3 | C | OWN | Active orders for a trusted account |
| `customer.late_cancel_strikes` | 2 | C | OWN | Strikes before a review stop |
| `customer.late_cancel_window_days` | 30 | C | OWN | Strike window |
| `customer.fake_order_dues_rule` | fee_plus_merchant_net | C | OWN | Dues after a fake order: fee_plus_merchant_net · fee_plus_items_value · fixed |
| `customer.fake_order_dues_fixed` | — | C | OWN | Amount used when the rule is `fixed` |
| `customer.phone_default_country` | Before launch | C | OWN | Country preselected on the customer sign-in screen: SY or TR (customer-app U3) |
| `customer.far_pin_warn_m` | 1000 | C | OWN | Pin-to-device distance above which the customer app asks to confirm the address (customer-app U5) |
| `customer.rating_window_days` | 3 | C | OWN | Days after delivery during which an order can be rated (customer-app U15) |
| `customer.report_problem_window_hours` | 24 | C | OWN | Hours after delivery during which a customer can report a problem in the app (customer-app U16) |
| `otp.validity_min` | 5 | G | OWN | App sign-in code validity |
| `otp.max_attempts` | 5 | G | OWN | Attempts per code |
| `otp.resend_after_sec` | 60 | G | OWN | Resend wait |
| `otp.channel_order` | whatsapp | G | OWN | Channel priority for app OTP. WhatsApp is the only channel in V1; sms and voice are reserved for later (technology-stack T5) |
| `otp.number_hourly_max` | 3 | G | OWN | Codes per phone number per hour |
| `otp.number_daily_max` | 6 | G | OWN | Codes per phone number per day |
| `otp.device_daily_max` | 6 | G | OWN | Codes per device per day |
| `otp.ip_hourly_max` | 30 | G | OWN | Code requests per IP address per hour |
| `otp.sender_per_minute_max` | 12 | G | OWN | Messages per WhatsApp sending number per minute |
| `otp.sender_daily_max` | 1500 | G | OWN | Messages per WhatsApp sending number per day |
| `otp.send_jitter_sec` | 1–4 | G | OWN | Random delay between two sends from the same number |
| `otp.sender_warmup_caps` | 50, 100, 200, 400, 800, full | G | OWN | Daily caps for a new sending number during its warm-up, one step every 2–3 days |
| `support.first_response_active_min` | 15 | C | OWN | SLA for active-order tickets |
| `support.resolution_post_delivery_hours` | 24 | C | OWN | SLA after delivery |
| `support.compensation_cap_pct.SUP` | 30 | C | OWN | Cap without approval (D4) |
| `support.compensation_cap_pct.OPS` | 30 | C | OWN | Cap without approval |
| `finance.business_day_cutoff` | 06:00 | C | OWN | Start of the business day |
| `fx.stale_alert_hours` | 24 | C | OWN | Stale-rate alert |
| `fx.large_change_confirm_pct` | 10 | C | OWN | Second confirmation for large rate changes |
| `currency.<code>.rounding_unit` | Before launch | C | OWN, FIN | Rounding unit per currency (D14) |
| `currency.<code>.rounding_mode` | nearest | C | OWN, FIN | nearest · up · down (D14) |
| `push.daily_limit` | none | C | OWN | Mass-push limit (D20: none) |
| `admin.password_min_length` | 10 | G | OWN | Panel password length |
| `admin.login_max_attempts` | 5 | G | OWN | Failures before lockout |
| `admin.lockout_min` | 15 | G | OWN | Lockout duration |
| `admin.session_idle_min` | 30 | G | OWN | Idle timeout |
| `admin.session_max_hours` | 12 | G | OWN | Absolute session length |
| `app.<customer\|merchant\|captain>.min_version` | — | G | OWN | Force update below this |
| `app.<customer\|merchant\|captain>.latest_version` | — | G | OWN | Suggest update below this |
| `app.<customer\|merchant\|captain>.update_message` | — | G | OWN | Update screen text |
| `app.<customer\|merchant\|captain>.maintenance` | false | G | OWN | Maintenance mode and message |

Pricing data (delivery fee rules, captain pay tables, peak bonus windows) and exchange rates are managed in their own screens (§9.12, §9.10.4), not as plain settings.

---

## Appendix B. Default reason lists (editable in Content)

| List | Default reasons |
|---|---|
| Restaurant rejection | «صنف غير متوفر» (marks the items unavailable) · «المطعم مغلق» (also pauses the restaurant until it reopens) · «ضغط طلبات». There is no free-text reason (restaurant-app R3). |
| Restaurant problem on an order | «الكابتن تأخر» · «سلوك الكابتن» · «مشكلة في مبلغ الاستلام» · «مشكلة في الطلب» · «أخرى» |
| Item unavailable after acceptance (optional note) | «يوجد بديل مشابه» · «الكمية غير كافية» |
| Restaurant ticket types | «مشكلة في طلب» · «استفسار مالي» · «طلب تعديل بيانات» · «مشكلة في التطبيق» · «أخرى» |
| Captain cannot complete the order | «عطل في المركبة» · «حادث» · «ظرف طارئ» · «لا أملك المبلغ المطلوب للمطعم» · «أخرى» (text) |
| Captain arrival or delivery away from the pin | «الزبون طلب مكاناً آخر» · «موقع الزبون على الخريطة غير دقيق» · «أخرى» (text) |
| Collected less than due | «الزبون لا يملك المبلغ كاملاً» · «خطأ في العد» · «أخرى» (text) |
| Food after a failed order | «يبقى مع الكابتن» · «أُعيد إلى المطعم» · «أُتلف» |
| Captain ticket types | «مشكلة في طلب» · «مشكلة في العهدة أو الأرباح» · «طلب تعديل بيانات» · «إنهاء التعاقد» · «تبديل العدة» · «مشكلة في التطبيق» · «أخرى» |
| Customer self-cancel | «غيّرت رأيي» · «طلبت بالخطأ» · «العنوان خاطئ» · «سبب آخر» |
| Ops cancellation | «طلب الزبون» · «المطعم لم يستجب» · «المطعم أغلق» · «صنف نفد» · «لا يوجد كابتن» · «العنوان خارج المنطقة» · «ظرف طارئ» · «سبب آخر» |
| Reassignment | «عطل في المركبة» · «حادث» · «طلب الكابتن» · «تأخر الكابتن» · «انقطاع الاتصال» · «سبب آخر» (each with a fault yes/no) |
| Customer problem | «صنف ناقص» · «صنف خطأ» · «الطعام بارد» · «الطلب تالف» · «تأخير» · «سلوك الكابتن» · «مشكلة في المبلغ أو الباقي» · «أخرى» |
| Restaurant rating reasons (customer-app spec §12.1) | 1–2 stars: «الطعام بارد» · «الطعم غير جيد» · «صنف ناقص أو خطأ» · «الكمية قليلة» · «التغليف سيئ». 3 stars: «جيد لكن يمكن أفضل» · «الكمية قليلة» · «التغليف يحتاج تحسيناً». 4–5 stars: «طعم رائع» · «حار وطازج» · «كمية جيدة» · «تغليف ممتاز» |
| Captain rating reasons (customer-app spec §12.1) | 1–2 stars: «تأخر» · «سلوك غير لائق» · «لم يتصل عند الوصول» · «الطلب وصل تالفاً». 3 stars: «تأخر قليلاً» · «يحتاج لطفاً أكثر». 4–5 stars: «لطيف» · «سريع» · «حافظ على الطلب» · «ملتزم بالتعليمات» |
| Preset order notes | «اتصل بي عند الوصول» · «لا تطرق الباب» · «أرسلوا أدوات طعام» · «لا أحتاج أدوات طعام» |
| Captain problem | «المطعم متأخر» · «صنف ناقص» · «مشكلة في مبلغ الاستلام» (opens a pickup-dispute ticket) · «العنوان خاطئ» · «الزبون لا يرد» · «حادث أو طارئ» · «أخرى» |
| Captain suspension | «مخالفة سلوك» · «شكاوى متكررة» · «نسبة قبول منخفضة» · «مستند منتهي» · «طلب الكابتن» · «أخرى» |
| Customer block | «طلب وهمي» · «إساءة» · «احتيال على الأكواد» · «أخرى» |
| Emergency stop | «أحوال جوية» · «انقطاع كهرباء أو إنترنت» · «ظرف أمني» · «عطل تقني» · «أخرى» |

---

## Appendix C. Arabic labels for statuses and outcomes

| Code | Arabic |
|---|---|
| Order: `placed` / `accepted` / `ready` / `picked_up` / `arrived` / `delivered` / `rejected` / `cancelled` / `failed` | «بانتظار المطعم» / «قيد التحضير» / «جاهز» / «مع الكابتن» / «الكابتن وصل» / «تم التسليم» / «مرفوض» / «ملغى» / «فشل التسليم» |
| Outcome: `normal` / `free` / `fake` / `damaged` / `wrong_refused` / `failed_other` | «عادي» / «مجاني» / «وهمي» / «تالف» / «خطأ ورفضه الزبون» / «تعذّر التسليم» |
| Responsible party: restaurant / captain / customer / platform | «المطعم» / «الكابتن» / «الزبون» / «المنصة» |
| Restaurant account: `draft` / `test` / `active` / `suspended` / `terminated` | «مسودة» / «تجريبي» / «فعّال» / «معلّق» / «منتهي» |
| Restaurant operating state: `open` / `busy` / `paused` / `closed`, and the busy-mode flag | «مفتوح» / «مشغول» / «موقوف مؤقتاً» / «مغلق», and «وضع الضغط» |
| Restaurant roles: owner / cashier | «مالك» / «كاشير» |
| Captain status: online-available / busy / offline / suspended / cash-blocked | «متصل متاح» / «مشغول» / «غير متصل» / «موقوف» / «محجوب لعدم تسليم النقد» |
| Captain contract: probation / commitment / open-ended | «فترة تجربة» / «فترة التزام» / «مفتوح» |
| Customer: active / review stop / blocked / closed / trusted | «نشط» / «موقوف حتى مراجعة الدعم» / «محظور» / «مغلق» / «موثوق» |
| Ticket: new / in progress / waiting / resolved / closed | «جديدة» / «قيد المعالجة» / «بانتظار رد» / «محلولة» / «مغلقة» |
| Alert severity: critical / warning / information | «حرج» / «تحذير» / «معلومة» |
