# Tasks

The handover note between sessions: the current task, its branch, its plan, and where work stopped. Replace it when a task starts; keep it current while the task runs.

## Current task

Phase 0, slice 0.2: server skeleton and module boundaries (`docs/roadmap.md`).

- **Implements:** architecture §4 (modular monolith, modules, module rules, processes), §5.1 (TypeScript strict, Node LTS, NestJS on Fastify, Zod), §5.3 (`/v1`, the four route groups, `Server-Time`), §16 (structured logs without codes, tokens or full phone numbers).
- **Branch:** `feat/server-skeleton`
- **Done when:** `pnpm verify` runs the server's lint, type check and tests; a test import across a module boundary fails the boundary lint rule; the server starts in each of the four roles from one container image.

## Plan

- [x] `apps/server`: NestJS on Fastify, strict TypeScript (shared `tsconfig` base), Vitest, `lint`, `typecheck` and `test` scripts picked up by Turborepo.
- [x] HTTP layer: `/v1` prefix, the `/admin`, `/merchant`, `/captain` and `/customer` route groups, a `Server-Time` header on every response, Zod validation (`nestjs-zod`); tests for each.
- [x] Structured logs (Pino) that redact codes, tokens and phone numbers, with a test.
- [ ] Module boundaries: the module folder layout of §4.2 with a public entry per module, and the ESLint boundary rule; a fixture proves a forbidden import fails.
- [ ] Process roles: one entry point that starts `api`, `worker`, `dispatcher` or `otp-sender` from an environment variable; a Dockerfile for the single image.
- [ ] Folder `CLAUDE.md` for `apps/server` and the rule for the module pattern.
- [ ] Pull request with `## Summary` and `## Test plan`, merged with a merge commit once CI passes.

## Next

Slice 0.3, OpenAPI contract and generated clients (`docs/roadmap.md`).
