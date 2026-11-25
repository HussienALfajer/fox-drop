# D.P1 The component registry, the web-first rule and one card per component

Status: Planned · Tier: T2 · Branch: `feat/component-registry`
Spec: architecture §9.3, §9.6–§9.9 (rewritten here); workflow §1 item 7, §3.1 · Definition of done: the owner decision of 2026-11-25 (web components are the single design reference) is written and checked by a test; the 51 separate «Flutter ·» cards are gone and each component with both sides has one card, the live web component with its Flutter golden beneath.

## Goal

One file names every component once, with its web and Flutter names, the surfaces that use it and the group it sits in, and a test keeps it true. The architecture says the web component is the reference: sheet, then `ui-web`, then `core_ui` copied from it. The owner opens the Design System and sees one card per component: the live, touchable web component, then «Flutter» and its golden underneath; the 17 Flutter-only components keep an image card marked «Web twin pending» until D.P3 to D.P6 build them.

## Plan

1. Docs: architecture §9.6–§9.9 and §9.3 (the web component is the reference; "same design" means the same anatomy, sizes, states, colours, copy and API names, with the platform's own behaviour written in each component's README; phone-only components; one Design System card per component; the parity check of D.P2); §9.9 step 5 (a missing component is built web first, then Flutter from it); workflow §1 item 7 and §3.1 (web side before Flutter side). The owner's waiver of 2026-11-25: the 17 twins copy the current `core_ui` design and goldens, with no new sheet.
2. Registry: `packages/design-tokens/components.json` replaces `packages/core_ui/design-system/cards.json`. One entry per component: `name` (the web name, the key), `web` (export or null), `flutter` (widget or null), `group` (Actions, Forms, Data, Overlays, Navigation), `surfaces` (customer, captain, restaurant, portal, panel, from the spec sections that use it), `phoneOnly` (no portal or panel surface), `summary`, `golden` (the Flutter card image). `pendingWeb`: the 17 Flutter-only names.
3. `src/design-system-build.ts` reads the registry instead of `cards.json`, and writes no separate Flutter card for a component with a web twin (the Flutter asset group stays as the image store; a pending one keeps its card, retitled). `design_system_cards_test.dart` and its comment point at the registry.
4. `packages/ui-web/scripts/docs.ts`: each preview ends with the Flutter section (the golden from the asset store, by the registry's `golden`); each README gains «Flutter: `<widget>`» and the platform differences line.
5. `packages/design-tokens/design-system/README.md`: the stale «Not synced» line (Flutter widgets "not carried") rewritten.
6. Sync the Design System (`packages/design-tokens/CLAUDE.md` «Sync», without the Guide step) and render each card as the system loads it.

Files (hand-written count, 17): `docs/architecture/09-design-system.md`, `docs/process/development-workflow.md`, `packages/design-tokens/components.json` (new), `packages/core_ui/design-system/cards.json` (removed), `packages/design-tokens/src/design-system-build.ts`, `src/design-system-build.test.ts`, `src/components.test.ts` (new), `packages/design-tokens/design-system/README.md`, `packages/design-tokens/CLAUDE.md`, `packages/core_ui/test/golden/design_system_cards_test.dart` (comment), `packages/ui-web/scripts/docs.ts`, `packages/ui-web/scripts/design-system.ts`, `packages/ui-web/test/design-system.test.ts`, `docs/code/packages/design-tokens.md`, `docs/code/packages/ui-web.md`, `docs/roadmap.md`, this file.

Tests written first (locked in the red phase):

- `src/components.test.ts`: every `ui-web` export in `COMPONENTS` and every public `core_ui` widget has exactly one entry; an entry without a web twin must be in `pendingWeb`; a name in `pendingWeb` that now has a twin fails until removed; every `surfaces` value is known; `phoneOnly` matches `surfaces`.
- The design-system tests: the build reads the registry; a twin's preview carries its golden; no `project/components/Fox*` card for a component with a web twin; a pending one has exactly one card.

## Stopped at

Not started.

## Evidence

- `node scripts/verify.mjs --changed`:
- The published system checked card by card (screenshots outside the repository).
- Review: `reviewer` at medium, short list.

## Before deploying

Nothing.

## To check on staging

Nothing new; the owner opens the Design System.

## Notes for the next session

Surfaces come from the specs (RA, CA, CU, AP sections that use each component); one that is unclear goes to the owner, never guessed. The preview needs the blob ids, so the Flutter section is written by the `--blobs` run. The sync publishes the Design System only: the Guide and the other canvases (the customer screens, the component proposals) are not touched until every D.P slice is done (owner, 2026-11-25). The customer screens (D.11 onward) are paused by the owner (2026-11-25).
