# 1. Context and principles

> Part of the [admin panel spec](README.md) (AP). A bare "§n" here means AP §n.

## 1.1 V1 in one paragraph

V1 serves one city, Azaz, inside service zones that the admin draws on a map. Partners are restaurants and ready-food shops: restaurants, sweets, bakeries, cafés and juice shops. Supermarkets and stores come in V3. Orders are instant delivery only, paid in cash on delivery. There are four products: the customer app (Android and iOS; [`docs/product/v1/customer-app/`](../customer-app/README.md)), the restaurant app (Android and Windows, with an owner web portal; [`docs/product/v1/restaurant-app/`](../restaurant-app/README.md)), the captain app (Android and iOS; [`docs/product/v1/captain-app/`](../captain-app/README.md)) and this admin panel (web).

The cash model works in five steps (D11, D12, D26):

1. At pickup, the captain pays the restaurant the **full items value** in cash. No commission is deducted.
2. At the door, the captain collects the full order total from the customer.
3. Every business day, the captain hands the office the platform's cash: what they collected minus what they paid the restaurant.
4. Every Thursday, the captain is paid their earnings.
5. Every Saturday, each restaurant settles its account with the platform: the week's commission, any discounts it funded, and any exceptions.

## 1.2 What the panel is

The admin panel is the single control plane of the platform. From it the owner and staff:

- watch every live order and step into any order at any stage
- manage restaurants, menus, captains and customers
- run the cash desk
- set every price, fee, timer, limit and policy without a code change or an app update

## 1.3 Principles (MUST)

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
