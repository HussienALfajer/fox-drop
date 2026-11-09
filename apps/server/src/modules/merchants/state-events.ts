import { inTransaction, QUEUES } from '../../jobs/job-queue.js';
import type { Jobs } from '../../jobs/jobs.module.js';
import type { Database } from '../../database/database.js';
import { stateOutbox } from './schema.js';

// RA §18 «restaurant state changed»: what changed. Every device of the
// restaurant reads its status again on any of them (a missed one is never
// the only copy); some also carry a push (RA §16).
export const stateKinds = [
  // The restaurant's own commands (RA §7.2, §10).
  'paused',
  'resumed',
  'busy_mode',
  'holiday_close',
  'hours',
  'order_settings',
  // RA §16 #24: a timed pause ended on its own; push says whether the
  // restaurant takes orders again, so «انتهى الإيقاف المؤقت» is true.
  'pause_ended',
  // RA §16 #25: busy mode is still on, with its minutes.
  'busy_reminder',
  // RA §16 #3, AP §9.6.5: paused after the unanswered orders of a day.
  'auto_paused',
] as const;
export type StateKind = (typeof stateKinds)[number];

export interface StateChange {
  restaurantId: string;
  cityId: string;
  kind: StateKind;
  at: Date;
  // What its push says, such as { push: true } or { extraMin: 20 }.
  values?: Record<string, string | number | boolean>;
}

type Tx = Parameters<Parameters<Database['db']['transaction']>[0]>[0];

// Writes the change in its own transaction (E4) and starts a relay run that
// exists exactly when the change commits.
export async function recordStateChange(tx: Tx, jobs: Jobs, change: StateChange): Promise<void> {
  await tx.insert(stateOutbox).values({
    createdAt: change.at,
    restaurantId: change.restaurantId,
    cityId: change.cityId,
    kind: change.kind,
    payload: { schema: 1, values: change.values ?? {} },
  });
  await jobs.send(QUEUES.restaurantStateRelay, {}, { db: inTransaction(tx) });
}
