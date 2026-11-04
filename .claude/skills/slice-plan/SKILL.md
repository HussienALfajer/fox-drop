---
name: slice-plan
description: Split a phase, a spec section or a feature of FOX DROP into vertical slices (one pull request and one session each), ordered by dependency, and get the owner's approval of the split. Use before building anything that is larger than one pull request.
effort: high
---

# Plan vertical slices

Input: what to plan, such as "Phase 0", "Phase 1" or a spec section like "RA §9 Menu".

## 1. Read

- `docs/README.md`, then `docs/roadmap.md` for the phase and what is already done.
- The spec sections in scope, their definition of done (the last numbered section of each spec), and the domain and architecture sections they cite.
- The code that already exists for this scope, if any.

## 2. Split

A slice is one pull request that one session can finish. It:

- delivers one behaviour through every layer it touches (database, server module, API contract and generated clients, real-time events, each app screen that shows it, tests), so it can be tried end to end;
- names the spec sections it implements and the definition-of-done items it closes;
- states how it is verified: the tests and, for screens, what the owner can try;
- leaves `main` working.

Order the slices by dependency, then by risk: the money flows, the order state machine, timers and dispatch come before screens that only display data. Mark every slice that needs visual design: it waits for the owner's answer on the UI/UX and the design system (`CLAUDE.md`, design stop). List every open item the scope touches (`docs/open-questions.md`).

## 3. Present and stop

Show the owner, in Arabic: the slices in order (one line each: what it delivers and what the owner can try), the open items that need an answer, and the slices that wait for design. Wait for approval or changes. This is the only planned stop.

## 4. Record

After approval:

- Add the slices to the phase in `docs/roadmap.md`, one line each, marked `[ ]`.
- Write `TASKS.md` for the first slice: the slice, its spec sections, its branch name, and its plan as a checklist.
- Commit both on a `docs/` branch and open the pull request.
