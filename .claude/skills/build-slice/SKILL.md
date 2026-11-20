---
name: build-slice
description: Build one slice of the FOX DROP roadmap end to end, from TASKS.md to a merged pull request, then hand over to the next slice. Use when asked to build, start or continue a roadmap slice such as "0.2" or "the next slice".
---

# Build one roadmap slice

Input: the slice, such as "0.2", or nothing for the slice `TASKS.md` names.

## 1. Read

- `TASKS.md`: the slice, the spec sections it implements, its branch, its plan and any "Stopped at" line. If `TASKS.md` describes another slice that is not done, stop and ask the owner.
- The slice's line in `docs/roadmap.md`, the spec and architecture sections it cites, their definition of done. A folder's `CLAUDE.md` and its parents' load by themselves when you read a file there; do not read them again, but Read once one that a loaded file says to read first (`apps/customer/CLAUDE.md` for the captain and restaurant apps, `apps/admin/CLAUDE.md` for the portal). For what a feature already does and why, grep the folder's `docs/code/<folder path>.md` and `docs/slice-notes.md`, or ask the `Explore` agent.
- If the plan in `TASKS.md` is missing or does not match the roadmap line, write it as a checklist first, one step per commit.

Stop and ask the owner about everything `CLAUDE.md` says to ask about, and at the design stop.

## 2. Build

- Work on the branch `TASKS.md` names, created from an up-to-date `main`.
- One plan step at a time. For domain rules (order states, timers, money), write the failing test first and see it fail.
- Build only what the cited sections say.
- In the same slice: a rule an agent editing the folder would get wrong goes in its `CLAUDE.md` (at most 4 KB; `pnpm verify` checks), a rule a machine can check goes in a test or a lint rule, and what the slice built, decided or left out goes in the folder's `docs/code/<folder path>.md`.
- After each step: run the `checker` agent; when it passes, tick the step in `TASKS.md`, commit (Conventional Commits, body says what and why) and push.

## 3. Review

- Run the `reviewer` agent with the spec sections the slice implements. It runs at medium effort; pass `effort: high` when the diff touches money or order state (`ledger`, `ordering`, `cashdesk`).
- Fix every blocking and should-fix finding and run `checker` again, then send the fixes' diff to the same reviewer (SendMessage) for the next round instead of starting a new one. After three rounds with a blocking finding still open, stop and ask the owner.

## 4. Hand over

As the last commit of the slice:

- Mark the slice `[x]` in `docs/roadmap.md`.
- Rewrite `TASKS.md` for the next slice: its roadmap line, spec sections, branch name and plan as a checklist (at most 8 KB).
- What this slice leaves (before deploying, to check on staging, decisions pending the owner, not yet, what was checked) goes as a `## Left from <slice>` section at the top of `docs/slice-notes.md`, never in `TASKS.md`.

If the session ends with work open instead, add a "Stopped at" line to `TASKS.md`, commit and push.

## 5. Merge

- Open the pull request: `## Summary` (what and why, the spec sections) and `## Test plan` (the commands and their results, and what the owner can try).
- Wait for CI. Fix failures at their root; never skip or silence a check.
- Merge with a merge commit once CI passes (`gh pr merge --merge --delete-branch`).

## 6. Report

In the format of "Reporting" in `CLAUDE.md`. Under «ما المطلوب منك», turn the slice's "what the owner can try" into numbered steps to run after the merge. Under «الخطوة التالية», name the next slice and give its first message, such as `ابنِ الشريحة 0.3`.
