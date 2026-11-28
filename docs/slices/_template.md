# <id> <Slice title>

Status: Planned | In progress | Done · Tier: T0 | T1 | T2 · Branch: `<type>/<topic>`
Spec: <cited sections, such as RA §9.2, AP §8.3> · Definition of done: <items it closes>

## Goal

One or two sentences: what the owner or a user can do after this slice.

## Plan

1. Database and server module: tables, migration (expand, then contract), grants, services, timers and outbox events.
2. Routes, contract and generated clients (`pnpm generate:api`).
3. Web: the panel, the portal.
4. Flutter: the apps.
5. End-to-end: the journey, and what the owner tries on staging.

Files (hand-written count): <every file the slice creates or changes by hand, by layer, and their number; at most about 25 or two layers (workflow §3.1); generated files and images apart>.

Tests written first (locked in the red phase): <test files and what each proves, mapped to the definition of done>.

## Stopped at

<one line, updated at every green checkpoint>

## Evidence

- `node scripts/verify.mjs --changed`: <summary line>
- Screenshots or recordings (outside the repository): <where>
- Review: <reviewer (and security-reviewer for T0) findings fixed; deferred to the backlog>

## Before deploying

<migrations, new variables, provisioning, app rebuilds; or "nothing">

## To check on staging

<what the owner tries after the deploy; or "nothing new">

## Notes for the next session

<decisions taken pending the owner, what is left out on purpose, only what is needed to resume>
