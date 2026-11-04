# 6. Navigation

> Part of the [restaurant app spec](README.md) (RA). A bare "§n" here means RA §n.

## 6.1 Screen map

| #   | Screen            | Arabic              | Owner | Cashier           | Portal              |
| --- | ----------------- | ------------------- | ----- | ----------------- | ------------------- |
| 1   | Orders            | «الطلبات»           | Yes   | Yes               | Read-only (§17)     |
| 2   | History           | «السجل»             | Yes   | Limited (§5.4)    | Yes                 |
| 3   | Menu              | «القائمة»           | Yes   | Availability only | Yes                 |
| 4   | Status and hours  | «الحالة والأوقات»   | Yes   | Status only       | Yes                 |
| 5   | Reports           | «التقارير»          | Yes   | —                 | Yes                 |
| 6   | Account           | «الحساب»            | Yes   | —                 | Yes                 |
| 7   | Ratings           | «التقييمات»         | Yes   | —                 | Yes                 |
| 8   | Staff and devices | «الموظفون والأجهزة» | Yes   | —                 | Yes                 |
| 9   | Settings          | «الإعدادات»         | Yes   | This device only  | Restaurant settings |
| 10  | Support           | «الدعم»             | Yes   | Yes               | Yes                 |

## 6.2 Layout

- **Top bar (every screen):** restaurant name, a status pill (tap to open the status sheet, §7.2), a connection dot (green when connected, red when not) and a support button.
- **Phone:** bottom navigation with «الطلبات», «القائمة», «الحالة» and «المزيد» (more). «المزيد» holds the other screens.
- **Tablet (840 dp or wider) and Windows:** a navigation rail on the right, and the orders board in four columns.
- **Touch targets:** at least 48 dp. The main action on a card is at least 56 dp tall.
- **Keep screen on:** an option on Android, on by default for tablets and off for phones. While on, the orders screen keeps the display awake.
- **Theme:** light theme in V1, with high-contrast status colours.

## 6.3 Banners (highest priority first)

Banners sit under the top bar. When several apply, up to two show and the rest are behind a counter.

1. No connection (red, §4.7)
2. Platform emergency stop (red, §8.17)
3. Restaurant suspended, auto-paused or paused by operations (red, §5.5, §7)
4. Device check failed (yellow, §4.5)
5. Test mode (blue, §5.5)
6. Busy because of the active-orders limit, or busy mode on (amber, §7)
7. Settlement overdue (owners; amber, §12.6)
8. App update available (grey, §4.2)
