import { and, eq, sql } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import type { SettingsService } from '../settings/index.js';
import { generatedCode } from './promo-codes.js';
import { type CompensationKind, promoCodes } from './schema.js';

type Tx = Parameters<Parameters<NodePgDatabase['transaction']>[0]>[0];

const DAY_MS = 24 * 60 * 60 * 1000;
const DRAWS = 5;

// The value of a personal code: an amount, or a percentage (basis points)
// with its maximum, none for the late code's (AP Appendix A).
export interface PersonalCodeValue {
  kind: CompensationKind;
  amount: bigint | null;
  percentBp: number | null;
  maxDiscount: bigint | null;
  currency: string;
}

export interface PersonalCode {
  id: string;
  code: string;
  validTo: Date;
}

// A personal code (slices 2.22a, 2.22c): one use by its customer, funded by
// the platform, valid support.personal_code_valid_days from now, a generated
// 8-character code. The caller holds the city's codes lock
// (`marketing.codes:<cityId>`, `lockCityCodes`); the setting is read through
// the transaction, which may be the order's and never waits on a second
// connection. `createdBy` is the admin, null for the system (the late code).
export async function createPersonalCode(
  tx: Tx,
  settings: SettingsService,
  input: PersonalCodeValue & { cityId: string; customerAccountId: string },
  createdBy: string | null,
  now: Date,
): Promise<PersonalCode> {
  const days = await settings.get('support.personal_code_valid_days', { cityId: input.cityId }, tx);
  let code: string | null = null;
  for (let i = 0; i < DRAWS && code === null; i += 1) {
    const candidate = generatedCode('');
    const [taken] = await tx
      .select({ id: promoCodes.id })
      .from(promoCodes)
      .where(and(eq(promoCodes.cityId, input.cityId), eq(promoCodes.code, candidate)));
    if (!taken) code = candidate;
  }
  if (code === null) throw new Error('could not draw a free code');
  const validTo = new Date(now.getTime() + days * DAY_MS);
  const [created] = (await tx
    .insert(promoCodes)
    .values({
      cityId: input.cityId,
      code,
      kind: input.kind,
      percentBp: input.percentBp,
      amount: input.amount,
      maxDiscount: input.maxDiscount,
      currency: input.currency,
      validFrom: now,
      validTo,
      totalLimit: 1,
      perCustomerLimit: 1,
      audience: 'everyone',
      restaurantIds: [],
      zoneIds: [],
      funding: 'platform',
      merchantShareBp: 0,
      visibility: 'personal',
      customerAccountId: input.customerAccountId,
      createdBy,
      updatedBy: createdBy,
    })
    .returning({ id: promoCodes.id })) as [{ id: string }];
  return { id: created.id, code, validTo };
}

// The city's codes lock: a code is drawn and created under it, so two never
// take the same one.
export async function lockCityCodes(tx: Tx, cityId: string): Promise<void> {
  await tx.execute(
    sql`SELECT pg_advisory_xact_lock(hashtextextended(${`marketing.codes:${cityId}`}, 0))`,
  );
}
