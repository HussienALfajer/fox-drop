# Tasks

The handover note between sessions: the current task, its branch, its plan, and where work stopped. Replace it when a task starts; keep it current while the task runs. At most 8 KB: the notes of earlier slices live in `docs/slice-notes.md`.

## Current task

D.1b Brand expression (architecture §9.12, `docs/roadmap.md` Phase D): each §9.12 item discussed with the owner in chat, one at a time, with options and a recommendation; `docs/brand/expression.md` is written only after the owner decides.

- **Branch:** `docs/brand-expression`.

### Plan

- [x] Principles and personality.
- [x] Signature shape.
- [x] Motion language.
- [x] Map style.
- [x] Illustration and photos.
- [ ] Full palette (discussing).
- [ ] Arabic typography.
- [ ] Voice and tone.
- [ ] Device budgets.
- [ ] First icon set.
- [ ] Write `docs/brand/expression.md` from the decisions; mark §9.12 decided; the owner approves the brief.
- [ ] Pull request; merge when its checks pass.

Decided so far (owner, 2026-11-22):

- Personality: «الجار الشاطر», the clever, quick, warm neighbour we know. The fox is wit and speed, the drop is delivery to your door; orange carries warmth and appetite, blue carries trust in numbers and states; friendly, never clowning. Rejected: loud and playful (hurts trust with cash and dense screens), calm premium (loses appetite, breaks the 30% orange).
- Principles, ordered; the higher one wins a conflict: (1) clear before beautiful: amount, time and state read at a glance; (2) honest numbers: every price, fee and time shown before the user commits, no surprise at the door; (3) light as a fox: fewest steps, felt speed, works on a low-end Android phone and a weak network; (4) each screen its moment: captain in the sun with one hand, kitchen alert seen from afar, dense panel with the keyboard; (5) local and warm: Arabic first, people's words, calm in errors, every error says what to do next.
- Signature shape: measured presence. The drop appears where it means "a place" or "on its way to you": the map pins (restaurant, customer, captain: drops told apart by icon and colour), the loading indicator (a drop filling), the order-confirmed moment (the fox leaving the drop), the frame of empty-state illustrations. Never on cards, buttons, inputs, anything pressed or typed in, never cropping a restaurant logo or food photo; in the panel only as map pins. The "drop corner" on cards (three large radii, one smaller) may be tried in a D.3 direction and added later.
- Motion: "motion with meaning". Durations fast 100 ms (press, state toggle), base 200 ms (appear, disappear), slow 300 ms (screen transitions), a signature moment at most 1.2 s; calm easing, no bounce; transitions follow RTL (the next screen enters from the end side). Two signature moments only: order confirmed (the fox leaps out of the drop, straight into tracking, never blocking, skippable with a tap) and delivered (the drop settles at the door, then rating). The captain's pin glides along the route line between the 10-second points; after 30 s without an update it stops and shows «آخر تحديث قبل …», never motion without a fact behind it. Per surface: captain's new offer enters strongly with a pulse, a 45-second countdown ring and the C3 sound; restaurant's new order pulses until accepted; panel almost still (a changed row lights briefly). Haptics: light on order confirmed and add to cart, a distinct pattern for the captain's new offer, none in the restaurant app (sound and light there). Reduced motion: fades or instant, signature moments become a still image, the pin jumps; haptics stay. Motion is drawn in code or small vector files, no video or heavy animation (technique settled under device budgets).
- Map: our own "ivory map", Protomaps' style recoloured: faint ivory land, white roads with warm grey edges, pale water from our blue, calm green parks; no orange in the base map (kept for our pins and route). Arabic names (`name:ar`, else the name); most points of interest hidden, landmarks kept (mosques, schools, hospitals, roundabouts); never a competitor's logo. Pins (drops, never told apart by colour alone): captain orange with the vehicle icon and a heading arrow, largest; restaurant filled blue with a plate; customer ivory with a blue edge and a house. Route: dashed captain to restaurant before pickup; after pickup solid accessible orange, width 5 with a white casing; the travelled part disappears. Captain app always uses a high-contrast sunlight style (darker road edges, larger names, fewer points of interest, route width 8), no automatic switching; the 7:1 target is settled under the palette. Panel: the same ivory map, small pins, captain state (free, busy, offline) by colour and a symbol. Night style waits for dark mode; until then the captain uses the sunlight style at night, to be tried on a device at night in L.9.
- Illustration: in the three phone apps, the fox in simple flat scenes, lines at the icon stroke, the three brand colours only, inside the drop frame; in the panel and the restaurant web portal, a large icon in a drop with text. First set about 8 SVG scenes (empty cart, no search results, outside the delivery zone, offline, general error, restaurant closed, captain with no orders yet, restaurant with no new orders), drawn in D.3 and D.5, each approved by the owner.
- Missing photos: a dish without a photo is a text row without an image slot, never a fake placeholder; a restaurant without a cover shows its logo centred on a light tint; without a logo, its first letter in a rounded square (not a drop).
- Food photo guide (given to restaurants, applied by the panel on review): dish 1:1, cover 16:9, at least 1080 px; daylight, no flash; plain background, the dish fills about 70%, from above or at 45°; no text, phone numbers, watermarks, photos from the internet or AI-generated photos of a real dish. V1: each restaurant photographs its own dishes with its phone, from the guide with a good and a bad example (no platform photography).

## Waiting for the owner

- From `test/money-properties` (merged, PR 246): what an outcome posts when a restaurant-funded discount exceeds what the clearing account holds (`outcomeEntries` throws today; the property skips that case).

- D.1: the `FONTS_DEPLOY_KEY` secret (the private half of a read-only deploy key on `fox-drop-fonts`, no expiry; commands in the pull request thread) in the repository's Actions secrets; until then the CI fetch step skips. (The owner confirmed on 2026-11-21 that he holds the right to use every font in the pack, CoFo included, in the apps.) The meaning of the `broken-edges` icon SVGs and of the `variant-b/c` icons.
- Phase 3 of `docs/claude-code-workflow.md`: the phase 4 session started at 75.7K tokens with one MCP delta (goal: under 45K, none). Left: the `marketing` and `social-media-skills` plugins, off only in the app's settings.
- Phase 6 items 1 and 2 (owner decision 2026-11-21): `autoCompactWindow: 350000` and every slice in two sessions, planning then build (`build-slice`). L.1c was the first trial; record its measurement (`scripts/claude-audit.mjs`, against L.1a and L.1b) in `docs/claude-code-workflow.md`.
- L.1c's choices to confirm (`docs/slice-notes.md` «Left from L.1c»): the 1 km fit of a kept read, and the rest under «Decided by us».

## After that

D.2 (`feat/design-tokens`), then L.2 The permission matrix (branch `test/permission-matrix`; read first: architecture §18.1, AP §6 and §14 item 2, RA §22 item 2, the AP-2 and RA-2 rows of `docs/launch/dod-checklist.md`, `apps/server/CLAUDE.md` «Deny by default», the route table in `apps/server/src/modules/identity/admin-team.test.ts`), then the rest of launch readiness from L.3 (`docs/roadmap.md`).

Branches of Phase D: D.2 `feat/design-tokens`, D.3 `feat/design-directions`, D.4 `feat/design-system-project`, D.5 `feat/icon-set`, D.6 `feat/ui-web`, D.7 `feat/core-ui`. Branches of the later slices: L.3 `feat/captain-simulator`, L.4 `test/load-k6`, L.5 `chore/pgbackrest`, L.6 `feat/monitoring-alerts`, L.7 `chore/production-environment`, L.8 `test/patrol-e2e`, L.9 `docs/device-lab`, L.10 `docs/staging-rehearsal`, L.11 `chore/launch`.
