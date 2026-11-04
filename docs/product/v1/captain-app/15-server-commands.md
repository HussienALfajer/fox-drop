# 15. Server commands

> Part of the [captain app spec](README.md) (CA). A bare "§n" here means CA §n.

Every command:

- carries an idempotency key (§4.6)
- is checked on the server for the captain's status, the order's state and the captain track
- returns the new state
- records the captain, the device, the time and the location

| Command                                             | Allowed when                                                                           | Effect                                                     |
| --------------------------------------------------- | -------------------------------------------------------------------------------------- | ---------------------------------------------------------- |
| Submit or update an application                     | No active captain account                                                              | Application created or updated (§5)                        |
| Upload a document                                   | Applicant or captain                                                                   | Document pending verification (§5.3, §12.2)                |
| Go online                                           | No block in §7.2                                                                       | `متصل متاح` (§7.2)                                         |
| Go offline                                          | No active order                                                                        | `غير متصل` (§7.5)                                          |
| Last-order mode on / off                            | Active order                                                                           | No new offers; offline after the order (§7.3)              |
| Accept offer                                        | Offer open for this captain                                                            | Order assigned (§8.3)                                      |
| Reject offer                                        | Offer open                                                                             | Offer closed, next captain (§8.3)                          |
| Arrived at the restaurant                           | `assigned`, within 150 m                                                               | `at_merchant` (§9.2)                                       |
| Request pickup with payment lines                   | `at_merchant`, all items ticked, no block in RA §8.10                                  | `pickup_pending` (§9.4)                                    |
| Confirm a handover receipt                          | Handover order, within 200 m of the first captain                                      | Second captain `picked_up`; first captain `done` (§9.10.1) |
| Arrived at the customer                             | `picked_up`, within 200 m or with a reason                                             | `at_customer` (§9.6)                                       |
| Ping customer                                       | `at_customer`, ping allowed                                                            | Ping sent (§9.9)                                           |
| Customer not responding                             | `at_customer`, 3 pings and 15 min                                                      | Alert to OPS (§9.9)                                        |
| Record payment and deliver                          | `at_customer`, within 200 m or with a reason, and the amount-due version still current | `delivered` and ledger entries (§9.7, §9.8)                |
| Record payment for an OPS outcome                   | OPS ended the order with an amount to collect                                          | Outcome posted (§9.10)                                     |
| Can't complete, or withdraw that request            | Active order                                                                           | Alert to OPS, or alert closed (§9.11)                      |
| Emergency                                           | Active order                                                                           | Alert with location, order marked (§9.11)                  |
| Report a problem or appeal                          | Any time                                                                               | Ticket (§9.11, §11.3, §13)                                 |
| Call or WhatsApp the customer                       | Active order, after acceptance                                                         | Number revealed to the dialer; recorded (§9.5)             |
| Set the maximum pickup amount or carried currencies | No active order                                                                        | Applies to the next offer (§10.5)                          |
| Report the device check                             | After a check                                                                          | Stored on the captain profile (§4.5)                       |
| Accept terms                                        | A pending version                                                                      | Recorded (§4.8)                                            |
| Location batch                                      | Online                                                                                 | Positions stored (§4.3)                                    |

**Real-time events the app subscribes to** (captain channel):

- an offer opened or closed
- the active order updated: status, restaurant ready, pickup request result, edits, withdrawal, handover, cancellation, outcome
- custody or earnings entry posted
- a receipt or statement issued
- a block, grace or suspension changed
- messages and announcements
- platform broadcasts: emergency stop, maintenance, version
