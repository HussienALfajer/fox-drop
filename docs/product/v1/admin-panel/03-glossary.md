# 3. Glossary

> Part of the [admin panel spec](README.md) (AP). A bare "§n" here means AP §n.

| Term | Meaning |
|---|---|
| Restaurant / merchant | A partner that prepares orders. "Merchant" is the generic code term (it covers V3 stores). |
| Captain «كابتن» | A courier who picks up orders and delivers them. |
| Customer «زبون» | A person who orders through the customer app. |
| Items value | The sum of item prices, including options and add-ons, multiplied by quantity, before any discount. |
| Customer total | What the customer pays at the door (§8.4). |
| Pickup payment «دفعة الاستلام» | What the captain pays the restaurant in cash at pickup: the full items value, with nothing deducted (D26, §8.4). |
| Commission | The platform's share of the items value, as a percentage set per restaurant. The restaurant pays it on Saturday. |
| Merchant net «صافي المطعم» | What the restaurant keeps from an order after the Saturday settlement: items value − commission − restaurant-funded discount (§8.4). |
| Base currency «عملة الأساس» | The currency a city uses for menu prices, fees, ledgers and reports (§8.6). |
| Accepted currency | A currency customers may pay in and captains may hold. The base currency is always accepted. |
| Exchange rate | How many base-currency units one unit of another currency is worth. The panel sets it, and each order keeps a snapshot of it. |
| Custody «العهدة النقدية» | Platform cash that a captain physically holds, tracked per currency (§8.5). |
| Earnings «المستحقات» | What the platform owes the captain for their work, in the base currency (§8.5). |
| Hand-in «تسليم النقد» | The captain handing custody cash to the cash desk. Required every business day. |
| Thursday settlement «تصفية الخميس» | The weekly full settlement and payout of a captain's earnings. |
| Restaurant account «حساب المطعم» | The running balance between the platform and a restaurant: commission, restaurant-funded discounts and exceptions (§8.7). It is settled every Saturday. |
| Business day | A city's operating day, from `finance.business_day_cutoff` to the same time on the next day (§4.3). |
| Outcome | The financial result of an order that ends after pickup: `normal`, `free`, `fake`, `damaged`, `wrong_refused` or `failed_other` (§8.9). |
| Responsible party | Who is at fault for a problem: restaurant, captain, customer or platform. It decides who bears the cost. |
| Compensation | A remedy given to a customer: a discount code for a next order, or a free re-delivery of missing or wrong items. V1 has no wallet or credit balance. |
| Zone | A polygon on the map where the platform delivers. |
| Offer | A dispatch proposal sent to one captain for a set time. |
| Probation «فترة التجربة» | The first month of a captain's contract. |
| Commitment period «فترة الالتزام» | The minimum 3 months a captain commits to after probation. |
