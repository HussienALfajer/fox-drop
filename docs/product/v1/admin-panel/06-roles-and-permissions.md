# 6. Roles and permissions

> Part of the [admin panel spec](README.md) (AP). A bare "§n" here means AP §n.

## 6.1 Roles

V1 has five fixed roles. Permissions are stored as data, so V2 can add custom roles.

- A user holds **one or more** roles, and their permissions are the union of those roles. At launch the dispatcher MAY hold OPS + FIN, so they can also run the cash desk (D1).
- With several roles, the highest compensation cap among them applies (§6.4).
- An alert reaches a user if any of their roles is a recipient (§9.1.3).

| Code | Role                    | Arabic label        | Main job                                                                                   |
| ---- | ----------------------- | ------------------- | ------------------------------------------------------------------------------------------ |
| OWN  | Owner                   | «المالك»            | Everything, including money rules, commissions, the team, the audit log and approvals      |
| OPS  | Operations and dispatch | «العمليات والتوزيع» | Live orders, dispatch, restaurants (except commission), captains (except money), customers |
| SUP  | Support                 | «الدعم»             | Tickets, customer problems and compensation within the cap                                 |
| FIN  | Finance                 | «المالية»           | The cash desk, ledgers, settlements, statements, exchange rates and financial reports      |
| DATA | Data entry              | «إدخال البيانات»    | Creating restaurants and menus before activation, banners and categories                   |

## 6.2 Module access matrix

"Full" means every action in the module, subject to the special permissions in §6.3. "—" means no access.

| Module                            | OWN  | OPS                     | SUP                     | FIN                                      | DATA                                                    |
| --------------------------------- | ---- | ----------------------- | ----------------------- | ---------------------------------------- | ------------------------------------------------------- |
| Dashboard                         | Full | Full                    | Read                    | Read                                     | —                                                       |
| Operations room and order actions | Full | Full                    | Read and compensation   | Read                                     | —                                                       |
| Live map                          | Full | Full                    | Read                    | —                                        | —                                                       |
| Order history                     | Full | Full                    | Read                    | Read and financial corrections           | —                                                       |
| Restaurants                       | Full | Edit, except commission | Read                    | Statements and settlement                | Create and edit menus, without activation or commission |
| Captains                          | Full | Full, except money      | Read                    | Ledgers, cash limit, deposit and hand-in | —                                                       |
| Customers                         | Full | Full                    | Read and compensation   | Read and dues payments                   | —                                                       |
| Support                           | Full | Full                    | Full                    | Read, and resolve pickup-dispute tickets | —                                                       |
| Finance                           | Full | —                       | —                       | Full                                     | —                                                       |
| Marketing                         | Full | Read                    | —                       | Read costs                               | Banners                                                 |
| Zones and pricing                 | Full | Read                    | —                       | Read                                     | —                                                       |
| Content                           | Full | Read                    | FAQs and canned replies | —                                        | Categories                                              |
| Settings                          | Full | Dispatch mode only      | —                       | —                                        | —                                                       |
| Admin team                        | Full | —                       | —                       | —                                        | —                                                       |
| Audit log                         | Full | —                       | —                       | —                                        | —                                                       |
| Reports                           | Full | Operations reports      | Support reports         | Financial reports                        | —                                                       |

## 6.3 Special permissions

| Permission                                                                                         | Roles                                                                 |
| -------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------- |
| See or call a customer's phone number                                                              | OWN, OPS, SUP                                                         |
| Emergency stop on or off                                                                           | OWN, OPS                                                              |
| Switch dispatch mode                                                                               | OWN, OPS                                                              |
| Change a restaurant's commission or launch commission                                              | OWN                                                                   |
| Activate a restaurant (make it visible)                                                            | OWN, OPS                                                              |
| Edit menu prices                                                                                   | OWN, OPS, DATA (DATA only before activation)                          |
| Set or change a captain's cash limit                                                               | OWN, FIN                                                              |
| Record cash-desk transactions (hand-in, reimbursement, payout, deposit, settlement, customer dues) | OWN, FIN                                                              |
| Grant a hand-in grace to one captain (§8.5.4)                                                      | OWN, FIN                                                              |
| Grant a bulk hand-in grace for one business day                                                    | OWN                                                                   |
| Off-cycle captain payout                                                                           | OWN                                                                   |
| Change an outcome or responsible party after it was set (§8.9)                                     | OWN                                                                   |
| Hand an order over to another captain after pickup (§9.3.2)                                        | OWN, OPS                                                              |
| Confirm a pickup on a restaurant's behalf (§8.1)                                                   | OWN, OPS                                                              |
| Record a captain's arrival at the restaurant, or a delivery on their behalf (§9.3.2)               | OWN, OPS                                                              |
| Release a captain's device (§9.7.5)                                                                | OWN, OPS                                                              |
| Activate a captain flagged «خروج مبكر» (§9.7.1)                                                    | OWN                                                                   |
| Resolve a pickup-dispute ticket with account corrections (§9.9.3)                                  | OWN, OPS, FIN                                                         |
| Review menu change requests from restaurants (§9.6.7)                                              | OWN, OPS                                                              |
| Add or remove a restaurant owner account (§9.6.3)                                                  | OWN, OPS                                                              |
| Manual ledger adjustment or reversal                                                               | OWN, FIN                                                              |
| Edit exchange rates                                                                                | OWN, FIN                                                              |
| Approve compensation above the cap                                                                 | OWN                                                                   |
| Edit captain pay tables, delivery fee rules and the peak bonus                                     | OWN                                                                   |
| Close a customer account                                                                           | OWN, OPS, SUP                                                         |
| Clear customer strikes or end a review stop                                                        | OWN, OPS, SUP                                                         |
| Block or unblock a customer                                                                        | OWN, OPS                                                              |
| Suspend or terminate a captain                                                                     | OWN, OPS (the final earnings payout at termination needs OWN, §9.7.5) |
| Export data that contains phone numbers                                                            | OWN, OPS, SUP                                                         |

## 6.4 Compensation caps and approvals (D4)

- Each role has a cap as a percentage of the order's customer total: `support.compensation_cap_pct.SUP` (30), `support.compensation_cap_pct.OPS` (30). OWN has no cap. FIN and DATA cannot issue compensation.
- Every compensation MUST be linked to an order, including when it is issued from the customer profile or a ticket.
- The cap is **cumulative per order**: the sum of all compensation codes on one order, by anyone, counts against the issuer's cap.
- A percentage code MUST have a maximum amount, and that maximum is what counts against the cap.
- A free re-delivery of missing or wrong items is **not** capped, because it only restores what the customer already paid for. The same applies to a wrong-change code (§8.10). The automatic late-delivery code is not capped either, and does not count toward the cumulative total.
- **Above the cap:**
  1. The request goes to «طلبات الموافقة» (the approvals queue), and OWN gets an alert.
  2. OWN approves, edits the value or rejects.
  3. The customer is notified only after approval.
- The automatic late-delivery code (§8.3) is issued by the system and is not subject to caps.
