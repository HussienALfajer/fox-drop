# 10. Cart and checkout

> Part of the [customer app spec](README.md) (CU). A bare "§n" here means CU §n.

## 10.1 Cart (U8, Q9)

- **One restaurant:** adding an item from another restaurant asks:
  - «سلتك فيها أصناف من {المطعم}. هل تفرغها وتبدأ سلة جديدة من {المطعم الجديد}؟»
  - with «سلة جديدة» and «إلغاء»
- **Each line:** quantity with «−» and «+», «تعديل» (reopens the item sheet), and removal.
- **Kept on the device:** for 24 hours (fixed) after the last change. After that it empties with «انتهت صلاحية سلتك».
- **Changes since adding:** the cart and checkout show them before the customer can confirm (§10.6):
  - an unavailable item, with a remove button
  - a new price: «تغيّر سعر {الصنف} من {القديم} إلى {الجديد}»
  - a removed option
- **«متابعة»** (continue) leads to checkout. A guest signs in at «تأكيد الطلب» (§5.1).

## 10.2 Minimum order and free delivery (U9)

- **Minimum order:** set per restaurant by admins (RA R13), compared with the items value before discounts.
  - Below it: «أضف {المبلغ} لتصل إلى الحد الأدنى ({الحد})», with a progress bar, and «متابعة» disabled (U9).
- **Free delivery:** when the restaurant has a threshold (AP §9.12.3), compared with the items value:
  - below it: «أضف {المبلغ} لتحصل على توصيل مجاني», with a progress bar
  - at or above it: «توصيلك مجاني»
- Neither threshold is re-checked after the order is placed (AP §9.3.3).

## 10.3 Checkout

From top to bottom:

1. **Address:**
   - preselected from the point the customer browsed with: that saved address, or else a saved address within 200 m (fixed) of the point, or else the point itself as an unsaved address to complete (§7.4)
   - «تغيير», «إضافة عنوان» and «التوصيل إلى موقعي الحالي» (§7). Changing the address here also changes the point used for browsing.
   - the recipient and contact phone, when they are not the account's
2. **Notes:**
   - preset chips from Content (AP §9.13, Appendix C)
   - a free note to the restaurant and the captain, up to 200 characters (fixed). A note with a run of 7 or more digits is refused: «لا تكتب أرقام هواتف في الملاحظة. رقم التواصل يصل إلى الكابتن تلقائياً.» (Q25)
3. **«سأدفع بـ»** (§10.5).
4. **Code** (§10.4).
5. **Payment:** «نقداً عند الاستلام» (cash on delivery), the only method in V1.
6. **Estimate:** «يصل خلال {الحد الأدنى}–{الحد الأعلى} د».
7. **Money:**
   - «قيمة الأصناف» (items value)
   - «رسوم التوصيل» (delivery fee), or «مجاني»
   - «الخصم» (discount), with the code
   - «تقريب» (rounding), only when it is not 0 (AP §8.4)
   - «المجموع» (total) in the base currency
   - under it: «أو {المبلغ} $ · {المبلغ} ل.س» and so on, one equivalent per accepted currency, each rounded by its own rule (AP §8.6)
8. **«تأكيد الطلب — {المجموع}».**

## 10.4 Codes (U11, Q19)

- **Entering:** «أدخل الكود» and «تطبيق». Visible and secret codes both work.
- **«الأكواد المتاحة لك»:** a list of the visible codes this customer is eligible for, and their personal codes (§12.4). Each shows its value, its conditions and its expiry.
- **Suggestion (Q19):** when an eligible code would give a discount, a line shows «لديك كود يوفر عليك {المبلغ}: {الكود}» with «تطبيق».
  - It suggests the code with the largest discount on the current cart.
  - It never applies a code by itself (U11).
- **One code per order** (AP §9.11.1). Applying another replaces it, after a confirmation. «إزالة» removes it.
- **Caps (AP §8.4):** a code never takes the total below 0. When a fixed-amount code is larger than the items value, checkout warns before confirming: «قيمة الكود أكبر من قيمة الأصناف، ولا يُستعاد الفرق».
- **Given back:** a code used on an order that ends rejected, cancelled, or failed without the customer at fault returns to «متاحة» (AP §9.11.1), with «أُعيد الكود {الكود} إلى أكوادك».
- **Validation** is on the server, with every rule in AP §9.11.1. A refused code shows the reason (Appendix C), for example:
  - «هذا الكود للطلب الأول فقط»
  - «أضف {المبلغ} لاستخدام هذا الكود»
- **When a code stops working** between quote and confirmation (for example its daily budget ran out), the quote shows it. The customer confirms again without it, or with another code.

## 10.5 «سأدفع بـ» (U10)

- **Choices:** chips for each accepted currency, plus «لم أحدد» (not set), which is the default.
- **Choosing a currency** shows the total in it: «ستدفع حوالي {المبلغ} {العملة}».
- **The choice is saved on the order.** The captain sees it (CA §9.5) and the panel shows it (AP §9.3.1).
- **It is not binding.** The customer can pay in any accepted currency, and the captain records what they actually received (CA §9.7).
- The app remembers the last choice on the device.

## 10.6 The quote and the pre-order checks (Q9, Q10)

- **When the app asks for a quote:** every time the cart, the address or the code changes, and on opening checkout.
- **The quote contains:**
  - each line with its current price and availability
  - the items value, the delivery fee, the discount, the rounding and the total
  - the equivalents in each accepted currency
  - the estimate range
  - the minimum-order and free-delivery status
  - a list of problems
  - the exchange-rate version
  - a quote version, which changes only when a money line, an equivalent, the exchange rates or a blocking problem changes. A new estimate alone does not change it.
- **Problems that block ordering** show at the top of checkout with the action to fix each. The texts are in Appendix C.

  | Check                                                            | Source        |
  | ---------------------------------------------------------------- | ------------- |
  | App version, maintenance, terms accepted                         | §4.2, §4.7    |
  | Platform hours and emergency stop                                | §4.7          |
  | Account state and the active-order limit                         | §5.5          |
  | Point inside an active zone and inside the restaurant's coverage | §7, §8.2      |
  | Restaurant can take orders, including its maximum active orders  | §9.2, RA §7.4 |
  | Every item and option available, prices accepted                 | §9.3, §10.1   |
  | Minimum order                                                    | §10.2         |
  | Code valid (otherwise the order can go without it)               | §10.4         |
  | An eligible captain nearby (capacity check)                      | AP §9.12.6    |

- **The capacity check** is part of every quote while `dispatch.capacity_check` is on. A refusal shows «الضغط عالٍ الآن، جرّب بعد دقائق». It is logged as lost demand once per checkout session, which runs from opening checkout until the customer leaves it or places the order (AP §9.12.6).

## 10.7 Placing the order (Q10, Q11)

1. The customer taps «تأكيد الطلب — {المجموع}».
2. A guest signs in here (§5.1), and returns to checkout with the refreshed quote.
3. The far-pin check runs (§7.5).
4. On the first order only, the notification permission is asked (Q11).
5. **The command** carries the quote version, the address snapshot, the notes, the pay-in currency, the code and an idempotency key.
6. **The server re-runs every check atomically** (AP §1.3 principle 10, RA §7.4). Two customers can never take a restaurant's last place, and a new account can never place two orders at once.
   - **Everything still matches:** the order becomes `placed`, with the quote's exchange rates as its snapshot (AP §8.6). The cart empties, and the app opens the order screen with «أرسلنا طلبك إلى {المطعم}».
   - **The total, a line or an exchange rate changed:** the server refuses, and the app shows the new quote with what changed. The customer confirms again (Q10).
   - **A blocking problem appeared:** the server refuses, and the app shows the problem. The cart stays.
7. **While sending:** «جارٍ إرسال طلبك…». The button cannot be pressed twice, and leaving the screen does not cancel the command.
