# Component registry

Every component in the design system, one line each. Search here before making a component ([`rules.md`](rules.md), Layers and naming). A line is added in the same batch that makes the component. The audit's `components` list (library pages) is compared with this table after every library batch; a name in one and not the other is fixed before publishing.

## Statuses

| Status     | Meaning                                                                                                           | Moved by                                |
| ---------- | ----------------------------------------------------------------------------------------------------------------- | --------------------------------------- |
| Planned    | Agreed, not built                                                                                                 | The owner's approval of a flow's choice |
| Proposed   | Built and published; its flow is not approved yet                                                                 | Claude, at the polish step              |
| Beta       | Its first flow is approved by the owner (and, for the customer app, the designer) and «Ready for dev»             | Claude, when the flow is approved       |
| Stable     | Its coded widget is merged and named in «Code»                                                                    | Claude, in the pull request of the code |
| Deprecated | Replaced: the line names the replacement; deleted once no file uses it                                            | The owner's approval                    |
| Asset      | An identity asset from [`../brand/`](../brand/README.md), approved with the identity pack, not designed in a flow | The owner's identity pack               |

## Layers

**Core** any surface · **Mobile** the three apps · **Web** the panel and the portal · **Customer**, **Restaurant**, **Captain**, **Admin**, **Portal** one surface. Decoration is named under its layer (`Mobile/Decor/…`); the identity's assets are `Core/Brand/…`.

## Components

Figma ids are in the library file (`ITmxeo3ipw0UH5OiV0880s`). «Key» is the component key that surface files import by (`importComponentByKeyAsync`); it survives a republish, a node id does not survive a rebuild. «States or variants» is copied into the audit's `STATES` in the batch that builds an interactive component. «Code» names the widget or component file once coded.

The brand components are the identity pack's SVGs on the library's «🏷️ Brand» page ([`../brand/README.md`](../brand/README.md)); they keep the identity's literal colours (rules.md, Components and screens). No other component exists yet: components are added flow by flow at the polish step ([`README.md`](README.md), How design work runs).

| Name                                            | Layer | Used by | Status | States or variants | Figma   | Key                                        | Code | Not to confuse with     |
| ----------------------------------------------- | ----- | ------- | ------ | ------------------ | ------- | ------------------------------------------ | ---- | ----------------------- |
| Core/Brand/Lockup/Horizontal Arabic             | Core  | All     | Asset  |                    | `76:2`  | `cf7ec829673e78fa485777cef6aebf9e44408c28` |      | The other three lockups |
| Core/Brand/Lockup/Horizontal Latin              | Core  | All     | Asset  |                    | `76:5`  | `5acf9f4d90a54b32b7f7513a69ed78e2cd8d09ce` |      | The other three lockups |
| Core/Brand/Lockup/Vertical Arabic               | Core  | All     | Asset  |                    | `76:8`  | `14da3b80b42308f22b64a943f20f7822db132cc8` |      | The other three lockups |
| Core/Brand/Lockup/Vertical Latin                | Core  | All     | Asset  |                    | `76:11` | `b9a81b8e6a1fb24f002f6245f0a116a5083c1464` |      | The other three lockups |
| Core/Brand/Mark/Orange                          | Core  | All     | Asset  |                    | `76:14` | `40fbc20ba44ddd92eabdef1a67d66d6a56734780` |      | Core/Brand/App icon/*   |
| Core/Brand/Mark/Blue                            | Core  | All     | Asset  |                    | `76:17` | `bb16f739da1d6bc1585eaca1f92f15ad2374ff09` |      | Core/Brand/App icon/*   |
| Core/Brand/Mark/Ivory                           | Core  | All     | Asset  |                    | `76:20` | `e01bd417dcbbb4bc6114ef342b756b891de24d57` |      | Core/Brand/App icon/*   |
| Core/Brand/Mark/Orange on ivory square          | Core  | All     | Asset  |                    | `76:23` | `55d051dda991be987a3aada795ccfa8e8986b4ad` |      | Core/Brand/App icon/*   |
| Core/Brand/Mark/Orange on ivory drop            | Core  | All     | Asset  |                    | `76:26` | `23cdad28e39712da1891d134fe7cf0593c08de9b` |      | Core/Brand/App icon/*   |
| Core/Brand/Mark/Blue on ivory square            | Core  | All     | Asset  |                    | `76:29` | `9356fbcc6bf51aa17ec27c13c2b72ff328b1b7f4` |      | Core/Brand/App icon/*   |
| Core/Brand/Mark/Blue on ivory drop              | Core  | All     | Asset  |                    | `76:32` | `4e4b69284b8650abb220e10ba28abee230e04455` |      | Core/Brand/App icon/*   |
| Core/Brand/Mark/Ivory on orange square          | Core  | All     | Asset  |                    | `76:35` | `a1f3afdb9952ccc6154c6f5b23556b948e2b979d` |      | Core/Brand/App icon/*   |
| Core/Brand/Mark/Ivory on blue square            | Core  | All     | Asset  |                    | `76:38` | `5d62c6411cbef73eb449f44de8c8a0448d8efa2c` |      | Core/Brand/App icon/*   |
| Core/Brand/Mark/Ivory on blue drop              | Core  | All     | Asset  |                    | `76:41` | `3aaf255396e7ad406627e1e447a1dfe28b4f6a3f` |      | Core/Brand/App icon/*   |
| Core/Brand/App icon/White fox on orange/Square  | Core  | All     | Asset  |                    | `76:44` | `0f8662248f323c92dc1b7c56c66fa9c3c93be135` |      | Core/Brand/Mark/*       |
| Core/Brand/App icon/White fox on orange/Rounded | Core  | All     | Asset  |                    | `76:47` | `2ec53d1e2ca0d58ee1f5451ad76f3a5babe410eb` |      | Core/Brand/Mark/*       |
| Core/Brand/App icon/Black fox on ivory/Square   | Core  | All     | Asset  |                    | `76:50` | `a77949d4085a50509643fbead350c092e1222314` |      | Core/Brand/Mark/*       |
| Core/Brand/App icon/Black fox on ivory/Rounded  | Core  | All     | Asset  |                    | `76:53` | `c47c4fc1a7c35213bbde89941a7e9d010fcd0766` |      | Core/Brand/Mark/*       |
| Core/Brand/App icon/Ivory fox on black/Square   | Core  | All     | Asset  |                    | `76:56` | `86c6cabbfb4b6e2e79c8b288cfe7b0597358bbf1` |      | Core/Brand/Mark/*       |
| Core/Brand/App icon/Ivory fox on black/Rounded  | Core  | All     | Asset  |                    | `76:59` | `04f53c75087a27e301c491272d41d909da100237` |      | Core/Brand/Mark/*       |

## Surface components

Built on each surface file's components page («🧩 Customer components» in `FhvOwKGrGEv6p3JnIBHOof`). None yet.

| Name | Layer | Status | States or variants | Figma | Key | Code | Not to confuse with |
| ---- | ----- | ------ | ------------------ | ----- | --- | ---- | ------------------- |
