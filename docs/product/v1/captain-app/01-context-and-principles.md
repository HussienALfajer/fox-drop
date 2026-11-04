# 1. Context and principles

> Part of the [captain app spec](README.md) (CA). A bare "§n" here means CA §n.

## 1.1 What the captain app is

A captain «كابتن» picks up orders from restaurants and delivers them to customers (AP §3). The captain app is the captain's only tool:

- apply to join and follow the application
- go online, receive offers, and accept or reject them
- carry out each order: go to the restaurant, check the items, pay the restaurant, deliver, collect the cash
- see the cash they hold for the platform, hand it in every business day, and follow their earnings until the Thursday payout
- see their performance, contract, documents, kit and the rules they work under

## 1.2 A working day

1. The captain opens the app and goes online. If they still hold cash from a previous business day, they hand it in at the office first (AP D11).
2. Offers arrive one at a time. The captain accepts one.
3. They ride to the restaurant, check the items, pay the full items value in cash, and the restaurant confirms the pickup (RA R4).
4. They ride to the customer, hand over the order, and collect the order total.
5. They see what they earned from the order and how much cash they now owe the office.
6. They go online for the next offer, or offline.
7. They hand in the platform's cash at the office every business day, and collect their earnings every Thursday.

## 1.3 Money in one paragraph (AP D11, D12, D26)

At pickup the captain pays the restaurant the **full items value** from their own cash. At the door they collect the full order total. The difference is the platform's cash in their hands, their **custody** «العهدة». They hand it in at the office every business day. Separately, the platform owes them **earnings** «المستحقات» for each order. Earnings are paid in full every Thursday. The two accounts never mix in the app: custody is cash they hold for the platform, and earnings are what the platform owes them.

## 1.4 Principles (MUST)

1. **Never miss an offer.** Offers ring with the screen off. The device check makes sure the phone can ring (§4.5).
2. **Show the money before the choice.** Every offer shows the captain's pay, what they will pay the restaurant, and what they will collect, before they accept (C2).
3. **The server is the authority.** The server owns order state, timers, every amount and every ledger entry. The app shows them and sends commands.
4. **One big action at a time.** Each step of an order has one main button. A captain on a motorbike can use the app with one hand, in sunlight, with gloves.
5. **Works on weak internet and cheap phones.** Commands retry safely. Maps and data stay light (§4.6).
6. **Customer privacy.** The captain sees the customer's name, phone and exact address only after accepting and only until the order ends (C2, C10, K8).
7. **Fair and transparent rules.** Every block, warning or charge tells the captain why and what to do next. Every violation can be appealed (C16).
8. **Every action is recorded.** Each command records the captain, the device, the time and the location. Admins see these in the order timeline (AP §9.3.1).
