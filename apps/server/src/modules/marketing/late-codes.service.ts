import { Inject, Injectable } from '@nestjs/common';
import { eq } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { NotificationTexts } from '../content/index.js';
import { PushQueue } from '../notifications/index.js';
import { SettingsService } from '../settings/index.js';
import { createPersonalCode, lockCityCodes, type PersonalCodeValue } from './personal-codes.js';
import { lateCodes, promoCodes } from './schema.js';

type Tx = Parameters<Parameters<NodePgDatabase['transaction']>[0]>[0];

// The order the late code is for, as ordering reads it under its lock.
export interface LateCodeOrder {
  id: string;
  cityId: string;
  number: bigint;
  customerAccountId: string;
  // The order's currency, the city's base when it was placed.
  currency: string;
  promisedAt: Date;
}

// An order's late code with its value, for the customer's order (CU §11.6).
export interface LateCode extends PersonalCodeValue {
  code: string;
  validTo: Date;
  issuedAt: Date;
}

// Why no late code was issued: the setting has no value yet («Before
// launch», AP §13), its percentage rounds to nothing, its amount is in another currency than the order's, or
// the order has one already.
export type LateCodeSkip = 'unset' | 'zero' | 'other_currency' | 'already_issued';

// AP §8.3, §6.4, docs/domain/03 (slice 2.22c): the automatic late code, a
// personal code of order.late_compensation_value issued once per order by the
// system, outside every compensation cap and the order's cumulative total.
@Injectable()
export class LateCodesService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly settings: SettingsService,
    private readonly texts: NotificationTexts,
    private readonly pushes: PushQueue,
  ) {}

  // In ordering's transaction, under the order's lock: the code and the push
  // «تأخر طلبك، وهذا كود خصم لطلبك القادم: {الكود}» (CU §14 #15, opening the
  // order), or why none.
  async issue(tx: Tx, order: LateCodeOrder, now: Date): Promise<LateCode | LateCodeSkip> {
    const [existing] = await tx
      .select({ orderId: lateCodes.orderId })
      .from(lateCodes)
      .where(eq(lateCodes.orderId, order.id));
    if (existing) return 'already_issued';
    const setting = await this.settings.get(
      'order.late_compensation_value',
      { cityId: order.cityId },
      tx,
    );
    if (setting === null) return 'unset';
    let value: PersonalCodeValue;
    if (setting.kind === 'amount') {
      if (setting.currency !== order.currency) return 'other_currency';
      value = {
        kind: 'fixed_amount',
        amount: BigInt(setting.amountMinor),
        percentBp: null,
        maxDiscount: null,
        currency: order.currency,
      };
    } else {
      const percentBp = Math.round(setting.percent * 100);
      // 0% gives nothing: no code.
      if (percentBp < 1) return 'zero';
      value = {
        kind: 'percentage',
        amount: null,
        percentBp,
        maxDiscount: null,
        currency: order.currency,
      };
    }
    await lockCityCodes(tx, order.cityId);
    const created = await createPersonalCode(
      tx,
      this.settings,
      { ...value, cityId: order.cityId, customerAccountId: order.customerAccountId },
      null,
      now,
    );
    await tx.insert(lateCodes).values({
      orderId: order.id,
      cityId: order.cityId,
      orderNumber: order.number,
      customerAccountId: order.customerAccountId,
      codeId: created.id,
      promisedAt: order.promisedAt,
      issuedAt: now,
    });
    const templateKey = 'customer.late_code';
    const rendered = await this.texts.render(templateKey, { الكود: created.code }, tx);
    await this.pushes.enqueue(
      tx,
      [
        {
          source: `marketing:${templateKey}:${order.id}`,
          recipient: { party: 'customer', accountId: order.customerAccountId },
          templateKey,
          body: rendered.body,
          level: rendered.level,
          priority: rendered.priority,
          // CU §14: rows 1 to 15 open the order.
          data: { target: 'order', orderId: order.id },
          at: now,
          expiresAt: created.validTo,
        },
      ],
      now,
    );
    return { ...value, code: created.code, validTo: created.validTo, issuedAt: now };
  }

  // The order's late code, or null (CU §11.6).
  async forOrder(orderId: string): Promise<LateCode | null> {
    const [row] = await this.database.db
      .select({ issuedAt: lateCodes.issuedAt, code: promoCodes })
      .from(lateCodes)
      .innerJoin(promoCodes, eq(promoCodes.id, lateCodes.codeId))
      .where(eq(lateCodes.orderId, orderId));
    if (!row) return null;
    const { code } = row;
    return {
      kind: code.kind === 'percentage' ? 'percentage' : 'fixed_amount',
      amount: code.amount,
      percentBp: code.percentBp,
      maxDiscount: code.maxDiscount,
      currency: code.currency,
      code: code.code,
      validTo: code.validTo,
      issuedAt: row.issuedAt,
    };
  }
}
