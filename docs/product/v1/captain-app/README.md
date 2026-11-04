# FOX DROP V1 — Captain App Specification

| | |
|---|---|
| Product | FOX DROP, a food delivery platform launching in Azaz, Syria, then expanding city by city |
| Scope | V1, the first version that completes a full order cycle |
| Component | The captain app «تطبيق الكابتن» for Android and iOS |
| Status | Approved by the owner on 2026-11-03 (decisions in §2) |
| Audience | Engineers and coding agents (Claude Code) who build the captain app and the server rules behind it |
| UI language | Arabic only, right to left |
| Related | Admin panel spec [`docs/product/v1/admin-panel/`](../admin-panel/README.md), cited as "AP §n". Restaurant app spec [`docs/product/v1/restaurant-app/`](../restaurant-app/README.md), cited as "RA §n". Customer app spec [`docs/product/v1/customer-app/`](../customer-app/README.md). Arabic V1 plan page: https://claude.ai/artifact/8XR91QrZHk73nRHdu7E1q6 (section 20). BeeOrder captain research: `03-captain.md` (kept outside this repository). Technology stack: [`docs/architecture/`](../../../architecture/README.md) |

## How these files are organised

Each section of the original document is one file, and a long section is a folder with one file per subsection. Section numbers are unchanged, so a citation such as "CA §n" still finds its place: the file name starts with the section number, and a subsection file inside a folder starts with the subsection number.

§16 «Changes made to the other specs» was removed on 2026-11-04 after a check confirmed that every change it listed is in the target documents. The git history keeps it. The section numbers after it are unchanged.

## Contents

| Section | File |
|---|---|
| 0. How to use this document | [00-how-to-use-this-document.md](00-how-to-use-this-document.md) |
| 1. Context and principles | [01-context-and-principles.md](01-context-and-principles.md) |
| 2. Decisions | [02-decisions.md](02-decisions.md) |
| 3. Glossary | [03-glossary.md](03-glossary.md) |
| 4. Platforms and technical foundations | [04-platforms-and-technical-foundations.md](04-platforms-and-technical-foundations.md) |
| 5. Joining | [05-joining.md](05-joining.md) |
| 6. Navigation | [06-navigation.md](06-navigation.md) |
| 7. Availability | [07-availability.md](07-availability.md) |
| 8. Offers | [08-offers.md](08-offers.md) |
| 9. The active order | [09-the-active-order/README.md](09-the-active-order/README.md) |
| 10. Money | [10-money.md](10-money.md) |
| 11. Performance and rules «أدائي» | [11-performance-and-rules.md](11-performance-and-rules.md) |
| 12. Profile «ملفي» | [12-profile.md](12-profile.md) |
| 13. Support «الدعم» | [13-support.md](13-support.md) |
| 14. Notifications and sounds | [14-notifications-and-sounds.md](14-notifications-and-sounds.md) |
| 15. Server commands | [15-server-commands.md](15-server-commands.md) |
| 17. Not in the captain app V1 | [17-not-in-the-captain-app-v1.md](17-not-in-the-captain-app-v1.md) |
| 18. Open items (these do not block the build) | [18-open-items.md](18-open-items.md) |
| 19. Definition of done (captain app V1) | [19-definition-of-done.md](19-definition-of-done.md) |
| Appendix A. Settings | [appendix-a-settings.md](appendix-a-settings.md) |
| Appendix B. Main Arabic UI strings | [appendix-b-main-arabic-ui-strings.md](appendix-b-main-arabic-ui-strings.md) |
| Appendix C. Reason lists used by the app | [appendix-c-reason-lists-used-by-the-app.md](appendix-c-reason-lists-used-by-the-app.md) |
