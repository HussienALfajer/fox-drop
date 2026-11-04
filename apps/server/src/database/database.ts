import { drizzle, type NodePgDatabase } from 'drizzle-orm/node-postgres';
import pg from 'pg';

export interface Database {
  db: NodePgDatabase;
  pool: pg.Pool;
}

// The server connects with the application role (DATABASE_URL), which cannot
// change the schema; only the migrations use the migration role.
export function createDatabase(connectionString: string): Database {
  const pool = new pg.Pool({ connectionString });
  return { db: drizzle({ client: pool }), pool };
}
