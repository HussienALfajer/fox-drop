import { fileURLToPath } from 'node:url';
import { migrate } from 'drizzle-orm/node-postgres/migrator';
import { createDatabase } from './database.js';

// apps/server/migrations, from src/database in tests and dist/database in the image.
export const MIGRATIONS_FOLDER = fileURLToPath(new URL('../../migrations', import.meta.url));

// Applies the pending migrations as the migration role, which owns the schemas.
// Deployments run it as its own step before the new version starts (architecture §17.3).
export async function runMigrations(connectionString: string): Promise<void> {
  const { db, pool } = createDatabase(connectionString);
  try {
    await migrate(db, { migrationsFolder: MIGRATIONS_FOLDER });
  } finally {
    await pool.end();
  }
}
