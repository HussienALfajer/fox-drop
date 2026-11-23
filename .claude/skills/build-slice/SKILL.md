---
name: build-slice
description: Build one planned FOX DROP slice from its slice file in one session, test-first and layer by layer, to a pull request with auto-merge. Use when asked to build, start or continue a roadmap slice such as "D.8" or "the next slice".
argument-hint: '<slice id or slice file path>'
---

# Build one slice

Input: the slice, such as `D.8`, or its file `docs/slices/<id>-<name>.md`. The process is `docs/process/development-workflow.md` §3; this is its build step.

## 1. Start

- Read the slice file. If it does not exist, or has no plan yet, stop: the slice is planned first with `/slice-plan` in a fresh session in plan mode.
- `git fetch`, then `git status`. Switch to the branch the file names if it exists on `origin` (pull it), or create it from an up-to-date `origin/main`.
- Read the spec and architecture sections the file cites and their definition of done; for what a feature already does and why, grep the folder's `docs/code/<folder path>.md` (and `docs/slice-notes.md`, the archive of earlier slices). Build only what the cited sections say.
- Restate the goal and the tier to the owner in one line. The tier sets the effort (§2 of the workflow): T0 high or xhigh, T1 medium (high for tricky logic), T2 medium or low.

## 2. Components and screens: look and approval first

When the slice builds components or screens:

- **Look at the Figma file** (owner, 2026-11-23): inspiration, not rules, so each component comes out professional, creative and fitted to its surface. Render it with `node .claude/skills/build-slice/figma-look.mjs <scratchpad folder> [node id ...]` (the owner's token in `~/.figma-token`; the main screens are `49:2041` home, `49:1765` dish, `49:1557` cart, the rest of page `1:3` its rough components) and Read the PNGs. Say in the slice file which ideas the slice takes from it. The images and the file's link never enter the repository (architecture §9.8).
- **Design approval** (architecture §9.9): no component or screen code before the owner approved its sheet or drawing. That approval is the slice's first checkpoint; record it in the slice file.

## 3. Red phase: the tests first

- Write `.claude/state/red-phase` (empty) with the Write tool: the Stop hook skips the check while it exists.
- Write the failing tests the plan lists (for domain rules, order states, timers and money always) and run them to see each fail for the right reason.
- List their paths in `.claude/state/locked-tests.txt`, one per line: the edit guard then refuses changes to them. If a locked test turns out wrong, stop and ask the owner.
- Delete `.claude/state/red-phase`.

## 4. Build layer by layer

In the plan's order: database and server module → routes, contract and generated clients (`pnpm generate:api`) → web (`ui-web`, the panel and portal) → Flutter (`core_ui`, the apps) → end-to-end. After each layer:

- run the `checker` agent (`node scripts/verify.mjs --changed`) and fix at the root until it passes;
- commit at the green checkpoint (Conventional Commits, the slice ID in the scope, the body says what and why) and push;
- update the slice file's "Stopped at" line.

In the same slice: a rule an agent editing a folder would get wrong goes in that folder's `CLAUDE.md` (at most 4 KB; `pnpm verify` checks), a rule a machine can check goes in a test or a lint rule, and what the slice built, decided or left out goes in the folder's `docs/code/<folder path>.md`.

## 5. Before the pull request

- `checker` passes on the final tree. Run the full `pnpm verify` through it as well when the slice changes `scripts/verify.mjs`, `scripts/classify-changes.mjs`, `.github/` or the generators; CI runs everything and is the gate.
- For screens and components: run them (Storybook, widgetbook, the app) in Arabic, right to left, and compare each with its approved drawing; fix a difference or explain it in the slice file.
- Write the evidence into the slice file: the commands and their summary lines, screenshots' paths outside the repository, what the owner can try. Fill "Before deploying" and "To check on staging".
- Review by tier: the `reviewer` agent with the branch and the slice file (it applies `REVIEW.md` from `main`); for T0 also the `security-reviewer`, in parallel. Fix every blocking and should-fix finding and run `checker` again; send the fixes' diff to the same reviewer (SendMessage) for the next round. After three rounds with a blocking finding still open, stop and ask the owner. Non-blocking findings go to `docs/backlog.md` with their source.

## 6. Pull request

- Empty `.claude/state/locked-tests.txt`.
- Mark the slice `[x]` in `docs/roadmap.md`, set the slice file's status to Done, and commit.
- `gh pr create --base main`: `## Summary` (what and why, the slice file, the spec sections, the tier), `## Test plan` (the evidence and what the owner can try), and `## Checks changed` when it touches `ci.yml`, `scripts/verify.mjs` or `REVIEW.md`.
- At once: auto-merge with squash (`gh pr merge --auto --squash --delete-branch`) and the app's Auto-fix. If CI fails, fix the cause on the branch and push; never skip or silence a check.

## 7. Report

In the format of "Reporting" in the root `CLAUDE.md`. Under «ما المطلوب منك», the slice's acceptance steps as numbered steps to run after the merge; under «الخطوة التالية», the next slice from `docs/roadmap.md`: whether its slice file exists (else `/slice-plan` first, in plan mode), its tier and effort, and its first message, such as `/build-slice D.9`.

If the session ends with work open instead: commit what is green, update "Stopped at" and "Notes for the next session" in the slice file, commit and push.
