import { afterEach, beforeEach, describe, expect, it } from 'vitest';
import type { Database } from '../../database/database.js';
import type { CaptainsService } from '../captains/index.js';
import type { GeoService } from '../geo/index.js';
import type { OtpSenderPoolService } from '../identity/index.js';
import type { AlertCode } from './alert-rules.js';
import { AlertsSweep } from './alerts-sweep.js';
import type { AlertSubjectRef, AlertsService } from './alerts.service.js';

// AP §9.1.3: the alerts the worker reads every ALERTS_SWEEP_MS, each synced
// for its subject (the records are proved in order-alerts-sync.test.ts).
interface Synced {
  subject: string;
  evaluated: readonly AlertCode[];
  open: readonly AlertCode[];
}

function sweep(options: {
  numbers: string[];
  alerts: { type: 'number_stopped' | 'cannot_send'; numberIds: string[] }[];
  captains: { id: string; name: string; atLimit: boolean | null }[];
  openSubjects?: string[];
}) {
  const synced: Synced[] = [];
  const alerts = {
    sync: async (
      _db: unknown,
      subject: AlertSubjectRef,
      evaluated: readonly AlertCode[],
      open: readonly AlertCode[],
    ) => {
      synced.push({ subject: `${subject.type}:${subject.id}`, evaluated, open });
    },
    openSubjects: async () => (options.openSubjects ?? []).map((id) => ({ id, cityId: 'city' })),
  } as unknown as AlertsService;
  const pool = {
    read: async () => ({
      numbers: options.numbers.map((id) => ({ id })),
      alerts: options.alerts.map((alert) => ({ ...alert, severity: 'warning' })),
    }),
  } as unknown as OtpSenderPoolService;
  const captains = { cashLimits: async () => options.captains } as unknown as CaptainsService;
  const geo = { activeCities: async () => [{ id: 'city' }] } as unknown as GeoService;
  // Each sync runs in its own transaction (E4).
  const tx = {};
  const database = {
    db: { transaction: async (run: (each: object) => Promise<void>) => run(tx) },
  } as unknown as Database;
  return { sweep: new AlertsSweep(database, alerts, pool, captains, geo), synced };
}

describe('the alerts sweep (AP §9.1.3)', () => {
  const environment = process.env.FOX_DROP_ENVIRONMENT;
  beforeEach(() => {
    process.env.FOX_DROP_ENVIRONMENT = 'staging';
  });
  afterEach(() => {
    process.env.FOX_DROP_ENVIRONMENT = environment;
  });

  it('leaves the code senders alone in development', async () => {
    process.env.FOX_DROP_ENVIRONMENT = 'development';
    const { sweep: run, synced } = sweep({
      numbers: [],
      alerts: [{ type: 'cannot_send', numberIds: [] }],
      captains: [],
    });
    await run.senders(new Date());
    expect(synced).toEqual([]);
  });

  it('raises «لا يمكن إرسال رموز الدخول» and «رقم إرسال الرموز متوقف» per number', async () => {
    const { sweep: run, synced } = sweep({
      numbers: ['n1', 'n2'],
      alerts: [
        { type: 'number_stopped', numberIds: ['n2'] },
        { type: 'cannot_send', numberIds: [] },
      ],
      captains: [],
      openSubjects: ['n3'],
    });
    await run.senders(new Date());
    expect(synced).toEqual([
      { subject: 'otp_pool:pool', evaluated: ['codes_cannot_send'], open: ['codes_cannot_send'] },
      { subject: 'otp_number:n1', evaluated: ['code_number_stopped'], open: [] },
      {
        subject: 'otp_number:n2',
        evaluated: ['code_number_stopped'],
        open: ['code_number_stopped'],
      },
      // A number disabled since: its alert resolves.
      { subject: 'otp_number:n3', evaluated: ['code_number_stopped'], open: [] },
    ]);
  });

  it('raises «كابتن بلغ حد العهدة» at 100% and resolves it for a captain gone', async () => {
    const { sweep: run, synced } = sweep({
      numbers: [],
      alerts: [],
      captains: [
        { id: 'c1', name: 'أحمد', atLimit: true },
        { id: 'c2', name: 'سامر', atLimit: false },
        // Its cash cannot be read now: its alert stays as it was.
        { id: 'c3', name: 'خالد', atLimit: null },
      ],
      openSubjects: ['c1', 'c3', 'c9'],
    });
    await run.cashLimits(new Date());
    expect(synced).toEqual([
      { subject: 'captain:c1', evaluated: ['captain_cash_limit'], open: ['captain_cash_limit'] },
      { subject: 'captain:c2', evaluated: ['captain_cash_limit'], open: [] },
      { subject: 'captain:c9', evaluated: ['captain_cash_limit'], open: [] },
    ]);
  });
});
