import { createHash } from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { and, desc, eq, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { AuditService } from '../audit/index.js';
import { GeoService } from '../geo/index.js';
import { MerchantsService } from '../merchants/index.js';
import { PushQueue, type QueuedPush } from '../notifications/index.js';
import { BannersService } from './banners.service.js';
import type { PromoChange } from './promo-codes.service.js';
import {
  idempotencyKeys,
  type MassPushAudienceKind,
  massPushes,
  type MassPushTarget,
} from './schema.js';

// The phone's title and text (the table's CHECKs; decided by us).
export const MASS_PUSH_TITLE_MAX = 50;
export const MASS_PUSH_BODY_MAX = 200;
// «لم يطلب منذ N يوماً»: 1 to 365 days (decided by us).
export const MASS_PUSH_INACTIVE_DAYS_MAX = 365;
// How far ahead a push can be scheduled, and how long its pushes wait for a
// phone that is off or a failing FCM after their time (decided by us).
export const MASS_PUSH_SCHEDULE_DAYS = 30;
const MASS_PUSH_TTL_MS = 24 * 60 * 60 * 1000;
// The history the panel shows, newest first.
const HISTORY_MAX = 100;
// Architecture §5.3: a create's key answers its repeat for 24 hours.
const KEY_LIFETIME_MS = 24 * 60 * 60 * 1000;
// CU §14 row 22: the default sound, the campaign's own text.
export const MASS_PUSH_TEMPLATE = 'customer.mass_push';

export interface MassPushAudience {
  kind: MassPushAudienceKind;
  // `zone` only.
  zoneId: string | null;
  // `inactive` only.
  inactiveDays: number | null;
}

export interface MassPushFields {
  title: string;
  body: string;
  audience: MassPushAudience;
  target: MassPushTarget;
  restaurantId: string | null;
  codeId: string | null;
  // Null: now.
  sendAt: Date | null;
}

export interface MassPush {
  id: string;
  title: string;
  body: string;
  audience: MassPushAudience;
  target: MassPushTarget;
  restaurantId: string | null;
  codeId: string | null;
  code: string | null;
  scheduled: boolean;
  sendAt: Date;
  // `scheduled` before its time, `cancelled`, else `sent`.
  status: 'scheduled' | 'sent' | 'cancelled';
  recipients: number;
  sent: number;
  delivered: number;
  createdBy: string;
  createdAt: Date;
  cancelledBy: string | null;
  cancelledAt: Date | null;
}

// Who is in an audience now: the customers' account ids. The customers
// module registers it (useAudience), since this module cannot import it.
export type MassPushAudienceSource = (
  cityId: string,
  audience: MassPushAudience,
  now: Date,
) => Promise<string[]>;

export type MassPushRefusal =
  | 'unknown_city'
  | 'unknown_mass_push'
  | 'invalid_mass_push'
  | 'audience_changed'
  | 'audience_empty'
  | 'not_cancellable'
  | 'idempotency_key_reused';

export class MassPushRefusedError extends Error {
  constructor(
    readonly refusal: MassPushRefusal,
    message: string,
  ) {
    super(message);
  }
}

type Tx = Parameters<Parameters<Database['db']['transaction']>[0]>[0];
type Executor = Database['db'] | Tx;
type Row = typeof massPushes.$inferSelect;

// AP §9.11.4 «الإشعارات الجماعية» (slice 2.27d, owner decisions 2026-11-18;
// D20: no daily limit). OWN sends (marketing.manage), OPS reads the
// history. The audience is counted when the panel asks and again at the
// confirmation, which must find the size the admin confirmed; its pushes are
// queued then, for the push's time, in the transaction that records it.
@Injectable()
export class MassPushesService {
  private audienceSource: MassPushAudienceSource | null = null;

  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly audit: AuditService,
    private readonly banners: BannersService,
    private readonly geo: GeoService,
    private readonly merchants: MerchantsService,
    private readonly queue: PushQueue,
  ) {}

  useAudience(source: MassPushAudienceSource): void {
    this.audienceSource = source;
  }

  // The panel's audience size before the confirmation. 400
  // invalid_mass_push, 404 unknown_city.
  async audienceSize(cityId: string, audience: MassPushAudience, now: Date): Promise<number> {
    await this.checkCity(cityId);
    await this.checkAudience(cityId, audience);
    return (await this.members(cityId, audience, now)).length;
  }

  // The city's pushes, newest first, with their counts.
  async list(
    cityId: string,
    now: Date,
    executor: Executor = this.database.db,
  ): Promise<MassPush[]> {
    const rows = await executor
      .select()
      .from(massPushes)
      .where(eq(massPushes.cityId, cityId))
      .orderBy(desc(massPushes.createdAt), desc(massPushes.id))
      .limit(HISTORY_MAX);
    const counts = await this.queue.campaignCounts(rows.map((row) => row.id));
    return rows.map((row) => pushOf(row, counts.get(row.id), now));
  }

  // The confirmation: `expected` is the size the panel showed, so the
  // admin never sends to an audience other than the one confirmed (409
  // audience_changed otherwise, with the size now; 409 audience_empty for
  // none). Its Idempotency-Key is kept with the push in
  // marketing.idempotency_keys (`code_ids` holds its id): a repeat within 24
  // hours answers the history without a second push.
  async create(
    cityId: string,
    fields: MassPushFields,
    expected: number,
    idempotencyKey: string,
    change: PromoChange,
    now = new Date(),
  ): Promise<MassPush[]> {
    const requestHash = createHash('sha256')
      .update(
        JSON.stringify([
          'mass_push.create',
          cityId,
          { ...fields, sendAt: fields.sendAt?.toISOString() ?? null },
          expected,
        ]),
      )
      .digest('hex');
    const keyOf = { accountId: change.accountId, key: idempotencyKey, requestHash, now };
    if (await this.replayed(this.database.db, keyOf)) return this.list(cityId, now);
    const checked = await this.checkFields(cityId, fields, now);
    const members = await this.members(cityId, fields.audience, now);
    if (members.length === 0) {
      throw new MassPushRefusedError('audience_empty', 'nobody is in the audience');
    }
    if (members.length !== expected) {
      throw new MassPushRefusedError(
        'audience_changed',
        `the audience is ${members.length} now, not ${expected}`,
      );
    }
    const sendAt = fields.sendAt ?? now;
    return this.database.db.transaction(async (tx) => {
      await tx.execute(
        sql`SELECT pg_advisory_xact_lock(hashtextextended(${`marketing.key:${change.accountId}:${idempotencyKey}`}, 0))`,
      );
      if (await this.replayed(tx, keyOf)) return this.list(cityId, now, tx);
      const [row] = await tx
        .insert(massPushes)
        .values({
          cityId,
          title: checked.title,
          body: checked.body,
          audience: checked.audience.kind,
          zoneId: checked.audience.zoneId,
          inactiveDays: checked.audience.inactiveDays,
          target: checked.target,
          restaurantId: checked.restaurantId,
          codeId: checked.codeId,
          code: checked.code,
          scheduled: fields.sendAt !== null,
          sendAt,
          recipients: members.length,
          createdBy: change.accountId,
          createdAt: now,
        })
        .returning();
      const data = dataOf(row!);
      await this.queue.enqueue(
        tx,
        members.map((accountId): QueuedPush => ({
          source: `marketing:${MASS_PUSH_TEMPLATE}:${row!.id}:${accountId}`,
          recipient: { party: 'customer', accountId },
          templateKey: MASS_PUSH_TEMPLATE,
          title: row!.title,
          body: row!.body,
          level: 'default',
          priority: 'normal',
          data,
          at: sendAt,
          expiresAt: new Date(sendAt.getTime() + MASS_PUSH_TTL_MS),
          campaignId: row!.id,
        })),
        now,
      );
      await tx
        .insert(idempotencyKeys)
        .values({
          accountId: change.accountId,
          key: idempotencyKey,
          requestHash,
          codeIds: [row!.id],
          createdAt: now,
        })
        .onConflictDoUpdate({
          target: [idempotencyKeys.accountId, idempotencyKeys.key],
          set: { requestHash, codeIds: [row!.id], createdAt: now },
        });
      await this.record(tx, change, cityId, 'mass_push.create', row!.id, null, auditOf(row!));
      return this.list(cityId, now, tx);
    });
  }

  // A scheduled push before its time, for good; its pushes are given up.
  // 404 unknown_mass_push; 409 not_cancellable once its time came, for one
  // sent now, and for one cancelled already.
  async cancel(cityId: string, id: string, change: PromoChange, now = new Date()) {
    await this.checkCity(cityId);
    return this.database.db.transaction(async (tx) => {
      const [row] = await tx
        .select()
        .from(massPushes)
        .where(and(eq(massPushes.id, id), eq(massPushes.cityId, cityId)))
        .for('update');
      if (!row) throw new MassPushRefusedError('unknown_mass_push', 'no such mass push');
      if (!row.scheduled || row.cancelledAt !== null || row.sendAt <= now) {
        throw new MassPushRefusedError('not_cancellable', 'only a scheduled push before its time');
      }
      await tx
        .update(massPushes)
        .set({ cancelledAt: now, cancelledBy: change.accountId })
        .where(eq(massPushes.id, id));
      await this.queue.cancelCampaign(tx, id, now);
      await this.record(tx, change, cityId, 'mass_push.cancel', id, auditOf(row), {
        ...auditOf(row),
        cancelledAt: now.toISOString(),
      });
      return this.list(cityId, now, tx);
    });
  }

  // 404 unknown_city.
  async checkCity(cityId: string): Promise<void> {
    if ((await this.geo.cityTimeZone(cityId)) === null) {
      throw new MassPushRefusedError('unknown_city', 'no such city');
    }
  }

  private members(cityId: string, audience: MassPushAudience, now: Date): Promise<string[]> {
    if (this.audienceSource === null) throw new Error('customers has not registered the audience');
    return this.audienceSource(cityId, audience, now);
  }

  // The zone one of the city's active zones; the days a whole number from 1
  // to 365; nothing the kind does not take.
  private async checkAudience(cityId: string, audience: MassPushAudience): Promise<void> {
    const invalid = (message: string) => new MassPushRefusedError('invalid_mass_push', message);
    if ((audience.zoneId !== null) !== (audience.kind === 'zone')) {
      throw invalid('a zone goes with the zone audience only');
    }
    if ((audience.inactiveDays !== null) !== (audience.kind === 'inactive')) {
      throw invalid('the days go with the inactive audience only');
    }
    if (
      audience.inactiveDays !== null &&
      (!Number.isInteger(audience.inactiveDays) ||
        audience.inactiveDays < 1 ||
        audience.inactiveDays > MASS_PUSH_INACTIVE_DAYS_MAX)
    ) {
      throw invalid(`the days are 1 to ${MASS_PUSH_INACTIVE_DAYS_MAX}`);
    }
    if (audience.zoneId !== null) {
      const zone = (await this.geo.zones(cityId)).find((each) => each.id === audience.zoneId);
      if (zone === undefined || !zone.active)
        throw invalid('the zone is an active zone of the city');
    }
  }

  // The title and text trimmed, within their bounds; the audience; the
  // target (a restaurant of the city, or a code the city runs now, as a
  // banner's); a time ahead within MASS_PUSH_SCHEDULE_DAYS, or now.
  private async checkFields(cityId: string, fields: MassPushFields, now: Date) {
    await this.checkCity(cityId);
    const invalid = (message: string) => new MassPushRefusedError('invalid_mass_push', message);
    const title = fields.title.trim();
    const body = fields.body.trim();
    if (title.length === 0 || [...title].length > MASS_PUSH_TITLE_MAX) {
      throw invalid(`the title is 1 to ${MASS_PUSH_TITLE_MAX} characters`);
    }
    if (body.length === 0 || [...body].length > MASS_PUSH_BODY_MAX) {
      throw invalid(`the text is 1 to ${MASS_PUSH_BODY_MAX} characters`);
    }
    await this.checkAudience(cityId, fields.audience);
    if ((fields.restaurantId !== null) !== (fields.target === 'restaurant')) {
      throw invalid('a restaurant goes with the restaurant target only');
    }
    if ((fields.codeId !== null) !== (fields.target === 'code')) {
      throw invalid('a code goes with the code target only');
    }
    if (fields.restaurantId !== null) {
      const restaurants = await this.merchants.restaurantIds(cityId);
      if (!restaurants.some((each) => each.id === fields.restaurantId)) {
        throw invalid('the restaurant is one of the city');
      }
    }
    let code: string | null = null;
    if (fields.codeId !== null) {
      const running = await this.banners.codeChoices(cityId, now);
      code = running.find((each) => each.id === fields.codeId)?.code ?? null;
      if (code === null) throw invalid('the code is a visible code the city runs now');
    }
    if (fields.sendAt !== null) {
      if (fields.sendAt <= now) throw invalid('a scheduled push is ahead of now');
      if (fields.sendAt.getTime() > now.getTime() + MASS_PUSH_SCHEDULE_DAYS * 86_400_000) {
        throw invalid(`a push is scheduled at most ${MASS_PUSH_SCHEDULE_DAYS} days ahead`);
      }
    }
    return { ...fields, title, body, code };
  }

  // Whether the key answered this body within 24 hours (422
  // idempotency_key_reused for another body).
  private async replayed(
    executor: Executor,
    kept: { accountId: string; key: string; requestHash: string; now: Date },
  ): Promise<boolean> {
    const [row] = await executor
      .select()
      .from(idempotencyKeys)
      .where(and(eq(idempotencyKeys.accountId, kept.accountId), eq(idempotencyKeys.key, kept.key)));
    if (!row || row.createdAt.getTime() < kept.now.getTime() - KEY_LIFETIME_MS) return false;
    if (row.requestHash !== kept.requestHash) {
      throw new MassPushRefusedError('idempotency_key_reused', 'the key came with another command');
    }
    return true;
  }

  private record(
    tx: Tx,
    change: PromoChange,
    cityId: string,
    action: string,
    id: string,
    before: object | null,
    after: object | null,
  ): Promise<void> {
    return this.audit.recordWrite(
      {
        actor: change.actor,
        context: change.context,
        cityId,
        action,
        target: { type: 'mass_push', id },
        before: before as Record<string, unknown> | null,
        after: after as Record<string, unknown> | null,
        reason: null,
      },
      tx,
    );
  }
}

// What a tap opens (CU §14 row 22): `kind` tells the app to acknowledge it.
function dataOf(row: Row): Record<string, string> {
  const base = { kind: 'mass_push' };
  if (row.target === 'restaurant') {
    return { ...base, target: 'restaurant', restaurantId: row.restaurantId! };
  }
  if (row.target === 'code') return { ...base, target: 'codes', code: row.code! };
  return { ...base, target: 'home' };
}

function pushOf(
  row: Row,
  counts: { sent: number; delivered: number } | undefined,
  now: Date,
): MassPush {
  return {
    id: row.id,
    title: row.title,
    body: row.body,
    audience: { kind: row.audience, zoneId: row.zoneId, inactiveDays: row.inactiveDays },
    target: row.target,
    restaurantId: row.restaurantId,
    codeId: row.codeId,
    code: row.code,
    scheduled: row.scheduled,
    sendAt: row.sendAt,
    status: row.cancelledAt !== null ? 'cancelled' : row.sendAt > now ? 'scheduled' : 'sent',
    recipients: row.recipients,
    sent: counts?.sent ?? 0,
    delivered: counts?.delivered ?? 0,
    createdBy: row.createdBy,
    createdAt: row.createdAt,
    cancelledBy: row.cancelledBy,
    cancelledAt: row.cancelledAt,
  };
}

function auditOf(row: Row) {
  return {
    title: row.title,
    body: row.body,
    audience: row.audience,
    zoneId: row.zoneId,
    inactiveDays: row.inactiveDays,
    target: row.target,
    restaurantId: row.restaurantId,
    codeId: row.codeId,
    sendAt: row.sendAt.toISOString(),
    recipients: row.recipients,
  };
}
