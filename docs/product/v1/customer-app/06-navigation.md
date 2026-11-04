# 6. Navigation

> Part of the [customer app spec](README.md) (CU). A bare "§n" here means CU §n.

## 6.1 Screen map

- **Bottom bar:**
  - «الرئيسية» (home)
  - «البحث» (search)
  - «طلباتي» (my orders)
  - «حسابي» (my account)
- **Floating cart button:** shows while the cart is not empty, with the item count and the items value.
- **Active-order bar:** pinned above the bottom bar on home and search while an order is active: «طلبك من {المطعم}: {الحالة}». With several active orders, it shows their count and opens a list.
- **Screens:**
  - First location, coming soon
  - Home, category, restaurant list, search
  - Restaurant page, item sheet
  - Cart, checkout, address picker, address form
  - Order status, order detail, rating, report a problem
  - Sign-in, code, account details
  - «حسابي»: profile, addresses, favourites, «أكوادي», notifications, help, terms, about, delete account

## 6.2 Banners (highest priority first)

1. Forced update or maintenance (blocking)
2. Emergency stop
3. Account state (§5.5)
4. Outside platform hours
5. Terms waiting for acceptance
6. Outside the zones (§7.2)
7. No internet
