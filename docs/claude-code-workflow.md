# Claude Code workflow plan

How FOX DROP is built with Claude Code, what it costs, and the plan to cut tokens and check time. It applies three Anthropic posts (Code Mode, how the Claude Code team thinks about verification, which Claude model to build with) and the Claude Code docs on costs, context, prompt caching, memory and subagents.

Phase 1 (the context diet) is done. A second audit on 2026-11-21 measured where the cost really goes and reordered the rest: the phases below are in the order to do them.

## Baseline

### First audit (2026-11-20, last 40 sessions)

- **Session start:** about 75K tokens before the first message: the desktop app's tool schemas (about 30K), the system prompt (8K), the skill listing (16K, mostly personal video and social media skills and plugins unrelated to this project), deferred MCP tool names (6K) and the instruction files (5K).
- **A slice session:** peak context 400–560K tokens, 100–220M cache-read tokens; an average of 284K context tokens a request.
- **Folder `CLAUDE.md` files:** 941 KB in 38 files, about 40K tokens carried by the average session and 165K by the worst. Fixed by phase 1 (now 117 KB, at most 4 KB each).
- **Checks:** the `checker` ran the full `pnpm verify` 305 times (median 3.7 min, p90 9.5 min, 25.6 h in all), with every Turborepo cache off and no changed-only mode.

### Second audit (2026-11-21, all 134 sessions and 506 subagent runs since 2026-11-02)

Costs are API list prices, used only to weigh one thing against another; the subscription's limits follow the same proportions.

- **Model:** Opus 5.5 is 98.5% of the cost. Fable, Sonnet and Haiku together are 1.5%, so the model of the main session is not where the saving is; the context and the number of requests are.
- **What a main session pays for:** cache reads 60%, cache writes 22%, output 18%. Uncached input is nothing. Idle gaps past the one-hour cache broke it only 10 times: not a problem.
- **Requests:** 17,973 in main sessions. 83% of the assistant messages hold exactly one tool call, and 12,178 of them are a single Bash command. Main sessions made 13,645 Bash calls against 709 Read and 175 Grep calls: `sed -n` 2,695 times, `grep -n` 2,666, `python -` 1,521, `git diff` 616 (8.5 KB each), `sed -i` 557. Every one is a request that resends the whole context.
- **The shell itself:** on the owner's machine every Bash command prints an fnm error, Node commands need a two-command prefix (726 calls), and `cd … &&` sometimes skips the rest silently.
- **Context that grows by itself:** MCP servers that connect or reconnect during a session announce themselves again: 872 instruction deltas (7.6 KB each) and 570 tool-name deltas (8.6 KB each), about 22K tokens a session on top of the 75K start. With the folder files fixed, the personal MCP servers, plugins and skills are now about a third of the average request's context.
- **Effort:** 22% of main requests ran at `high` or `xhigh`, set per turn; `high` costs about 40% more than `medium` for about 2.5 points on SWE-bench Pro.
- **Subagents:** 24% of the cost. `reviewer` 13% (Opus, about 31 requests a run). `general-purpose` 9%: 33 runs on Opus at about 5.5 USD each, the most expensive thing per call. Subagents pay more for cache writes than for reads (each starts cold), and over half their output is thinking. `checker` on Haiku costs nothing: its cost is the wait.
- **Sessions:** median 129 requests; the 25 sessions past 200 requests hold 37% of the main cost.
- **CI, per job:** every job of a pull request without native builds ends within 4 minutes (server shards 3–4, TypeScript 3, Dart and Flutter 2, contract 2.5). The wait is the native release builds: iOS 25–36 min, Android 10–11 for each of three apps, Windows 10. Renovate pull requests that touch `ci.yml` took 60–75 min each.
- **CI filter bugs:** every file under `docs/product` and `docs/domain` counts as code although only a few test files read a spec file; once anything counts as code, a Markdown file under a Flutter app or a `core_` package sets the Dart, Flutter and native build jobs; a merge of specs alone builds the staging APKs and the Windows installer and deploys staging. The `verify` job requires `windows-release` and `ios-release` but not `android-release`, so a broken Android release build does not block a merge.
- **Local checks:** the server's 242 test files take about 223 s and the server is where most changes land, so skipping unaffected packages alone (`turbo --affected`) would not shorten the common case.

## Phase 1: context diet (done, `chore/claude-context-diet`)

1. Folder `CLAUDE.md` files hold only what an agent editing the folder must know and would get wrong otherwise, at most 4 KB. The behaviour, decisions and slice history moved to `docs/code/<folder path>.md`, which nothing loads by itself; grep it for the feature you touch.
2. `TASKS.md` holds the current task only (at most 8 KB). Earlier handover notes are in `docs/slice-notes.md`.
3. `pnpm verify` fails when a folder `CLAUDE.md` passes 4 KB, the root one 10 KB or `TASKS.md` 8 KB.
4. An `Explore` agent on Haiku for wide searches. Reviewer: Opus 5.5 at medium effort, high for money and order state; follow-up rounds go to the same reviewer with the fix's diff only; three rounds, then ask the owner.

## Phase 2: fewer requests, smaller results (done, `chore/fewer-requests`)

The largest lever left: the cost is the context times the number of requests, and four requests in five carry one shell command.

1. Fix the Git Bash profile so the pinned Node is on PATH without a prefix and nothing prints an fnm error; then delete the workaround from the memory notes.
2. A `PreToolUse` hook on Bash that refuses reading a tracked file with `sed -n`, `cat`, `head` or `tail`, and editing one with `sed -i` or an inline script, and names the tool to use (Read with a line range, Grep, Edit). Start it in observe mode (it logs what it would refuse), read the log after two sessions for false positives, then enforce. Pipes that filter a command's output stay allowed.
3. Root `CLAUDE.md`: send independent tool calls in one message; `git diff --stat` first and the diff of a path only when needed.
4. A hook that cuts a test command's output to its failures and its summary.
5. `medium` effort for slices; `high` only for a turn that needs it, never as the session's setting.
6. Commit the audit as `scripts/claude-audit.mjs` (requests, context, cost split, tool calls per message, Bash by command, deltas), so every later phase is measured the same way.

Done when: a slice session shows under half the single-Bash requests of the baseline.

Status (2026-11-21): done; items 1 to 4 and 6 are in, the guard enforcing. The owner's `~/.bashrc` (outside the repository) puts the Node of the nearest `.node-version` first on PATH, without fnm's cd hook. `.claude/hooks/bash.mjs` runs before every Bash call: it refuses what item 2 names (`MODE = 'enforce'` at its top since 2026-11-21, slice L.1, after its observe-mode log over two sessions held 5 entries and no false positive: 4 `sed -n` and 1 `cat` of tracked files; `MODE = 'observe'` logs to `.claude/bash-guard.log` instead), and it rewrites a command made only of test commands (and `cd`) to pipe through `.claude/hooks/test-summary.mjs`, which keeps output up to 120 lines whole and otherwise the `===` step headers, the failure lines with their context and the last 40 lines, and saves the whole output to a temporary file it names; the exit status stays the test command's. `pnpm verify` runs their tests (`.claude/hooks/hooks.test.mjs`). Item 5 is the project setting already (`effortLevel: medium`); `high` per turn stays the owner's choice. Phase 2 is done: the slice session of L.1 (2026-11-21, `fac0a54b`, measured before its pull request) had 33 main requests, 8 of them a single Bash call (24.2%, under the goal of 33.9%), 139K tokens of context a request on average, 2.91 USD plus 0.23 USD for its four `Explore` audits. Before that: measure one slice session with `node scripts/claude-audit.mjs --session=<id>` (the whole history on 2026-11-21: 135 sessions, 18,030 main requests, 67.7% of them a single Bash call). First measurement after the merge (2026-11-21): the launch-readiness planning session `5e6c2ce1`, 14 main requests, 2 of them a single Bash call (14.3%, under the goal of 33.9%), 117K tokens of context a request on average, 1.29 USD; a planning session reads more than it runs, so one slice session is still to measure.

## Phase 3: the owner's own settings (with the owner, outside the repository)

About a third of every request's context after phase 1.

1. Disable for this project the `premiere-pro` and `higgsfield` MCP servers and the marketing connectors; enable `hostinger` and `hostinger-dns` only in a session that works on the domain.
2. Disable for this project the marketing, social media, `figma` and `ui-ux-pro-max` plugins (the last two until the design stop), and turn the 38 personal video and Instagram skills off here or move them to their projects.
3. Remove the local proxy (`ANTHROPIC_BASE_URL`) and the plain-text API key from `~/.claude/settings.json` if unused, and revoke the key.
4. A status line with the context and the 5-hour and weekly limits.

Done when: `/context` at the start of a new session shows under 45K tokens, and a session's transcript has no MCP delta.

Status (2026-11-21, with the owner): items 1 to 4 applied on the owner's machine, with backups in `~/.claude/backups/2026-11-21-phase3`.

- `premiere-pro`, `higgsfield`, `hostinger` and `hostinger-dns` are in the project's `disabledMcpServers` in `~/.claude.json`; turn `hostinger` on with `/mcp` for domain work.
- `figma` and `ui-ux-pro-max` are off in the git-ignored `.claude/settings.local.json`.
- The 37 video, Remotion and Instagram skills moved to `~/.claude/skills-off`; only `vertex-server` stays.
- The Canva connector is off by default.
- The unused proxy and the plain-text key are gone from `~/.claude/settings.json`; nothing listened on its port.
- `~/.claude/statusline.mjs` shows the model, the context used and the 5-hour and weekly limits (terminal `claude` only).

Left to the owner in the app's settings: the `marketing` plugin (13 connectors) and the `social-media-skills` plugin, which no settings file controls.

Found: the Bash guard refuses an inline script that writes files outside the repository (here `~/.claude.json`), a false positive. Fixed with phase 4: it flags an inline script that writes only when it names a tracked file or a file in a tracked folder.

Measured (2026-11-21, the first request of the phase 4 session in the desktop app, from its transcript, since an agent cannot run `/context`): 75.7K tokens at the start, and one MCP instruction delta (3 KB) when the `marketing` plugin's connectors announced they need authorization. Not done: the goal is under 45K. What is left is the desktop app's own tool schemas and the `marketing` and `social-media-skills` plugins (their skill listing and connectors), which only the app's settings turn off; `/context` in a terminal `claude` session would show the split.

## Phase 4: fast checks (`chore/fast-verify`)

1. One script classifies a change's paths; `ci.yml` and `verify.mjs` share it.
2. `node scripts/verify.mjs --changed`, the `checker`'s default. Markdown only: Prettier on the changed files and the size check. TypeScript: `turbo --affected`, and inside the server `vitest run --changed origin/main`, with the migrations, the fixtures and the spec files that tests read as `forceRerunTriggers`. Dart: Melos `--diff`. The API contract only after a route or schema change. The full run stays in CI, which is the gate.
3. Turborepo cache for `lint` and `typecheck` only.
4. A `Stop` hook that runs the fast check when a turn ends with code changes and prints only failures.
5. Measure a Markdown-only change, a one-module server change and a Flutter change, before and after.

Done when: the fast check of a one-module server change takes under a minute.

Status (2026-11-21): done. `scripts/classify-changes.mjs` classifies the paths for both CI's `changes` job (the same rules as before; phase 5 changes them) and `node scripts/verify.mjs --changed` (`--changed=<ref>` for a branch stacked on another), with `scripts/classify-changes.test.mjs`. `.claude/hooks/stop-verify.mjs` is the `Stop` hook: once for each new set of uncommitted code changes, it hands Claude the failing step only, cut by `test-summary.mjs`, and lets the turn end the next time. Turborepo caches `lint` and `typecheck`, which depend on `^transit` so a change in a package they import misses the cache. Two changes from the plan, after measuring:

- The server's tests: Vitest's `--changed` ran 162 of the 242 files for a change to one module (170 s), since every test that starts the app imports every module. A change inside `src/modules/<name>/` runs that module's tests and `test/` (the boundary tests); any other server change runs `--changed`, with the migrations, the fixtures, `src/database` and the spec files tests read as `forceRerunTriggers`. A module's change that breaks another module's test is caught by CI.
- Dart: Melos's `--diff` sees commits only, so the changed packages come from the paths (`--scope` with `--include-dependents`). The analyzer runs over the workspace (one run is as fast as a few packages); a change to what every package shares (the workspace pubspec, the lock file, `.fvmrc`, the root analysis options) checks them all. `ci.yml` and `verify.mjs` set CI's Dart jobs but not the local Dart checks.

Measured on the owner's machine (before: the `checker` ran the full `pnpm verify` for every change, median 3.7 min, p90 9.5 min; the server's tests alone 223 s):

| Change                                         | `--changed`                                                                  |
| ---------------------------------------------- | ---------------------------------------------------------------------------- |
| Markdown only (`docs/roadmap.md`)              | 1.2 s                                                                        |
| One server module (`content/terms.service.ts`) | 43 s (turbo lint, type check and build 21 s, 9 test files 15 s); 39 s cached |
| Flutter (`apps/customer/lib/main.dart`)        | 1 min 47 s (analyze, format and the customer app's 188 tests, 23 s of them)  |

## Phase 5: CI (`chore/ci-filters`, may ride with phase 4: they share the classifier)

1. Markdown never sets a code, Dart or Flutter job. Only the spec files a test reads count as code, listed in the classifier and checked by a test that fails when a test reads a spec file not in the list.
2. The native release builds on a pull request run only when a native project (`android/`, `ios/`, `windows/`), a pubspec or lock file, a package with native code, the pinned Flutter or the workflow changes, or with a label. The staging builds on `main` stay and catch the rest.
3. `verify` requires `android-release` too.
4. Cache CocoaPods and the Swift packages in the iOS jobs.
5. A merge of specs or docs alone builds and deploys nothing.
6. Renovate groups GitHub Actions updates into one weekly pull request.

Done when: a docs-only pull request passes in under 2 minutes and a server-only one in under 5.

Status (2026-11-21): built. `scripts/classify-changes.mjs` prints four flags for CI: `code` (the checks: any path outside Markdown and `docs/`, or a spec file in `SPEC_FILES_READ_BY_TESTS`), `dart`, `native` (an app's `android/`, `ios/`, `windows/`, a pubspec or `pubspec.lock`, a package in `NATIVE_PACKAGES`, `.fvmrc`, `ci.yml`) and `build` (the images, the staging builds and the deploy: any path outside Markdown and `docs/`). Its test fails when a test file quotes a spec path missing from `SPEC_FILES_READ_BY_TESTS`, or when a package with a native folder is missing from `NATIVE_PACKAGES`. The `native-builds` label runs the native release builds on a pull request (`labeled` is one of its triggers). `verify` needs `android-release`. `ios-release` and `staging-ios` share a cache of CocoaPods' downloads and the Swift packages, keyed on `pubspec.lock`, the app's `Podfile` and its Xcode project; while `staging-ios` is skipped (no Apple account), main writes no cache, so a pull request reuses only its own earlier runs. Renovate groups every GitHub Actions update, majors included, into one weekly pull request.

Measured on GitHub Actions (2026-11-21), from the run's start to its last job (both targets met):

| Pull request                                                | CI        | Longest job                                                                                                                               |
| ----------------------------------------------------------- | --------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| Docs only (#225, `docs/claude-code-workflow.md`)            | 55 s      | `format` 47 s; every code, Dart, Flutter, native, image and deploy job skipped                                                            |
| Server only (#224, a comment in `content/terms.service.ts`) | 4 min 9 s | `server` shard 1 3 min 48 s (shards 2 and 3 3 min 10 s); `contract` 2 min 21 s, `typescript` 2 min 16 s; Dart, Flutter and native skipped |

## Phase 6: session shape and subagents

1. Try an auto-compact window of about 200K (`autoCompactWindow`) on one slice and compare its cost and its result with the baseline; keep it only if the slice loses nothing.
2. A slice in three sessions when it is large: plan, build, review fixes, with `TASKS.md` as the handover.
3. `CLAUDE_CODE_SUBAGENT_MODEL=sonnet`, and purpose-built agents on Sonnet instead of `general-purpose` on Opus.
4. Test the reviewer: about 10 past pull requests with a known blocking bug, each with a one-sentence answer key, plus clean ones as controls; compare Sonnet 5.5 medium, Opus 5.5 medium and Opus 5.5 high, and keep the cheapest that finds the same bugs.
5. Split the `deploy` skill (30 KB) into a short file and reference files read when needed.
6. Sonnet 5.5 for docs-only, Renovate and small fixes; Opus 5.5 at medium for slices. Never switch models mid-session (it rewrites the prompt cache).

Status of item 5 (2026-11-21, `chore/deploy-skill-split`): built. `.claude/skills/deploy/SKILL.md` went from 30 KB to 6 KB: the staging table, deploy, rollback and provisioning stay, with a table of the reference files. Seven files in `.claude/skills/deploy/references/` hold the rest, each read only when the task needs it: `osrm-storage.md`, `secrets.md`, `accounts.md`, `android-windows-builds.md`, `ios-builds.md`, `app-check.md` and `restore-and-checks.md`. The text moved unchanged, except two cross-references.

Status of item 3 (2026-11-21): built on `chore/subagents-sonnet`. `.claude/settings.json` sets `CLAUDE_CODE_SUBAGENT_MODEL=sonnet` under `env`, without `CLAUDE_CODE_SUBAGENT_MODEL_FORCE`: the docs' order is the call's `model` parameter, then the agent's `model` field, then this variable, then the main session's model. So `general-purpose` and any agent without a `model` field now run on Sonnet, while `checker` and `Explore` keep Haiku, `reviewer` keeps Opus until item 4 picks its model, and the built-in `Plan` still inherits the main session's model. The 41 `general-purpose` runs so far were spec writing and condensing, research, the short `CLAUDE.md` rewrite and pieces of slices (2.9's admin panel and Flutter apps, a review's fixes); research has `claude-code-guide` and `web-fetch`, and the rest goes to a new `builder` agent on Sonnet at medium effort, which edits only the files it is given, never commits, and reports in 250 words.

Checked (2026-11-21, `chore/reviewer-test`): the variable does not work in the desktop app. A `general-purpose` probe ran on Opus 5.5 (its transcript's `model`), and `CLAUDE_CODE_SUBAGENT_MODEL` was not in the session's environment at all, so the app does not pass the settings' `env` to the process. The call's `model` parameter and an agent's `model` field both work (a probe of each ran on Sonnet 5.5). So `.claude/agents/general-purpose.md` now replaces the built-in agent with one on Sonnet (`isBuiltIn: false`; the probe ran on Sonnet), the way `Explore.md` replaces the built-in `Explore`. The variable stays for terminal `claude` sessions. The built-in `Plan` still inherits the main session's model.

Status of item 6 (2026-11-21, `docs/model-choice`): decided; the rule is in the root `CLAUDE.md` (How to work, Reporting).

- **Sonnet 5.5 at medium:** a change of Markdown and `docs/` only (specs, notes, `CLAUDE.md`, skills), a Renovate pull request, and a small fix: a few files in one package, with no money, ledger, order state, timer, migration, auth, secret or deploy in it, and no new route or schema.
- **Opus 5.5 at medium (the project default, `.claude/settings.json`):** every slice, plan mode across packages, any fix that touches what the small fix excludes, the deploy skill's work, and anything whose size is unclear. `high` stays a per-turn choice (phase 2 item 5).
- **How:** the owner picks the model before the first message (the app's model picker, or `claude --model sonnet` in a terminal); the setting stays `opus`, so a session without a choice gets Opus. The previous session's «الخطوة التالية» names the model for the next task by this rule.
- **No switch:** a Sonnet session that finds the task bigger than this rule allows stops, writes the "Stopped at" line in `TASKS.md`, and its report hands the task to a new Opus session. Subagents keep their own models (`builder` and `general-purpose` Sonnet, `reviewer` Opus, `checker` and `Explore` Haiku); they never change the main session's cache.
- **Why:** the second audit puts 98.5% of the cost on Opus, and the reviewer test (item 4) showed Sonnet missing half the bugs that Opus found in slice code; docs and dependency bumps carry no such bug, so they are where Sonnet saves without loss. To measure after a month: the cost of Sonnet sessions against Opus sessions of the same kind with `scripts/claude-audit.mjs`.

Status of item 4 (2026-11-21, `chore/reviewer-test`): measured; the reviewer stays on Opus 5.5 at medium. Eight past slices with a known bug, each reviewed blind in a detached worktree at the commit before the review's fix (its base given, no look at later commits), with the bug from that fix commit as the answer key; and two controls, the same slice right after its fix. Sonnet 5.5 medium and Opus 5.5 medium reviewed all ten; Opus 5.5 high reviewed the four that Opus medium missed.

| Case (pull request, fix commit) | Answer key                                                                                       | Sonnet medium      | Opus medium        | Opus high                           |
| ------------------------------- | ------------------------------------------------------------------------------------------------ | ------------------ | ------------------ | ----------------------------------- |
| #30, `3eb5ab4f`                 | A fee rule can be entered only in the current base, so the base can never change after one.      | missed             | found, blocking    | –                                   |
| #38, `420cce0e`                 | Two placings with one key at once: the second is refused by what the first changed.              | missed (called OK) | missed             | missed                              |
| #39, `ed4c0efe`                 | A failed timer job is not retried, so a database blip leaves an order placed forever.            | missed             | found, should fix  | –                                   |
| #44, `287b05e5`                 | An early «الطلب جاهز» does not move a search start still ahead to now.                           | missed             | missed             | half (the job's moment), should fix |
| #116, `087c669c`                | A dispatch pass reads the mode and the clock once, so a slow pass shortens offers.               | missed (called OK) | half (mode), minor | missed                              |
| #120, `40f2e09d`                | A hand-in sent twice at once with one key does not answer the first's receipts.                  | found, should fix  | found, should fix  | –                                   |
| #137, `f5956645`                | With the restaurant responsible, the owner's lines still show a commission and the pickup money. | missed             | missed             | missed                              |
| #144, `1bd3ae01`                | A manual reversal accepts an order's journals, so a later «تغيير النتيجة» fails.                 | found, should fix  | found, blocking    | –                                   |
| Controls (#38, #137 after fix)  | No blocking finding, and the fixed bug not reported again.                                       | both clean         | both clean         | –                                   |

- **Keys found:** Sonnet medium 2 of 8; Opus medium 4 and two halves; Opus high none of the four Opus medium missed, one half. Sonnet twice named the buggy code as correct.
- **Other items of the same fix commits found:** Sonnet 1–2 a case, Opus medium 2–3, Opus high 2 more than Opus medium on each of its four cases (the per-order failure and the mixed fallback of #116, the job's moment and the busy minutes of #44).
- **Cost and time per run** (API list prices, from the transcripts): Sonnet medium 0.10–0.33 USD (mean 0.19), 4–16 tool calls, 26–76 s; Opus medium 0.55–1.51 USD (mean 1.01), 8–42 tool calls, 2–4.5 min; Opus high 1.47–2.29 USD (mean 1.84, 1.6 × Opus medium on the same cases), 25–53 tool calls, 4.5–7.7 min.
- **Decision:** Sonnet is five times cheaper but finds half the bugs, and a review that calls a race correct costs more than it saves. Opus high finds more of each fix's smaller items, not the bugs Opus medium misses, at 1.6 times the cost; it stays a per-call choice for money and order state, as phase 1 set. Sample of eight: a direction, not a measurement.
- **What all three missed:** concurrent requests with one idempotency key (#38, and #120 only as should fix) and a derived value that ignores the outcome (#137). Both are candidates for phase 7's `REVIEW.md` checklist.
- **Found on the way:** two Opus reports came back in Arabic, from the owner's global instruction; `reviewer.md` now says to report in English.

## Phase 7: verification that catches more

From the verification post:

1. A `verify` skill that boots the server and the web apps and drives a real order through them (step trace and screenshot on failure), with a feature map (each feature from the user's side, its path, selectors and expected result) as guide and rubric. Fits launch readiness.
2. Property tests with fast-check for money: every journal balances per currency, rounding round-trips, a repeated request or timer job posts once.
3. A diff-triggered checklist in `REVIEW.md`, read from `main`, never from the branch under review; a change to `ci.yml`, `verify.mjs` or `REVIEW.md` is named in the pull request.
4. Every bug found after a merge becomes a `REVIEW.md` item or a test; prune both on a routine.

## Not now

- Code Mode (experimental) would batch tool calls, which is this project's largest cost, but it needs a terminal session (not the desktop app), the native build v2.1.323 or later (2.1.295 is installed) and no gateway or API key helper. Try it on a mechanical multi-file task once phase 3 has removed the proxy.
- `opusplan`: it puts the code edits on Sonnet, the reverse of the model post's advice.
- A second reviewer on top of the first: tune the one reviewer instead.
