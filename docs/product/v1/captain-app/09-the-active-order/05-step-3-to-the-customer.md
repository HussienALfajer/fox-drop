# 9.5 Step 3: to the customer

> Part of the [captain app spec](../README.md) (CA). A bare "§n" here means CA §n.

- **Shown after acceptance only (C2):**
  - the customer's name, or the recipient's name when the order is for someone else (customer-app spec Q5)
  - the exact pin on the map, with the route
  - the address text with the building, floor, the nearby landmark and the customer's directions
  - the customer's note and preset notes
  - «تقبض من الزبون: {المبلغ}», with the equivalents in the other accepted currencies
  - the pay-in currency, when the customer chose one: «الزبون سيدفع بـ {العملة}» (customer-app spec U10). It is an indication, not a commitment.
  - the promised time: «التسليم المتوقع قبل {الساعة}» (AP §8.3)
- **Buttons (C10):** «ابدأ الملاحة», «اتصال بالزبون» and «واتساب الزبون». They work only while the order is active.
  - The call button opens the phone's dialer with the address's contact phone, which is the customer's own number unless the order is for someone else. WhatsApp opens a chat with that number.
  - The app does not display the number anywhere else.
  - Each call or WhatsApp tap is recorded in the order timeline.
- **Tracking:** from pickup until the order ends, the customer sees the captain on the map and can call them. The customer sees the captain's number on their call screen (customer-app spec §11.3, U12).
