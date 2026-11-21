---
name: build-slice
description: Build one slice of the FOX DROP roadmap in two sessions, a planning session and a build session, from TASKS.md to a merged pull request, then hand over to the next slice. Use when asked to build, start or continue a roadmap slice such as "0.2" or "the next slice".
---

# Build one roadmap slice

Input: the slice, such as "0.2", or nothing for the slice `TASKS.md` names.

A slice takes two sessions (owner decision 2026-11-21, `docs/claude-code-workflow.md` phase 6 items 1 and 2): a planning session that reads and writes the design, and a build session that starts from `TASKS.md` alone and builds, reviews, fixes and merges. The planning session's reads never ride along with the build.

## 0. Which session this is

- If the slice's branch exists on `origin`, switch to it and pull; its `TASKS.md` is the current one. Otherwise work from an up-to-date `main`.
- If `TASKS.md` describes another slice that is not done, stop and ask the owner.
- The first plan step of the slice is the design step ("Read the cited sections and write the design here"). Unticked: this is the **planning session**, do 1 and stop. Ticked: this is the **build session**, start at 2.

## 1. Plan (planning session)

- Read the slice's line in `docs/roadmap.md`, the spec and architecture sections it cites and their definition of done. A folder's `CLAUDE.md` and its parents' load by themselves when you read a file there; do not read them again, but Read once one that a loaded file says to read first (`apps/customer/CLAUDE.md` for the captain and restaurant apps, `apps/admin/CLAUDE.md` for the portal). For what a feature already does and why, grep the folder's `docs/code/<folder path>.md` and `docs/slice-notes.md`, or ask the `Explore` agent.
- Write the design under `### Design` in `TASKS.md`, for a session that has read none of it: what is built and where (files, modules, routes, tables, screens), each decision with its reason and the spec line it rests on, the tests that prove each definition-of-done item, and what is left out on purpose. Then the plan as a checklist, one step per commit. `TASKS.md` stays under 8 KB: point to spec lines instead of copying them.
- Stop and ask the owner about everything `CLAUDE.md` says to ask about, and at the design stop. Write the answers into the design.
- Tick the design step, create the branch from an up-to-date `main`, commit `TASKS.md` and push.
- Report as in 6, with «الخطوة التالية» giving a new session (`/clear`) and its first message, `ابنِ الشريحة <slice>`. Build nothing.

## 2. Build (build session)

- Read `TASKS.md` on the branch first, then only the files the step at hand needs; the design is the plan of record. If it is wrong or missing something, fix it in `TASKS.md` with the reason before building on it.
- One plan step at a time. For domain rules (order states, timers, money), write the failing test first and see it fail.
- Build only what the cited sections say.
- In the same slice: a rule an agent editing the folder would get wrong goes in its `CLAUDE.md` (at most 4 KB; `pnpm verify` checks), a rule a machine can check goes in a test or a lint rule, and what the slice built, decided or left out goes in the folder's `docs/code/<folder path>.md`.
- After each step: run the `checker` agent; when it passes, tick the step in `TASKS.md`, commit (Conventional Commits, body says what and why) and push. A compaction may come at any time: what a later step needs from an earlier one goes in `TASKS.md`, not only in the conversation.

## 3. Review

- Run the `reviewer` agent with the spec sections the slice implements. It runs at medium effort; pass `effort: high` when the diff touches money or order state (`ledger`, `ordering`, `cashdesk`).
- Fix every blocking and should-fix finding and run `checker` again, then send the fixes' diff to the same reviewer (SendMessage) for the next round instead of starting a new one. After three rounds with a blocking finding still open, stop and ask the owner.

## 4. Hand over

As the last commit of the slice:

- Mark the slice `[x]` in `docs/roadmap.md`.
- Rewrite `TASKS.md` for the next slice: its roadmap line, spec sections, branch name and plan as a checklist whose first step is the design step (at most 8 KB).
- What this slice leaves (before deploying, to check on staging, decisions pending the owner, not yet, what was checked) goes as a `## Left from <slice>` section at the top of `docs/slice-notes.md`, never in `TASKS.md`.

If the session ends with work open instead, add a "Stopped at" line to `TASKS.md`, commit and push.

## 5. Merge

- Open the pull request: `## Summary` (what and why, the spec sections) and `## Test plan` (the commands and their results, and what the owner can try).
- Wait for CI. Fix failures at their root; never skip or silence a check.
- Merge with a merge commit once CI passes (`gh pr merge --merge --delete-branch`).

## 6. Report

In the format of "Reporting" in `CLAUDE.md`. Under «ما المطلوب منك», turn the slice's "what the owner can try" into numbered steps to run after the merge. Under «ما وجدته», say whether the context was compacted, how often, and what was re-read or redone after it. Under «الخطوة التالية», name the next session: after planning, the build session of the same slice; after the merge, the planning session of the next slice; with its first message, such as `ابنِ الشريحة 0.3`.
