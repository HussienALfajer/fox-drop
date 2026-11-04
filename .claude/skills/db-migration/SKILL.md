---
name: db-migration
description: Add or change a FOX DROP database table, column, index, grant or seed through a Drizzle SQL migration, with the module schema, the application role's grants and the database test. Use for any change under apps/server/src/modules/*/schema.ts or apps/server/migrations.
---

# Database migration

The rules: architecture §4.3 (each module owns the PostgreSQL schema of its name) and §5.2 (data model), and `apps/server/CLAUDE.md` ("Database").

## 1. Change the Drizzle schema

- Edit `apps/server/src/modules/<module>/schema.ts`. A new module declares `export const <module> = pgSchema('<module>')` and its tables with `<module>.table(...)`.
- Keys: `uuid('id').primaryKey().default(sql\`uuidv7()\`)`. Human numbers are separate columns.
- Every business record has `city_id`. Times are `timestamp(..., { withTimezone: true })`. Money is `bigint` minor units next to a currency code column, never `numeric` or `real`. Phones are E.164 text.
- Column names are snake_case, given explicitly. Status values are `text` with a `CHECK`, so adding a value is one migration.
- No table references another module's table: keep the other module's id as a plain column.

## 2. Generate and review the SQL

```bash
pnpm --filter @fox-drop/server db:generate --name <module>_<change>
```

Read the generated `apps/server/migrations/NNNN_<name>.sql` as SQL, then add by hand, with `--> statement-breakpoint` between statements:

- **A new schema:** right after `CREATE SCHEMA`, the grants for the application role, before any table:

  ```sql
  GRANT USAGE ON SCHEMA "<module>" TO fox_drop_app;
  ALTER DEFAULT PRIVILEGES IN SCHEMA "<module>" GRANT SELECT, INSERT, UPDATE ON TABLES TO fox_drop_app;
  ALTER DEFAULT PRIVILEGES IN SCHEMA "<module>" GRANT USAGE, SELECT ON SEQUENCES TO fox_drop_app;
  ```

- **Append-only tables** (ledger, audit log, order events; architecture §5.6, §15.3): the application role gets `SELECT` and `INSERT` only. These tables are partitioned by month (§5.4) and every partition is a table of its own, so a `REVOKE` on the parent does not reach a new partition:
  - A schema holding only append-only tables (`ledger`, `audit`) grants `SELECT, INSERT ON TABLES` in its default privileges, without `UPDATE`.
  - A schema that mixes them (`ordering`) revokes `UPDATE` on the parent and on every partition when it is created.
  - Partitions are created by the migration role, never by the application role, and the test proves `UPDATE` is refused on a partition, not only on the parent. Follow `audit.create_month_partitions()` in `migrations/0001_audit_events.sql`: a `SECURITY DEFINER` function owned by the migration role, with a fixed `search_path`, `EXECUTE` revoked from `PUBLIC` and granted to the application role, called by the migration and by the `worker` every day.
- **Reference data every environment needs** (such as the Azaz city): an `INSERT` in the migration. Development-only data never goes in a migration.

Never `GRANT DELETE`: business records are not deleted (§5.2). Never edit a migration that has reached `main`; add a new one. After a rebase onto a `main` that gained a migration, delete yours and generate it again, so it is numbered and dated after the other (`src/database/journal.test.ts` fails otherwise: Drizzle silently skips an older one). Only `plpgsql` and `postgis` are installed; a new extension goes in `db/bootstrap.sql` and is created by an administrator in every environment.

## 3. Keep it backward compatible

Migrations run before the new version starts, while the old one still serves (architecture §17.3): expand, then contract. Add nullable or defaulted columns; drop or rename only in a later pull request, after no running version uses them. A destructive or non-backward-compatible migration needs the owner's approval first.

## 4. Test

Extend `apps/server/src/database/migrations.test.ts` (Testcontainers, needs Docker) or the module's own database test: the new rows, constraints and what the application role is refused. Run it with `pnpm --filter @fox-drop/server test`, then let `checker` run `pnpm verify`.

## 5. Apply locally

```bash
pnpm --filter @fox-drop/server db:migrate
```

It reads `MIGRATION_DATABASE_URL` from the root `.env` (copied from `.env.example`) and needs `docker compose up --detach`.
