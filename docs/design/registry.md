# Component registry

Every component in the design system, one line each. Search here before making a component ([`rules.md`](rules.md), Layers and naming). A line is added in the same batch that makes the component. The audit's `components` list (library pages) is compared with this table after every library batch; a name in one and not the other is fixed before publishing.

## Statuses

| Status     | Meaning                                                                                               | Moved by                                |
| ---------- | ----------------------------------------------------------------------------------------------------- | --------------------------------------- |
| Planned    | Agreed, not built                                                                                     | The owner's approval of a flow's choice |
| Proposed   | Built and published; its flow is not approved yet                                                     | Claude, at the polish step              |
| Beta       | Its first flow is approved by the owner (and, for the customer app, the designer) and «Ready for dev» | Claude, when the flow is approved       |
| Stable     | Its coded widget is merged and named in «Code»                                                        | Claude, in the pull request of the code |
| Deprecated | Replaced: the line names the replacement; deleted once no file uses it                                | The owner's approval                    |

**Provisional** marks a component made for one direction of a flow that is not chosen yet; it is removed if that direction loses (rules.md, Explorations).

## Layers

**Core** any surface · **Mobile** the three apps · **Web** the panel and the portal · **Customer**, **Restaurant**, **Captain**, **Admin**, **Portal** one surface. Decoration is named under its layer (`Mobile/Decor/…`).

## Components

Figma ids are in the library file (`ITmxeo3ipw0UH5OiV0880s`). «Code» names the widget or component file once coded.

| Name                      | Layer  | Used by  | Status                                 | States or variants                                                            | Figma    | Code | Not to confuse with                 |
| ------------------------- | ------ | -------- | -------------------------------------- | ----------------------------------------------------------------------------- | -------- | ---- | ----------------------------------- |
| Core/Button               | Core   | Customer | Proposed                               | Style: Primary, Secondary, Ghost × State: Default, Pressed, Loading, Disabled | `3:65`   |      | Core/Icon button, Core/Chip         |
| Core/Icon button          | Core   | Customer | Proposed                               | State: Default, Pressed, Disabled; 48                                         | `51:94`  |      | Core/Button                         |
| Core/Text field           | Core   | Customer | Proposed                               | State: Default, Filled, Focused, Error, Disabled                              | `5:70`   |      | Core/Phone field, Core/Search field |
| Core/Phone field          | Core   | Customer | Proposed                               | State: Default, Focused, Valid, Error, Disabled                               | `5:46`   |      | Core/Text field                     |
| Core/Search field         | Core   | Customer | Proposed                               | State: Default, Focused                                                       | `55:58`  |      | Core/Text field                     |
| Core/OTP cell             | Core   | Customer | Proposed                               | State: Empty, Active, Filled, Error, Success                                  | `5:58`   |      |                                     |
| Core/Checkbox             | Core   | Customer | Proposed                               | Checked: No, Yes × State: Default, Error, Disabled                            | `3:77`   |      | Core/Choice                         |
| Core/Choice               | Core   | Customer | Proposed                               | Selected: No, Yes × State: Default, Disabled                                  | `3:85`   |      | Core/Checkbox                       |
| Core/Country row          | Core   | Customer | Proposed                               | Selected: No, Yes                                                             | `5:86`   |      |                                     |
| Core/Section label        | Core   | Customer | Proposed                               |                                                                               | `55:62`  |      |                                     |
| Core/Inline message       | Core   | Customer | Proposed                               | Tone: Error, Info, Success                                                    | `5:100`  |      | Core/Hint                           |
| Core/Hint                 | Core   | Customer | Proposed                               | Tone: Neutral, Brand                                                          | `55:91`  |      | Core/Inline message                 |
| Core/Chip                 | Core   | Customer | Proposed                               | 48 high                                                                       | `55:67`  |      | Core/Button                         |
| Core/Icon tile            | Core   | Customer | Proposed, provisional (sign-in Idea A) |                                                                               | `55:95`  |      | Core/Icon button                    |
| Core/Logo mark ivory      | Core   | Customer | Proposed                               |                                                                               | `7:11`   |      |                                     |
| Core/Icon/arrow-back      | Core   | Customer | Proposed                               | Solar Linear; points right (back in RTL)                                      | `3:8`    |      |                                     |
| Core/Icon/close           | Core   | Customer | Proposed                               | Solar Linear                                                                  | `3:11`   |      |                                     |
| Core/Icon/chevron-down    | Core   | Customer | Proposed                               | Solar Linear                                                                  | `3:14`   |      |                                     |
| Core/Icon/check           | Core   | Customer | Proposed                               | Solar Linear                                                                  | `3:17`   |      |                                     |
| Core/Icon/search          | Core   | Customer | Proposed                               | Solar Linear                                                                  | `3:21`   |      |                                     |
| Core/Icon/paste           | Core   | Customer | Proposed                               | Solar Linear                                                                  | `3:25`   |      |                                     |
| Core/Icon/chat            | Core   | Customer | Proposed                               | Solar Linear                                                                  | `3:29`   |      |                                     |
| Core/Icon/alert           | Core   | Customer | Proposed                               | Solar Linear                                                                  | `3:33`   |      |                                     |
| Core/Icon/calendar        | Core   | Customer | Proposed                               | Solar Linear                                                                  | `3:37`   |      |                                     |
| Core/Icon/shield          | Core   | Customer | Proposed                               | Solar Linear                                                                  | `3:41`   |      |                                     |
| Core/Icon/clock           | Core   | Customer | Proposed                               | Solar Linear                                                                  | `3:45`   |      |                                     |
| Core/Icon/phone           | Core   | Customer | Proposed                               | Solar Linear                                                                  | `3:49`   |      |                                     |
| Mobile/Status bar         | Mobile | Customer | Proposed                               | Tone: Dark, Light; mock-ups only                                              | `54:53`  |      |                                     |
| Mobile/Home indicator     | Mobile | Customer | Proposed                               | Mock-ups only                                                                 | `54:57`  |      |                                     |
| Mobile/Top bar            | Mobile | Customer | Proposed                               | Show title: yes, no                                                           | `54:62`  |      | Mobile/Sheet header                 |
| Mobile/Sheet header       | Mobile | Customer | Proposed                               |                                                                               | `54:70`  |      | Mobile/Top bar                      |
| Mobile/Scrim              | Mobile | Customer | Proposed                               |                                                                               | `54:83`  |      |                                     |
| Mobile/Decor/Sign-in hero | Mobile | Customer | Proposed, provisional (sign-in Idea A) |                                                                               | `55:107` |      | Mobile/Decor/Brand corner           |
| Mobile/Decor/Brand corner | Mobile | Customer | Proposed, provisional (sign-in Idea A) |                                                                               | `55:123` |      | Mobile/Decor/Sign-in hero           |

A bottom sheet is not a component: it is an auto-layout frame on `bg/canvas` with `radius/2xl` top corners, holding a Mobile/Sheet header and its rows.

## Surface components

Built on each surface file's components page («🧩 Customer components» in `FhvOwKGrGEv6p3JnIBHOof`). None yet.

| Name | Layer | Status | States or variants | Figma | Code | Not to confuse with |
| ---- | ----- | ------ | ------------------ | ----- | ---- | ------------------- |
