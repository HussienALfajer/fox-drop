# 20. Growth path V1 → V6

> Part of the [technology stack](README.md). A bare "§n" here means §n of the technology stack.

| Version | What changes technically                                                                                                                                                                                                                                                                                     |
| ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **V1**  | Modular monolith, one PostgreSQL with standby and replica, Centrifugo, OSRM, pg-boss timers, manual then mixed dispatch, WhatsApp codes                                                                                                                                                                      |
| **V2**  | Printing, panel chat (on Centrifugo), the penalties engine, English UI (the RTL-first logical styles already support LTR)                                                                                                                                                                                    |
| **V3**  | Stores and the central catalogue with **Meilisearch** (Arabic search at scale), errands, order stacking. **Temporal** for long-running flows. **Dispatch and location split into their own service** (Go is an option for it). Move off the shared server to dedicated servers or a managed Kubernetes (T9). |
| **V4**  | Loyalty, referral and campaigns: a rules engine for offers; **ClickHouse** fed from PostgreSQL by change data capture for analytics and campaign ROI                                                                                                                                                         |
| **V5**  | E-payments and wallet: new account and journal types in the existing ledger, payment gateway adapters, reconciliation jobs; the payments module gets stricter isolation and its own audit                                                                                                                    |
| **V6**  | Smart dispatch and forecasting: a **Python (FastAPI)** service for ETA, demand and matching models trained on ClickHouse data; regional database separation if the number of cities requires it                                                                                                              |

Second sign-in channel (SMS or the official WhatsApp Cloud API) can be added in any version as a new `CodeSender` adapter (§8.3.1).
