# Tasks

The handover note between sessions: the current task, its branch, its plan, and where work stopped. Replace it when a task starts; keep it current while the task runs.

## Current task

Phase 0, slice 0.3: OpenAPI contract and generated clients (`docs/roadmap.md`).

- **Implements:** architecture §5.3 (REST documented by OpenAPI 3.1 generated from the NestJS controllers; Dart `openapi-generator` `dart-dio` client for Flutter, TypeScript `openapi-typescript` and `openapi-fetch` client for the web; a breaking change fails a client's build), E6 (clients are generated, never written by hand), §11 (`core_api` row), §19.1 (`packages/api-schema`).
- **Branch:** `feat/api-contract`
- **Done when:** `pnpm verify` regenerates the OpenAPI document and both clients and fails when a committed client is stale; a Zod schema in a route reaches the TypeScript and Dart clients as a typed model.

## Plan

- [ ] OpenAPI document from the server: `@nestjs/swagger` with `nestjs-zod`'s `cleanupOpenApiDoc`, written to `packages/api-schema` by a script; a test that the route groups and `Server-Time` appear in it.
- [ ] `packages/api-schema`: the committed OpenAPI 3.1 document and the generated TypeScript client (`openapi-typescript`, `openapi-fetch`).
- [ ] `packages/core_api`: the Dart client generated with `openapi-generator` (`dart-dio`), in the pub workspace. Note: `openapi-generator` needs Java; decide between the CLI in CI or its Docker image.
- [ ] Stale-client check in `pnpm verify`: regenerate, then fail on any difference.
- [ ] Folder `CLAUDE.md` for `packages/api-schema` and `packages/core_api`, and the rule for regenerating clients.
- [ ] Pull request with `## Summary` and `## Test plan`, merged with a merge commit once CI passes.

## Next

Slice 0.4, local environment and database (`docs/roadmap.md`).
