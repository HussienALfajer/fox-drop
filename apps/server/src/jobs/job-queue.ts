import { sql } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { type Db, fromDrizzle, PgBoss } from 'pg-boss';
import pg from 'pg';

// Architecture §5.5: timers and background jobs are pg-boss jobs in their own
// schema. The migration role installs and upgrades it (installJobQueue, run
// with the migrations) and creates every queue, so the application role only
// reads and writes rows, as it does in the module schemas.
export const JOB_SCHEMA = 'pgboss';

// Every queue, created by the migration role. A module adds its queue here.
export const QUEUES = {
  // AP §8.3: the order the restaurant did not accept in time.
  merchantAutoCancel: 'ordering-merchant-auto-cancel',
} as const;

export type QueueName = (typeof QUEUES)[keyof typeof QUEUES];

// Installs pg-boss, or upgrades it to this version, and creates the queues,
// as the migration role; then grants the application role its rows. pg-boss
// keeps jobs, not business records, and deletes the ones it has archived, so
// the application role gets DELETE here and nowhere else.
export async function installJobQueue(connectionString: string): Promise<void> {
  const boss = new PgBoss({
    connectionString,
    schema: JOB_SCHEMA,
    max: 2,
    migrate: true,
    createSchema: true,
    supervise: false,
    schedule: false,
  });
  boss.on('error', () => undefined);
  await boss.start();
  try {
    for (const name of Object.values(QUEUES)) {
      if ((await boss.getQueue(name)) === null) await boss.createQueue(name);
    }
  } finally {
    await boss.stop({ graceful: false });
  }
  const client = new pg.Client({ connectionString });
  await client.connect();
  try {
    await client.query(`
      GRANT USAGE ON SCHEMA ${JOB_SCHEMA} TO fox_drop_app;
      GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA ${JOB_SCHEMA} TO fox_drop_app;
      GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA ${JOB_SCHEMA} TO fox_drop_app;
      GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA ${JOB_SCHEMA} TO fox_drop_app;
      ALTER DEFAULT PRIVILEGES IN SCHEMA ${JOB_SCHEMA} GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO fox_drop_app;
      ALTER DEFAULT PRIVILEGES IN SCHEMA ${JOB_SCHEMA} GRANT USAGE, SELECT ON SEQUENCES TO fox_drop_app;
      ALTER DEFAULT PRIVILEGES IN SCHEMA ${JOB_SCHEMA} GRANT EXECUTE ON FUNCTIONS TO fox_drop_app;
    `);
  } finally {
    await client.end();
  }
}

// The application role's pg-boss: it never installs or migrates. Only the
// worker supervises (maintenance and the job timers).
export function createJobQueue(connectionString: string, worker: boolean): PgBoss {
  return new PgBoss({
    connectionString,
    schema: JOB_SCHEMA,
    max: worker ? 4 : 2,
    migrate: false,
    createSchema: false,
    supervise: worker,
    schedule: false,
  });
}

type Executor = Pick<NodePgDatabase, 'execute'>;

// pg-boss runs its statement on the transaction, so a job sent with
// { db: inTransaction(tx) } exists exactly when the transaction commits
// (architecture §5.5).
export function inTransaction(tx: Executor): Db {
  return fromDrizzle(tx, sql);
}
