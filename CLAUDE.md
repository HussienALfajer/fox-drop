# FOX DROP

Food delivery platform for Syria, launching in Azaz: a customer app, a restaurant app with an owner web portal, a captain (courier) app, and the owner's admin panel. Status lives in `docs/roadmap.md`, never here.

## Where things are

- `docs/README.md`: the map of all documentation, the citation codes (AP, RA, CA, CU) and the decision ID prefixes. Start there, then read only the sections a task needs.
- `docs/product/v1/<party>/`: the specs, one file per section. `docs/domain/`: the shared rules (AP §8). `docs/architecture/`: the stack and its rules. The specs are the source of truth; never guess an open item (`docs/open-questions.md`): ask the owner.
- How we work (risk tiers, slice loop, definition of done): `docs/process/development-workflow.md`. Status: `docs/roadmap.md`. A slice's plan and hand-over: its file in `docs/slices/`. Open items: `docs/backlog.md`. Slices before 2026-11-23: the read-only archive `docs/slice-notes.md`.
- Folder `CLAUDE.md` files and the path-scoped `.claude/rules/*.md` hold the rules for working in a folder and load by themselves; `docs/code/<folder path>.md` holds what each feature there does, what was decided and why. Grep it for the feature you touch; never read it whole.
- `apps/server/`: the server; its `CLAUDE.md` has the module, route, validation and logging rules. The web apps (`apps/admin/`, `apps/merchant-portal/`) share `.claude/rules/web-apps.md`; the Flutter apps (`apps/customer/`, `apps/captain/`, `apps/merchant/`) share `.claude/rules/flutter-apps.md`, and `packages/core_l10n/CLAUDE.md` has the strings' rules.

## Commands

Node and Flutter versions are pinned in `.node-version` and `.fvmrc`; pnpm comes from `packageManager` in `package.json`. `fvm install` installs the pinned Flutter and links it at `.fvm/flutter_sdk` (a worktree without one uses the main checkout's), which `pnpm verify` and the format hook use before any Flutter on PATH.

- `pnpm install`, then `dart pub get`: install the TypeScript and Dart dependencies (the pub workspace replaces `melos bootstrap`).
- `pnpm verify`: the whole check. It first regenerates the API contract and clients and fails when the committed ones are stale (needs Java 11 or later); then Prettier, ESLint, type checks, tests, the web builds and their Playwright smoke tests through Turborepo, then Dart analyze, format and tests through Melos. The database tests start PostGIS with Testcontainers, so Docker must be running. CI runs its parts as parallel jobs (`node scripts/verify.mjs contract|format|typescript|server|dart|flutter`, the server's tests and the Flutter packages in three shards each with `--shard=<i>/3`), skips all but Prettier and the instruction size check for a change of Markdown and `docs/` only (only the spec files a test reads count as code: `SPEC_FILES_READ_BY_TESTS` in `scripts/classify-changes.mjs`), skips the Dart and Flutter parts for a change without Dart, and runs native release builds only for a native change or the `native-builds` label.
- `node scripts/verify.mjs --changed`: only what the change since origin/main can break, committed or not (classified by `scripts/classify-changes.mjs`, which CI uses too). The `checker` agent runs it; a passing run records the tree, so the Stop hook skips it. One check at a time in a folder (a lock; a second exits with 3). CI runs everything and stays the gate.
- `docker compose up --detach`: the local PostGIS, Valkey and Centrifugo, after copying `.env.example` to `.env`; then `pnpm --filter @fox-drop/server db:migrate`.
- `docker compose run --rm osrm-build`, then `docker compose --profile osrm up --detach`: OSRM over Azaz (else straight line × 1.3).
- `pnpm generate:api`: regenerate the OpenAPI document and the TypeScript and Dart clients after a route or schema change.
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
- A rule a machine can check belongs in a test, a lint rule or a hook, not in prose.

## How to work

- Slice loop: `/spec` (only beyond the written specs) → `/slice-plan` (fresh session, plan mode) → `/build-slice` (one session from the slice file) → `reviewer` (+ `security-reviewer` for T0) → pull request. One slice per session and per pull request; `/clear` between tasks.
- Model: Opus 5.5 always, chosen when the session starts and never switched in it. Effort by risk tier (`docs/process/development-workflow.md` §2): **T0** money, ledger, order states and timers, auth, migrations, secrets, deploy and CI: high or xhigh; **T1** domain services, routes, contracts: medium (high for tricky logic); **T2** UI, docs, tests: medium or low.
- Build only what the cited spec sections say. No helpers, options or abstractions before their first real use.
- Tests first: failing tests in the red phase, then locked (`/build-slice`); always for order states, timers and money.
- Show evidence: the command and its result. A task is done when its checks pass, not when the code is written.
- Fix root causes. Never silence a failing test, a type error or a lint rule. A flaky test is fixed at its cause: no retries, sleeps or skips. After three failed attempts at the same check, stop and ask the owner.
- Send independent tool calls together in one message; send wide searches to the `Explore` agent.
- A bug found after a merge becomes a `REVIEW.md` item or a test in its fix's pull request.
- Commit and push at every green checkpoint; keep the slice file's "Stopped at" line current.
- Stop and ask the owner about: scope, business rules, open items, a feature's split into pull requests, destructive or non-backward-compatible migrations, production deploys, and anything that touches real money or real users.

## Git

- Branch from `main` as `feat/`, `fix/`, `docs/`, `chore/`, `refactor/` or `test/` plus a topic. Conventional Commits; the body says what changed and why.
- Every change reaches `main` through a pull request, merged with squash. The body has `## Summary` and `## Test plan`, and `## Checks changed` when the change touches `ci.yml`, `scripts/verify.mjs` or `REVIEW.md`.
- When a task's work is done, finish it in the same turn without asking: update the roadmap, the slice file and every doc the change made stale; check `git status` and `git diff --stat` for stray or secret files; `checker` green; review by tier; `gh pr create --base main`; then enable auto-merge (`gh pr merge --auto --squash --delete-branch`) and the app's Auto-fix. If CI fails, fix the cause on the branch and push.

## Enforced by hooks (`.claude/hooks/`)

- Secret files (`.env*`, keys) are readable and editable; never commit them.
- Edits are refused for generated files (`packages/core_api/lib/`, the OpenAPI document and its TypeScript types, `generated/` folders, `*.g.dart`, lockfiles, Drizzle's `migrations/meta/`), the read-only archives (`docs/archive/`, `docs/slice-notes.md`), migrations merged to `main` (add a new one) and the slice's locked tests (`.claude/state/locked-tests.txt`).
- Shell writes into `apps/`, `packages/`, `scripts/`, `infra/` and `.claude/` are refused: use Edit or Write so the format hook runs. The guard reads the command text, so it cannot see `cd apps && echo > x` or `cp` and `node -e` writes: do not use them.
- `--no-verify`, force pushes, pushes to `main`, permission bypasses, run-time package fetches (`npx -y`, `dlx`, `bunx`) and installs outside pnpm are refused.
- On stop, a session's own uncommitted code changes must pass `--changed`, unless `.claude/state/red-phase` exists or the tree already passed.
- At session end, uncommitted work is reported.

## Language

Talk to the owner in Arabic: messages, questions and reports. Everything stored in the repository is English, except Arabic UI labels written in «guillemets».

## Reporting

End every substantial task with these sections, in Arabic, in this order:

1. «ما المطلوب منك»: decisions blocking progress, what the owner can try (a slice's acceptance steps, to run after the merge), or «لا شيء». When the task opened or merged a pull request, end with the cleanup line in a code block, to run after the merge (squash merges need `-D`): `cd D:\fox-drop; git switch main; git pull --ff-only; git fetch --prune; git branch -D <branch>`.
2. «ما تغيّر»: what was built or changed, with the pull request link.
3. «التحقق»: the checks run and their results.
4. «ما وجدته»: issues, risks and follow-ups noticed.
5. «الخطوة التالية»: always last. The next task (from `docs/roadmap.md` or what this task uncovered), why it comes next and what it needs from the owner first; whether it needs a new session (`/clear`) and plan mode; the effort by its tier; and the exact first message to send, in its own code block.
