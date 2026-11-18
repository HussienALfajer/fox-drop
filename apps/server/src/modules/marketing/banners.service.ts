import { createHash } from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { and, asc, eq, gt, isNull, lte, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { AuditService } from '../audit/index.js';
import { CategoriesService } from '../content/index.js';
import { FilesService } from '../files/index.js';
import { FxService } from '../fx/index.js';
import { GeoService } from '../geo/index.js';
import { MerchantsService } from '../merchants/index.js';
import type { PromoChange } from './promo-codes.service.js';
import { type BannerTarget, banners, idempotencyKeys, promoCodes } from './schema.js';

// A banner's title, 1 to 60 characters (the table's CHECK).
export const BANNER_TITLE_MAX = 60;
// A list target's restaurants (the table's CHECK).
export const BANNER_RESTAURANTS_MAX = 30;
// Technical bounds, not business rules (decided by us): the banners of a
// city that are neither removed nor ended, and those the home shows at once
// (owner decision 2026-11-18: at most 10, swipeable).
export const BANNERS_MAX = 30;
export const HOME_BANNERS_MAX = 10;
// Architecture §5.3: a create's key answers its repeat for 24 hours.
const KEY_LIFETIME_MS = 24 * 60 * 60 * 1000;

export interface Banner {
  id: string;
  title: string;
  imageKey: string;
  target: BannerTarget;
  // `restaurant`: one; `restaurants`: the list in the admin's order.
  restaurantIds: string[];
  categoryId: string | null;
  codeId: string | null;
  // The code target's code as the customer types it; null otherwise.
  code: string | null;
  // None: every zone of the city.
  zoneIds: string[];
  startsAt: Date;
  endsAt: Date;
}

export interface BannerFields {
  title: string;
  target: BannerTarget;
  restaurantIds: string[];
  categoryId: string | null;
  codeId: string | null;
  zoneIds: string[];
  startsAt: Date;
  endsAt: Date;
}

export type BannerRefusal =
  | 'unknown_city'
  | 'unknown_banner'
  | 'invalid_banner'
  | 'banners_changed'
  | 'upload_used'
  | 'idempotency_key_reused';

export class BannerRefusedError extends Error {
  constructor(
    readonly refusal: BannerRefusal,
    message: string,
  ) {
    super(message);
  }
}

type Tx = Parameters<Parameters<Database['db']['transaction']>[0]>[0];
type Executor = Database['db'] | Tx;

// AP §9.11.2 «البانرات» (slice 2.27c, owner decisions 2026-11-18): the
// customer home's banners per city. OWN and DATA publish them
// (marketing.banners), OPS reads them; each edit takes the city's advisory
// lock and is audited banner.*. The customer's home reads those running at
// the point (`shown`).
@Injectable()
export class BannersService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly audit: AuditService,
    private readonly categories: CategoriesService,
    private readonly files: FilesService,
    private readonly fx: FxService,
    private readonly geo: GeoService,
    private readonly merchants: MerchantsService,
  ) {}

  // Every banner of the city not removed, in the strip's order, ended ones
  // included (the panel shows them as ended).
  async list(cityId: string, executor: Executor = this.database.db): Promise<Banner[]> {
    const rows = await executor
      .select({ banner: banners, code: promoCodes.code })
      .from(banners)
      .leftJoin(promoCodes, eq(promoCodes.id, banners.codeId))
      .where(and(eq(banners.cityId, cityId), isNull(banners.removedAt)))
      .orderBy(asc(banners.position), asc(banners.id));
    return rows.map(({ banner, code }) => bannerOf(banner, code));
  }

  // The city's visible codes not ended, for the panel's code target:
  // newest first.
  async codeChoices(cityId: string, now = new Date()): Promise<{ id: string; code: string }[]> {
    return this.database.db
      .select({ id: promoCodes.id, code: promoCodes.code })
      .from(promoCodes)
      .where(
        and(
          eq(promoCodes.cityId, cityId),
          eq(promoCodes.visibility, 'visible'),
          gt(promoCodes.validTo, now),
        ),
      )
      .orderBy(sql`${promoCodes.createdAt} DESC`, asc(promoCodes.code));
  }

  // CU §8.1 (owner decision 2026-11-18): the banners running now in the
  // zone, in the panel's order, before the caller drops those whose target
  // the customer cannot open. A code target counts only while its code runs
  // now in the city's base (visible, active, started, not ended: «أكوادي»'s
  // `runsNow`), since «أكوادي» would not show it otherwise.
  async running(cityId: string, zoneId: string, now: Date): Promise<Banner[]> {
    const base = await this.fx.baseCurrency(cityId);
    const rows = await this.database.db
      .select({ banner: banners, code: promoCodes.code })
      .from(banners)
      .leftJoin(
        promoCodes,
        and(
          eq(promoCodes.id, banners.codeId),
          eq(promoCodes.visibility, 'visible'),
          eq(promoCodes.status, 'active'),
          lte(promoCodes.validFrom, now),
          gt(promoCodes.validTo, now),
          base === null ? sql`false` : eq(promoCodes.currency, base),
        ),
      )
      .where(
        and(
          eq(banners.cityId, cityId),
          isNull(banners.removedAt),
          lte(banners.startsAt, now),
          gt(banners.endsAt, now),
          sql`(cardinality(${banners.zoneIds}) = 0 OR ${zoneId}::uuid = ANY(${banners.zoneIds}))`,
        ),
      )
      .orderBy(asc(banners.position), asc(banners.id));
    return rows
      .filter(({ banner, code }) => banner.target !== 'code' || code !== null)
      .map(({ banner, code }) => bannerOf(banner, code));
  }

  // The panel: a banner at the end of the strip with its image (an upload
  // of banner_image, already cut to 1200×500). Its Idempotency-Key is kept
  // with the banner in marketing.idempotency_keys (`code_ids` holds the
  // banner's id): a repeat within 24 hours answers the banners without
  // adding one; another body under the key is 422 idempotency_key_reused.
  async create(
    cityId: string,
    fields: BannerFields,
    uploadId: string,
    idempotencyKey: string,
    change: PromoChange,
    now = new Date(),
  ): Promise<Banner[]> {
    const checked = await this.checkFields(cityId, fields, now);
    const requestHash = createHash('sha256')
      .update(JSON.stringify(['banner.create', cityId, checked, uploadId]))
      .digest('hex');
    // Before the transaction: it calls the storage (the files module's rule).
    await this.files.prepare(uploadId, 'banner_image', now);
    return this.database.db.transaction(async (tx) => {
      await tx.execute(
        sql`SELECT pg_advisory_xact_lock(hashtextextended(${`marketing.key:${change.accountId}:${idempotencyKey}`}, 0))`,
      );
      const [kept] = await tx
        .select()
        .from(idempotencyKeys)
        .where(
          and(
            eq(idempotencyKeys.accountId, change.accountId),
            eq(idempotencyKeys.key, idempotencyKey),
          ),
        );
      if (kept && kept.createdAt.getTime() >= now.getTime() - KEY_LIFETIME_MS) {
        if (kept.requestHash !== requestHash) {
          throw new BannerRefusedError(
            'idempotency_key_reused',
            'the key came with another command',
          );
        }
        return this.list(cityId, tx);
      }
      await lockBanners(tx, cityId);
      const before = await this.list(cityId, tx);
      if (before.filter((each) => each.endsAt > now).length >= BANNERS_MAX) {
        throw new BannerRefusedError('invalid_banner', `at most ${BANNERS_MAX} banners running`);
      }
      const { key, alreadyLinked } = await this.files.link(tx, uploadId, now);
      if (alreadyLinked) {
        throw new BannerRefusedError('upload_used', 'the upload is linked elsewhere');
      }
      const [row] = await tx
        .insert(banners)
        .values({
          cityId,
          ...checked,
          imageKey: key,
          position: before.length + 1,
          createdBy: change.accountId,
          updatedBy: change.accountId,
        })
        .returning({ id: banners.id });
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
      await this.record(tx, change, cityId, 'banner.create', row!.id, null, {
        ...auditOf(checked),
        imageKey: key,
      });
      return this.list(cityId, tx);
    });
  }

  // The panel: every field of a banner, and its image when `uploadId` is
  // given (null keeps it). It sets values, so it takes no key: the same
  // upload again on the same banner changes nothing. 404 unknown_banner.
  async update(
    cityId: string,
    id: string,
    fields: BannerFields,
    uploadId: string | null,
    change: PromoChange,
    now = new Date(),
  ): Promise<Banner[]> {
    const checked = await this.checkFields(cityId, fields, now);
    if (uploadId !== null) await this.files.prepare(uploadId, 'banner_image', now);
    return this.database.db.transaction(async (tx) => {
      await lockBanners(tx, cityId);
      const before = await this.find(tx, cityId, id);
      let imageKey = before.imageKey;
      if (uploadId !== null) {
        const linked = await this.files.link(tx, uploadId, now);
        if (linked.alreadyLinked && linked.key !== before.imageKey) {
          throw new BannerRefusedError('upload_used', 'the upload is linked elsewhere');
        }
        imageKey = linked.key;
      }
      await tx
        .update(banners)
        .set({ ...checked, imageKey, updatedBy: change.accountId, updatedAt: now })
        .where(eq(banners.id, id));
      await this.record(
        tx,
        change,
        cityId,
        'banner.update',
        id,
        { ...auditOf(before), imageKey: before.imageKey },
        { ...auditOf(checked), imageKey },
      );
      return this.list(cityId, tx);
    });
  }

  // The panel: every banner once, in the new order. 409 banners_changed when
  // the ids are not the city's banners; the same order writes nothing.
  async reorder(cityId: string, ids: string[], change: PromoChange): Promise<Banner[]> {
    await this.checkCity(cityId);
    return this.database.db.transaction(async (tx) => {
      await lockBanners(tx, cityId);
      const before = await this.list(cityId, tx);
      const known = before.map((banner) => banner.id);
      if (ids.length !== known.length || [...ids].sort().join() !== [...known].sort().join()) {
        throw new BannerRefusedError('banners_changed', 'the order names every banner once');
      }
      if (ids.join() === known.join()) return before;
      for (const [index, id] of ids.entries()) {
        await tx
          .update(banners)
          .set({ position: index + 1 })
          .where(eq(banners.id, id));
      }
      await this.record(tx, change, cityId, 'banner.reorder', 'order', { ids: known }, { ids });
      return this.list(cityId, tx);
    });
  }

  // The panel: a banner off the strip for good (kept with its removal). A
  // repeat is 404 unknown_banner.
  async remove(
    cityId: string,
    id: string,
    change: PromoChange,
    now = new Date(),
  ): Promise<Banner[]> {
    return this.database.db.transaction(async (tx) => {
      await lockBanners(tx, cityId);
      const before = await this.find(tx, cityId, id);
      await tx
        .update(banners)
        .set({ removedAt: now, updatedBy: change.accountId, updatedAt: now })
        .where(eq(banners.id, id));
      await this.record(
        tx,
        change,
        cityId,
        'banner.remove',
        id,
        { ...auditOf(before), imageKey: before.imageKey },
        null,
      );
      return this.list(cityId, tx);
    });
  }

  // 404 unknown_city.
  async checkCity(cityId: string): Promise<void> {
    if ((await this.geo.cityTimeZone(cityId)) === null) {
      throw new BannerRefusedError('unknown_city', 'no such city');
    }
  }

  private async find(tx: Tx, cityId: string, id: string): Promise<Banner> {
    const found = (await this.list(cityId, tx)).find((banner) => banner.id === id);
    if (found === undefined) throw new BannerRefusedError('unknown_banner', 'no such banner');
    return found;
  }

  // The title trimmed, 1 to 60 characters; a target of the city (a
  // restaurant, 1 to 30 restaurants each once, an active category, or a
  // visible code that has not ended); zones of the city, each once; the
  // start before the end and the end after now.
  private async checkFields(
    cityId: string,
    fields: BannerFields,
    now: Date,
  ): Promise<BannerFields> {
    await this.checkCity(cityId);
    const invalid = (message: string) => new BannerRefusedError('invalid_banner', message);
    const title = fields.title.trim();
    if (title.length === 0 || [...title].length > BANNER_TITLE_MAX) {
      throw invalid(`the title is 1 to ${BANNER_TITLE_MAX} characters`);
    }
    if (fields.startsAt.getTime() >= fields.endsAt.getTime()) {
      throw invalid('the start is before the end');
    }
    if (fields.endsAt.getTime() <= now.getTime()) throw invalid('the end is after now');
    const zoneIds = fields.zoneIds;
    if (new Set(zoneIds).size !== zoneIds.length) throw invalid('a zone is named twice');
    if (zoneIds.length > 0) {
      const city = new Set((await this.geo.zones(cityId)).map((zone) => zone.id));
      if (zoneIds.some((id) => !city.has(id))) throw invalid('a zone is not one of the city');
    }
    const target = { restaurantIds: [] as string[], categoryId: null, codeId: null } as const;
    switch (fields.target) {
      case 'restaurant':
      case 'restaurants': {
        const ids = fields.restaurantIds;
        const most = fields.target === 'restaurant' ? 1 : BANNER_RESTAURANTS_MAX;
        if (ids.length === 0 || ids.length > most || new Set(ids).size !== ids.length) {
          throw invalid(`1 to ${most} restaurants, each once`);
        }
        const city = new Set((await this.merchants.restaurantIds(cityId)).map((each) => each.id));
        if (ids.some((id) => !city.has(id))) throw invalid('a restaurant is not one of the city');
        return { ...fields, title, zoneIds, ...target, restaurantIds: ids };
      }
      case 'category': {
        const id = fields.categoryId;
        if (id === null) throw invalid('the category target names a category');
        const active = await this.categories.active();
        if (!active.some((category) => category.id === id)) {
          throw invalid('the category is not an active one');
        }
        return { ...fields, title, zoneIds, ...target, categoryId: id };
      }
      case 'code': {
        const id = fields.codeId;
        if (id === null) throw invalid('the code target names a code');
        const [code] = await this.database.db
          .select({ id: promoCodes.id })
          .from(promoCodes)
          .where(
            and(
              eq(promoCodes.id, id),
              eq(promoCodes.cityId, cityId),
              eq(promoCodes.visibility, 'visible'),
              gt(promoCodes.validTo, now),
            ),
          );
        if (code === undefined) throw invalid('the code is not a visible code of the city');
        return { ...fields, title, zoneIds, ...target, codeId: id };
      }
    }
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
        target: { type: 'banner', id },
        before: before as Record<string, unknown> | null,
        after: after as Record<string, unknown> | null,
        reason: null,
      },
      tx,
    );
  }
}

// Edits of a city's banners take turns, so the positions stay consistent.
async function lockBanners(tx: Tx, cityId: string): Promise<void> {
  await tx.execute(
    sql`SELECT pg_advisory_xact_lock(hashtextextended(${`marketing.banners:${cityId}`}, 0))`,
  );
}

function bannerOf(row: typeof banners.$inferSelect, code: string | null): Banner {
  return {
    id: row.id,
    title: row.title,
    imageKey: row.imageKey,
    target: row.target,
    restaurantIds: row.restaurantIds,
    categoryId: row.categoryId,
    codeId: row.codeId,
    code: row.target === 'code' ? code : null,
    zoneIds: row.zoneIds,
    startsAt: row.startsAt,
    endsAt: row.endsAt,
  };
}

// What the audit log keeps of a banner's fields (dates as ISO text).
function auditOf(fields: BannerFields): Record<string, unknown> {
  return {
    title: fields.title,
    target: fields.target,
    restaurantIds: fields.restaurantIds,
    categoryId: fields.categoryId,
    codeId: fields.codeId,
    zoneIds: fields.zoneIds,
    startsAt: fields.startsAt.toISOString(),
    endsAt: fields.endsAt.toISOString(),
  };
}
