# apps/server

The FOX DROP server: one NestJS on Fastify application, strict TypeScript, ES modules (architecture §4, §5). These rules apply to every module.

## Rules

- **Layout:** `src/modules/<name>/` is one module (architecture §4.2); its `index.ts` is the public entry, the rest is private. Everything else in `src` is the shared layer. Tables are in `<module>/schema.ts`, migrations in `migrations/`, tests beside the code as `*.test.ts`.
- **Module boundaries:** import another module only from its `index.ts`; `eslint-plugin-boundaries` fails anything else (`test/module-boundaries.test.ts`).
- **Routes:** use `AdminController`, `MerchantController`, `CaptainController` or `CustomerController` from `src/http/route-groups.ts`, never Nest's `Controller` (lint rule). Served under `/v1/<group>/`.
- **Deny by default (architecture §15.2):** every route declares access with a decorator from `src/http/access.ts` (`@Public()`, `@SignedIn()`, `@RequirePermission(...)`, `@RequireAnyPermission(...)`, `@AppSignedIn()`, `@AppSignedInOrGuest()`, `@RealtimeProxy()`); an undeclared route gets `403`. Add a route to the table of `src/modules/identity/admin-team.test.ts`.
- **DTOs and validation:** bodies, queries and params are Zod schemas wrapped with `createZodDto`. A DTO class name is its OpenAPI schema name, so it is unique across the server; prefix it with the group on a clash (`CustomerSignInDto`).
- **OpenAPI (E6):** declare every response with `@ZodResponse({ status, type })`. After changing a route or schema run `pnpm generate:api` from the root and commit `packages/api-schema` and `packages/core_api`. No `z.union` or `z.discriminatedUnion` of objects (the Dart client cannot take `oneOf`): use one object with a `kind` and nullable fields.
- **Idempotency (architecture §5.3):** a command route takes `Idempotency-Key` with `@Idempotent()` and `@IdempotencyKey()` from `src/http/idempotency.ts`; the module stores the key and result in its own schema, in the command's transaction. No key for a command that sets a value, one whose repeat is refused by what the first changed, or one whose answer is a secret shown once.
- **Server-Time:** every response carries it (Unix ms); keep the hook in `create-api-app.ts`.
- **Logs:** Nest `Logger` or `nestjs-pino`, never `console`. Name fields so `src/logging/redact.ts` finds secrets (`code`, `otp`, `token`, `password`, `phone`); add a key there for a new kind of secret. Never put a code or token in a URL.
- **Placeholder data** for development and staging goes in `src/seed/placeholder-seed.ts` through the modules' public services, never in a migration; reference data every environment needs stays in its migration.
- **Database:** follow the `db-migration` skill for every schema change. The app role (`fox_drop_app`) gets `SELECT`, `INSERT`, `UPDATE`, never `DELETE`; append-only tables get `SELECT` and `INSERT` only. A module that touches its tables imports `DatabaseModule` and injects `DATABASE`. Tests use `startTestDatabase()`.- **Jobs and timers (architecture §5.5):** pg-boss. A new queue goes into `QUEUES` with `QUEUE_OPTIONS` in `src/jobs/job-queue.ts`. `send` a timer inside the state's transaction with `{ db: inTransaction(tx) }`; the handler re-reads the record under its lock and acts only on the state and version the job carries.- **Valkey:** import `ValkeyModule`, inject `VALKEY`; never the only copy of data.
- **Process roles:** background work joins its role in `src/roles/start-role.ts`.
- **Imports** end in `.js`. Classes Nest injects are imported as values, not `import type`.

## Commands

- `pnpm --filter @fox-drop/server test` (also `lint`, `typecheck`, `build`); tests start PostGIS, so Docker must run.
- `pnpm --filter @fox-drop/server db:generate --name <module>_<change>`: the SQL migration for a schema change.

NestJS stays on 11.x until `nestjs-zod` supports 12.

## More

Behaviour, decisions and slice history: `docs/code/apps/server.md`. Grep it for the feature, route, table or label you are changing and read only those lines; never read it whole.
