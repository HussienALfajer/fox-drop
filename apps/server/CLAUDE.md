# apps/server

The FOX DROP server: one NestJS on Fastify application, strict TypeScript, ES modules (architecture §4, §5).

## Layout

- `src/modules/<name>/`: one folder per module of architecture §4.2, created by the first slice that needs it. `index.ts` is the module's public entry: its Nest module, public service and domain events. Everything else in the folder is private.
- Everything else in `src` is the shared layer: `http/` (the API app and route groups), `database/` (the connection and the migration runner), `valkey/` (the Valkey client), `logging/`, `roles/` (process roles), `seed/` (the placeholder data of development and staging) and `main.ts`.
- `src/modules/<name>/schema.ts`: the module's Drizzle tables, in the PostgreSQL schema of the module's name. `migrations/`: the SQL migrations generated from them. `db/`: the one-time bootstrap of the database roles.
- Tests sit next to the code as `*.test.ts`; `test/` holds tests of the tooling and their fixtures.

## Rules

- **Module boundaries:** a module imports another module only from its `index.ts`. `eslint-plugin-boundaries` fails any other import, and every file under `src` must belong to a module or the shared layer (`eslint.config.mjs`, proved by `test/module-boundaries.test.ts`).
- **Routes:** every controller uses `AdminController`, `MerchantController`, `CaptainController` or `CustomerController` from `src/http/route-groups.ts`, never Nest's `Controller` (a lint rule). Routes are served under `/v1/<group>/` (architecture §5.3).
- **Access, deny by default (architecture §15.2):** every route declares who may call it with a decorator from `src/http/access.ts`: `@Public()`, `@SignedIn()` or `@RequirePermission('<permission>')` for admin routes, `@AppSignedIn()` for an app route that needs the app's bearer token; a handler takes the session with `@CurrentAdminSession()` or `@CurrentAppSession()`. They live in the shared layer so every module can use them, the settings module included, which the identity module imports. `RouteAccessGuard` in the identity module (registered in `api.module.ts`) refuses a route that declares nothing with `403`. A new route also goes into the route table of `src/modules/identity/admin-team.test.ts`, which calls every route with every role and fails on a route it does not know.
- **DTO names:** a `createZodDto` class's name is its schema's name in the OpenAPI document, so names are unique across the server; prefix a route group's DTOs with the group when another group has the same one (`CustomerSignInDto`). `src/http/openapi.test.ts` fails on a repeated name.
- **Idempotency (architecture §5.3):** a command route takes the `Idempotency-Key` header with `@Idempotent()` (documents it, so the clients send it) and `@IdempotencyKey()` (`400 idempotency_key_required`) from `src/http/idempotency.ts`. The module that runs the command keeps the key with its result in the command's own transaction, in its own schema (`ordering.idempotency_keys`), and answers a repeat within 24 hours with that result.
- **Validation:** request bodies, queries and params are Zod schemas wrapped with `createZodDto` from `nestjs-zod`; the global pipe rejects a mismatch with `400`.
- **OpenAPI (E6):** the document is generated from the controllers (`src/http/openapi.ts`); each route group is its tag, so each client has one API class per group. Declare every response with `@ZodResponse({ status, type })` and a `createZodDto` class, so the response is parsed by its schema and documented with it (`src/http/openapi.test.ts` fails an operation without a documented success response). After changing a route or a schema, run `pnpm generate:api` from the repository root and commit the regenerated `packages/api-schema` and `packages/core_api`; `pnpm verify` fails on a stale contract.
- **Server-Time:** every response carries `Server-Time`, the server clock in Unix milliseconds. Do not remove the hook in `create-api-app.ts`. Two raw Fastify replies skip it: the `503` while the server is closing and the reply to a malformed HTTP request.
- **Logs:** use the Nest `Logger` or the `nestjs-pino` logger, never `console`. Logs pass through `src/logging/redact.ts`: name fields so it can find secrets (`code`, `otp`, `token`, `password`, `phone` and the rest of its lists), and add a key there when a new kind of secret appears. Redaction runs on every finished log line (`hooks.streamWrite`): secret field names by their ending, phone numbers in any string. Requests are logged by id, method and path only, so a code or token never goes in a URL path; put it in the body.
- **Placeholder data** for development and staging (AP §13 items 4 and 5) goes in `src/seed/placeholder-seed.ts`, through the modules' public services, never in a migration. The API runs it at start when `FOX_DROP_ENVIRONMENT` is `development` or `staging`, and it sets each value only while it is missing, so an edit on staging is never replaced. Reference data every environment needs stays in its migration.
- **Process roles:** `PROCESS_ROLE` is `api`, `worker`, `dispatcher` or `otp-sender` (architecture §4.4). Background work joins its role in `src/roles/start-role.ts`.
- **Database:** follow the `db-migration` skill for every schema change. Two roles (`db/bootstrap.sql`): `fox_drop_migrator` runs the migrations and owns the schemas; the server connects as `fox_drop_app` (`DATABASE_URL`), which gets `SELECT`, `INSERT` and `UPDATE` on its tables, never `DELETE`, and can never change the schema. Append-only tables (the audit log, the ledger, later the order events) get `SELECT` and `INSERT` only. `src/database/migrations.test.ts` proves it on a fresh PostGIS with Testcontainers (`src/database/test-database.ts` starts one for any database test), so `pnpm verify` needs Docker running. A module that reads or writes its tables imports `DatabaseModule` and injects `DATABASE`: one pool per process, built from `DATABASE_URL`, closed on shutdown.
- **Valkey:** a module that caches, locks or limits in Valkey imports `ValkeyModule` and injects `VALKEY`: one client per process, built from `VALKEY_URL`, closed on shutdown. Nothing in Valkey is the only copy (architecture §5.7); a test starts one with `src/valkey/test-valkey.ts`.
- **Imports** end in `.js` (Node ES modules). Classes injected by Nest are imported as values, not with `import type`, so decorator metadata survives.

## Commands

From the repository root:

- `pnpm --filter @fox-drop/server test` (or `lint`, `typecheck`, `build`).
- `docker compose up --detach` (after copying `.env.example` to `.env`), then `pnpm --filter @fox-drop/server db:migrate`: the local services and database.
- `pnpm --filter @fox-drop/server db:generate --name <module>_<change>`: the SQL migration for a schema change.
- `docker build -f apps/server/Dockerfile -t fox-drop-server .`, then `node apps/server/scripts/smoke-image.mjs fox-drop-server`: starts the image in each role (the `server-image` CI job).

NestJS stays on 11.x until `nestjs-zod` supports NestJS 12.
