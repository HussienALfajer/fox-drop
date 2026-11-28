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

| Name                  | Layer  | Used by  | Status   | Figma          | Code | Not to confuse with                                                                                  |
| --------------------- | ------ | -------- | -------- | -------------- | ---- | ---------------------------------------------------------------------------------------------------- |
| Core/Button           | Core   | Customer | Proposed | `3:65`         |      | Core/Icon button, Core/Chip. States: Default, Pressed, Loading, Disabled × Primary, Secondary, Ghost |
| Core/Icon button      | Core   | Customer | Proposed | `51:94`        |      | Core/Button. States: Default, Pressed, Disabled                                                      |
| Core/Text field       | Core   | Customer | Proposed | `5:70`         |      | Core/Phone field, Core/Search field. States: Default, Filled, Focused, Error, Disabled               |
| Core/Phone field      | Core   | Customer | Proposed | `5:46`         |      | Core/Text field. States: Default, Focused, Valid, Error, Disabled                                    |
| Core/Search field     | Core   | Customer | Proposed | `55:58`        |      | Core/Text field                                                                                      |
| Core/OTP cell         | Core   | Customer | Proposed | `5:58`         |      | States: Empty, Active, Filled, Error, Success                                                        |
| Core/Checkbox         | Core   | Customer | Proposed | `3:77`         |      | Core/Choice. States: Default, Error, Disabled                                                        |
| Core/Choice           | Core   | Customer | Proposed | `3:85`         |      | Core/Checkbox                                                                                        |
| Core/Country row      | Core   | Customer | Proposed | `5:86`         |      |                                                                                                      |
| Core/Section label    | Core   | Customer | Proposed | `55:62`        |      |                                                                                                      |
| Core/Inline message   | Core   | Customer | Proposed | `5:100`        |      | Core/Hint. Tones: Error, Info, Success                                                               |
| Core/Hint             | Core   | Customer | Proposed | `55:91`        |      | Core/Inline message                                                                                  |
| Core/Chip             | Core   | Customer | Proposed | `55:67`        |      | Core/Button                                                                                          |
| Core/Icon tile        | Core   | Customer | Proposed | `55:95`        |      | Core/Icon button                                                                                     |
| Core/Logo mark ivory  | Core   | Customer | Proposed | `7:11`         |      |                                                                                                      |
| Core/Icon/\* (12)     | Core   | Customer | Proposed | `3:8` … `3:49` |      | Solar Linear, interim (owner, 2026-11-28)                                                            |
| Mobile/Status bar     | Mobile | Customer | Proposed | `54:53`        |      | Mockups only; the system draws it. Tones: Dark, Light                                                |
| Mobile/Home indicator | Mobile | Customer | Proposed | `54:57`        |      | Mockups only                                                                                         |
| Mobile/Top bar        | Mobile | Customer | Proposed | `54:62`        |      | Mobile/Sheet header                                                                                  |
| Mobile/Sheet header   | Mobile | Customer | Proposed | `54:70`        |      | Mobile/Top bar. The sheet is an auto-layout frame on `bg/canvas` with `radius/2xl`                   |
| Mobile/Scrim          | Mobile | Customer | Proposed | `54:83`        |      |                                                                                                      |
| Decor/Sign-in hero    | Mobile | Customer | Proposed | `55:107`       |      | Decor/Brand corner                                                                                   |
| Decor/Brand corner    | Mobile | Customer | Proposed | `55:123`       |      | Decor/Sign-in hero                                                                                   |

The six sign-in screens live in «FOX DROP — Customer app» (`FhvOwKGrGEv6p3JnIBHOof`), built only from these instances.
