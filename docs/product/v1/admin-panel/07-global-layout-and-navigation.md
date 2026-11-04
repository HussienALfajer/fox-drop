# 7. Global layout and navigation

> Part of the [admin panel spec](README.md) (AP). A bare "§n" here means AP §n.

## 7.1 Main navigation (right-side sidebar, RTL)

| #   | Module            | Arabic label       | Section  |
| --- | ----------------- | ------------------ | -------- |
| 1   | Dashboard         | «لوحة التحكم»      | §9.1     |
| 2   | Operations room   | «غرفة العمليات»    | §9.2–9.3 |
| 3   | Live map          | «الخريطة الحية»    | §9.4     |
| 4   | Order history     | «سجل الطلبات»      | §9.5     |
| 5   | Restaurants       | «المطاعم»          | §9.6     |
| 6   | Captains          | «الكباتن»          | §9.7     |
| 7   | Customers         | «الزبائن»          | §9.8     |
| 8   | Support           | «الدعم»            | §9.9     |
| 9   | Finance           | «المالية»          | §9.10    |
| 10  | Marketing         | «التسويق»          | §9.11    |
| 11  | Zones and pricing | «المناطق والتسعير» | §9.12    |
| 12  | Content           | «المحتوى»          | §9.13    |
| 13  | Settings          | «الإعدادات»        | §9.14    |
| 14  | Admin team        | «فريق الإدارة»     | §9.15    |
| 15  | Audit log         | «سجل التدقيق»      | §9.16    |
| 16  | Reports           | «التقارير»         | §9.17    |

Each user sees only the modules their roles allow.

## 7.2 Top bar

- City selector.
- **Platform status:** «المنصة تعمل» (platform running, green) or «إيقاف طارئ» (emergency stop, red, flashing).
- Dispatch mode: «يدوي» (manual), «آلي» (automatic) or «مختلط» (mixed).
- Global search by order number, restaurant name, captain name or phone, ticket number, or customer phone. Searching by customer phone is available to OWN, OPS and SUP only, the same rule as order history (§9.5), and results show masked numbers until revealed.
- Alerts bell with a count of open alerts.
- Approvals badge (OWN).
- User menu: profile, sessions, sign out.

## 7.3 Alerts system

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

## 7.4 Common UI patterns

- Tables have filters, sorting, a search box, pagination and, where noted, Excel export (XLSX with Arabic headers).
- Detail pages have tabs. Side drawers give quick views from tables.
- Every destructive or financial action opens a confirmation dialog with:
  - the reason field
  - the money-effect preview, when ledgers are affected
  - the list of who will be notified
- Empty states explain what to do, for example «لا توجد طلبات حية الآن».
- Each form field shows its validation error next to the field.

## 7.5 Devices

- Desktop and laptop are the primary devices: everything MUST work there.
- Tablet: everything SHOULD work.
- Phone: the dashboard, operations room, order detail, live map, alerts and tickets MUST be usable for monitoring and simple actions. The cash desk's restaurant settlement MUST also work on a phone, for field visits (§9.10.3).
