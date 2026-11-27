# Development workflow

Status: Accepted (owner, 2026-11-23) · Owner: product owner

How FOX DROP is built: almost all code is written by Claude Code (Opus 5.5) under the owner's direction. This document is the operating model every session follows: risk tiers, the slice loop, verification, review, pull requests, instruction files and the Claude Code configuration. It is modelled on the owner's Shifa project and replaces the phase plan now archived in [`archive/claude-code-workflow.md`](../archive/claude-code-workflow.md); five FOX DROP pieces that measurably sped work up stay (§5, §8).

## 1. Principles

1. **Harness over prompt.** Rules that must never break are enforced by hooks, tests, lint rules and CI, not by prose. A written rule ignored twice becomes a hook or a test.
2. **Verify with evidence.** Every change is proven by a check that passes or fails; the command and its result are the evidence. "Done" without evidence is not done.
3. **Specs first.** The specs under `docs/product/` and `docs/domain/` are the source of truth. No feature code without a spec section and its definition of done; a feature beyond them gets one with `/spec`. Never guess an open item: ask the owner.
4. **Small slices.** One slice per session, one slice per pull request, sized by §3.1.
5. **Independent review.** The session that wrote the code never approves it: a fresh-context `reviewer` checks it against the slice file and the specs.
6. **Compounding.** A correction made twice becomes a rule, a skill, a hook or a test. A bug found after a merge becomes a `REVIEW.md` item or a test in its fix's pull request.
7. **Design before code.** A screen is coded only after the owner approved its drawing; a web component's board on "Fox Drop Components", generated from the bundle, is its drawing, and a Flutter twin's checkpoint is its parity sheet (architecture §9.9, T14, T15). Screens come in UI batches after their API, drawn as working prototypes with an analysis and tested by the owner in Play before approval (T13).

## 2. Risk tiers

Every slice and every pull request carries a tier. The tier sets the effort and the review.

| Tier          | Areas                                                                                                | Effort                         | Review                                                         |
| ------------- | ---------------------------------------------------------------------------------------------------- | ------------------------------ | -------------------------------------------------------------- |
| T0 critical   | Money and the ledger, order states and timers, auth and sessions, migrations, secrets, deploy and CI | high or xhigh                  | `reviewer` at high, full list, + `security-reviewer`           |
| T1 core       | Domain services, routes, API contracts                                                               | medium (high for tricky logic) | `reviewer` at medium, full list                                |
| T2 peripheral | UI, docs, tests                                                                                      | medium or low                  | `reviewer` at medium, short list, for code; none for docs only |

How the calling session passes the tier and the effort is §6. Branch protection and green CI are the gate. The owner may read any pull request before CI finishes.

## 3. The slice loop

1. **Spec** (only for features the written specs do not cover): `/spec` interviews the owner with recommended options and writes the spec sections with a definition of done. The owner approves.
2. **Plan:** a fresh session in plan mode runs `/slice-plan`: the split into slices, a tier each, one file each in [`docs/slices/`](../slices/README.md) with the plan by layer and the tests written first, each sized by §3.1. The owner approves. A T0 plan is critiqued by a second fresh session before it is built.
3. **Build:** one session runs `/build-slice` from the slice file: for components and screens, the Figma look and the owner's approval first; then the red phase (failing tests, then locked), then layer by layer (database and server → contract and clients → web → Flutter → end-to-end), `node scripts/verify.mjs --changed` in the background and a commit at each green checkpoint.
4. **Verify:** `node scripts/verify.mjs --changed` passes on the final tree; screens and components are run in Arabic, right to left, and compared with their approved drawing. The evidence goes into the slice file.
5. **Review** by tier (§6); real findings fixed, non-blocking ones to [`backlog.md`](../backlog.md).
6. **Pull request:** one slice, the slice file and spec sections linked, the evidence, the tier; a draft until the slice is complete, then auto-merge (squash) and Auto-fix (§6).
7. **Close:** the roadmap line `[x]`, the slice file Done, `docs/code` notes current, the owner report (root `CLAUDE.md`, Reporting).

### 3.1 Slice size

Measured on 2026-11-25: slices of 115 to 320 files took 250 to 440 requests in one session, with up to 780K tokens of context. So:

- A slice is at most about 25 hand-written files, or two layers of the build order (database and server, contract and clients, web, Flutter, end-to-end), whichever comes first. Generated files (the contract, the clients, `*.g.dart`), icons and image baselines do not count; they go in a commit of their own.
- A behaviour that crosses more layers is split along the build order, each slice leaving `main` working: the server and its contract first, then each client.
- A component batch's web side (`ui-web`) and Flutter side (`core_ui`) are separate slices (T14, owner 2026-11-26). The web side comes first and is the drawing: its components, synced, get their boards on "Fox Drop Components" from the bundle, and those boards are what the owner approves (architecture §9.9, T15). Its Flutter twin is its own slice, planned when a screen needs it, on the same component tokens, and its checkpoint is its parity sheet (`pnpm parity`), with no second sheet. A component whose look must be settled before any code is drawn first on that canvas's proposals page with the owner; once coded, its drawing is deleted and its board generated.
- The planner estimates by counting: the slice file's plan names, layer by layer, every file the slice creates or changes by hand, and the count is written next to the plan. A plan over the limit is split before the owner approves it, never during the build.

## 4. Definition of done

- Every definition-of-done item the slice closes is met and proven by a test or a staging demonstration.
- `--changed` green locally; CI's full check green; no new lint suppression without a written reason.
- Money: integer minor units, balances only through the ledger, every journal balanced per currency, repeated requests and timer jobs post once.
- UI: a screen built from its approved drawing, a web component approved as its generated board (T15), a Flutter twin checked on its parity sheet (T14); Arabic right to left, start and end, strings in translation files.
- No secrets or real personal data in code, fixtures, logs or screenshots.
- `docs/code/<folder path>.md`, folder `CLAUDE.md` files and the slice file updated; the roadmap line ticked.

## 5. Verification

- `pnpm verify` is the whole check; `node scripts/verify.mjs --changed` runs only what the change since `origin/main` can break (the paths are classified by `scripts/classify-changes.mjs`, which CI uses too). CI runs as parallel jobs what a pull request can break and everything on `main`, and stays the gate. Run the full check locally too when the change touches `scripts/verify.mjs`, `scripts/classify-changes.mjs`, `.github/` or a generator.
- **One check per layer.** While building, the session runs only the test file it is editing. When a layer is finished it runs `--changed` once: a Bash call with `run_in_background: true` and its output redirected to a log file; Claude Code says when it exits, and the session goes on meanwhile with work that does not depend on it. Never in the foreground (the Bash tool moves a command to the background after 180 s), never piped into `tail`, never polled, never a second run for a docs-only edit.
- `--changed` needs no help: it runs the format checks and the contract first, then the TypeScript, server and Dart parts at the same time; it skips a server, Dart or contract step whose inputs are unchanged since it last passed, and Turborepo replays the builds and tests whose inputs did not change (`--fresh` runs everything again); a Markdown-only change runs the format checks alone. It prints one line per step and a final table, whose "Image baselines" row says whether the tree's images are checked, skipped (the change cannot move one) or UNCHECKED with the command to run; it writes each step's whole output to `<git dir>/verify-runs/<time>/`, and when a step fails the other parts still finish and the failure is printed cut to what failed. The session reads the log with Grep or a ranged Read, never whole.
- One check at a time in a folder: `verify.mjs` takes a lock in the folder's git directory; a second check waits for it, up to 20 minutes (`--no-wait` exits with 3 instead), so a session never writes a sleep loop on the lock.
- **Image baselines** (the `ui-web` screenshots and the `core_ui` goldens) are valid only from the Linux images run in Docker. `pnpm baselines` updates the images the change since `origin/main` can move (the `visual` and `golden` outputs of `classify-changes.mjs`), then compares them and records the checked tree; `--check` only compares, `--all` ignores the classification, and `node scripts/baselines.mjs --status` says in under a second whether the tree's images are checked. Check the images before the pull request: the shell guard refuses `gh pr create` (drafts too) and `gh pr ready` while `node scripts/baselines.mjs --status` says the tree's images are unchecked, and when that helper itself cannot run it allows the command with a warning. The new images go in a commit of their own.
- A passing `--changed` or full run records the tree (`scripts/green-tree.mjs`); the Stop hook says once per tree when the full check has not run on it.
- The Stop hook checks only the files the session edited since its last pass, in seconds: Prettier, the pinned `dart format` and ESLint per package. It never runs tests, builds, type checks or analyzers, and an untracked file nobody edited through the tools never starts it.
- CI's filters skip all but Prettier and the instruction size check for a change of Markdown and `docs/` only (only the spec files a test reads count as code: `SPEC_FILES_READ_BY_TESTS` in `scripts/classify-changes.mjs`), the Dart and Flutter parts for a change without Dart, and the `visual` and `golden` image jobs for a change that cannot move their images. On a pull request (owner, 2026-11-27) the `lint` and `e2e` jobs run only for a TypeScript change, the server's shards only for a change its tests read and the contract for any server change or what builds the Dart client (`ciJobs`), and Turborepo checks only the affected packages (`verify.mjs lint|e2e --affected=<base>`: `...[base]` plus each package whose `turbo.json` task reads a changed file outside it, `turboScope`; every package for a root manifest, lock, shared configuration or root script). On `main`, and for a change to the check engine (`CHECK_ENGINE`: `ci.yml`, `turbo.json`, `verify.mjs` and its scripts), every job runs on every package, forced, as before: what a pull request's narrower run misses, main catches.
- `pnpm generate:api` skips its Dart half (the Java generator, `build_runner`, `dart format`) outside CI when the OpenAPI document and everything that builds the client are as its last full run in that checkout left them (`DART_CLIENT_INPUTS`); `--force` and CI always run it.
- Money has property tests with fast-check (every journal balances per currency, rounding round-trips, a repeated request or timer job posts once); new money rules extend them.

## 6. Pull requests

- Branch from `main` as `feat/`, `fix/`, `docs/`, `chore/`, `refactor/` or `test/` plus a topic. Conventional Commits; the body says what and why.
- The body has `## Summary` and `## Test plan`, and `## Checks changed` when the change touches `ci.yml`, `scripts/verify.mjs` or `REVIEW.md`.
- **Draft until complete.** A pull request opened before its slice is complete is a draft (`gh pr create --draft`) without auto-merge. When the slice is complete and reviewed: `gh pr ready`, then auto-merge with squash (`gh pr merge --auto --squash --delete-branch`) and Auto-fix. The branch is deleted on merge (`git branch -D` locally, since a squash merge is not an ancestor).
- **Nothing pushed that is known to fail**, image baselines included (§5). One push per green checkpoint: everything the checkpoint holds is committed first, then pushed once; never two pushes in a row, since each starts CI.
- **Honest records.** The slice file, the roadmap and the pull request state only what has happened: "merged" or "on `main`" is written after the merge, never ahead of it.
- **Review by tier** (§2). The calling session names the tier in the `reviewer` prompt and passes the effort as the Agent tool's `effort`: T2 `medium` (the short list), T1 `medium` (the full list), T0 `high` (the full list) with `security-reviewer` in parallel at its own `xhigh`. The session that wrote the code never approves it. `REVIEW.md` is read by the reviewer from `main`, never from the branch under review.

## 7. Working with Claude Code

- **Model and effort:** Opus 5.5 always, chosen when the session starts; effort by tier (§2): `medium` by default (`.claude/settings.json`), `high` or `xhigh` for T0. Never switch the model in a session (it rewrites the prompt cache). `reviewer` runs on Opus at the effort its caller passes (§6), `security-reviewer` on Opus at xhigh.
- **Context:** one slice per session, `/clear` between tasks, plan mode for work across packages. Read files with Read and Grep a range at a time; an existing file is changed with Edit, never rewritten with Write; send independent tool calls together in one message (on 2026-11-25, 68% of requests carried a single call). Use subagents (the built-in `Explore`, `Plan` and `general-purpose`, and the project's `reviewer`, `security-reviewer`) for independent review and noisy exploration; the session runs the check itself (§5).
- **Drawings and design sessions** (sheets, artboards, prototypes, guide pages): a long Write shows nothing while it runs (25 to 63 thousand characters took 1.4 to 3.7 minutes; the owner interrupted three times in one session and the work started over). So a drawing is files of at most about 15 thousand characters each, on a shared base written once and reused (the frame, the tokens, the component styles); a change is an Edit of the part that changed, never a rewrite of the file; variants are small files that differ only in what varies; before any generation expected to take more than a minute, the session says in one line what it is about to write and how long it will take; one publish per round of the owner's comments; an approved file is never regenerated. This is how the cycles of architecture §9.9 are carried out; it changes none of their steps.
- **Parallel work:** two or three sessions in separate git worktrees on independent slices; never two slices in flight on the same hand-written file or the same dependency (owner, 2026-11-26: the files, not the package; each slice file names its files, and append-only shared files such as an `index.ts` or a changelog are resolved when the second slice rebases, one merge at a time); schema and API-contract changes one at a time. A dependency's version is pinned once, in the slice that adds it; a later slice uses that pin. A worktree uses the main checkout's pinned Flutter: never `fvm install` or `fvm use` in one, and remove a worktree only after removing its `.fvm/flutter_sdk` link alone (Git Bash `rm -f <worktree>/.fvm/flutter_sdk`, PowerShell `cmd /c rmdir`), since `git worktree remove` follows the link and empties the shared SDK (2026-11-25); the shell guard refuses both.

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
- **During:** one commit and one push at each green checkpoint (§6); keep "Stopped at" current.
- **End:** the slice file and roadmap updated; the pull request ready, with auto-merge and Auto-fix (§6); the owner report in Arabic.

## 10. Claude Code configuration

- **Settings** (`.claude/settings.json`): model `opus`, `effortLevel` `medium`; `permissions.allow` lists every built-in tool, with no deny list (the owner's decision, 2026-11-23: secret files are readable and editable; `.gitignore` and the CI secret scan keep them out of git). No sandbox: Windows with Git Bash. The permission mode is the owner's choice; Claude never starts a session that skips permissions.
- **Hooks** (`.claude/hooks/`, policy in `lib/policy.mjs` with unit tests in `hooks.test.mjs`, run by `pnpm verify`; the guards fail closed):
  - `session-start.mjs`: puts the pinned Dart and Flutter first on PATH for the session's Bash commands (`CLAUDE_ENV_FILE`; PowerShell commands never get it, so the shell guard asks them for the prefix);
  - `guard-bash.mjs`: refuses shell writes into `apps/`, `packages/`, `scripts/`, `infra/`, `.claude/`, `--no-verify`, force pushes, pushes to `main`, permission bypasses, run-time package fetches, installs outside pnpm, `C:\flutter`, a bare `dart` or `flutter` in PowerShell, `fvm install` in a worktree removing a worktree before its `.fvm/flutter_sdk` link, and `gh pr create` or `gh pr ready` with unchecked images (§5);
  - `guard-edits.mjs`: refuses edits to generated files, the read-only archives, merged migrations and the slice's locked tests;
  - `format.mjs`: formats each edited file (Prettier, the pinned `dart.exe format`, no shell) and records the edit for the Stop hook;
  - `stop-check.mjs`: the light check of the files the session edited (§5), unless in the red phase; one line of result, timeout 60 s;
  - `session-end.mjs`: warns about uncommitted work.
- **Agents:** `reviewer`, `security-reviewer`; the built-in agents for the rest.
- **Skills:** `/spec`, `/slice-plan`, `/build-slice`, `/audit-phase`, `/db-migration`, `/deploy`.

## 11. Cadence

- **Per phase:** `/audit-phase` with parallel read-only reviewers and an owner walkthrough on staging before the next phase.
- **Every 20 merged pull requests:** prune `REVIEW.md` (an item a test now catches goes) and the backlog.
- **After a model or Claude Code release:** remove scaffolding the new model no longer needs.
