---
name: audit-phase
description: End-of-phase audit of FOX DROP with parallel read-only reviewers before the next phase starts. Use when a roadmap phase's slices are all merged.
argument-hint: '<phase, such as D or L>'
---

# Audit a phase

1. Read `docs/roadmap.md` (the phase's exit criteria and slice list), the phase's slice files in `docs/slices/` (and the archive `docs/slice-notes.md` for slices before 2026-11-23), and `docs/backlog.md`.
2. Run the full `pnpm verify` through the `checker` agent.
3. Start read-only reviewers in parallel (at most four), each with one dimension and the list of the phase's merged pull requests:
   - money, ledger, order states and timers (`security-reviewer`);
   - auth, scope across cities, restaurants, captains and customers, secrets, CI (`security-reviewer`);
   - correctness against the specs and their definitions of done (`reviewer`);
   - instruction files, `docs/code`, the roadmap and `REVIEW.md` against the code (`reviewer`): stale statements, rules repeated instead of enforced, `REVIEW.md` items a test now covers.
4. Verify each finding yourself. Blocking ones become fix slices (`/slice-plan`); the others go to `docs/backlog.md` with their source.
5. Write `docs/audits/<phase>-<date>.md`: the exit criteria with their evidence, the findings and what happens to each.
6. Report to the owner in Arabic and ask for a walkthrough of the real apps on staging before the next phase starts.
