# 8.1 Statuses as the restaurant sees them

> Part of the [restaurant app spec](../README.md) (RA). A bare "§n" here means RA §n.

| Order status (AP §8.1) | Where it shows | Arabic        |
| ---------------------- | -------------- | ------------- |
| `placed`               | Column 1       | «جديدة»       |
| `accepted`             | Column 2       | «قيد التحضير» |
| `ready`                | Column 3       | «جاهزة»       |
| `picked_up`, `arrived` | Column 4       | «مع الكابتن»  |
| `delivered`            | History        | «تم التسليم»  |
| `failed`               | History        | «فشل التسليم» |
| `rejected`             | History        | «مرفوض»       |
| `cancelled`            | History        | «ملغى»        |

**Captain line on the card** (from the captain track, AP §8.2):

| Captain track          | Card line                                    |
| ---------------------- | -------------------------------------------- |
| `searching`, `offered` | «بانتظار كابتن»                              |
| `assigned`             | «الكابتن {الاسم} في الطريق — يصل خلال {د} د» |
| `at_merchant`          | «وصل الكابتن — ينتظر منذ {د} د»              |
| `pickup_pending`       | «الكابتن يطلب تأكيد الاستلام»                |
| `picked_up` onwards    | «مع الكابتن {الاسم}»                         |
