# 2. Owner decisions (2026-11-02)

> Part of the [admin panel spec](README.md) (AP). A bare "§n" here means AP §n.

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
