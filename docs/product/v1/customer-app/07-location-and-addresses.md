# 7. Location and addresses

> Part of the [customer app spec](README.md) (CU). A bare "§n" here means CU §n.

## 7.1 First location and the zone check

- **First open:** «أين نوصل طلبك؟», with «استخدم موقعي الحالي» and «اختر على الخريطة».
- **Map:**
  - the customer moves the map under a fixed pin
  - the pin can be confirmed only at street-level zoom: zoom 16 or closer (fixed). Below that: «قرّب الخريطة لتحديد موقعك بدقة»
- **Zone check:** the server checks the point against the active zones (AP §9.12.2).
  - Inside a zone with restaurants that cover it: the home screen.
  - Inside a zone, but no restaurant covers the point: «لا توجد مطاعم توصل إلى موقعك حالياً»
  - Outside every zone: §7.2.
- **The home header** shows the current location's label, or the neighbourhood name for an unsaved point. Tapping it opens the address picker.

## 7.2 Outside the zones

- The screen shows «قريباً في منطقتك» with «صوّت لمنطقتك» (AP §9.12.2).
- A vote records the point and appears in the panel's vote map and the lost-demand report (AP §9.17).
- A device can vote once per point (fixed). The app then shows «شكراً، سنخبرك عندما نصل إلى منطقتك».
- The customer can choose another point at any time.

## 7.3 Saved addresses (U5, Q5, Q6)

| Field                                        | Rule                                                                         |
| -------------------------------------------- | ---------------------------------------------------------------------------- |
| Pin                                          | Required, inside an active zone, at street-level zoom (§7.1)                 |
| Label                                        | «البيت», «العمل» or «آخر» with a custom name                                 |
| Neighbourhood «الحي»                         | Filled from the zone name. Read-only                                         |
| Street and building «الشارع والبناء»         | Required, 3 to 100 characters                                                |
| Floor and apartment «الطابق والشقة»          | Optional                                                                     |
| Landmark «بالقرب من»                         | Required, 3 to 100 characters (U5). Placeholder «مثلاً: قرب جامع النور»      |
| Contact phone «رقم التواصل»                  | The account's phone by default. May be another Syrian or Turkish mobile (U5) |
| Recipient's name «اسم المستلم»               | Required only when the contact phone is not the account's (Q5)               |
| Directions for the captain «توجيهات للكابتن» | Optional, up to 200 characters, for example «الباب الأزرق بجانب الصيدلية»    |

- **Limits:** up to 10 saved addresses (fixed). One is the default.
- **Editing (U5):** every field can be edited, including the pin. The pin can move only inside active zones.
- **Snapshots:** an order keeps the address as it was when it was placed. Editing or deleting an address never changes an active or past order (Q6).
- **A zone that is turned off:** an address outside every active zone shows «خارج منطقة التوصيل حالياً» and cannot be chosen (Q6).
- **Deleting:** allowed, with a confirmation.

## 7.4 Deliver to my current location (U5)

- At checkout, «التوصيل إلى موقعي الحالي» takes the GPS position as the pin.
  - If the accuracy is worse than 100 m (fixed), the app asks the customer to adjust the pin on the map.
- The form is the same as §7.3, with «احفظ هذا العنوان» off by default.
- An unsaved address belongs to that order only.

## 7.5 The far-pin check (U5)

- **When:** the customer taps «تأكيد الطلب» and location permission is granted. The app requests a fresh position and waits up to 5 seconds (fixed). The check runs when the position is accurate to 100 m (fixed).
- **Check:** if the pin is farther than `customer.far_pin_warn_m` (1000) metres from the device, a dialog asks:
  - «هل أنت متأكد من العنوان؟ النقطة تبعد {المسافة} عن موقعك الحالي.»
  - with «نعم، أرسل إلى هذا العنوان» and «تغيير العنوان»
- Without permission, or without an accurate position within the 5 seconds, there is no check, and the order continues.
- The check runs on the device. Its result is not sent to the server (§4.4).
