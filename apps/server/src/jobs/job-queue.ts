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
  // AP §8.3, §9.12.6: the search-start moment of an accepted order.
  searchStart: 'ordering-search-start',
  // Architecture §5.5: a run of the outbox relay, sent with each transition.
  outboxRelay: 'ordering-outbox-relay',
  // AP §8.3: an offer the captain did not answer in dispatch.offer_timeout_sec.
  offerExpiry: 'dispatch-offer-expiry',
} as const;

export type QueueName = (typeof QUEUES)[keyof typeof QUEUES];

// A timer that fails (the database briefly away, a worker restarting) is tried
// again for about an hour with a growing delay, so it never ends failed while
// its state still waits for it.
const QUEUE_OPTIONS = { retryLimit: 10, retryDelay: 15, retryBackoff: true, retryDelayMax: 600 };

// pg-boss runs some upgrade steps (index builds) in the background of the
// instance that migrated; the migration waits for them.
const BACKGROUND_STEPS_TIMEOUT_MS = 10 * 60_000;

// Installs pg-boss, or upgrades it to this version, and creates or updates the
// queues, as the migration role; then grants the application role its rows.
// pg-boss keeps jobs, not business records, and deletes completed jobs after
// their retention, so the application role gets DELETE here and nowhere else.
// It stamps the maintenance times on pgboss.version, never the version itself.
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
      if ((await boss.getQueue(name)) === null) await boss.createQueue(name, QUEUE_OPTIONS);
      else await boss.updateQueue(name, QUEUE_OPTIONS);
    }
    await backgroundSteps(boss);
  } finally {
    await boss.stop({ graceful: false });
  }
  const client = new pg.Client({ connectionString });
  await client.connect();
  try {
    await client.query(`
      GRANT USAGE ON SCHEMA ${JOB_SCHEMA} TO fox_drop_app;
      GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA ${JOB_SCHEMA} TO fox_drop_app;
      REVOKE INSERT, UPDATE, DELETE ON ${JOB_SCHEMA}.version FROM fox_drop_app;
      GRANT UPDATE (cron_on, bam_on, flow_on, reindex_on, monitor_backoff_on) ON ${JOB_SCHEMA}.version TO fox_drop_app;
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

// Waits for the upgrade's background steps; a failed or endless one fails
// the migration.
async function backgroundSteps(boss: PgBoss): Promise<void> {
  const deadline = Date.now() + BACKGROUND_STEPS_TIMEOUT_MS;
  for (;;) {
    const status = await boss.getBamStatus();
    if (status.some((entry) => entry.status === 'failed' && entry.count > 0)) {
      throw new Error('a pg-boss upgrade step failed (pgboss.bam)');
    }
    const open = status.some(
      (entry) => (entry.status === 'pending' || entry.status === 'in_progress') && entry.count > 0,
    );
    if (!open) return;
    if (Date.now() > deadline) throw new Error('pg-boss upgrade steps did not finish');
    await new Promise((resolve) => setTimeout(resolve, 1000));
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
    // The application role owns no index, so rebuilding them is the
    // migration role's or an operator's (pg-boss warns when one is bloated).
    reindex: false,
  });
}

type Executor = Pick<NodePgDatabase, 'execute'>;

// pg-boss runs its statement on the transaction, so a job sent with
// { db: inTransaction(tx) } exists exactly when the transaction commits
// (architecture §5.5).
export function inTransaction(tx: Executor): Db {
  return fromDrizzle(tx, sql);
}
