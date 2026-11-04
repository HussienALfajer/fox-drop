# 1. Context and principles

> Part of the [restaurant app spec](README.md) (RA). A bare "§n" here means RA §n.

## 1.1 What the restaurant app is

FOX DROP partners are restaurants and ready-food shops: restaurants, sweets, bakeries, cafés and juice shops (AP §1.1). They use one product to run their side of the platform:

- receive orders with a loud, repeating alert, accept or reject them, and prepare them on time
- hand orders to captains and confirm the cash they receive
- keep the menu and its availability up to date
- set opening hours, and pause or slow down when the kitchen is under pressure
- follow their sales, their performance and their account with FOX DROP

BeeOrder splits this between a Windows order receiver and a web dashboard (research `02-merchant-side.md` §2). FOX DROP gives each restaurant one app that runs on Android or Windows, plus a web portal for the owner.

## 1.2 The order cycle from the restaurant's side

1. A new order rings on every receiving device of the restaurant.
2. A cashier or owner accepts it with a prep time, or rejects it with a reason.
3. The kitchen prepares it. The app shows the captain on the way and when they arrive.
4. The restaurant presses «الطلب جاهز» (order ready) when the food is ready.
5. The captain checks the items, pays the full items value in cash, and asks the restaurant to confirm. The restaurant confirms with one tap (R4).
6. The order travels with the captain until delivery, then moves to history.
7. Every Saturday the owner settles the week's commission with FOX DROP.

## 1.3 Money in one paragraph (AP D26)

At pickup the captain pays the restaurant the **full items value** in cash, with nothing deducted. During the week, the restaurant's account with FOX DROP accumulates what it owes: the commission on each order and its share of any discount it funded. Every Saturday the owner pays that amount at the office or to a visiting staff member and gets a receipt in the app. The restaurant never sees the delivery fee or the customer's total (R11).

## 1.4 Principles (MUST)

1. **Never miss an order.** New orders ring loudly and repeatedly on every receiving device, with the screen off and the app in the background. The app checks each device and warns when it may not ring (§4.5). Operations are alerted when an open restaurant has no device connected (§4.6).
2. **The server is the authority.** The server owns order state, timers and every amount. The app shows them and sends commands; it never computes money on its own.
3. **Configured from the panel.** Timers, choices and limits come from server settings. Changing them needs no app update.
4. **Built for a busy counter.** One main action per card, large tap targets, almost no typing. A cashier with flour on their hands can accept an order with one tap.
5. **Works on unstable internet.** Commands retry safely and never apply twice. The connection state is always visible (§4.7).
6. **Customer privacy.** The restaurant never sees the customer's phone number, last name or full address. It sees the first name and the neighbourhood only.
7. **Money is for owners.** Cashiers see the items and their value, because they receive the cash. Commission, net amounts, the account, statements and reports are visible to owners only (R10).
8. **Every action is attributed.** Every command records the user, the device and the time. Admins see these in the order timeline and the restaurant change log (AP §9.3.1 and AP §9.6.4).
