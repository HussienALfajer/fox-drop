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

## Phase 2: fewer requests, smaller results (`chore/fewer-requests`)

The largest lever left: the cost is the context times the number of requests, and four requests in five carry one shell command.

1. Fix the Git Bash profile so the pinned Node is on PATH without a prefix and nothing prints an fnm error; then delete the workaround from the memory notes.
2. A `PreToolUse` hook on Bash that refuses reading a tracked file with `sed -n`, `cat`, `head` or `tail`, and editing one with `sed -i` or an inline script, and names the tool to use (Read with a line range, Grep, Edit). Start it in observe mode (it logs what it would refuse), read the log after two sessions for false positives, then enforce. Pipes that filter a command's output stay allowed.
3. Root `CLAUDE.md`: send independent tool calls in one message; `git diff --stat` first and the diff of a path only when needed.
4. A hook that cuts a test command's output to its failures and its summary.
5. `medium` effort for slices; `high` only for a turn that needs it, never as the session's setting.
6. Commit the audit as `scripts/claude-audit.mjs` (requests, context, cost split, tool calls per message, Bash by command, deltas), so every later phase is measured the same way.

Done when: a slice session shows under half the single-Bash requests of the baseline.

Status (2026-11-21): items 1 to 4 and 6 are in. The owner's `~/.bashrc` (outside the repository) puts the Node of the nearest `.node-version` first on PATH, without fnm's cd hook. `.claude/hooks/bash.mjs` runs before every Bash call: in observe mode (`MODE` at its top) it logs to `.claude/bash-guard.log` what it would refuse, and it rewrites a command made only of test commands (and `cd`) to pipe through `.claude/hooks/test-summary.mjs`, which keeps output up to 120 lines whole and otherwise the `===` step headers, the failure lines with their context and the last 40 lines, and saves the whole output to a temporary file it names; the exit status stays the test command's. `pnpm verify` runs their tests (`.claude/hooks/hooks.test.mjs`). Item 5 is the project setting already (`effortLevel: medium`); `high` per turn stays the owner's choice. Left: read the guard log after two sessions and switch `MODE` to `enforce`, and measure one slice session with `node scripts/claude-audit.mjs --session=<id>` (the whole history on 2026-11-21: 135 sessions, 18,030 main requests, 67.7% of them a single Bash call). First measurement after the merge (2026-11-21): the launch-readiness planning session `5e6c2ce1`, 14 main requests, 2 of them a single Bash call (14.3%, under the goal of 33.9%), 117K tokens of context a request on average, 1.29 USD; a planning session reads more than it runs, so one slice session is still to measure.

## Phase 3: the owner's own settings (with the owner, outside the repository)

About a third of every request's context after phase 1.

1. Disable for this project the `premiere-pro` and `higgsfield` MCP servers and the marketing connectors; enable `hostinger` and `hostinger-dns` only in a session that works on the domain.
2. Disable for this project the marketing, social media, `figma` and `ui-ux-pro-max` plugins (the last two until the design stop), and turn the 38 personal video and Instagram skills off here or move them to their projects.
3. Remove the local proxy (`ANTHROPIC_BASE_URL`) and the plain-text API key from `~/.claude/settings.json` if unused, and revoke the key.
4. A status line with the context and the 5-hour and weekly limits.

Done when: `/context` at the start of a new session shows under 45K tokens, and a session's transcript has no MCP delta.

## Phase 4: fast checks (`chore/fast-verify`)

1. One script classifies a change's paths; `ci.yml` and `verify.mjs` share it.
2. `node scripts/verify.mjs --changed`, the `checker`'s default. Markdown only: Prettier on the changed files and the size check. TypeScript: `turbo --affected`, and inside the server `vitest run --changed origin/main`, with the migrations, the fixtures and the spec files that tests read as `forceRerunTriggers`. Dart: Melos `--diff`. The API contract only after a route or schema change. The full run stays in CI, which is the gate.
3. Turborepo cache for `lint` and `typecheck` only.
4. A `Stop` hook that runs the fast check when a turn ends with code changes and prints only failures.
5. Measure a Markdown-only change, a one-module server change and a Flutter change, before and after.

Done when: the fast check of a one-module server change takes under a minute.

## Phase 5: CI (`chore/ci-filters`, may ride with phase 4: they share the classifier)

1. Markdown never sets a code, Dart or Flutter job. Only the spec files a test reads count as code, listed in the classifier and checked by a test that fails when a test reads a spec file not in the list.
2. The native release builds on a pull request run only when a native project (`android/`, `ios/`, `windows/`), a pubspec or lock file, a package with native code, the pinned Flutter or the workflow changes, or with a label. The staging builds on `main` stay and catch the rest.
3. `verify` requires `android-release` too.
4. Cache CocoaPods and the Swift packages in the iOS jobs.
5. A merge of specs or docs alone builds and deploys nothing.
6. Renovate groups GitHub Actions updates into one weekly pull request.

Done when: a docs-only pull request passes in under 2 minutes and a server-only one in under 5.

## Phase 6: session shape and subagents

1. Try an auto-compact window of about 200K (`autoCompactWindow`) on one slice and compare its cost and its result with the baseline; keep it only if the slice loses nothing.
2. A slice in three sessions when it is large: plan, build, review fixes, with `TASKS.md` as the handover.
3. `CLAUDE_CODE_SUBAGENT_MODEL=sonnet`, and purpose-built agents on Sonnet instead of `general-purpose` on Opus.
4. Test the reviewer: about 10 past pull requests with a known blocking bug, each with a one-sentence answer key, plus clean ones as controls; compare Sonnet 5.5 medium, Opus 5.5 medium and Opus 5.5 high, and keep the cheapest that finds the same bugs.
5. Split the `deploy` skill (30 KB) into a short file and reference files read when needed.
6. Sonnet 5.5 for docs-only, Renovate and small fixes; Opus 5.5 at medium for slices. Never switch models mid-session (it rewrites the prompt cache).

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
