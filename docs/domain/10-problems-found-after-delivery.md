# 8.10 Problems found after delivery (tickets)

> Part of AP §8, the domain reference shared by all four V1 specs ([index](README.md)). A bare "§n" here means AP §n.

A customer may report missing, wrong or damaged items after a normal delivery (§9.9). The order's outcome stays `normal`; the ticket handles the money.

- **Affected value `V`:** the value of the affected items from the order snapshot, chosen in the ticket.
- **Remedy:** a compensation code (capped, §6.4), a free re-delivery of the items (§9.9.3), or no remedy. Remedies are funded by the platform, and the cost of a code goes to `platform.compensation_cost`.
- **Responsible party:**
  - **Restaurant:** with a free re-delivery, the restaurant replaces the items for free and nothing else is posted. Otherwise it posts `merchant.debit` of `V` and a reversing `merchant.commission` on `V`, so the restaurant gives back the merchant net of the affected items.
  - **Captain** (for example items missing after the captain verified the order): `earn.charge` of the merchant net of `V`. With a free re-delivery, this charge is posted once, on the re-delivery order.
  - **Platform:** only the cost of the remedy.
  - **Customer** (complaint not justified): no remedy and no entries.
- **Wrong change «مشكلة في المبلغ أو الباقي»** (customer-app spec Q23). The resolver enters `M`, the amount the customer was short, compared with what the captain recorded.
  - **Captain responsible:** `earn.charge` of `M` on the captain. The customer gets `M` back as a code, or in person through the captain arranged by OPS (then no charge is posted).
  - **Platform responsible:** a code of `M`, booked to `platform.compensation_cost`.
  - **Customer** (complaint not justified): no remedy and no entries.
  - The code restores money the customer already paid, so it is not capped (§6.4).
  - The opposite case, where the captain recorded more than they received, is the collection-shortfall flow (§8.6).
- These are system entries created when OPS or SUP resolves the ticket, with a preview. They are not manual adjustments, so SUP may create them.
