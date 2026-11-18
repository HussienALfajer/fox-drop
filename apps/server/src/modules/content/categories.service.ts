import { Inject, Injectable } from '@nestjs/common';
import { and, asc, eq, inArray, ne, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { AuditService } from '../audit/index.js';
import { FilesService } from '../files/index.js';
import { ContentRefusedError, type ContentEdit } from './content.service.js';
import { categories } from './schema.js';

// AP §9.13 «التصنيفات»: a name of 1 to 40 characters (the table's CHECK).
export const CATEGORY_NAME_MAX = 40;
// Every category, active or not, at most: the panel's list and its order.
export const CATEGORIES_MAX = 200;

export interface Category {
  id: string;
  name: string;
  // Its key in public-media (architecture §5.8); null without an image.
  imageKey: string | null;
  // False once removed: off the cards and the category list, kept on the
  // restaurants that link to it.
  active: boolean;
}

// An admin's edit, or the placeholder seed's (development and staging only).
export type CategoryEditor = ContentEdit | 'system';

type Executor = Pick<Database['db'], 'select' | 'insert' | 'update' | 'execute'>;

// AP §9.13 «التصنيفات» (slice 2.27a): the platform's restaurant categories,
// edited in the panel (OWN and DATA, content.categories; every edit audited
// as content.category.*) and read by the customer's cards, the category list
// and the merchants module, which links a restaurant to them.
@Injectable()
export class CategoriesService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly audit: AuditService,
    private readonly files: FilesService,
  ) {}

  // Every category in its order, removed ones included, for the panel.
  async all(): Promise<Category[]> {
    const rows = await this.database.db
      .select()
      .from(categories)
      .orderBy(asc(categories.position), asc(categories.id));
    return rows.map(categoryOf);
  }

  // The active categories in their order: the customer's list (CU §8.1).
  async active(): Promise<Category[]> {
    return (await this.all()).filter((category) => category.active);
  }

  // The panel: a new category at the end of the list.
  async create(name: string, edit: CategoryEditor): Promise<Category> {
    const checked = checkName(name);
    return this.database.db.transaction(async (tx) => {
      await lockCategories(tx);
      await checkUniqueName(tx, checked, null);
      const [{ next }] = (
        await tx.execute<{ next: number }>(
          sql`SELECT coalesce(max(position), 0) + 1 AS next FROM content.categories`,
        )
      ).rows as [{ next: number }];
      if (Number(next) > CATEGORIES_MAX) {
        throw new ContentRefusedError('invalid_value', `at most ${CATEGORIES_MAX} categories`);
      }
      const [row] = await tx
        .insert(categories)
        .values({ name: checked, position: Number(next) })
        .returning();
      const created = categoryOf(row!);
      await this.record(tx, edit, 'content.category.create', created.id, null, created);
      return created;
    });
  }

  // The panel: a category's name, and whether it is offered (false removes
  // it; true brings it back, its name still unique among the active ones).
  async update(
    id: string,
    fields: { name: string; active: boolean },
    edit: ContentEdit,
  ): Promise<Category> {
    const name = checkName(fields.name);
    return this.database.db.transaction(async (tx) => {
      await lockCategories(tx);
      const before = await this.find(tx, id);
      if (fields.active) await checkUniqueName(tx, name, id);
      const [row] = await tx
        .update(categories)
        .set({ name, active: fields.active, updatedAt: sql`now()` })
        .where(eq(categories.id, id))
        .returning();
      const after = categoryOf(row!);
      await this.record(tx, edit, 'content.category.update', id, before, after);
      return after;
    });
  }

  // The panel: its icon or image from an upload (architecture §5.8), checked
  // before the transaction and linked in it, as a restaurant's logo is. The
  // same upload again changes nothing; another record's is upload_used.
  async setImage(id: string, uploadId: string, edit: ContentEdit): Promise<Category> {
    await this.files.prepare(uploadId, 'category_image');
    return this.database.db.transaction(async (tx) => {
      await lockCategories(tx);
      const before = await this.find(tx, id);
      const { key, alreadyLinked } = await this.files.link(tx, uploadId);
      if (alreadyLinked) {
        if (before.imageKey === key) return before;
        throw new ContentRefusedError('upload_used', 'the upload is linked elsewhere');
      }
      const [row] = await tx
        .update(categories)
        .set({ imageKey: key, updatedAt: sql`now()` })
        .where(eq(categories.id, id))
        .returning();
      const after = categoryOf(row!);
      await this.record(tx, edit, 'content.category.image', id, before, after);
      return after;
    });
  }

  // The panel: the list's order, every category once, removed ones included.
  async reorder(ids: string[], edit: ContentEdit): Promise<Category[]> {
    return this.database.db.transaction(async (tx) => {
      await lockCategories(tx);
      const rows = await tx
        .select({ id: categories.id })
        .from(categories)
        .orderBy(asc(categories.position), asc(categories.id));
      const known = rows.map((row) => row.id);
      if (ids.length !== known.length || [...ids].sort().join() !== [...known].sort().join()) {
        throw new ContentRefusedError('invalid_order', 'the order names every category once');
      }
      for (const [index, id] of ids.entries()) {
        await tx
          .update(categories)
          .set({ position: index + 1, updatedAt: sql`now()` })
          .where(eq(categories.id, id));
      }
      await this.record(
        tx,
        edit,
        'content.category.reorder',
        'categories',
        { ids: known },
        { ids },
      );
      const after = await tx
        .select()
        .from(categories)
        .orderBy(asc(categories.position), asc(categories.id));
      return after.map(categoryOf);
    });
  }

  // The merchants module, before linking a restaurant to them: each id an
  // active category, once (unknown_category otherwise).
  async checkActive(ids: string[]): Promise<void> {
    if (new Set(ids).size !== ids.length) {
      throw new ContentRefusedError('unknown_category', 'a category is named twice');
    }
    if (ids.length === 0) return;
    const rows = await this.database.db
      .select({ id: categories.id })
      .from(categories)
      .where(and(inArray(categories.id, ids), eq(categories.active, true)));
    if (rows.length !== ids.length) {
      throw new ContentRefusedError('unknown_category', 'not an active category');
    }
  }

  private async find(tx: Executor, id: string): Promise<Category> {
    const [row] = await tx.select().from(categories).where(eq(categories.id, id));
    if (!row) throw new ContentRefusedError('unknown_category', 'no such category');
    return categoryOf(row);
  }

  private record(
    tx: Executor,
    edit: CategoryEditor,
    action: string,
    id: string,
    before: object | null,
    after: object | null,
  ): Promise<void> {
    return this.audit.recordWrite(
      {
        actor:
          edit === 'system'
            ? { type: 'system', id: null, role: null }
            : { type: 'admin', id: edit.admin.accountId, role: edit.admin.roles.join(',') },
        context: edit === 'system' ? { ipAddress: null, device: null } : edit.context,
        cityId: null,
        action,
        target: { type: 'content', id: `category:${id}` },
        before: before as Record<string, unknown> | null,
        after: after as Record<string, unknown> | null,
        reason: null,
      },
      tx,
    );
  }
}

function checkName(name: string): string {
  const trimmed = name.trim();
  if (trimmed.length === 0 || [...trimmed].length > CATEGORY_NAME_MAX) {
    throw new ContentRefusedError(
      'invalid_value',
      `the name is 1 to ${CATEGORY_NAME_MAX} characters`,
    );
  }
  return trimmed;
}

async function checkUniqueName(tx: Executor, name: string, except: string | null): Promise<void> {
  const [row] = await tx
    .select({ id: categories.id })
    .from(categories)
    .where(
      and(
        eq(categories.name, name),
        eq(categories.active, true),
        except === null ? undefined : ne(categories.id, except),
      ),
    );
  if (row) throw new ContentRefusedError('duplicate_label', `${name} is already a category`);
}

// Edits of the categories take turns, so positions and names stay consistent.
async function lockCategories(tx: Pick<Database['db'], 'execute'>): Promise<void> {
  await tx.execute(sql`SELECT pg_advisory_xact_lock(hashtextextended('content:categories', 0))`);
}

function categoryOf(row: typeof categories.$inferSelect): Category {
  return { id: row.id, name: row.name, imageKey: row.imageKey, active: row.active };
}
