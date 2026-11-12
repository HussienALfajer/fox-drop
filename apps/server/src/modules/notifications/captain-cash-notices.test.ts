import { describe, expect, it } from 'vitest';
import type { Database } from '../../database/database.js';
import type { CaptainsService, CashReminder } from '../captains/index.js';
import type { NotificationTexts } from '../content/index.js';
import type { FxService } from '../fx/index.js';
import type { GeoService, Office } from '../geo/index.js';
import { CaptainCashNotices, HAND_IN_REMINDER_CATCH_UP_MS } from './captain-cash-notices.js';
import type { PushQueue, QueuedPush } from './push-queue.js';

// CA §10.3, §14 #16–#17 (slice 2.17d): the 22:00 reminder while the office is
// open, and the push to a captain online across the cutoff with cash due.
// 22:00 in Azaz (UTC+3) is 19:00Z.
const evening = new Date('2026-11-12T19:00:00Z');
const minute = 60_000;
const closesAt = new Date('2026-11-12T20:00:00Z');

const holding = (captainId: string, overrides: Partial<CashReminder> = {}): CashReminder => ({
  captainId,
  handIn: { amount: 41_000n, currency: 'TRY' },
  heldToday: true,
  remitBy: null,
  ...overrides,
});

function notices(reminders: CashReminder[], office: Partial<Office> | null = { open: true }) {
  const queued: QueuedPush[] = [];
  const rendered: { key: string; values: Record<string, string> }[] = [];
  const swept: string[] = [];
  const captains = {
    sweepCustodyWarnings: async (cityId: string) => {
      swept.push(cityId);
    },
    cashReminders: async () => reminders,
  } as unknown as CaptainsService;
  const geo = {
    activeCities: async () => [{ id: 'city', timeZone: 'Asia/Damascus' }],
    office: async () => office && { closesAt, opensAt: null, ...office },
  } as unknown as GeoService;
  const fx = {
    currencies: async () => [{ code: 'TRY', symbol: '₺', decimals: 2 }],
  } as unknown as FxService;
  const texts = {
    render: async (key: string, values: Record<string, string>) => {
      rendered.push({ key, values });
      return { body: key, level: 'chime', priority: 'normal' };
    },
  } as unknown as NotificationTexts;
  const pushes = {
    enqueue: async (_db: unknown, each: QueuedPush[]) => {
      queued.push(...each);
    },
  } as unknown as PushQueue;
  const database = { db: {} } as unknown as Database;
  return {
    run: new CaptainCashNotices(database, captains, geo, fx, texts, pushes),
    queued,
    rendered,
    swept,
  };
}

describe('the captain cash notices (CA §10.3–10.4)', () => {
  it('sweeps the warnings of every city', async () => {
    const { run, swept } = notices([]);
    await run.run(evening);
    expect(swept).toEqual(['city']);
  });

  it('reminds at 22:00 each captain holding cash from today while the office is open, once a day', async () => {
    const { run, queued, rendered } = notices([
      holding('captain-1'),
      holding('captain-2', { heldToday: false }),
      holding('captain-3', { handIn: null }),
    ]);
    await run.run(new Date(evening.getTime() + 2 * minute));
    expect(rendered).toEqual([
      { key: 'captain.hand_in_reminder', values: { المبلغ: '410 ₺', الساعة: '11:00 م' } },
    ]);
    expect(queued).toHaveLength(1);
    expect(queued[0]).toMatchObject({
      recipient: { party: 'captain', captainId: 'captain-1' },
      templateKey: 'captain.hand_in_reminder',
      data: { target: 'custody' },
      at: evening,
      expiresAt: closesAt,
    });
    // A later run within the catch-up names the same source.
    const again = notices([holding('captain-1')]);
    await again.run.run(new Date(evening.getTime() + 5 * minute));
    expect(again.queued.map((push) => push.source)).toEqual([queued[0]!.source]);
  });

  it('says nothing at 22:00 while the office is closed or not set, or after the catch-up', async () => {
    for (const office of [{ open: false }, null]) {
      const { run, queued } = notices([holding('captain-1')], office);
      await run.run(evening);
      expect(queued).toEqual([]);
    }
    const late = notices([holding('captain-1')]);
    await late.run.run(new Date(evening.getTime() + HAND_IN_REMINDER_CATCH_UP_MS + minute));
    expect(late.queued).toEqual([]);
  });

  it('tells a captain online across the cutoff until when the offers continue', async () => {
    // The cutoff at 06:00 (03:00Z), offers until 10:00 (07:00Z).
    const now = new Date('2026-11-13T03:01:00Z');
    const remitBy = new Date('2026-11-13T07:00:00Z');
    const { run, queued, rendered } = notices([
      holding('captain-1', { heldToday: false, remitBy }),
    ]);
    await run.run(now);
    expect(rendered).toEqual([{ key: 'captain.cutoff_passed', values: { الساعة: '10:00 ص' } }]);
    expect(queued[0]).toMatchObject({
      source: `captain:captain.cutoff_passed:captain-1:${remitBy.toISOString()}`,
      recipient: { party: 'captain', captainId: 'captain-1' },
      expiresAt: remitBy,
    });
  });
});
