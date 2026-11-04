# 6. Navigation

> Part of the [captain app spec](README.md) (CA). A bare "§n" here means CA §n.

## 6.1 Screen map

| # | Screen | Arabic | Section |
|---|---|---|---|
| 1 | Home | «الرئيسية» | §7 |
| 2 | Offer | «عرض» (full screen) | §8 |
| 3 | Active order | «الطلب الجاري» | §9 |
| 4 | Earnings | «أرباحي» | §10.6 |
| 5 | Custody | «عهدتي» | §10.2 |
| 6 | Performance | «أدائي» | §11 |
| 7 | Profile | «ملفي» | §12 |
| 8 | History | «السجل» | §9.13 |
| 9 | Support | «الدعم» | §13 |
| 10 | Settings | «الإعدادات» | §10.5, §4.5 |

## 6.2 Layout

- **Bottom navigation:** «الرئيسية» · «أرباحي» · «عهدتي» · «المزيد». «المزيد» holds the other screens.
- **Active order:** while an order is active, the home screen shows it as a large card, and a bar on every screen returns to it.
- **Touch targets:** at least 48 dp. The main button of each order step is full width and at least 64 dp tall.
- **Sunlight:** high-contrast colours and text that is readable outdoors. A dark theme is V2.

## 6.3 Banners (highest priority first)

1. No connection (red, §4.6)
2. Platform emergency stop (red): «المنصة متوقفة مؤقتاً عن استقبال طلبات جديدة. أكملوا الطلبات الحالية.» (AP §9.1.6)
3. A block on going online, with its reason (red, §7.2)
4. Device check failed (yellow, §4.5)
5. Cash limit at 80% or more (amber, §10.4)
6. A document expiring within 30 days (amber, §12.2)
7. An operations announcement, for example «نحتاج كباتن الآن في حي الشهداء» (blue)
8. App update available (grey)
