# FOX DROP — Technology Stack and Architecture

|           |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| --------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Product   | FOX DROP, a food delivery platform launching in Azaz, Syria, then expanding city by city                                                                                                                                                                                                                                                                                                                                                                                                                 |
| Scope     | The technical foundation for V1, designed to carry V2–V6 without a rewrite                                                                                                                                                                                                                                                                                                                                                                                                                               |
| Component | The shared server, the admin panel, the restaurant app and owner portal, the customer app and the captain app                                                                                                                                                                                                                                                                                                                                                                                            |
| Status    | Approved by the owner on 2026-11-04 (decisions in §2)                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| Audience  | Engineers and coding agents (Claude Code) who set up the repository, the infrastructure and the code                                                                                                                                                                                                                                                                                                                                                                                                     |
| Related   | Admin panel spec [`docs/product/v1/admin-panel/`](../product/v1/admin-panel/README.md) ("AP §n"). Restaurant app spec [`docs/product/v1/restaurant-app/`](../product/v1/restaurant-app/README.md) ("RA §n"). Captain app spec [`docs/product/v1/captain-app/`](../product/v1/captain-app/README.md) ("CA §n"). Customer app spec [`docs/product/v1/customer-app/`](../product/v1/customer-app/README.md) ("CU §n"). BeeOrder technical findings: `01-customer-app.md` (kept outside this repository) §10 |

## How these files are organised

Each section of the original document is one file, and a long section is a folder with one file per subsection. Section numbers are unchanged, so a citation such as "§n" still finds its place: the file name starts with the section number, and a subsection file inside a folder starts with the subsection number.

§23 «Changes made to the specs» was removed on 2026-11-04 after a check confirmed that every change it listed is in the target documents. The git history keeps it. The section numbers after it are unchanged.

## Contents

| Section                                      | File                                                                                               |
| -------------------------------------------- | -------------------------------------------------------------------------------------------------- |
| 0. How to use this document                  | [00-how-to-use-this-document.md](00-how-to-use-this-document.md)                                   |
| 1. What the specs demand from the technology | [01-what-the-specs-demand-from-the-technology.md](01-what-the-specs-demand-from-the-technology.md) |
| 2. Decisions                                 | [02-decisions.md](02-decisions.md)                                                                 |
| 3. The stack at a glance                     | [03-the-stack-at-a-glance.md](03-the-stack-at-a-glance.md)                                         |
| 4. Architecture                              | [04-architecture.md](04-architecture.md)                                                           |
| 5. Server                                    | [05-server.md](05-server.md)                                                                       |
| 6. Real time                                 | [06-real-time.md](06-real-time.md)                                                                 |
| 7. Maps, routing and location                | [07-maps-routing-and-location.md](07-maps-routing-and-location.md)                                 |
| 8. Notifications and sign-in codes           | [08-notifications-and-sign-in-codes.md](08-notifications-and-sign-in-codes.md)                     |
| 9. Design system (T2)                        | [09-design-system.md](09-design-system.md)                                                         |
| 10. Admin panel and owner portal (web)       | [10-admin-panel-and-owner-portal.md](10-admin-panel-and-owner-portal.md)                           |
| 11. Flutter apps: shared foundation (E5)     | [11-flutter-apps-shared-foundation.md](11-flutter-apps-shared-foundation.md)                       |
| 12. Restaurant app (Android and Windows)     | [12-restaurant-app.md](12-restaurant-app.md)                                                       |
| 13. Customer app (Android and iOS)           | [13-customer-app.md](13-customer-app.md)                                                           |
| 14. Captain app (Android and iOS)            | [14-captain-app.md](14-captain-app.md)                                                             |
| 15. Security                                 | [15-security.md](15-security.md)                                                                   |
| 16. Observability and analytics              | [16-observability-and-analytics.md](16-observability-and-analytics.md)                             |
| 17. Infrastructure and environments (E8)     | [17-infrastructure-and-environments.md](17-infrastructure-and-environments.md)                     |
| 18. Testing and quality                      | [18-testing-and-quality.md](18-testing-and-quality.md)                                             |
| 19. Repository and conventions               | [19-repository-and-conventions.md](19-repository-and-conventions.md)                               |
| 20. Growth path V1 → V6                      | [20-growth-path-v1-v6.md](20-growth-path-v1-v6.md)                                                 |
| 21. Options considered and not chosen        | [21-options-considered-and-not-chosen.md](21-options-considered-and-not-chosen.md)                 |
| 22. Risks and open items                     | [22-risks-and-open-items.md](22-risks-and-open-items.md)                                           |
