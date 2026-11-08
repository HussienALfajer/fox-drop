import { randomBytes } from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { and, asc, eq, sql } from 'drizzle-orm';
import { z } from 'zod';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { AuditService, type AuditRequestContext } from '../audit/index.js';
import {
  ANSWER_MAX,
  type ContentApp,
  CUSTOMER_TEXT_MAX,
  FAQ_MAX_ITEMS,
  type FaqAudience,
  GENERIC_CUSTOMER_TEXT,
  isReasonList,
  LABEL_MAX,
  listDefinition,
  type NoteMode,
  NOTE_MAX,
  QUESTION_MAX,
  type ReasonList,
  reasonListNames,
  WORK_RULES_MAX,
} from './lists.js';
import { reasons, texts } from './schema.js';

export interface Reason {
  code: string;
  label: string;
  customerText: string | null;
  note: NoteMode;
  fixed: boolean;
  active: boolean;
}

// A reason as an app offers it: the active ones, in their order.
export interface ReasonChoice {
  code: string;
  label: string;
  note: NoteMode;
}

// What an order keeps of a choice (owner decision 2026-11-07): the code, the
// label as chosen, and the text of «أخرى».
export interface ChosenReason {
  code: string;
  label: string;
  note: string | null;
}

export interface FaqItem {
  question: string;
  answer: string;
}

export interface Contact {
  phone?: string;
  whatsapp?: string;
}

export type ContentRefusal =
  // The code is not an active reason of the list.
  | 'unknown_reason'
  // «أخرى» needs its text; another reason takes none.
  | 'reason_note_required'
  | 'reason_note_not_allowed'
  // The panel's edits.
  | 'unknown_list'
  | 'list_closed'
  | 'reason_fixed'
  | 'customer_text_not_allowed'
  | 'duplicate_label'
  | 'invalid_order'
  | 'invalid_value'
  // «نصوص الإشعارات»: no such template, or a placeholder it does not take.
  | 'unknown_template'
  | 'unknown_variable'
  // «الشروط والخصوصية»: a newer version was published, or the text is the
  // one in force.
  | 'terms_outdated'
  | 'terms_unchanged';

export class ContentRefusedError extends Error {
  override readonly name = 'ContentRefusedError';
  constructor(
    readonly refusal: ContentRefusal,
    message: string,
  ) {
    super(message);
  }
}

// An admin's edit, for the audit log.
export interface ContentEdit {
  admin: { accountId: string; roles: string[] };
  context: AuditRequestContext;
}

export interface ReasonFields {
  label: string;
  customerText: string | null;
  note: NoteMode;
}

const E164 = /^\+[1-9]\d{7,14}$/;

const faqSchema = z
  .array(
    z.object({
      question: z.string().trim().min(1).max(QUESTION_MAX),
      answer: z.string().trim().min(1).max(ANSWER_MAX),
    }),
  )
  .max(FAQ_MAX_ITEMS);

const workRulesSchema = z.object({ body: z.string().max(WORK_RULES_MAX) });

const contactSchema = z.object({
  phone: z.string().regex(E164).nullable(),
  whatsapp: z.string().regex(E164).nullable(),
});

type Executor = Pick<Database['db'], 'select' | 'insert' | 'update' | 'execute'>;

// The content of AP §9.13: the reason lists, the FAQs, the captain work rules
// and the contact info, edited in the panel (every edit audited) and read by
// the apps and by the modules that record a reason.
@Injectable()
export class ContentService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly audit: AuditService,
  ) {}

  // Every list with all its reasons, inactive ones included, for the panel.
  async allLists(): Promise<{ list: ReasonList; reasons: Reason[] }[]> {
    const rows = await this.database.db
      .select()
      .from(reasons)
      .orderBy(asc(reasons.list), asc(reasons.position));
    return reasonListNames.map((list) => ({
      list,
      reasons: rows.filter((row) => row.list === list).map(reasonOf),
    }));
  }

  // The lists an app reads, each with its active reasons in order.
  async listsFor(app: ContentApp): Promise<Record<string, ReasonChoice[]>> {
    const names = reasonListNames.filter((list) =>
      (listDefinition(list).apps as readonly string[]).includes(app),
    );
    const rows = await this.database.db
      .select()
      .from(reasons)
      .where(eq(reasons.active, true))
      .orderBy(asc(reasons.position));
    return Object.fromEntries(
      names.map((list) => [
        list,
        rows
          .filter((row) => row.list === list)
          .map((row) => ({ code: row.code, label: row.label, note: row.note })),
      ]),
    );
  }

  // A reason chosen in an app or the panel, checked against its list: an
  // active reason, with a note when it requires one (AP Appendix B «أخرى»
  // with its text), and none when it takes none. Answers what the order keeps.
  async choose(
    list: ReasonList,
    given: { code: string; note: string | null },
    executor: Pick<Database['db'], 'select'> = this.database.db,
  ): Promise<ChosenReason> {
    const [row] = await executor
      .select()
      .from(reasons)
      .where(and(eq(reasons.list, list), eq(reasons.code, given.code), eq(reasons.active, true)));
    if (!row) {
      throw new ContentRefusedError('unknown_reason', `${given.code} is not a reason of ${list}`);
    }
    const note = given.note?.trim() || null;
    if (row.note === 'required' && note === null) {
      throw new ContentRefusedError('reason_note_required', `${given.code} needs its text`);
    }
    if (row.note === 'none' && note !== null) {
      throw new ContentRefusedError('reason_note_not_allowed', `${given.code} takes no text`);
    }
    if (note !== null && note.length > NOTE_MAX) {
      throw new ContentRefusedError('invalid_value', `the text is longer than ${NOTE_MAX}`);
    }
    return { code: row.code, label: row.label, note };
  }

  // «نصوص الأسباب للزبون»: the text the customer sees for a reason, active or
  // not; a reason without one shows the generic apology (CU Appendix C).
  async customerText(
    list: ReasonList,
    code: string,
    executor: Pick<Database['db'], 'select'> = this.database.db,
  ): Promise<string> {
    const [row] = await executor
      .select({ customerText: reasons.customerText })
      .from(reasons)
      .where(and(eq(reasons.list, list), eq(reasons.code, code)));
    return row?.customerText ?? GENERIC_CUSTOMER_TEXT;
  }

  // The panel: a new reason at the end of its list, with a new code.
  async addReason(list: string, fields: ReasonFields, edit: ContentEdit): Promise<Reason> {
    const name = this.knownList(list);
    if (listDefinition(name).closed) {
      throw new ContentRefusedError('list_closed', `${name} takes no new reason`);
    }
    const checked = this.checkFields(name, fields);
    return this.database.db.transaction(async (tx) => {
      await lockList(tx, name);
      await this.checkUniqueLabel(tx, name, checked.label, null);
      const [{ next }] = (
        await tx.execute<{ next: number }>(
          sql`SELECT coalesce(max(position), 0) + 1 AS next FROM content.reasons WHERE list = ${name}`,
        )
      ).rows as [{ next: number }];
      const code = `custom_${randomBytes(4).toString('hex')}`;
      const [row] = await tx
        .insert(reasons)
        .values({ list: name, code, ...checked, position: Number(next) })
        .returning();
      const created = reasonOf(row!);
      await this.recordEdit(tx, edit, 'content.reason.create', `${name}:${code}`, null, created);
      return created;
    });
  }

  // The panel: a reason's label, customer text, «أخرى» text and whether it
  // is offered. A fixed reason stays active.
  async updateReason(
    list: string,
    code: string,
    fields: ReasonFields & { active: boolean },
    edit: ContentEdit,
  ): Promise<Reason> {
    const name = this.knownList(list);
    const checked = this.checkFields(name, fields);
    return this.database.db.transaction(async (tx) => {
      await lockList(tx, name);
      const [before] = await tx
        .select()
        .from(reasons)
        .where(and(eq(reasons.list, name), eq(reasons.code, code)));
      if (!before) throw new ContentRefusedError('unknown_reason', `${code} is not in ${name}`);
      if (before.fixed && !fields.active) {
        throw new ContentRefusedError('reason_fixed', `${code} cannot be removed`);
      }
      if (fields.active) await this.checkUniqueLabel(tx, name, checked.label, code);
      const [row] = await tx
        .update(reasons)
        .set({ ...checked, active: fields.active, updatedAt: sql`now()` })
        .where(eq(reasons.id, before.id))
        .returning();
      const after = reasonOf(row!);
      await this.recordEdit(
        tx,
        edit,
        'content.reason.update',
        `${name}:${code}`,
        reasonOf(before),
        after,
      );
      return after;
    });
  }

  // The panel: the list's order, every code of the list once.
  async reorder(list: string, codes: string[], edit: ContentEdit): Promise<Reason[]> {
    const name = this.knownList(list);
    return this.database.db.transaction(async (tx) => {
      await lockList(tx, name);
      const rows = await tx
        .select()
        .from(reasons)
        .where(eq(reasons.list, name))
        .orderBy(asc(reasons.position));
      const known = rows.map((row) => row.code);
      if (codes.length !== known.length || [...codes].sort().join() !== [...known].sort().join()) {
        throw new ContentRefusedError(
          'invalid_order',
          'the order names every code of the list once',
        );
      }
      for (const [index, code] of codes.entries()) {
        await tx
          .update(reasons)
          .set({ position: index + 1, updatedAt: sql`now()` })
          .where(and(eq(reasons.list, name), eq(reasons.code, code)));
      }
      await this.recordEdit(
        tx,
        edit,
        'content.reason.reorder',
        name,
        { order: known },
        { order: codes },
      );
      const byCode = new Map(rows.map((row) => [row.code, row]));
      return codes.map((code, index) => reasonOf({ ...byCode.get(code)!, position: index + 1 }));
    });
  }

  async faq(audience: FaqAudience): Promise<FaqItem[]> {
    const value = await this.text(`faq.${audience}`);
    const parsed = faqSchema.safeParse(value);
    return parsed.success ? parsed.data : [];
  }

  async updateFaq(audience: FaqAudience, items: FaqItem[], edit: ContentEdit): Promise<FaqItem[]> {
    const parsed = faqSchema.safeParse(items);
    if (!parsed.success) throw new ContentRefusedError('invalid_value', parsed.error.message);
    await this.writeText(`faq.${audience}`, parsed.data, edit);
    return parsed.data;
  }

  // CA §11.4: the work rules page; empty until written.
  async workRules(): Promise<string> {
    const parsed = workRulesSchema.safeParse(await this.text('captain_work_rules'));
    return parsed.success ? parsed.data.body : '';
  }

  async updateWorkRules(body: string, edit: ContentEdit): Promise<string> {
    const parsed = workRulesSchema.safeParse({ body });
    if (!parsed.success) throw new ContentRefusedError('invalid_value', parsed.error.message);
    await this.writeText('captain_work_rules', parsed.data, edit);
    return parsed.data.body;
  }

  // AP §9.13 «Contact info»: the numbers stored in the panel; until they are,
  // SUPPORT_PHONE_NUMBER and SUPPORT_WHATSAPP_NUMBER (owner decision
  // 2026-11-07). A missing or malformed number is left out, and the app hides
  // its button.
  async contact(environment: NodeJS.ProcessEnv = process.env): Promise<Contact> {
    const parsed = contactSchema.safeParse(await this.text('contact'));
    const stored = parsed.success
      ? parsed.data
      : {
          phone: environment.SUPPORT_PHONE_NUMBER?.trim() ?? null,
          whatsapp: environment.SUPPORT_WHATSAPP_NUMBER?.trim() ?? null,
        };
    const contact: Contact = {};
    if (stored.phone && E164.test(stored.phone)) contact.phone = stored.phone;
    if (stored.whatsapp && E164.test(stored.whatsapp)) contact.whatsapp = stored.whatsapp;
    return contact;
  }

  async updateContact(
    value: { phone: string | null; whatsapp: string | null },
    edit: ContentEdit,
  ): Promise<Contact> {
    const parsed = contactSchema.safeParse(value);
    if (!parsed.success) throw new ContentRefusedError('invalid_value', 'a number is not E.164');
    await this.writeText('contact', parsed.data, edit);
    return this.contact();
  }

  private async text(key: string): Promise<unknown> {
    const [row] = await this.database.db
      .select({ value: texts.value })
      .from(texts)
      .where(eq(texts.key, key));
    return row?.value;
  }

  private async writeText(key: string, value: unknown, edit: ContentEdit): Promise<void> {
    await this.database.db.transaction(async (tx) => {
      await tx.execute(sql`SELECT pg_advisory_xact_lock(hashtextextended(${`content:${key}`}, 0))`);
      const [before] = await tx
        .select({ value: texts.value })
        .from(texts)
        .where(eq(texts.key, key));
      await tx
        .insert(texts)
        .values({ key, value })
        .onConflictDoUpdate({ target: texts.key, set: { value, updatedAt: sql`now()` } });
      await this.recordEdit(
        tx,
        edit,
        'content.text.update',
        key,
        before ? { value: before.value } : null,
        { value },
      );
    });
  }

  private knownList(list: string): ReasonList {
    if (!isReasonList(list)) throw new ContentRefusedError('unknown_list', `${list} is no list`);
    return list;
  }

  private checkFields(list: ReasonList, fields: ReasonFields): ReasonFields {
    const label = fields.label.trim();
    const customerText = fields.customerText?.trim() || null;
    if (label.length === 0 || label.length > LABEL_MAX) {
      throw new ContentRefusedError('invalid_value', `a label has 1 to ${LABEL_MAX} characters`);
    }
    if (customerText !== null && !listDefinition(list).customerText) {
      throw new ContentRefusedError('customer_text_not_allowed', `${list} has no customer texts`);
    }
    if (customerText !== null && customerText.length > CUSTOMER_TEXT_MAX) {
      throw new ContentRefusedError(
        'invalid_value',
        `a customer text has at most ${CUSTOMER_TEXT_MAX} characters`,
      );
    }
    // A closed list's reasons take no note (RA R3: no free-text rejection).
    if (fields.note !== 'none' && listDefinition(list).closed) {
      throw new ContentRefusedError('invalid_value', `${list} takes no notes`);
    }
    return { label, customerText, note: fields.note };
  }

  // Two active reasons of a list never read the same.
  private async checkUniqueLabel(
    tx: Executor,
    list: ReasonList,
    label: string,
    exceptCode: string | null,
  ): Promise<void> {
    const rows = await tx
      .select({ code: reasons.code })
      .from(reasons)
      .where(and(eq(reasons.list, list), eq(reasons.label, label), eq(reasons.active, true)));
    if (rows.some((row) => row.code !== exceptCode)) {
      throw new ContentRefusedError('duplicate_label', `${list} already has «${label}»`);
    }
  }

  private recordEdit(
    tx: Executor,
    edit: ContentEdit,
    action: string,
    id: string,
    before: object | null,
    after: object | null,
  ): Promise<void> {
    return this.audit.recordWrite(
      {
        actor: { type: 'admin', id: edit.admin.accountId, role: edit.admin.roles.join(',') },
        context: edit.context,
        cityId: null,
        action,
        target: { type: 'content', id },
        before: before as Record<string, unknown> | null,
        after: after as Record<string, unknown> | null,
        reason: null,
      },
      tx,
    );
  }
}

// Edits of one list take turns, so positions and labels stay consistent.
async function lockList(tx: Pick<Database['db'], 'execute'>, list: ReasonList): Promise<void> {
  await tx.execute(sql`SELECT pg_advisory_xact_lock(hashtextextended(${`content:${list}`}, 0))`);
}

function reasonOf(row: typeof reasons.$inferSelect): Reason {
  return {
    code: row.code,
    label: row.label,
    customerText: row.customerText,
    note: row.note,
    fixed: row.fixed,
    active: row.active,
  };
}
