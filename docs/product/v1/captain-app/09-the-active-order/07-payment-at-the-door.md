# 9.7 Payment at the door

> Part of the [captain app spec](../README.md) (CA). A bare "§n" here means CA §n.

The screen shows the amount due and helps the captain record what really happened.

1. **Amount due:** the order total in the base currency, large, with its equivalents in the other accepted currencies, each rounded by its own rule (AP §8.6).
2. **Received:** the captain enters what they received, in one or more currency lines. Buttons for each currency fill the exact equivalent with one tap. The button of the customer's pay-in currency comes first (customer-app spec U10).
3. **Change:** the app computes the change in the base currency. The captain can switch the change to another currency, or split it, and records the change the customer was due. If the customer left that change as a tip, the captain still records it as given (K14).
4. **Check:** the server converts the lines with the order's snapshot rates.
   - The net received is the received lines minus the change lines. A difference from the amount due within half the largest rounding unit among the currencies of all the lines is rounding (AP §8.6).
   - If the net received is lower, the app warns «المبلغ المقبوض أقل من المطلوب بـ {المبلغ}». The captain must choose a reason (K16, Appendix C): «الزبون لا يملك المبلغ كاملاً», «خطأ في العد», «أخرى». Operations get «نقص في التحصيل» and resolve it (AP §8.6).
   - A net received above the amount due beyond rounding is refused: «سجّل الباقي الذي أعدته للزبون».
   - The command carries the version of the amount due that the screen showed. If operations changed the amount in the meantime, the server refuses it, and the screen reloads with the new amount: «تغيّر المبلغ المطلوب إلى {المبلغ}».
5. **Tips (K14):** a line under the screen says «إذا ترك لك الزبون الباقي إكرامية فهو لك، سجّله كأنك أعدته» (a tip is yours; record the change as if you gave it back).
