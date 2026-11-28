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

## Layers

**Core** any surface · **Mobile** the three apps · **Web** the panel and the portal · **Customer**, **Restaurant**, **Captain**, **Admin**, **Portal** one surface. Decoration is named under its layer (`Mobile/Decor/…`); the identity's assets are `Core/Brand/…`.

## Components

Figma ids are in the library file (`ITmxeo3ipw0UH5OiV0880s`). «Code» names the widget or component file once coded.

The brand components are the identity pack's SVGs on the library's «🏷️ Brand» page ([`../brand/README.md`](../brand/README.md)); they keep the identity's literal colours (rules.md, Components and screens). No other component exists yet: components are added flow by flow at the polish step ([`README.md`](README.md), How design work runs).

| Name                                            | Layer | Used by | Status   | States or variants | Figma   | Code | Not to confuse with     |
| ----------------------------------------------- | ----- | ------- | -------- | ------------------ | ------- | ---- | ----------------------- |
| Core/Brand/Lockup/Horizontal Arabic             | Core  | All     | Proposed |                    | `76:2`  |      | The other three lockups |
| Core/Brand/Lockup/Horizontal Latin              | Core  | All     | Proposed |                    | `76:5`  |      | The other three lockups |
| Core/Brand/Lockup/Vertical Arabic               | Core  | All     | Proposed |                    | `76:8`  |      | The other three lockups |
| Core/Brand/Lockup/Vertical Latin                | Core  | All     | Proposed |                    | `76:11` |      | The other three lockups |
| Core/Brand/Mark/Orange                          | Core  | All     | Proposed |                    | `76:14` |      | Core/Brand/App icon/*   |
| Core/Brand/Mark/Blue                            | Core  | All     | Proposed |                    | `76:17` |      | Core/Brand/App icon/*   |
| Core/Brand/Mark/Ivory                           | Core  | All     | Proposed |                    | `76:20` |      | Core/Brand/App icon/*   |
| Core/Brand/Mark/Orange on ivory square          | Core  | All     | Proposed |                    | `76:23` |      | Core/Brand/App icon/*   |
| Core/Brand/Mark/Orange on ivory drop            | Core  | All     | Proposed |                    | `76:26` |      | Core/Brand/App icon/*   |
| Core/Brand/Mark/Blue on ivory square            | Core  | All     | Proposed |                    | `76:29` |      | Core/Brand/App icon/*   |
| Core/Brand/Mark/Blue on ivory drop              | Core  | All     | Proposed |                    | `76:32` |      | Core/Brand/App icon/*   |
| Core/Brand/Mark/Ivory on orange square          | Core  | All     | Proposed |                    | `76:35` |      | Core/Brand/App icon/*   |
| Core/Brand/Mark/Ivory on blue square            | Core  | All     | Proposed |                    | `76:38` |      | Core/Brand/App icon/*   |
| Core/Brand/Mark/Ivory on blue drop              | Core  | All     | Proposed |                    | `76:41` |      | Core/Brand/App icon/*   |
| Core/Brand/App icon/White fox on orange/Square  | Core  | All     | Proposed |                    | `76:44` |      | Core/Brand/Mark/*       |
| Core/Brand/App icon/White fox on orange/Rounded | Core  | All     | Proposed |                    | `76:47` |      | Core/Brand/Mark/*       |
| Core/Brand/App icon/Black fox on ivory/Square   | Core  | All     | Proposed |                    | `76:50` |      | Core/Brand/Mark/*       |
| Core/Brand/App icon/Black fox on ivory/Rounded  | Core  | All     | Proposed |                    | `76:53` |      | Core/Brand/Mark/*       |
| Core/Brand/App icon/Ivory fox on black/Square   | Core  | All     | Proposed |                    | `76:56` |      | Core/Brand/Mark/*       |
| Core/Brand/App icon/Ivory fox on black/Rounded  | Core  | All     | Proposed |                    | `76:59` |      | Core/Brand/Mark/*       |

## Surface components

Built on each surface file's components page («🧩 Customer components» in `FhvOwKGrGEv6p3JnIBHOof`). None yet.

| Name | Layer | Status | States or variants | Figma | Code | Not to confuse with |
| ---- | ----- | ------ | ------------------ | ----- | ---- | ------------------- |
