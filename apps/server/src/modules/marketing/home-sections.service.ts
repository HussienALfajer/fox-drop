import { Inject, Injectable } from '@nestjs/common';
import { and, asc, eq, gt, isNull, lte, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { AuditService } from '../audit/index.js';
import { FxService } from '../fx/index.js';
import { GeoService } from '../geo/index.js';
import { MerchantsService } from '../merchants/index.js';
import type { PromoChange } from './promo-codes.service.js';
import { type HomeSectionKind, homeSections, promoCodes } from './schema.js';

// AP §9.11.3, CU §8.1: the built-in sections in the home's default order.
export const BUILT_IN_SECTIONS = [
  'banners',
  'categories',
  'nearest',
  'most_ordered',
  'new',
  'offers',
] as const satisfies readonly HomeSectionKind[];
export type BuiltInSection = (typeof BUILT_IN_SECTIONS)[number];

// A custom section's title, 1 to 40 characters (the table's CHECK).
export const SECTION_TITLE_MAX = 40;
// Technical bounds on the panel's list and the home, not business rules
// (decided by us): the custom sections of a city not removed, and the
// restaurants one section names.
export const CUSTOM_SECTIONS_MAX = 20;
export const SECTION_RESTAURANTS_MAX = 30;

export interface HomeSection {
  // A built-in section's kind, or a custom section's id.
  key: string;
  kind: HomeSectionKind;
  // A custom section's; null for a built-in one.
  title: string | null;
  // A custom section's hand-picked restaurants, in the admin's order.
  restaurantIds: string[];
  visible: boolean;
}

export type HomeSectionRefusal =
  'unknown_city' | 'unknown_section' | 'invalid_section' | 'sections_changed';

export class HomeSectionRefusedError extends Error {
  constructor(
    readonly refusal: HomeSectionRefusal,
    message: string,
  ) {
    super(message);
  }
}

type Tx = Parameters<Parameters<Database['db']['transaction']>[0]>[0];
type Executor = Database['db'] | Tx;

// AP §9.11.3 «أقسام الرئيسية» (slice 2.27b): the order of the customer
// home's sections and which show, per city, and the custom sections. OWN
// edits (marketing.manage), each edit under the city's advisory lock and
// audited home_section.*; the customer's home reads the shown ones.
@Injectable()
export class HomeSectionsService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly audit: AuditService,
    private readonly geo: GeoService,
    private readonly merchants: MerchantsService,
    private readonly fx: FxService,
  ) {}

  // CU §8.1 «العروض» (owner decision 2026-11-18): the restaurants named by a
  // visible code running now (active, started, not ended, saved in the
  // city's base: «أكوادي»'s `runsNow`) that is limited to restaurants and
  // works in the zone. Neither its hours, its limits nor its day's budget
  // are read (decided by us: a code still on offer today).
  async offerRestaurants(cityId: string, zoneId: string, now: Date): Promise<Set<string>> {
    const base = await this.fx.baseCurrency(cityId);
    if (base === null) return new Set();
    const rows = await this.database.db
      .select({ restaurantIds: promoCodes.restaurantIds })
      .from(promoCodes)
      .where(
        and(
          eq(promoCodes.cityId, cityId),
          eq(promoCodes.visibility, 'visible'),
          eq(promoCodes.status, 'active'),
          eq(promoCodes.currency, base),
          lte(promoCodes.validFrom, now),
          gt(promoCodes.validTo, now),
          sql`cardinality(${promoCodes.restaurantIds}) > 0`,
          sql`(cardinality(${promoCodes.zoneIds}) = 0 OR ${zoneId}::uuid = ANY(${promoCodes.zoneIds}))`,
        ),
      );
    return new Set(rows.flatMap((row) => row.restaurantIds));
  }

  // Every section of the city in its order, hidden ones included: the
  // stored ones, then the built-in ones never stored, in the default order.
  async sections(cityId: string, executor: Executor = this.database.db): Promise<HomeSection[]> {
    const rows = await executor
      .select()
      .from(homeSections)
      .where(and(eq(homeSections.cityId, cityId), isNull(homeSections.removedAt)))
      .orderBy(asc(homeSections.position), asc(homeSections.id));
    const stored = rows.map(sectionOf);
    const missing = BUILT_IN_SECTIONS.filter((kind) => !stored.some((each) => each.key === kind));
    return [
      ...stored,
      ...missing.map((kind) => ({
        key: kind,
        kind,
        title: null,
        restaurantIds: [],
        visible: true,
      })),
    ];
  }

  // The panel: every section once, in the new order. 409 sections_changed
  // when the keys are not the city's sections (one added or removed since
  // the panel read them); the same order again writes nothing.
  async reorder(cityId: string, keys: string[], change: PromoChange): Promise<HomeSection[]> {
    await this.checkCity(cityId);
    return this.database.db.transaction(async (tx) => {
      await lockSections(tx, cityId);
      const before = await this.sections(cityId, tx);
      const known = before.map((section) => section.key);
      if (keys.length !== known.length || [...keys].sort().join() !== [...known].sort().join()) {
        throw new HomeSectionRefusedError(
          'sections_changed',
          'the order names every section of the city once',
        );
      }
      if (keys.join() === known.join()) return before;
      const byKey = new Map(before.map((section) => [section.key, section]));
      await this.store(
        tx,
        cityId,
        keys.map((key) => byKey.get(key)!),
      );
      await this.record(
        tx,
        change,
        cityId,
        'home_section.reorder',
        'order',
        { keys: known },
        { keys },
      );
      return this.sections(cityId, tx);
    });
  }

  // The panel: show or hide one section. 404 unknown_section.
  async setVisible(
    cityId: string,
    key: string,
    visible: boolean,
    change: PromoChange,
  ): Promise<HomeSection[]> {
    await this.checkCity(cityId);
    return this.database.db.transaction(async (tx) => {
      await lockSections(tx, cityId);
      const before = await this.sections(cityId, tx);
      const section = before.find((each) => each.key === key);
      if (section === undefined) {
        throw new HomeSectionRefusedError('unknown_section', 'no such section in the city');
      }
      if (section.visible === visible) return before;
      await this.store(
        tx,
        cityId,
        before.map((each) => (each.key === key ? { ...each, visible } : each)),
      );
      await this.record(
        tx,
        change,
        cityId,
        'home_section.visibility',
        key,
        { visible: section.visible },
        { visible },
      );
      return this.sections(cityId, tx);
    });
  }

  // The panel: a custom section at the end of the home, shown.
  async create(
    cityId: string,
    fields: { title: string; restaurantIds: string[] },
    change: PromoChange,
  ): Promise<HomeSection[]> {
    const checked = await this.checkFields(cityId, fields);
    return this.database.db.transaction(async (tx) => {
      await lockSections(tx, cityId);
      const before = await this.sections(cityId, tx);
      if (before.filter((each) => each.kind === 'custom').length >= CUSTOM_SECTIONS_MAX) {
        throw new HomeSectionRefusedError(
          'invalid_section',
          `at most ${CUSTOM_SECTIONS_MAX} custom sections`,
        );
      }
      await this.store(tx, cityId, before);
      const [row] = await tx
        .insert(homeSections)
        .values({
          cityId,
          kind: 'custom',
          title: checked.title,
          restaurantIds: checked.restaurantIds,
          position: before.length + 1,
        })
        .returning();
      await this.record(tx, change, cityId, 'home_section.create', row!.id, null, checked);
      return this.sections(cityId, tx);
    });
  }

  // The panel: a custom section's title and restaurants. 404 unknown_section.
  async update(
    cityId: string,
    id: string,
    fields: { title: string; restaurantIds: string[] },
    change: PromoChange,
  ): Promise<HomeSection[]> {
    const checked = await this.checkFields(cityId, fields);
    return this.database.db.transaction(async (tx) => {
      await lockSections(tx, cityId);
      const before = await this.custom(tx, cityId, id);
      await tx
        .update(homeSections)
        .set({ title: checked.title, restaurantIds: checked.restaurantIds, updatedAt: sql`now()` })
        .where(eq(homeSections.id, id));
      await this.record(
        tx,
        change,
        cityId,
        'home_section.update',
        id,
        { title: before.title, restaurantIds: before.restaurantIds },
        checked,
      );
      return this.sections(cityId, tx);
    });
  }

  // The panel: a custom section off the home for good (kept with its
  // removal). A built-in section is only hidden. 404 unknown_section.
  async remove(cityId: string, id: string, change: PromoChange): Promise<HomeSection[]> {
    return this.database.db.transaction(async (tx) => {
      await lockSections(tx, cityId);
      const before = await this.custom(tx, cityId, id);
      await tx
        .update(homeSections)
        .set({ removedAt: sql`now()`, updatedAt: sql`now()` })
        .where(eq(homeSections.id, id));
      await this.record(
        tx,
        change,
        cityId,
        'home_section.remove',
        id,
        { title: before.title, restaurantIds: before.restaurantIds },
        null,
      );
      return this.sections(cityId, tx);
    });
  }

  // Writes the sections in this order: the built-in ones not stored yet get
  // their row, and every position follows the list.
  private async store(tx: Tx, cityId: string, sections: HomeSection[]): Promise<void> {
    for (const [index, section] of sections.entries()) {
      const position = index + 1;
      if (section.kind === 'custom') {
        await tx
          .update(homeSections)
          .set({ position, visible: section.visible, updatedAt: sql`now()` })
          .where(eq(homeSections.id, section.key));
        continue;
      }
      await tx
        .insert(homeSections)
        .values({ cityId, kind: section.kind, position, visible: section.visible })
        .onConflictDoUpdate({
          target: [homeSections.cityId, homeSections.kind],
          targetWhere: sql`${homeSections.kind} <> 'custom'`,
          set: { position, visible: section.visible, updatedAt: sql`now()` },
        });
    }
  }

  private async custom(tx: Tx, cityId: string, id: string): Promise<HomeSection> {
    const [row] = await tx
      .select()
      .from(homeSections)
      .where(
        and(
          eq(homeSections.id, id),
          eq(homeSections.cityId, cityId),
          eq(homeSections.kind, 'custom'),
          isNull(homeSections.removedAt),
        ),
      );
    if (!row) throw new HomeSectionRefusedError('unknown_section', 'no such custom section');
    return sectionOf(row);
  }

  // 404 unknown_city.
  async checkCity(cityId: string): Promise<void> {
    if ((await this.geo.cityTimeZone(cityId)) === null) {
      throw new HomeSectionRefusedError('unknown_city', 'no such city');
    }
  }

  // The title trimmed, 1 to 40 characters; one to SECTION_RESTAURANTS_MAX
  // restaurants of the city, each once.
  private async checkFields(
    cityId: string,
    fields: { title: string; restaurantIds: string[] },
  ): Promise<{ title: string; restaurantIds: string[] }> {
    await this.checkCity(cityId);
    const title = fields.title.trim();
    if (title.length === 0 || [...title].length > SECTION_TITLE_MAX) {
      throw new HomeSectionRefusedError(
        'invalid_section',
        `the title is 1 to ${SECTION_TITLE_MAX} characters`,
      );
    }
    const ids = fields.restaurantIds;
    if (
      ids.length === 0 ||
      ids.length > SECTION_RESTAURANTS_MAX ||
      new Set(ids).size !== ids.length
    ) {
      throw new HomeSectionRefusedError(
        'invalid_section',
        `1 to ${SECTION_RESTAURANTS_MAX} restaurants, each once`,
      );
    }
    const city = new Set((await this.merchants.restaurantIds(cityId)).map((each) => each.id));
    if (ids.some((id) => !city.has(id))) {
      throw new HomeSectionRefusedError('invalid_section', 'a restaurant is not one of the city');
    }
    return { title, restaurantIds: ids };
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
        target: { type: 'home_section', id },
        before: before as Record<string, unknown> | null,
        after: after as Record<string, unknown> | null,
        reason: null,
      },
      tx,
    );
  }
}

// Edits of a city's sections take turns, so the positions stay consistent.
async function lockSections(tx: Tx, cityId: string): Promise<void> {
  await tx.execute(
    sql`SELECT pg_advisory_xact_lock(hashtextextended(${`marketing.home_sections:${cityId}`}, 0))`,
  );
}

function sectionOf(row: typeof homeSections.$inferSelect): HomeSection {
  return {
    key: row.kind === 'custom' ? row.id : row.kind,
    kind: row.kind,
    title: row.title,
    restaurantIds: row.restaurantIds,
    visible: row.visible,
  };
}
