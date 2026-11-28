# Component registry

Every component in the design system, one line each. Search here before making a component ([`rules.md`](rules.md), Layers and naming). A line is added in the same batch that makes the component; the audit fails on a component missing here.

## Statuses

| Status     | Meaning                                                                |
| ---------- | ---------------------------------------------------------------------- |
| Planned    | Agreed, not built yet                                                  |
| Proposed   | Built in Figma, not approved                                           |
| Beta       | Approved by the owner; may still change with the next surface          |
| Stable     | Approved by the owner and, for the customer app, the designer; coded   |
| Deprecated | Replaced; the line names the replacement; removed once nothing uses it |

## Layers

**Core** any surface · **Mobile** the three apps · **Web** the panel and the portal · **Customer**, **Restaurant**, **Captain**, **Admin**, **Portal** one surface.

## Components

Figma ids are in the library file (`ITmxeo3ipw0UH5OiV0880s`). «Code» stays empty until the component is coded.

| Name                 | Layer  | Used by  | Status   | Figma          | Code | Not to confuse with                    |
| -------------------- | ------ | -------- | -------- | -------------- | ---- | -------------------------------------- |
| Core/Button          | Core   | Customer | Proposed | `3:65`         |      | Core/Icon button                       |
| Core/Icon button     | Core   | Customer | Proposed | `5:104`        |      | Core/Button                            |
| Core/Text field      | Core   | Customer | Proposed | `5:70`         |      | Core/Phone field                       |
| Core/Phone field     | Core   | Customer | Proposed | `5:46`         |      | Core/Text field                        |
| Core/OTP cell        | Core   | Customer | Proposed | `5:58`         |      |                                        |
| Core/Checkbox        | Core   | Customer | Proposed | `3:77`         |      | Core/Choice                            |
| Core/Choice          | Core   | Customer | Proposed | `3:85`         |      | Core/Checkbox                          |
| Core/Country row     | Core   | Customer | Proposed | `5:86`         |      |                                        |
| Core/Inline message  | Core   | Customer | Proposed | `5:100`        |      |                                        |
| Core/Logo mark ivory | Core   | Customer | Proposed | `7:11`         |      |                                        |
| Core/Icon/\* (12)    | Core   | Customer | Proposed | `3:8` … `3:49` |      | Style undecided (owner, 2026-11-28)    |
| Mobile/Status bar    | Mobile | Customer | Planned  |                |      | Drawn raw in the sign-in screens today |
| Mobile/Top bar       | Mobile | Customer | Planned  |                |      |                                        |
| Mobile/Bottom sheet  | Mobile | Customer | Planned  |                |      | Web/Dialog                             |
| Core/Search field    | Core   | Customer | Planned  |                |      | Core/Text field                        |
| Core/Section label   | Core   | Customer | Planned  |                |      |                                        |
| Mobile/Resend timer  | Mobile | Customer | Planned  |                |      |                                        |
| Decor/Sign-in hero   | Mobile | Customer | Planned  |                |      | Decor/Brand corner                     |
| Decor/Brand corner   | Mobile | Customer | Planned  |                |      | Decor/Sign-in hero                     |

The Figma names do not carry their layer prefix yet; phase 1 renames them to the names above.
