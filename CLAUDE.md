# FOX DROP

Food delivery platform for Syria, launching in Azaz: a customer app, a restaurant app with an owner web portal, a captain (courier) app, and the owner's admin panel. The V1 specs and the technology stack are written; application code starts with Phase 0 (`docs/roadmap.md`).

## Where things are

- `docs/README.md`: the map of all documentation, the citation codes (AP, RA, CA, CU) and the decision ID prefixes. Start there, then read only the sections a task needs.
- `docs/product/v1/<party>/`: the specs, one file per section. `docs/domain/`: the shared rules (AP §8). `docs/architecture/`: the stack and its rules.
- `TASKS.md`: the current task, its branch, its plan, and where work stopped. `docs/slice-notes.md`: what earlier slices left (before deploying, to check on staging, decisions pending the owner, not yet).
- Folder `CLAUDE.md` files hold the rules for working in that folder and load by themselves; `docs/code/<folder path>.md` holds what each feature there does, what was decided and why. Grep it for the feature you touch; never read it whole.
- `docs/claude-code-workflow.md`: how this project uses Claude Code, its token and check-time baseline, and the planned changes.
- `apps/server/`: the server; its `CLAUDE.md` has the module, route, validation and logging rules.
- `apps/admin/` and `apps/merchant-portal/`: the web apps; `apps/admin/CLAUDE.md` has their API, translation and test rules.
- `apps/customer/`, `apps/captain/` and `apps/merchant/`: the Flutter apps; `apps/customer/CLAUDE.md` has their rules, `packages/core_l10n/CLAUDE.md` the strings' rules.
- The specs are the source of truth. Never guess an open item (`docs/open-questions.md`): ask the owner.

## Commands

Node and Flutter versions are pinned in `.node-version` and `.fvmrc`; pnpm comes from `packageManager` in `package.json`. `fvm install` installs the pinned Flutter and links it at `.fvm/flutter_sdk` (a worktree without one uses the main checkout's), which `pnpm verify` and the format hook use before any Flutter on PATH.

- `pnpm install`, then `dart pub get`: install the TypeScript and Dart dependencies (the pub workspace replaces `melos bootstrap`).
- `pnpm verify`: the single check (it first regenerates the API contract and clients and fails when the committed ones are stale, so it needs Java 11 or later; then Prettier, ESLint, type checks, tests, the web builds and their Playwright smoke tests through Turborepo, then Dart analyze, format and tests through Melos). The database tests start PostGIS with Testcontainers, so Docker must be running. The first run downloads Chromium for Playwright; on Linux it also needs its system libraries (`pnpm --filter @fox-drop/admin exec playwright install-deps chromium`). CI runs its parts as parallel jobs (`node scripts/verify.mjs contract|format|typescript|server|dart|flutter`, the server's tests and the Flutter packages in three shards each with `--shard=<i>/3`; `FLUTTER_TEST_SECONDS` in `verify.mjs` balances the Flutter shards), skips all but Prettier and the instruction size check for a change of Markdown and `docs/` only (only the spec files a test reads count as code: `SPEC_FILES_READ_BY_TESTS` in `scripts/classify-changes.mjs`, checked by its test), skips the Dart and Flutter parts for a change without Dart, runs a pull request's native release builds only for a native change or the `native-builds` label, and `main` requires the `verify` job that gathers them. The `checker` agent runs it for you.
- `node scripts/verify.mjs --changed`: only what the change since origin/main can break, committed or not (the paths are classified by `scripts/classify-changes.mjs`, which CI uses too). The `checker`'s default; a `Stop` hook runs it when a turn ends with unchecked code changes and hands back only the failing step. CI runs everything and stays the gate.
- `docker compose up --detach`: the local PostGIS, Valkey and Centrifugo, after copying `.env.example` to `.env`; then `pnpm --filter @fox-drop/server db:migrate`.
- `docker compose run --rm osrm-build`, then `docker compose --profile osrm up --detach`: OSRM over Azaz's region (it downloads the 82 MB Syria extract into a Docker volume). Without it, distances fall back to the straight line × 1.3.
- `pnpm generate:api`: regenerate the OpenAPI document and the TypeScript and Dart clients after a route or schema change (needs Java 11 or later); `pnpm verify` fails when the committed ones are stale.
- `pnpm format`: format every file with Prettier. Edits made by Claude are formatted by a hook.
- `dart run melos run <script>`: one Dart step on its own (`analyze`, `format:check`, `test:dart`, `test:flutter`).

## Non-negotiable rules

- **Money:** integer minor units with a currency code, never floats. Balances change only through the `ledger` module, as append-only double-entry entries (architecture §4.3, `docs/domain/`).
- **Modules:** each server module owns its PostgreSQL schema. Another module reaches it only through its public service or its domain events (architecture §4.3).
- **Transactions:** a state change and its timers are written in one transaction, and events leave through the outbox (E3, E4).
- **Clients:** API clients are generated from the OpenAPI document, never written by hand (E6). No secret ships inside an app or a web bundle (E7).
- **Arabic, right to left:** every user-facing string lives in translation files; layouts use start and end, never left and right; Western digits (AP §4.7).
- **Design first:** the design system is architecture §9 (Phase D). Code a component or a screen only after the owner approved its drawing (§9.9); screens use semantic tokens and `core_ui` or `ui-web` only (§9.5).
- **Public repository:** no secrets, keys, signing files, `google-services.json`, `GoogleService-Info.plist` or real personal data. `.env.example` holds fake values only.
- **Private research:** the BeeOrder research stays outside this repository.
- A rule a machine can check belongs in a test or a lint rule, not in prose.

## How to work

- One task per session: a slice, a fix or a docs change. Use plan mode for work that spans several packages, and `/clear` between tasks.
- Model, chosen when the session starts and never switched in it (that rewrites the prompt cache): Sonnet 5.5 for docs only, Renovate and small fixes; Opus 5.5 for the rest (`docs/claude-code-workflow.md`, phase 6 item 6).
- Read the spec sections the task cites and their definition of done, and build only what they say. No helpers, options or abstractions before their first real use.
- For domain rules (order states, timers, money), write the failing test first.
- Show evidence: the command and its result. A task is done when its checks pass, not when the code is written.
- Fix root causes. Never silence a failing test, a type error or a lint rule. A flaky test is fixed at its cause: no retries, sleeps or skips. After three failed attempts at the same check, stop and ask the owner.
- Context is the cost: every turn resends it. Read with Read and Grep, a line range at a time; never `cat` a whole long file or a `CLAUDE.md` already loaded (a folder's and its parents' load by themselves; Read once one that a loaded one says to read first). Send searches across many files to the `Explore` agent and keep only its answer.
- Requests are the other cost: each tool call in its own message resends the whole context. Send independent calls (reads, greps, `git status` and `git log`) together in one message. Read files with Read, search them with Grep and edit them with Edit, never with `cat`, `sed -n`, `head`, `sed -i` or an inline script (a hook logs these, `.claude/hooks/bash.mjs`). Look at `git diff --stat` first, then the diff of one path at a time when needed. A test command's output comes back cut to its failures and summary, with the path of the whole output.
- Before a feature's pull request, run the `reviewer` subagent and fix what it finds; it applies `REVIEW.md` from `main`. A bug found after a merge becomes a `REVIEW.md` item or a test in its fix's pull request.
- Keep `TASKS.md` current: the plan as a checklist, and a "Stopped at" line when a session ends with work open. Commit and push after each finished step.
- Stop and ask the owner about: scope, business rules, open items, a feature's split into pull requests, destructive or non-backward-compatible migrations, production deploys, and anything that touches real money or real users.

## Git

- Branch from `main` as `feat/`, `fix/`, `docs/`, `chore/`, `refactor/` or `test/` plus a topic.
- Conventional Commits; the body says what changed and why.
- Every change reaches `main` through a pull request with a merge commit (no squash or rebase). The body has `## Summary` and `## Test plan`, and `## Checks changed` when the change touches `ci.yml`, `scripts/verify.mjs` or `REVIEW.md`. Open it and merge it once its checks pass, without asking.

## Language

Talk to the owner in Arabic: messages, questions and reports. Everything stored in the repository is English, except Arabic UI labels written in «guillemets».

## Reporting

End every substantial task with these sections, in Arabic, in this order:

1. «ما المطلوب منك»: decisions blocking progress, what the owner can try (a slice's acceptance steps, to run after the merge), or «لا شيء». When the task opened or merged a pull request and the branch is still checked out locally, end with the cleanup line in a code block: `cd D:\fox-drop; git switch main; git pull --ff-only; git branch -d <branch>`.
2. «ما تغيّر»: what was built or changed, with the pull request link.
3. «التحقق»: the checks run and their results.
4. «ما وجدته»: issues, risks and follow-ups noticed.
5. «الخطوة التالية»: always last. The next task (from `docs/roadmap.md` or what this task uncovered), why it comes next and what it needs from the owner first; whether it needs a new session (`/clear`); the model by that rule and the effort if it differs from `.claude/settings.json`; and the exact first message to send, in its own code block.
