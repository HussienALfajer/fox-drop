import { describe, expect, it } from 'vitest';
import type { Database } from '../../database/database.js';
import type { ActivePeakWindow, CaptainsService, PeakBonusService } from '../captains/index.js';
import type { NotificationTexts } from '../content/index.js';
import type { FxService } from '../fx/index.js';
import type { GeoService } from '../geo/index.js';
import { PEAK_NOTICE_CATCH_UP_MS, PeakWindowNotices } from './peak-window-notices.js';
import type { PushQueue, QueuedPush } from './push-queue.js';

// CA §14 #23 (AP §9.12.5, D15; owner decision 2026-11-12): a window that
// started tells every active captain of the city, once.
const now = new Date('2026-11-12T17:02:00Z');
const minute = 60_000;

function notices(windows: ActivePeakWindow[]) {
  const queued: QueuedPush[] = [];
  const rendered: { key: string; values: Record<string, string> }[] = [];
  const peak = { activeNow: async () => windows } as unknown as PeakBonusService;
  const captains = {
    activeCaptainIds: async () => ['captain-1', 'captain-2'],
  } as unknown as CaptainsService;
  const geo = {
    activeCities: async () => [{ id: 'city', timeZone: 'Asia/Damascus' }],
  } as unknown as GeoService;
  const fx = {
    currencies: async () => [{ code: 'TRY', symbol: '₺', decimals: 2 }],
  } as unknown as FxService;
  const texts = {
    render: async (key: string, values: Record<string, string>) => {
      rendered.push({ key, values });
      return { body: `${key}:${JSON.stringify(values)}`, level: 'chime', priority: 'normal' };
    },
  } as unknown as NotificationTexts;
  const pushes = {
    enqueue: async (_db: unknown, each: QueuedPush[]) => {
      queued.push(...each);
    },
  } as unknown as PushQueue;
  const database = { db: {} } as unknown as Database;
  return {
    run: new PeakWindowNotices(database, peak, captains, geo, fx, texts, pushes),
    queued,
    rendered,
  };
}

const window = (since: Date, zones: { id: string; name: string }[] = []): ActivePeakWindow => ({
  amount: 500n,
  currency: 'TRY',
  since,
  until: new Date('2026-11-12T19:00:00Z'),
  zones,
});

describe('the peak window notices (CA §14 #23)', () => {
  it('tells every active captain once a window starts, until it ends', async () => {
    const started = new Date(now.getTime() - 2 * minute);
    const { run, queued, rendered } = notices([window(started)]);
    await run.run(now);
    expect(rendered).toEqual([
      { key: 'captain.peak_started', values: { المبلغ: '5 ₺', الساعة: '10:00 م' } },
    ]);
    expect(queued.map((push) => push.recipient)).toEqual([
      { party: 'captain', captainId: 'captain-1' },
      { party: 'captain', captainId: 'captain-2' },
    ]);
    expect(queued[0]).toMatchObject({
      templateKey: 'captain.peak_started',
      data: { type: 'captain.peak_bonus' },
      at: started,
      expiresAt: new Date('2026-11-12T19:00:00Z'),
    });
    // The next run finds the same window: the same source, which the queue
    // keeps once.
    const again = notices([window(started)]);
    await again.run.run(new Date(now.getTime() + minute));
    expect(again.queued.map((push) => push.source)).toEqual(queued.map((push) => push.source));
  });

  it('names the zones of a window limited to some', async () => {
    const { run, rendered } = notices([
      window(new Date(now.getTime() - minute), [
        { id: 'zone-a', name: 'الشمال' },
        { id: 'zone-b', name: 'المركز' },
      ]),
    ]);
    await run.run(now);
    expect(rendered[0]).toEqual({
      key: 'captain.peak_started_zones',
      values: { المبلغ: '5 ₺', الساعة: '10:00 م', المناطق: 'الشمال، المركز' },
    });
  });

  it('leaves a window that started before the catch-up', async () => {
    const { run, queued } = notices([
      window(new Date(now.getTime() - PEAK_NOTICE_CATCH_UP_MS - minute)),
    ]);
    await run.run(now);
    expect(queued).toEqual([]);
  });
});
