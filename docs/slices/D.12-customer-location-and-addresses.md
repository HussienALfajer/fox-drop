# D.12 Customer screens 2: location and addresses

Status: Planned · Tier: T2 · Branch: `feat/customer-screens-location`
Spec: architecture §9.5 (R1 to R20), §9.9, §7.2 (maps); CU §4.4 (location permission), §7.1 to §7.4, §13 («عناويني»); brand expression's map style · Definition of done: the D.12 line of `docs/roadmap.md`; keeps CU §19 items 4 to 6 passing

## Goal

Choosing where to deliver, styled: the first open «أين نوصل طلبك؟», the pin on the map, «قريباً في منطقتك» with the vote, the no-coverage message, the address picker and the address form, and «عناويني». The checkout's own address section comes in D.15 and reuses this batch's picker and form.

## Screen inventory (§9.9 step 1)

Sizes, R6 states and the cycle as in D.11.

| Screen                                     | Cites             | Purpose and main action                                   | States beyond R6                                                                                                                                                                  | Data and actions                                                    |
| ------------------------------------------ | ----------------- | --------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------- |
| First location «أين نوصل طلبك؟»            | CU §7.1, §4.4     | «استخدم موقعي الحالي», or «اختر على الخريطة»              | Permission asked, refused, or off in settings; position not found; checking the point                                                                                             | `GET /v1/customer/location`                                         |
| Pin «اختر على الخريطة» (`pin_screen.dart`) | CU §7.1, §7.4     | Move the map under the fixed pin, confirm                 | Zoom below 16 («قرّب الخريطة لتحديد موقعك بدقة»); the current-location adjustment above 100 m; outside every zone; tiles not loaded                                               | `GET /v1/customer/location`, the tiles (`core_maps`)                |
| «قريباً في منطقتك»                         | CU §7.2           | «صوّت لمنطقتك»                                            | Voted («شكراً، سنخبرك عندما نصل إلى منطقتك»); already voted from this device; choose another point                                                                                | `POST /v1/customer/zone-votes`                                      |
| No coverage                                | CU §7.1           | Choose another point                                      | Inside a zone, no restaurant covers it                                                                                                                                            | `GET /v1/customer/location`                                         |
| Address picker (sheet)                     | CU §7.1, §7.3     | Pick a saved address, the current location or a new point | A guest (no saved addresses); an address outside the active zones («خارج منطقة التوصيل حالياً», not choosable); the default                                                       | `GET /v1/customer/addresses`                                        |
| Address form (`address_form_screen.dart`)  | CU §7.3, §7.4, Q5 | «حفظ العنوان»                                             | New, editing, unsaved for one order with «احفظ هذا العنوان»; label «آخر» with its name; another contact phone with the recipient's name; each field's error; the 10-address limit | `POST`/`PUT /v1/customer/addresses[/{id}]`                          |
| «عناويني» (`addresses_screen.dart`)        | CU §7.3, §13      | Add an address                                            | Empty; the default marked; an address out of zone; the delete confirmation; at 10 addresses                                                                                       | `GET /v1/customer/addresses`, `DELETE …/{id}`, `PUT …/{id}/default` |

## Plan

0. Inventory check against `apps/customer/lib/src/location/` and `account/address*`.
1. Draw, prototype, analysis, missing components (the map pin and its zoom hint, the map frame, expected), designer pass, approval: §9.9 steps 2 to 7, as D.11 set up.
2. Code on `core_ui` and `core_maps`; add the batch's folders to the lint's paths; goldens and the comparison with the drawing; R12 run on the emulator.
3. Store review (R18): the location permission texts of Android and iOS («أثناء استخدام التطبيق» only, never in the background), asked at the first location and never at launch; the map alternative when refused. Recorded here.

Tests written first (locked in the red phase):

- R11 for every screen above.
- R14: «صوّت لمنطقتك» and «حفظ العنوان» cannot send twice; a lost answer of an address command resends the same `Idempotency-Key` (L.1c).
- R15: the first open lands on the first-location screen; the pin returns its point to its caller; Android back from the pin and the form.
- The refused permission leaves «اختر على الخريطة» working.

## Stopped at

Planned (2026-11-24); after D.11.

## Evidence

- `node scripts/verify.mjs --changed`: —
- Drawings, prototype and analysis: the screens canvas
- R12 profile run: —
- Review: —

## Before deploying

A new customer build.

## To check on staging

The owner installs fresh, refuses location then picks on the map, moves the pin outside the zones and votes, adds, edits and deletes an address.

## Notes for the next session

—
