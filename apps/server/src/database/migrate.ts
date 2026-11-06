import { fileURLToPath } from 'node:url';
import { drizzle } from 'drizzle-orm/node-postgres';
import { migrate } from 'drizzle-orm/node-postgres/migrator';
import pg from 'pg';
import { installJobQueue } from '../jobs/job-queue.js';

// apps/server/migrations, from src/database in tests and dist/database in the image.
export const MIGRATIONS_FOLDER = fileURLToPath(new URL('../../migrations', import.meta.url));

// Any constant both runners agree on; it only has to differ from other advisory locks.
const MIGRATION_LOCK = 4_096_001;

// Applies the pending migrations as the migration role, which owns the schemas.
// Deployments run it as its own step before the new version starts (architecture §17.3).
// Drizzle reads the applied migrations outside its transaction, so two runners
// started together would both apply the same ones; the advisory lock makes the
// second wait and then find nothing left to do.
export async function runMigrations(connectionString: string): Promise<void> {
  const client = new pg.Client({ connectionString });
  await client.connect();
  try {
    await client.query('SELECT pg_advisory_lock($1)', [MIGRATION_LOCK]);
    await migrate(drizzle({ client }), { migrationsFolder: MIGRATIONS_FOLDER });
    // pg-boss's own schema, installed or upgraded by the same role.
    await installJobQueue(connectionString);
  } finally {
    await client.end();
  }
}
