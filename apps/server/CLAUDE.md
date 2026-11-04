# apps/server

The FOX DROP server: one NestJS on Fastify application, strict TypeScript, ES modules (architecture §4, §5).

## Layout

- `src/modules/<name>/`: one folder per module of architecture §4.2, created by the first slice that needs it. `index.ts` is the module's public entry: its Nest module, public service and domain events. Everything else in the folder is private.
- Everything else in `src` is the shared layer: `http/` (the API app and route groups), `logging/`, `roles/` (process roles) and `main.ts`.
- Tests sit next to the code as `*.test.ts`; `test/` holds tests of the tooling and their fixtures.

## Rules

- **Module boundaries:** a module imports another module only from its `index.ts`. `eslint-plugin-boundaries` fails any other import, and every file under `src` must belong to a module or the shared layer (`eslint.config.mjs`, proved by `test/module-boundaries.test.ts`).
- **Routes:** every controller uses `AdminController`, `MerchantController`, `CaptainController` or `CustomerController` from `src/http/route-groups.ts`, never Nest's `Controller` (a lint rule). Routes are served under `/v1/<group>/` (architecture §5.3).
- **Validation:** request bodies, queries and params are Zod schemas wrapped with `createZodDto` from `nestjs-zod`; the global pipe rejects a mismatch with `400`.
- **Server-Time:** every response carries `Server-Time`, the server clock in Unix milliseconds. Do not remove the hook in `create-api-app.ts`.
- **Logs:** use the Nest `Logger` or the `nestjs-pino` logger, never `console`. Logs pass through `src/logging/redact.ts`: name fields so it can find secrets (`code`, `otp`, `token`, `password`, `phone` and the rest of its lists), and add a key there when a new kind of secret appears. Requests are logged by id, method and path only.
- **Process roles:** `PROCESS_ROLE` is `api`, `worker`, `dispatcher` or `otp-sender` (architecture §4.4). Background work joins its role in `src/roles/start-role.ts`.
- **Imports** end in `.js` (Node ES modules). Classes injected by Nest are imported as values, not with `import type`, so decorator metadata survives.

## Commands

From the repository root:

- `pnpm --filter @fox-drop/server test` (or `lint`, `typecheck`, `build`).
- `docker build -f apps/server/Dockerfile -t fox-drop-server .`, then `node apps/server/scripts/smoke-image.mjs fox-drop-server`: starts the image in each role (the `server-image` CI job).

NestJS stays on 11.x until `nestjs-zod` supports NestJS 12.
