import 'reflect-metadata';
import { randomUUID } from 'node:crypto';
import { Test } from '@nestjs/testing';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { type AccountPurpose, type JournalType, LedgerModule, LedgerService } from './index.js';

// The worked example of AP §8.4, for a restaurant in `active` status (a
// `test` restaurant posts no commission, AP §9.6.3): items 400, delivery fee
// 40, a platform code of 30, captain pay 35, commission 15%. Amounts are in
// minor units (kuruş) of TRY.
let database: TestDatabase;
let ledger: LedgerService;
let db: Database['db'];
let close: () => Promise<void>;

beforeAll(async () => {
  database = await startTestDatabase();
  process.env.DATABASE_URL = database.appUrl;
  const moduleRef = await Test.createTestingModule({ imports: [LedgerModule] }).compile();
  await moduleRef.init();
  ledger = moduleRef.get(LedgerService);
  db = moduleRef.get<Database>(DATABASE, { strict: false }).db;
  close = () => moduleRef.close();
}, 300_000);

afterAll(async () => {
  await close?.();
  await database?.stop();
});

const lira = (amount: number) => BigInt(amount * 100);

describe('the worked example of AP §8.4', () => {
  it('balances every account as the example says, and the platform cash equals its margin', async () => {
    const cityId = randomUUID();
    const order = { kind: 'order', id: randomUUID() } as const;
    const desk = { type: 'admin', id: randomUUID() } as const;
    const open = (purpose: AccountPurpose, ownerId: string | null = null) =>
      ledger.openAccount({ cityId, purpose, ownerId, currency: 'TRY' });
    const captainId = randomUUID();
    const account = {
      custody: await open('captain.custody', captainId),
      earnings: await open('captain.earnings', captainId),
      restaurant: await open('merchant.account', randomUUID()),
      clearing: await open('platform.order_clearing'),
      delivery: await open('platform.revenue_delivery'),
      commission: await open('platform.revenue_commission'),
      discount: await open('platform.discount_cost'),
      captainPay: await open('platform.captain_pay'),
      drawer: await open('platform.cash', randomUUID()),
    };
    type Name = keyof typeof account;

    // One journal: the entries from the platform's side, + a debit.
    const post = (
      type: JournalType,
      lines: Partial<Record<Name, number>>,
      source: typeof order | null = order,
    ) =>
      db.transaction((tx) =>
        ledger.post(
          {
            cityId,
            type,
            source,
            actor: source ? { type: 'system', id: null } : desk,
            entries: Object.entries(lines).map(([name, amount]) => ({
              accountId: account[name as Name],
              currency: 'TRY',
              amount: lira(amount),
            })),
          },
          tx,
        ),
      );
    const balances = async () => {
      const result: Partial<Record<Name, number>> = {};
      for (const name of Object.keys(account) as Name[]) {
        const { amount } = await ledger.balance(account[name]);
        result[name] = Number(amount) / 100;
      }
      return result;
    };

    // At pickup the captain pays the restaurant the full items value (D26).
    await post('custody.pay_merchant', { custody: -400, clearing: 400 });
    // At the door the customer pays 410; the platform books its fee and its code.
    await post('custody.collect', { custody: 410, clearing: -410 });
    await post('platform.revenue_delivery', { clearing: 40, delivery: -40 });
    await post('platform.discount_cost', { discount: 30, clearing: -30 });
    // The order finishes: commission on 400 and the captain's pay.
    await post('merchant.commission', { restaurant: 60, commission: -60 });
    await post('earn.order_pay', { earnings: -35, captainPay: 35 });

    expect(await balances()).toEqual({
      custody: 10, // custody gained, handed in the same business day
      earnings: 35, // paid on Thursday
      restaurant: -60, // the restaurant owes its commission on Saturday
      clearing: 0, // the order's money is settled
      delivery: 40,
      commission: 60,
      discount: 30,
      captainPay: 35,
      drawer: 0,
    });
    // Platform margin = 60 + 40 − 30 − 35.
    const margin = (await balances()) as Record<Name, number>;
    expect(margin.commission + margin.delivery - margin.discount - margin.captainPay).toBe(35);

    // When each amount reaches the platform: custody, Thursday, Saturday.
    await post('custody.hand_in', { custody: -10, drawer: 10 }, null);
    await post('earn.payout', { earnings: 35, drawer: -35 }, null);
    await post('merchant.settlement', { restaurant: -60, drawer: 60 }, null);

    expect(await balances()).toMatchObject({ custody: 0, earnings: 0, restaurant: 0, drawer: 35 });
  });
});
