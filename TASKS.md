# Tasks

The handover note between sessions: the current task, its branch, its plan, and where work stopped. Replace it when a task starts; keep it current while the task runs. At most 8 KB: the notes of earlier slices live in `docs/slice-notes.md`.

## Current task

D.2 Tokens pipeline (`docs/roadmap.md` Phase D; architecture §9.2, §9.5 R1 and R4, §9.11; `docs/brand/expression.md` §1, §3, §6, §7, §9). The owner reads the contrast report.

- **Branch:** `feat/design-tokens`.

### Design

Owner answers (2026-11-22): Dart output in a new pure-Dart package `packages/core_tokens`; the dark slot holds a copy of the light value until dark mode is designed; the contrast report is a generated Markdown file plus a private coloured Artifact page.

**`packages/design-tokens`** (`@fox-drop/design-tokens`, private, vitest, like `packages/api-schema`). Sources in W3C DTCG JSON (`$value`, `$type`) under `tokens/`; Style Dictionary (latest v5, exact pin) builds them with `pnpm --filter @fox-drop/design-tokens build`. Outputs are committed:

- `tokens/primitive/`: orange, blue and warm-neutral scales 50–900 (expression §6: brand orange at 400, accessible orange at 600, blue at 500, ivory at 50, greys derived from ivory); status raw colours; six chart colours; white; spacing on the 4-point grid; radii; three elevation shadows; durations fast 100, base 200, slow 300, moment 1200 ms and one calm easing without bounce (§3); the CoFo family and weights 400/500/700 (§7); the three type scales of §7 (phone, panel, captain) with line heights 1.6/1.3/1.2; web breakpoints; touch target 48.
- `tokens/semantic/light.json` and `dark.json`: surface, surface-raised, on-surface, on-surface-muted, primary (accessible orange), on-primary, accent (blue), on-accent, border, border-strong, focus-ring, success/warning/danger/info and their `on-*`, alert (7:1, §6 restaurant), typography roles per scale. They reference primitives only. `dark.json` has exactly the light keys (a test checks the key sets match) and copies the values (owner).
- `tokens/semantic/captain.json`: the captain override: text and numbers at 7:1 in near-black or blue, no orange text (§6).
- `tokens/component/button.json`: the only component layer now (Button is first in D.6/D.7): height, padding, radius, colour roles per state, referencing semantic tokens.
- Outputs: `dist/tokens.css` (`:root` semantic and component variables with resolved values, `[data-theme="dark"]` block, `[data-surface="captain"]` override; primitives are not exported, R1); `dist/tailwind.css` (a Tailwind v4 `@theme` that first resets the default colours, spacing and radii with `initial`, then maps only semantic names to the variables, R1); `packages/core_tokens/lib/src/tokens.g.dart`.
- `CHANGELOG.md` and a version (§9.2 governance); a token is deprecated with `$deprecated` for a release before removal (rule in the package `CLAUDE.md`).

**`packages/core_tokens`** (pure Dart, no Flutter, added to the pub workspace): generated `const` classes, colours as ARGB `int`, lengths as `double`, durations as `Duration`, a light and a dark set and the captain override, one type scale per surface. `core_ui` wraps them in D.7. A `dart test` checks a few values against the JSON.

**Tests (definition of done):**

- Contrast (`contrast.test.ts`): a list of required pairs per theme (phone, captain, panel) with their target: 4.5:1 text and filled controls, 3:1 borders, focus ring and icons, 7:1 captain text and restaurant alerts; it fails on any pair below target, and writes `contrast-report.md` (every pair, ratio, target, pass). It settles the accessible orange (candidate `#C2410C`) and the status colours of §6.
- Chart palette: the six colours stay apart under protan, deutan and tritan simulation (Machado matrices, a minimum CIEDE2000 distance) and each is ≥ 3:1 on the surface.
- Tabular digits (§7): `scripts/font-metrics.mjs` reads CoFo 400/500/700 from `.fonts/` (fontkit) and writes `docs/brand/font-metrics.json` (advance widths of 0–9 with `tnum`, keyed by each file's SHA-256 from `fonts-manifest.json`). The test checks equal widths and that the SHAs match the manifest; when `.fonts/` is present it also recomputes and compares. No font bytes enter the repository.
- Drift check: `verify.mjs` regenerates the tokens and fails when a committed output changes (as for the localizations); `scripts/classify-changes.mjs` marks `packages/design-tokens/**` as TypeScript plus Dart (the Dart output), with its test.
- Dark keys equal light keys; Tailwind theme holds no primitive name.

**Docs in the slice:** `packages/design-tokens/CLAUDE.md` and `packages/core_tokens/CLAUDE.md` (edit JSON, never the outputs; semantic only in screens); `docs/code/packages/design-tokens.md`; architecture §9.2 and §9.11 and expression §6 with the settled values.

**Left out on purpose:** real dark values; wiring the theme into the web apps (D.6) and Flutter (D.7); the Design System sync (D.4); font subsetting and the size budgets (D.6/D.7, expression §9); map style tokens (D.3); icon tokens (D.5).

**After the merge:** publish the private contrast Artifact from `contrast-report.md` (owner answer) and give the owner the link.

### Plan

- [x] Read the cited sections and write the design here.
- [ ] Scaffold `packages/design-tokens`, the primitive layer and the Style Dictionary build to CSS.
- [ ] Semantic (light, dark slot, captain) and Button layers; the Tailwind theme.
- [ ] `packages/core_tokens` and the Dart output.
- [ ] Contrast and chart tests, `contrast-report.md`; settle the accessible orange and status colours.
- [ ] Font metrics script, `font-metrics.json` and the tabular digits test.
- [ ] Drift check in `verify.mjs` and `classify-changes.mjs`; the `CLAUDE.md` files, `docs/code`, architecture §9.2/§9.11 and expression §6.
- [ ] Review, hand over to D.3, pull request, merge; then the contrast Artifact.

## Waiting for the owner

- From `test/money-properties` (merged, PR 246): what an outcome posts when a restaurant-funded discount exceeds what the clearing account holds (`outcomeEntries` throws today; the property skips that case).
- D.1: the `FONTS_DEPLOY_KEY` secret (the private half of a read-only deploy key on `fox-drop-fonts`, no expiry; commands in the pull request thread) in the repository's Actions secrets; until then the CI fetch step skips. (The owner confirmed on 2026-11-21 that he holds the right to use every font in the pack, CoFo included, in the apps.) The meaning of the `broken-edges` icon SVGs and of the `variant-b/c` icons.
- Phase 3 of `docs/claude-code-workflow.md`: the phase 4 session started at 75.7K tokens with one MCP delta (goal: under 45K, none). Left: the `marketing` and `social-media-skills` plugins, off only in the app's settings.
- Phase 6 items 1 and 2 (owner decision 2026-11-21): `autoCompactWindow: 350000` and every slice in two sessions, planning then build (`build-slice`). L.1c was the first trial; record its measurement (`scripts/claude-audit.mjs`, against L.1a and L.1b) in `docs/claude-code-workflow.md`.
- L.1c's choices to confirm (`docs/slice-notes.md` «Left from L.1c»): the 1 km fit of a kept read, and the rest under «Decided by us».

## After that

L.2 The permission matrix (branch `test/permission-matrix`; read first: architecture §18.1, AP §6 and §14 item 2, RA §22 item 2, the AP-2 and RA-2 rows of `docs/launch/dod-checklist.md`, `apps/server/CLAUDE.md` «Deny by default», the route table in `apps/server/src/modules/identity/admin-team.test.ts`), then the rest of launch readiness from L.3 (`docs/roadmap.md`).

Branches of Phase D: D.2 `feat/design-tokens`, D.3 `feat/design-directions`, D.4 `feat/design-system-project`, D.5 `feat/icon-set`, D.6 `feat/ui-web`, D.7 `feat/core-ui`. Branches of the later slices: L.3 `feat/captain-simulator`, L.4 `test/load-k6`, L.5 `chore/pgbackrest`, L.6 `feat/monitoring-alerts`, L.7 `chore/production-environment`, L.8 `test/patrol-e2e`, L.9 `docs/device-lab`, L.10 `docs/staging-rehearsal`, L.11 `chore/launch`.
