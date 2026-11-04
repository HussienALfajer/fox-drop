# apps/server

The FOX DROP server: one NestJS on Fastify application, strict TypeScript, ES modules (architecture §4, §5).

## Layout

- `src/modules/<name>/`: one folder per module of architecture §4.2, created by the first slice that needs it. `index.ts` is the module's public entry: its Nest module, public service and domain events. Everything else in the folder is private.
- Everything else in `src` is the shared layer: `http/` (the API app and route groups), `database/` (the connection and the migration runner), `logging/`, `roles/` (process roles) and `main.ts`.
- `src/modules/<name>/schema.ts`: the module's Drizzle tables, in the PostgreSQL schema of the module's name. `migrations/`: the SQL migrations generated from them. `db/`: the one-time bootstrap of the database roles.
- Tests sit next to the code as `*.test.ts`; `test/` holds tests of the tooling and their fixtures.

## Rules

- **Module boundaries:** a module imports another module only from its `index.ts`. `eslint-plugin-boundaries` fails any other import, and every file under `src` must belong to a module or the shared layer (`eslint.config.mjs`, proved by `test/module-boundaries.test.ts`).
- **Routes:** every controller uses `AdminController`, `MerchantController`, `CaptainController` or `CustomerController` from `src/http/route-groups.ts`, never Nest's `Controller` (a lint rule). Routes are served under `/v1/<group>/` (architecture §5.3).
- **Validation:** request bodies, queries and params are Zod schemas wrapped with `createZodDto` from `nestjs-zod`; the global pipe rejects a mismatch with `400`.
- **OpenAPI (E6):** the document is generated from the controllers (`src/http/openapi.ts`); each route group is its tag, so each client has one API class per group. Declare every response with `@ZodResponse({ status, type })` and a `createZodDto` class, so the response is parsed by its schema and documented with it (`src/http/openapi.test.ts` fails an operation without a documented success response). After changing a route or a schema, run `pnpm generate:api` from the repository root and commit the regenerated `packages/api-schema` and `packages/core_api`; `pnpm verify` fails on a stale contract.
- **Server-Time:** every response carries `Server-Time`, the server clock in Unix milliseconds. Do not remove the hook in `create-api-app.ts`. Two raw Fastify replies skip it: the `503` while the server is closing and the reply to a malformed HTTP request.
- **Logs:** use the Nest `Logger` or the `nestjs-pino` logger, never `console`. Logs pass through `src/logging/redact.ts`: name fields so it can find secrets (`code`, `otp`, `token`, `password`, `phone` and the rest of its lists), and add a key there when a new kind of secret appears. Redaction runs on every finished log line (`hooks.streamWrite`): secret field names by their ending, phone numbers in any string. Requests are logged by id, method and path only, so a code or token never goes in a URL path; put it in the body.
- **Process roles:** `PROCESS_ROLE` is `api`, `worker`, `dispatcher` or `otp-sender` (architecture §4.4). Background work joins its role in `src/roles/start-role.ts`.
- **Database:** follow the `db-migration` skill for every schema change. Two roles (`db/bootstrap.sql`): `fox_drop_migrator` runs the migrations and owns the schemas; the server connects as `fox_drop_app` (`DATABASE_URL`), which gets `SELECT`, `INSERT` and `UPDATE` on its tables, never `DELETE`, and can never change the schema. `src/database/migrations.test.ts` proves it on a fresh PostGIS with Testcontainers, so `pnpm verify` needs Docker running.
- **Imports** end in `.js` (Node ES modules). Classes injected by Nest are imported as values, not with `import type`, so decorator metadata survives.

## Commands

From the repository root:

- `pnpm --filter @fox-drop/server test` (or `lint`, `typecheck`, `build`).
- `docker compose up --detach` (after copying `.env.example` to `.env`), then `pnpm --filter @fox-drop/server db:migrate`: the local services and database.
- `pnpm --filter @fox-drop/server db:generate --name <module>_<change>`: the SQL migration for a schema change.
- `docker build -f apps/server/Dockerfile -t fox-drop-server .`, then `node apps/server/scripts/smoke-image.mjs fox-drop-server`: starts the image in each role (the `server-image` CI job).

NestJS stays on 11.x until `nestjs-zod` supports NestJS 12.
