---
name: slice-plan
description: Split a phase, a spec section or a feature of FOX DROP into vertical slices (one session and one pull request each), give each a risk tier, write one slice file per slice with a layered, test-first plan, and get the owner's approval. Use in plan mode in a fresh session before building anything.
argument-hint: '<phase, spec section or feature>'
effort: high
---

# Plan vertical slices

Input: what to plan, such as "Phase D", "D.9" or a spec section like "RA §9 Menu". Run in a fresh session in plan mode (`docs/process/development-workflow.md` §3).

## 1. Read

- `docs/README.md`, then `docs/roadmap.md` for the phase and what is already done.
- The spec sections in scope, their definition of done (the last numbered section of each spec), and the domain and architecture sections they cite. A feature with no written spec gets one first with `/spec`.
- The code that already exists for this scope: grep `docs/code/<folder path>.md`, `docs/backlog.md` and the archive `docs/slice-notes.md` for it.
- Every open item the scope touches (`docs/open-questions.md`). Never guess one: ask the owner.

## 2. Split

A slice is one pull request that one session can finish. It:

- delivers one behaviour through every layer it touches (database, server module, API contract and generated clients, real-time events, each app screen that shows it, tests), so it can be tried end to end; a behaviour too big for one slice is split along the build order (the server and its contract first, then each client), each part tried at its own layer;
- names the spec sections it implements and the definition-of-done items it closes;
- states how it is verified: the tests and, for screens, what the owner can try;
- leaves `main` working;
- fits the size of `docs/process/development-workflow.md` §3.1: at most about 25 hand-written files or two layers, a component batch's web side and Flutter twin as separate slices (and a hand-written sheet, when one is needed).

Estimate by counting: list in the plan, layer by layer, every file the slice creates or changes by hand (generated files, icons and image baselines apart), and write the count next to the plan. A slice over the limit is split now, before the owner approves it. No two slices in flight on the same hand-written file or dependency (name the files so parallel slices can be checked); a new dependency's version is pinned once, in the slice that adds it.

Order the slices by dependency, then by risk: the money flows, the order state machine, timers and dispatch come before screens that only display data. Schema and API-contract changes are serialised. A slice with components has a design checkpoint (architecture §9.9, T14, T15): web first, the Figma look, then the owner's approval of the built web components' generated boards on "Fox Drop Components" (they are the drawing); a Flutter twin is planned only when a screen needs it, as its own slice, and its checkpoint is its parity sheet, never a second drawing. Screens come in UI batches after the API they use; a batch's slice file holds the screen inventory, and its first checkpoint is the screen cycle of §9.9: draw, prototype, analysis, designer pass, owner approval.

Give each slice a tier (`docs/process/development-workflow.md` §2): **T0** money, ledger, order states and timers, auth, migrations, secrets, deploy and CI; **T1** domain services, routes, contracts; **T2** UI, docs, tests.

## 3. Write the slice files

For each slice copy `docs/slices/_template.md` to `docs/slices/<id>-<kebab-title>.md` and fill it in: goal, tier, branch (`feat/`, `fix/`, `test/`, `chore/` plus a topic), cited spec sections and definition-of-done items, the plan by layer, the tests written first mapped to the definition of done, and the checkpoints of a large slice. Point to spec lines instead of copying them.

## 4. Present and stop

Show the owner, in Arabic: the slices in order (one line each: what it delivers, its tier, its file count, what the owner can try), the open items that need an answer, and the design checkpoints. Wait for approval or changes.

For a T0 slice, a second fresh session critiques the plan before it is built (its first message: `راجع خطة الشريحة <id> في docs/slices/... وانقدها قبل البناء`); its findings go into the slice file.

## 5. Record

After approval: add the slices to the phase in `docs/roadmap.md`, one line each, marked `[ ]`; commit the slice files and the roadmap on a `docs/` branch; open the pull request with auto-merge (squash) and Auto-fix as in the root `CLAUDE.md`.
