# FOX DROP V1 — Restaurant App Specification

|             |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| ----------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Product     | FOX DROP, a food delivery platform launching in Azaz, Syria, then expanding city by city                                                                                                                                                                                                                                                                                                                                                                                                                          |
| Scope       | V1, the first version that completes a full order cycle                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| Component   | The restaurant side «تطبيق المطعم»: an Android app (phone and tablet), a Windows desktop app, and an owner web portal «بوابة المطعم»                                                                                                                                                                                                                                                                                                                                                                              |
| Status      | Approved by the owner on 2026-11-02 (decisions in §2)                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| Audience    | Engineers and coding agents (Claude Code) who build the restaurant apps and the server rules behind them                                                                                                                                                                                                                                                                                                                                                                                                          |
| UI language | Arabic only, right to left                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| Related     | Admin panel spec [`docs/product/v1/admin-panel/`](../admin-panel/README.md), cited here as "AP §n". Captain app spec [`docs/product/v1/captain-app/`](../captain-app/README.md). Customer app spec [`docs/product/v1/customer-app/`](../customer-app/README.md). Arabic V1 plan page: https://claude.ai/artifact/8XR91QrZHk73nRHdu7E1q6 (section 19). BeeOrder merchant research: `02-merchant-side.md` (kept outside this repository). Technology stack: [`docs/architecture/`](../../../architecture/README.md) |

## How these files are organised

Each section of the original document is one file, and a long section is a folder with one file per subsection. Section numbers are unchanged, so a citation such as "RA §n" still finds its place: the file name starts with the section number, and a subsection file inside a folder starts with the subsection number.

§19 «Changes made to the admin panel spec» was removed on 2026-11-04 after a check confirmed that every change it listed is in the target documents. The git history keeps it. The section numbers after it are unchanged.

## Contents

| Section                                       | File                                                                                     |
| --------------------------------------------- | ---------------------------------------------------------------------------------------- |
| 0. How to use this document                   | [00-how-to-use-this-document.md](00-how-to-use-this-document.md)                         |
| 1. Context and principles                     | [01-context-and-principles.md](01-context-and-principles.md)                             |
| 2. Decisions                                  | [02-decisions.md](02-decisions.md)                                                       |
| 3. Glossary                                   | [03-glossary.md](03-glossary.md)                                                         |
| 4. Platforms and technical foundations        | [04-platforms-and-technical-foundations.md](04-platforms-and-technical-foundations.md)   |
| 5. Accounts, sign-in and roles                | [05-accounts-sign-in-and-roles.md](05-accounts-sign-in-and-roles.md)                     |
| 6. Navigation                                 | [06-navigation.md](06-navigation.md)                                                     |
| 7. Restaurant status                          | [07-restaurant-status.md](07-restaurant-status.md)                                       |
| 8. Orders                                     | [08-orders/README.md](08-orders/README.md)                                               |
| 9. Menu                                       | [09-menu.md](09-menu.md)                                                                 |
| 10. Status and hours (owners)                 | [10-status-and-hours.md](10-status-and-hours.md)                                         |
| 11. Reports (owners)                          | [11-reports.md](11-reports.md)                                                           |
| 12. Money (owners)                            | [12-money.md](12-money.md)                                                               |
| 13. Ratings (owners)                          | [13-ratings.md](13-ratings.md)                                                           |
| 14. Staff, devices and settings               | [14-staff-devices-and-settings.md](14-staff-devices-and-settings.md)                     |
| 15. Support                                   | [15-support.md](15-support.md)                                                           |
| 16. Notifications and sounds                  | [16-notifications-and-sounds.md](16-notifications-and-sounds.md)                         |
| 17. Owner web portal «بوابة المطعم» (R15)     | [17-owner-web-portal.md](17-owner-web-portal.md)                                         |
| 18. Server commands                           | [18-server-commands.md](18-server-commands.md)                                           |
| 20. Not in the restaurant app V1              | [20-not-in-the-restaurant-app-v1.md](20-not-in-the-restaurant-app-v1.md)                 |
| 21. Open items (these do not block the build) | [21-open-items.md](21-open-items.md)                                                     |
| 22. Definition of done (restaurant app V1)    | [22-definition-of-done.md](22-definition-of-done.md)                                     |
| Appendix A. Settings                          | [appendix-a-settings.md](appendix-a-settings.md)                                         |
| Appendix B. Main Arabic UI strings            | [appendix-b-main-arabic-ui-strings.md](appendix-b-main-arabic-ui-strings.md)             |
| Appendix C. Reason lists used by the app      | [appendix-c-reason-lists-used-by-the-app.md](appendix-c-reason-lists-used-by-the-app.md) |
