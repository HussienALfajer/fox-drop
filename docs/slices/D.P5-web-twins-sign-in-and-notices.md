# D.P5 Web twins 3: sign-in and the blocking notices

Status: Planned · Tier: T2 · Branch: `feat/web-twins-sign-in`
Spec: architecture §9.6, §9.9 (as rewritten by D.P1); D.11's approved screens; the cited sections of each `core_ui` widget · Definition of done: `SignInHero`, `CodePreview`, `CountrySheet`, `VersionTicket` and `ShopSign` exist in `ui-web`, match their Flutter goldens, and leave `pendingWeb`.

## Goal

The sign-in hero, the code preview, the country sheet, the update ticket and the closed-shop sign are live on the canvas and in the Design System.

## Plan

0. Design checkpoint: waived (owner, 2026-11-25); copies of the `core_ui` widgets and goldens, checked by the side-by-side image.
1. Tokens: `tokens/component/notices.json`, `generate`, version and `CHANGELOG.md`.
2. Web: each component with its story and unit test, phone-only in `src/phone.ts`. `CountrySheet` reuses the country list `PhoneField` already has on the web (D.11b), so the two never differ; its README says which to use where.
3. Sync the Design System only: not the Guide or any other canvas until every D.P slice is done (owner, 2026-11-25).

Files (hand-written count, 22): five components × 3 = 15; `notices.json`, `packages/design-tokens/package.json`, `CHANGELOG.md`, `src/phone.ts`, `scripts/bundle.ts`, `scripts/docs.ts`, `components.json`.

Tests written first (locked in the red phase): each unit test (states, RTL, the code preview's left-to-right digits, the country search in Arabic and Latin); the registry `metrics` of the five.

## Stopped at

Not started.

## Evidence

- `node scripts/verify.mjs --changed`:
- The side-by-side images of the five.
- Review: `reviewer` at medium, short list.

## Before deploying

Nothing.

## To check on staging

Nothing new.

## Notes for the next session

After D.P4. Flutter side: D.P7.
