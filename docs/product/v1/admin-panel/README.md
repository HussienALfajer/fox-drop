# FOX DROP V1 — Admin Panel Specification

| | |
|---|---|
| Product | FOX DROP, a food delivery platform launching in Azaz, Syria, then expanding city by city |
| Scope | V1, the first version that completes a full order cycle |
| Component | Admin panel «لوحة الإدارة», a web application |
| Status | Approved by the owner on 2026-11-02 (decisions in §2) |
| Audience | Engineers and coding agents (Claude Code) who build the panel and the server rules it controls |
| UI language | Arabic only, right to left |
| Related | Restaurant app spec: [`docs/product/v1/restaurant-app/`](../restaurant-app/README.md). Captain app spec: [`docs/product/v1/captain-app/`](../captain-app/README.md). Customer app spec: [`docs/product/v1/customer-app/`](../customer-app/README.md). Arabic V1 plan page: https://claude.ai/artifact/8XR91QrZHk73nRHdu7E1q6 (sections 17–32). BeeOrder research: kept outside this repository. Technology stack: [`docs/architecture/`](../../../architecture/README.md) |

## How these files are organised

Each section of the original document is one file, and a long section is a folder with one file per subsection. Section numbers are unchanged, so a citation such as "AP §n" still finds its place: the file name starts with the section number, and a subsection file inside a folder starts with the subsection number.

§8, the domain reference shared by all four specs, lives in [`docs/domain/`](../../../domain/README.md).

## Contents

| Section | File |
|---|---|
| 0. How to use this document | [00-how-to-use-this-document.md](00-how-to-use-this-document.md) |
| 1. Context and principles | [01-context-and-principles.md](01-context-and-principles.md) |
| 2. Owner decisions (2026-11-02) | [02-owner-decisions.md](02-owner-decisions.md) |
| 3. Glossary | [03-glossary.md](03-glossary.md) |
| 4. Platform foundations the panel relies on | [04-platform-foundations-the-panel-relies-on.md](04-platform-foundations-the-panel-relies-on.md) |
| 5. Access and security | [05-access-and-security.md](05-access-and-security.md) |
| 6. Roles and permissions | [06-roles-and-permissions.md](06-roles-and-permissions.md) |
| 7. Global layout and navigation | [07-global-layout-and-navigation.md](07-global-layout-and-navigation.md) |
| 8. Domain reference | [../../../domain/README.md](../../../domain/README.md) |
| 9. Modules | [09-modules/README.md](09-modules/README.md) |
| 10. What the panel pushes to the apps | [10-what-the-panel-pushes-to-the-apps.md](10-what-the-panel-pushes-to-the-apps.md) |
| 11. Operating rhythm | [11-operating-rhythm.md](11-operating-rhythm.md) |
| 12. Not in the V1 admin panel | [12-not-in-the-v1-admin-panel.md](12-not-in-the-v1-admin-panel.md) |
| 13. Open items (these do not block the build) | [13-open-items.md](13-open-items.md) |
| 14. Definition of done (V1 admin panel) | [14-definition-of-done.md](14-definition-of-done.md) |
| Appendix A. Settings catalogue | [appendix-a-settings-catalogue.md](appendix-a-settings-catalogue.md) |
| Appendix B. Default reason lists (editable in Content) | [appendix-b-default-reason-lists.md](appendix-b-default-reason-lists.md) |
| Appendix C. Arabic labels for statuses and outcomes | [appendix-c-arabic-labels-for-statuses-and-outcomes.md](appendix-c-arabic-labels-for-statuses-and-outcomes.md) |
