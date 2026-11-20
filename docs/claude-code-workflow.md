# Claude Code workflow plan

How FOX DROP is built with Claude Code, what it costs, and the changes approved on 2026-11-20 to cut tokens and check time. It applies three Anthropic posts (Code Mode, how the Claude Code team thinks about verification, which Claude model to build with) and the Claude Code docs on costs, context, memory and subagents.

## Baseline (measured 2026-11-20, last 40 sessions)

- **Session start:** about 75K tokens before the first message: the desktop app's tool schemas (about 30K), the system prompt (8K), the skill listing (16K, mostly personal video and social media skills and plugins unrelated to this project), deferred MCP tool names (6K) and the instruction files (5K).
- **A slice session:** 300–450 turns, peak context 400–560K tokens, 100–220M cache-read tokens. Over 39 sessions: 11,844 turns at an average of 284K context tokens each. Every turn resends the whole context, so context size times turns is the cost.
- **The largest load:** folder `CLAUDE.md` files, 941 KB in 38 files (ordering 158 KB, admin 117 KB). Claude Code loads a folder's file as soon as a file in it is read, and it stays for the rest of the session: one session carried 659 KB (about 165K tokens). They grew because every slice added its rules and decisions to them. `TASKS.md` held 413 KB of handover notes.
- **Checks:** the `checker` ran the full `pnpm verify` 305 times (median 3.7 min, p90 9.5 min, 25.6 h in all), with every Turborepo cache off and no changed-only mode. CI's `verify` takes 4–5 min; the PR release builds take 25–36 min (iOS), 10–16 (Windows) and 8–12 (Android). A Markdown file under a Flutter app sets the Dart and Flutter jobs once any spec changed, and every file under `docs/product` counts as code although only `catalogue.test.ts` reads a spec file.
- **Reviewer:** 119 runs on Opus at high effort, about 5.8M processed tokens each, every round from scratch. `general-purpose` subagents: 33 runs on Opus, about 14.6M processed tokens each.

## Phase 1: context diet (`chore/claude-context-diet`)

1. Folder `CLAUDE.md` files hold only what an agent editing the folder must know and would get wrong otherwise: the patterns to copy, the traps, the commands, at most 4 KB. The behaviour, decisions and slice history they held move unchanged to `docs/code/<folder path>.md`, which nothing loads by itself; grep it for the feature you touch.
2. `TASKS.md` holds the current task only (at most 8 KB). Earlier handover notes move to `docs/slice-notes.md`.
3. `pnpm verify` (its format part, which CI runs on every change) fails when a folder `CLAUDE.md` passes 4 KB, the root one 10 KB or `TASKS.md` 8 KB.
4. `build-slice`: a slice adds a folder rule only when it is not obvious from the code; what it built goes to the folder's `docs/code` file.
5. An `Explore` agent on Haiku for wide searches; reading through Read and Grep with limits, never `cat` of whole files.
6. Reviewer: Opus 5.5 at medium effort, high when the diff touches money or order state (ledger, ordering, cashdesk); follow-up rounds go to the same reviewer with the fix's diff only; three rounds, then ask the owner.
7. Root `CLAUDE.md`: no retries, sleeps or skips to make a flaky test pass; three failed fixes of the same check, then ask the owner.

## Phase 2: fast checks

1. `node scripts/verify.mjs --changed`, the `checker`'s default: the parts the branch's changes need, using one classifier shared with CI's `changes` job. Markdown only: Prettier on the changed files. TypeScript: `turbo --affected`. Dart: Melos `--diff`. The API contract only after a route or schema change. The full run stays in CI.
2. Turborepo cache for `lint` and `typecheck` only (build and test stay uncached).
3. A `Stop` hook that runs the fast check when Claude finishes a turn with code changes.

## Phase 3: CI

1. The Dart and Flutter filters ignore Markdown; only the spec files a test reads count as code.
2. The PR release builds (iOS, Windows, Android) run only when a native project, a pubspec or the workflow changes, or with a label. The staging builds on `main` stay.
3. Renovate groups GitHub Actions updates into one weekly pull request.

## Phase 4: owner's own settings

- Move the `premiere-pro` and `higgsfield` MCP servers and the video and Instagram skills to the projects that use them; disable the marketing and social media plugins, and `figma` and `ui-ux-pro-max` until the design stop.
- Remove the local proxy (`ANTHROPIC_BASE_URL`) and the plain-text API key from `~/.claude/settings.json` if unused; it also blocks Code Mode.
- A status line with the context and the 5-hour and weekly limits.
- Sonnet 5.5 for docs-only, Renovate and small fixes; Opus 5.5 at medium for slices. Never switch models mid-session (it breaks the prompt cache).

## Phase 5: verification that catches more

From the verification post, not covered by the phases above:

1. A `verify` skill that boots the server and the web apps and drives a real order through them (step trace and screenshot on failure), with a feature map (each feature from the user's side, its path, selectors and expected result) as guide and rubric. Fits launch readiness.
2. Property tests with fast-check for money: every journal balances per currency, rounding round-trips, a repeated request or timer job posts once.
3. A diff-triggered checklist in `REVIEW.md`, read from `main`, never from the branch under review; a change to `ci.yml`, `verify.mjs` or `REVIEW.md` is named in the pull request.
4. Every bug found after a merge becomes a `REVIEW.md` item or a test.
5. Test the reviewer: about 10 past pull requests with a known blocking bug, each with a one-sentence answer key, plus clean ones as controls; compare Sonnet 5.5 medium, Opus 5.5 medium and Opus 5.5 high, and keep the cheapest that finds the same bugs.

## Phase 6: models and bulk work

From the model post:

- Purpose-built agents on Sonnet 5.5 instead of `general-purpose` on Opus for delegated work.
- Bulk mechanical work (many files, one rule): an Opus lead with Sonnet workers.
- Code Mode (experimental) needs the native Claude Code build v2.1.323 or later, a terminal session (not the desktop app) and no gateway; try it on a mechanical multi-file task before relying on it.
- After each phase, measure again against the baseline above.
