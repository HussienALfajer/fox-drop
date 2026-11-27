# D.R1 Every component deleted; screens first, one at a time

Status: In progress · Tier: T2 · Branch: `chore/delete-components`
Spec: architecture §9.6–§9.9, workflow §1.7, §3.1, §4 · Definition of done: none closed (a reset before the customer screens)

## Goal

Every UI component of FOX DROP is gone from both sides (`packages/ui-web`, `packages/core_ui`), with its tests, stories, goldens, parity cases, baselines, widgetbook use cases, component tokens and canvas boards, so components are rebuilt from scratch screen by screen. The machinery (Storybook, widgetbook, the canvas generator and check, parity, baselines, lint rules, harnesses, the theme) stays and runs with zero components. The new way of working is written down.

## Owner decisions (2026-11-27)

The owner decided to delete every current component: none was approved by the designer. No archive tag; git history is enough. In planning:

1. Component tokens: every file of `tokens/component/` deleted now (no deprecation release: no reader remains), with `FoxButtonTheme`, `FoxInputTheme` and `FoxThemeData.components`; a version bump and a CHANGELOG entry.
2. The sign-in screen (`core_auth`) and the restaurant staff screen are deleted fully, with their routes and every redirect to them. Accepted: no app signs in until the new sign-in screen is built (1.14h waits), and cashier management leaves the restaurant app.
3. Only the theme stays inside `core_ui`; `internal/` goes whole. The phone-reading rules (`phone_rules.dart`) move to `core_auth` with their cases file; the web phone logic goes with `PhoneField`.
4. Every board of the customer screens canvas is deleted, and the slice files D.11 to D.17 with their roadmap lines; each screen is planned anew.

## Plan

1. Web (`ui-web`): every `src/` folder, the review tests, the `design-system/` cards, the per-component e2e specs and every visual baseline deleted; `src/index.ts`, `scripts/bundle.ts`, `bundle-entry.ts`, `docs.ts`, `components-canvas/{copy-ar,stories,playground}.ts` emptied; the machinery tests keep one real check each; one e2e smoke keeps Playwright running.
2. Flutter: every `core_ui/lib/src/` folder but `theme/`; the per-component tests, goldens and parity cases; `phone_rules.dart` to `core_auth`; the sign-in and staff screens, their routes and tests; widgetbook's catalogues emptied and its coverage test accepting zero widgets.
3. Tokens: `tokens/component/` deleted, outputs regenerated, the component checks accepting an empty folder.
4. Machinery with zero components: `scripts/golden-docker.mjs` and `scripts/baselines.mjs` guarded.
5. Docs and rules: architecture §2 (T16), §9.6–§9.9, workflow §1.7, §3.1, §4, the roadmap, the package `CLAUDE.md` files, `.claude/rules/`, the `slice-plan` and `build-slice` skills, `docs/code/packages/*`.
6. Artifacts: the Design System (component cards removed), Fox Drop Components (Main and two empty pages) and the customer screens canvas (empty) republished.

Files (hand-written count): about 55 edited (ui-web ~11, Flutter ~14, tokens ~5, scripts ~5, docs and rules ~20), over the ~25 of workflow §3.1: the owner asked for one pull request, since `main` builds only when both sides go together, and most edits empty a list. Deleted files, generated outputs and baselines apart.

Tests written first: none (a deletion). The machinery tests are adjusted to accept zero components, each still asserting something real.

## Stopped at

Built, checked, reviewed and the artifacts republished; committed for the pull request.

## Evidence

- `node scripts/verify.mjs --changed`: green (Dart analyze, format, Dart and Flutter tests of 7 packages, fox_lints, the TypeScript lint, type check, build and smoke, the other packages' tests, Prettier, instruction sizes).
- Flutter apps: customer 203, captain 155, restaurant 168 tests passed; design-tokens 447, ui-web 47 vitest tests; scripts 117 node tests.
- `pnpm baselines`: goldens skipped (no golden test), ui-web screenshots over 0 stories, no image changed; the 684 old PNGs are deleted in this slice's commit.
- `components-canvas:check`: 1 board (Main), 2 combinations, 0 problems.
- Artifacts: Design System version 38 (108 card files removed, bundle with no component), Fox Drop Components version 41 (Main and the two pages), the customer screens canvas version 76 (the 25 D.11 boards removed, one note), the Guide version 23 (back on main's tokens; version 22 came from the dropped `fix/text-link-blue` branch).
- Machinery changed for zero components: `scripts/golden-docker.mjs` skips with no golden test; `scripts/baselines.mjs` tolerates a missing screenshots folder; `e2e/visual.spec.ts` checks that every baseline has a story; the canvas generator keeps approved screens (`Screen-<name>.dc.html`) on the approved page; `generate` writes no Dart `ComponentTokens` while `tokens/component/` is empty.
- Review (`reviewer`, T2): no blocking finding. Fixed: the generic canvas checks restored (holes, bundle-only mounts, states, Arabic copy, token-only chrome, now on Main too); a guest's heart and «تأكيد الطلب» leave the guest in place instead of sending them home; stronger sign-out assertions; `anatomy.ts` tolerates a missing `tokens/component/`; stale text in `merchant.md`, `ui-web/CLAUDE.md`, `phone_test.dart`, `.prettierignore` and the roadmap. Deferred to the backlog: the React 18 bridge tests return with the first component.

## Before deploying

Nothing for the server. The apps cannot sign in until the new sign-in screen ships: do not build a staging release of the apps from this commit for real phones.

## To check on staging

Nothing new.
