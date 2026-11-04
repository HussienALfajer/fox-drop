---
name: build-slice
description: Build one slice of the FOX DROP roadmap end to end, from TASKS.md to a merged pull request, then hand over to the next slice. Use when asked to build, start or continue a roadmap slice such as "0.2" or "the next slice".
---

# Build one roadmap slice

Input: the slice, such as "0.2", or nothing for the slice `TASKS.md` names.

## 1. Read

- `TASKS.md`: the slice, the spec sections it implements, its branch, its plan and any "Stopped at" line. If `TASKS.md` describes another slice that is not done, stop and ask the owner.
- The slice's line in `docs/roadmap.md`, the spec and architecture sections it cites, their definition of done, and the `CLAUDE.md` of every folder you will touch.
- If the plan in `TASKS.md` is missing or does not match the roadmap line, write it as a checklist first, one step per commit.

Stop and ask the owner about everything `CLAUDE.md` says to ask about, and at the design stop.

## 2. Build

- Work on the branch `TASKS.md` names, created from an up-to-date `main`.
- One plan step at a time. For domain rules (order states, timers, money), write the failing test first and see it fail.
- Build only what the cited sections say. Each new pattern gets its folder `CLAUDE.md` or rule in the same slice.
- After each step: run the `checker` agent; when it passes, tick the step in `TASKS.md`, commit (Conventional Commits, body says what and why) and push.

## 3. Review

- Run the `reviewer` agent with the spec sections the slice implements. Fix every blocking and should-fix finding, then run `checker` again.

## 4. Hand over

As the last commit of the slice:

- Mark the slice `[x]` in `docs/roadmap.md`.
- Rewrite `TASKS.md` for the next slice: its roadmap line, spec sections, branch name and plan as a checklist.

If the session ends with work open instead, add a "Stopped at" line to `TASKS.md`, commit and push.

## 5. Merge

- Open the pull request: `## Summary` (what and why, the spec sections) and `## Test plan` (the commands and their results, and what the owner can try).
- Wait for CI. Fix failures at their root; never skip or silence a check.
- Merge with a merge commit once CI passes (`gh pr merge --merge --delete-branch`).

## 6. Report

To the owner, in Arabic: what changed with the pull request link, how it was verified (commands and results), what you found, what the owner needs to do or decide, and the next slice.
