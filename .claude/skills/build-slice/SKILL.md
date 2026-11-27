---
name: build-slice
description: Build one planned FOX DROP slice from its slice file in one session, test-first and layer by layer, to a pull request with auto-merge. Use when asked to build, start or continue a roadmap slice such as "D.8" or "the next slice".
argument-hint: '<slice id or slice file path>'
---

# Build one slice

Input: the slice, such as `1.14h`, or its file `docs/slices/<id>-<name>.md`. The process is `docs/process/development-workflow.md` §3; this is its build step.

## 1. Start

- Read the slice file. If it does not exist, or has no plan yet, stop: the slice is planned first with `/slice-plan` in a fresh session in plan mode. If its plan names more than about 25 hand-written files or more than two layers, stop too: it is split first (workflow §3.1).
- `git fetch`, then `git status`. Switch to the branch the file names if it exists on `origin` (pull it), or create it from an up-to-date `origin/main`.
- Read the spec and architecture sections the file cites and their definition of done; for what a feature already does and why, grep the folder's `docs/code/<folder path>.md`. Build only what the cited sections say.
- Restate the goal and the tier to the owner in one line. The tier sets the effort (§2 of the workflow): T0 high or xhigh, T1 medium (high for tricky logic), T2 medium or low.

## 2. Red phase: the tests first

- Write `.claude/state/red-phase` (empty) with the Write tool: the Stop hook skips its light check while it exists.
- Write the failing tests the plan lists (for domain rules, order states, timers and money always) and run each test file on its own to see each fail for the right reason.
- List their paths in `.claude/state/locked-tests.txt`, one per line: the edit guard then refuses changes to them. If a locked test turns out wrong, stop and ask the owner.
- Delete `.claude/state/red-phase`.

## 3. Build layer by layer

In the plan's order: database and server module → routes, contract and generated clients (`pnpm generate:api`) → web (the panel and portal) → Flutter (the apps) → end-to-end. While building, run only the test file being edited; the Stop hook checks the format and lint of the edited files by itself. Send independent tool calls together in one message; change an existing file with Edit, never a rewrite with Write; search a log or a long output with Grep, never read it whole. After each finished layer:

- run the check once: `node scripts/verify.mjs --changed > <scratchpad>/verify-<layer>.log 2>&1` in a Bash call with `run_in_background: true`, and go on with work that does not depend on it; you are told when it exits. It does the rest by itself (workflow §5): parallel parts, skips what passed unchanged, waits for the lock, one line per step, each step's whole output under `<git dir>/verify-runs/`. Grep the log for the failing steps. Never run it in the foreground, never pipe it into `tail`, never poll it, never start a second run for a docs-only edit. Fix at the root and run it again until it passes;
- update the slice file's "Stopped at" line, commit at the green checkpoint (Conventional Commits, the slice ID in the scope, the body says what and why; generated files in a commit of their own), then push once.

In the same slice: a rule an agent editing a folder would get wrong goes in that folder's `CLAUDE.md` (at most 4 KB; `pnpm verify` checks), a rule a machine can check goes in a test or a lint rule, and what the slice built, decided or left out goes in the folder's `docs/code/<folder path>.md`.

## 4. Before the pull request

- `node scripts/verify.mjs --changed` passes on the final tree (in the background, as in §3). Run the full `pnpm verify` the same way as well when the slice changes `scripts/verify.mjs`, `scripts/classify-changes.mjs`, `.github/` or the generators; CI is the gate (everything on main).
- For screens: run them in the app in Arabic, right to left.
- Write the evidence into the slice file: the commands and their summary lines, what the owner can try. Fill "Before deploying" and "To check on staging".
- Review by tier (workflow §6): the `reviewer` agent with the branch, the slice file and the tier in its prompt, and the Agent tool's `effort` set to `medium` for T2 and T1 or `high` for T0 (it applies `REVIEW.md` from `main`); for T0 also the `security-reviewer`, in the same message. Fix every blocking and should-fix finding and run the check again (§4); send the fixes' diff to the same reviewer (SendMessage) for the next round. After three rounds with a blocking finding still open, stop and ask the owner. Non-blocking findings go to `docs/backlog.md` with their source.

## 6. Pull request

- Empty `.claude/state/locked-tests.txt`.
- Mark the slice `[x]` in `docs/roadmap.md`, set the slice file's status to Done, and commit. These land with the merge; never write that the slice was merged or is on `main` before it is.
- `gh pr create --base main`: `## Summary` (what and why, the slice file, the spec sections, the tier), `## Test plan` (the evidence and what the owner can try), and `## Checks changed` when it touches `ci.yml`, `scripts/verify.mjs` or `REVIEW.md`. A pull request opened earlier for CI on a checkpoint is a draft (`--draft`) without auto-merge; now `gh pr ready` it.
- Only now: auto-merge with squash (`gh pr merge --auto --squash --delete-branch`) and the app's Auto-fix. If CI fails, fix the cause on the branch and push once; never skip or silence a check.

## 7. Report

In the format of "Reporting" in the root `CLAUDE.md`. Under «ما المطلوب منك», the slice's acceptance steps as numbered steps to run after the merge; under «الخطوة التالية», the next slice from `docs/roadmap.md`: whether its slice file exists (else `/slice-plan` first, in plan mode), its tier and effort, and its first message, such as `/build-slice D.9`.

If the session ends with work open instead: update "Stopped at" and "Notes for the next session" in the slice file, commit what is green and push once; a pull request, if one is open, stays a draft.
