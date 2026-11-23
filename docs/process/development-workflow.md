# Development workflow

Status: Accepted (owner, 2026-11-23) · Owner: product owner

How FOX DROP is built: almost all code is written by Claude Code (Opus 5.5) under the owner's direction. This document is the operating model every session follows: risk tiers, the slice loop, verification, review, pull requests, instruction files and the Claude Code configuration. It is modelled on the owner's Shifa project and replaces the phase plan now archived in [`archive/claude-code-workflow.md`](../archive/claude-code-workflow.md); five FOX DROP pieces that measurably sped work up stay (§5, §8).

## 1. Principles

1. **Harness over prompt.** Rules that must never break are enforced by hooks, tests, lint rules and CI, not by prose. A written rule ignored twice becomes a hook or a test.
2. **Verify with evidence.** Every change is proven by a check that passes or fails; the command and its result are the evidence. "Done" without evidence is not done.
3. **Specs first.** The specs under `docs/product/` and `docs/domain/` are the source of truth. No feature code without a spec section and its definition of done; a feature beyond them gets one with `/spec`. Never guess an open item: ask the owner.
4. **Small slices.** One slice per session, one slice per pull request.
5. **Independent review.** The session that wrote the code never approves it: a fresh-context `reviewer` checks it against the slice file and the specs.
6. **Compounding.** A correction made twice becomes a rule, a skill, a hook or a test. A bug found after a merge becomes a `REVIEW.md` item or a test in its fix's pull request.
7. **Design before code.** A component or screen is coded only after the owner approved its sheet or drawing (architecture §9.9).

## 2. Risk tiers

Every slice and every pull request carries a tier. The tier sets the effort and the review.

| Tier          | Areas                                                                                                | Effort                         | Review                                  |
| ------------- | ---------------------------------------------------------------------------------------------------- | ------------------------------ | --------------------------------------- |
| T0 critical   | Money and the ledger, order states and timers, auth and sessions, migrations, secrets, deploy and CI | high or xhigh                  | `reviewer` + `security-reviewer`        |
| T1 core       | Domain services, routes, API contracts                                                               | medium (high for tricky logic) | `reviewer`                              |
| T2 peripheral | UI, docs, tests                                                                                      | medium or low                  | `reviewer` for code; none for docs only |

Every pull request gets auto-merge and Auto-fix when it is opened; branch protection and green CI are the gate. The owner may read any pull request before CI finishes.

## 3. The slice loop

1. **Spec** (only for features the written specs do not cover): `/spec` interviews the owner with recommended options and writes the spec sections with a definition of done. The owner approves.
2. **Plan:** a fresh session in plan mode runs `/slice-plan`: the split into slices, a tier each, one file each in [`docs/slices/`](../slices/README.md) with the plan by layer and the tests written first. The owner approves. A T0 plan is critiqued by a second fresh session before it is built.
3. **Build:** one session runs `/build-slice` from the slice file: for components and screens, the Figma look and the owner's approval first; then the red phase (failing tests, then locked), then layer by layer (database and server → contract and clients → web → Flutter → end-to-end), the `checker` and a commit at each green checkpoint.
4. **Verify:** `node scripts/verify.mjs --changed` passes on the final tree; screens and components are run in Arabic, right to left, and compared with their approved drawing. The evidence goes into the slice file.
5. **Review:** `reviewer` (and `security-reviewer` for T0); real findings fixed, non-blocking ones to [`backlog.md`](../backlog.md).
6. **Pull request:** one slice, the slice file and spec sections linked, the evidence, the tier; auto-merge (squash) and Auto-fix at once.
7. **Close:** the roadmap line `[x]`, the slice file Done, `docs/code` notes current, the owner report (root `CLAUDE.md`, Reporting).

## 4. Definition of done

- Every definition-of-done item the slice closes is met and proven by a test or a staging demonstration.
- `--changed` green locally; CI's full check green; no new lint suppression without a written reason.
- Money: integer minor units, balances only through the ledger, every journal balanced per currency, repeated requests and timer jobs post once.
- UI: built from an approved sheet or drawing, Arabic right to left, start and end, strings in translation files.
- No secrets or real personal data in code, fixtures, logs or screenshots.
- `docs/code/<folder path>.md`, folder `CLAUDE.md` files and the slice file updated; the roadmap line ticked.

## 5. Verification

- `pnpm verify` is the whole check; `node scripts/verify.mjs --changed` runs only what the change since `origin/main` can break (the paths are classified by `scripts/classify-changes.mjs`, which CI uses too). The `checker` agent runs it at each checkpoint; CI runs everything as parallel jobs and stays the gate. Run the full check locally too when the change touches `scripts/verify.mjs`, `scripts/classify-changes.mjs`, `.github/` or a generator.
- One check at a time in a folder: `verify.mjs` takes a lock in the folder's git directory; a second check exits with 3.
- A passing `--changed` or full run records the tree (`scripts/green-tree.mjs`), so the Stop hook does not check the same tree again.
- CI's filters skip all but Prettier and the instruction size check for a change of Markdown and `docs/` only, and the Dart and Flutter parts for a change without Dart.
- Money has property tests with fast-check (every journal balances per currency, rounding round-trips, a repeated request or timer job posts once); new money rules extend them.

## 6. Pull requests

- Branch from `main` as `feat/`, `fix/`, `docs/`, `chore/`, `refactor/` or `test/` plus a topic. Conventional Commits; the body says what and why.
- The body has `## Summary` and `## Test plan`, and `## Checks changed` when the change touches `ci.yml`, `scripts/verify.mjs` or `REVIEW.md`.
- Squash merge, auto-merge and Auto-fix enabled when the pull request is opened; the branch is deleted on merge (`git branch -D` locally, since a squash merge is not an ancestor).
- `REVIEW.md` is read by the reviewer from `main`, never from the branch under review.

## 7. Working with Claude Code

- **Model and effort:** Opus 5.5 always, chosen when the session starts; effort by tier (§2): `medium` by default (`.claude/settings.json`), `high` or `xhigh` for T0. Never switch the model in a session (it rewrites the prompt cache). The `checker` runs on Haiku at low effort; `reviewer` on Opus at high, `security-reviewer` on Opus at xhigh.
- **Context:** one slice per session, `/clear` between tasks, plan mode for work across packages. Read files with Read and Grep a range at a time; send independent tool calls together in one message. Use subagents (the built-in `Explore`, `Plan` and `general-purpose`, and the project's `checker`, `reviewer`, `security-reviewer`) for independent review and noisy exploration.
- **Parallel work:** two or three sessions in separate git worktrees on independent slices; schema and API-contract changes one at a time.

## 8. Instruction files

| File                                 | Budget         | Contains                                                                                                              |
| ------------------------------------ | -------------- | --------------------------------------------------------------------------------------------------------------------- |
| Root `CLAUDE.md`                     | ≤ 10 KB        | Where things are, commands, non-negotiables, how to work, hooks, reporting                                            |
| Folder `CLAUDE.md`                   | ≤ 4 KB         | The rules for working in that folder                                                                                  |
| `.claude/rules/*.md` (path-scoped)   | ≤ 4 KB         | Rules shared by several folders that one folder's `CLAUDE.md` cannot carry (the three Flutter apps, the two web apps) |
| `docs/code/<folder path>.md`         | none (grep it) | What each feature does, what was decided and why                                                                      |
| Skills (`.claude/skills/*/SKILL.md`) | short          | Procedures used sometimes                                                                                             |

`pnpm verify` checks the budgets. Write only what the code does not show; state each rule once and point to it.

## 9. Session protocol

- **Start:** read the slice file and the roadmap line; `git status` and the branch; restate the goal and the tier.
- **During:** commit and push at green checkpoints; keep "Stopped at" current.
- **End:** the slice file and roadmap updated; the pull request opened with auto-merge and Auto-fix; the owner report in Arabic.

## 10. Claude Code configuration

- **Settings** (`.claude/settings.json`): model `opus`, `effortLevel` `medium`; `permissions.allow` lists every built-in tool, with no deny list (the owner's decision, 2026-11-23: secret files are readable and editable; `.gitignore` and the CI secret scan keep them out of git). No sandbox: Windows with Git Bash. The permission mode is the owner's choice; Claude never starts a session that skips permissions.
- **Hooks** (`.claude/hooks/`, policy in `lib/policy.mjs` with unit tests in `hooks.test.mjs`, run by `pnpm verify`; the guards fail closed):
  - `guard-bash.mjs`: refuses shell writes into `apps/`, `packages/`, `scripts/`, `infra/`, `.claude/`, `--no-verify`, force pushes, pushes to `main`, permission bypasses, run-time package fetches and installs outside pnpm;
  - `guard-edits.mjs`: refuses edits to generated files, the read-only archives, merged migrations and the slice's locked tests;
  - `format.mjs`: formats each edited file (Prettier, `dart format`) and records the edit for the Stop hook;
  - `stop-verify.mjs`: runs `--changed` when the session itself edited code, unless in the red phase or the tree is already green;
  - `session-end.mjs`: warns about uncommitted work.
- **Agents:** `checker`, `reviewer`, `security-reviewer`; the built-in agents for the rest.
- **Skills:** `/spec`, `/slice-plan`, `/build-slice`, `/audit-phase`, `/db-migration`, `/deploy`.

## 11. Cadence

- **Per phase:** `/audit-phase` with parallel read-only reviewers and an owner walkthrough on staging before the next phase.
- **Every 20 merged pull requests:** prune `REVIEW.md` (an item a test now catches goes) and the backlog.
- **After a model or Claude Code release:** remove scaffolding the new model no longer needs.
