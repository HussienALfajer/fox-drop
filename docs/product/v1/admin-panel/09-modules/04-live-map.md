# 9.4 Live map «الخريطة الحية»

> Part of the [admin panel spec](../README.md) (AP). A bare "§n" here means AP §n.

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
