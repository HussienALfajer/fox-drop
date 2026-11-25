# D.P6 Web twins 4: date and time fields

Status: Planned · Tier: T2 · Branch: `feat/web-twins-date-time`
Spec: architecture §9.6, §9.9 (as rewritten by D.P1); D.8 (the Flutter pickers) · Definition of done: `DateField` and `TimeField` exist in `ui-web`, match their Flutter goldens, and `pendingWeb` is empty.

## Goal

The date and time fields and their pickers are on the web too, so every component of the system is live in the Design System and on the canvas.

## Plan

0. Design checkpoint: waived (owner, 2026-11-25); copies of `FoxDateField` and `FoxTimeField` and their goldens (the field, the open calendar, the open time picker), checked by the side-by-side image.
1. Tokens: the pickers' values in `tokens/component/input.json` (it holds the fields already), `generate`, version and `CHANGELOG.md`.
2. Web: the two fields on the existing `Field` frame, the calendar and time picker in a popover, keyboard operable (arrows, Page Up and Down, Home, End), the week from Saturday, Arabic month names from the app's strings passed in, Western digits. Not phone-only: the portal and the panel can use them (registry `surfaces`).
3. `pendingWeb` removed from the registry and its test, now that it is empty.
4. Sync the Design System only: not the Guide or any other canvas until every D.P slice is done (owner, 2026-11-25).

Files (hand-written count, 15): two components × 3 = 6, plus the shared calendar (component and test) = 8; `input.json`, `packages/design-tokens/package.json`, `CHANGELOG.md`, `src/index.ts`, `scripts/bundle.ts`, `scripts/docs.ts`, `components.json`, `src/components.test.ts`.

Tests written first (locked in the red phase): the calendar's keyboard and RTL, a date out of range disabled, the time picker's minute steps; the registry `metrics` of the two.

## Stopped at

Not started.

## Evidence

- `node scripts/verify.mjs --changed`:
- The side-by-side images of the two.
- Review: `reviewer` at medium, short list.

## Before deploying

Nothing.

## To check on staging

Nothing new.

## Notes for the next session

After D.P5. Flutter side: D.P7.
