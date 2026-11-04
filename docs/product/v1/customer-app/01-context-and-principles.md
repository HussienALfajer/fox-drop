# 1. Context and principles

> Part of the [customer app spec](README.md) (CU). A bare "§n" here means CU §n.

## 1.1 What the customer app is

The customer app is how people in Azaz order food from FOX DROP's partner restaurants (AP §1.1). With it a customer:

- picks where to deliver, and sees the restaurants that deliver there
- browses menus with real prices, delivery fees and delivery times
- places an order and pays in cash at the door
- follows the order live, from the restaurant to the door
- rates the restaurant and the captain, and reports a problem if something went wrong

## 1.2 An order from the customer's side

1. The customer opens the app and chooses a location, by GPS or on the map. Inside a service zone, they see the restaurants that deliver there.
2. They browse a restaurant and add items to the cart.
3. At checkout they sign in if they are a guest, choose the address, add notes and a code, and see the exact total. They confirm. Nothing is paid yet.
4. The restaurant accepts and the customer sees the expected arrival time. When a captain is assigned, the customer sees the captain's name and photo.
5. When the captain picks up the order, the customer follows them on the map and can call them.
6. The captain arrives. The customer pays the total in cash, in any accepted currency, and gets their change.
7. The customer rates the restaurant and the captain, and can report a problem within 24 hours.

## 1.3 Money in one paragraph (AP §8.4)

The customer pays one amount, the **customer total**: the items value, plus the delivery fee, minus any discount, rounded to the base currency's rounding unit (AP §8.4). They pay it in cash at the door, in the base currency or in any accepted currency at the order's exchange-rate snapshot (AP §8.6). Menu prices equal the prices in the restaurant itself (§9.5). The app never charges anything and has no tip field (CA C12). A compensation is a code for a next order; V1 has no wallet and no refunds (AP §3).

## 1.4 Principles (MUST)

1. **The full price before the order.** The customer sees the items value, the delivery fee, the discount and the total, with its equivalents in the other accepted currencies, before confirming. There are no hidden fees.
2. **Never accept an order we cannot deliver** (AP §1.3, principle 10). When an order cannot be placed, the app says why in plain words and keeps the cart.
3. **The server is the authority.** Prices, availability, fees, codes, the estimate and the total come from a server quote. The app never places an order with a total the customer did not see (Q10).
4. **Fast on cheap phones and weak internet.** Lists render before their extras, images are light, and commands retry safely (§4.5).
5. **Privacy.**
   - The restaurant sees the customer's first name and neighbourhood only (RA §1.4).
   - The captain sees the contact details only during the order (CA §1.4).
   - Gender and birthday stay in the admin panel (Q2).
   - The app reads location only while it is in use (§4.4).
6. **Honest status.** Every step says what is happening and who acts next. Delays, changes and problems are announced, never hidden.
7. **Few steps.** A returning customer can reorder in a few taps. Each screen has one main action.
