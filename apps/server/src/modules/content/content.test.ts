import 'reflect-metadata';
import { Test, type TestingModule } from '@nestjs/testing';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { captainLists, customerLists, merchantLists } from './app-content.controller.js';
import { ContentRefusedError, ContentService, type ContentEdit } from './content.service.js';
import { ContentModule } from './index.js';
import { reasonListNames, reasonLists } from './lists.js';

// The content module on a fresh database, connected as the application role.
let database: TestDatabase;
let sql: pg.Pool;
let moduleRef: TestingModule;
let content: ContentService;

beforeAll(async () => {
  database = await startTestDatabase();
  process.env.DATABASE_URL = database.appUrl;
  sql = new pg.Pool({ connectionString: database.appUrl });
  moduleRef = await Test.createTestingModule({ imports: [ContentModule] }).compile();
  await moduleRef.init();
  content = moduleRef.get(ContentService);
}, 300_000);

afterAll(async () => {
  await moduleRef?.close();
  await sql?.end();
  await database?.stop();
});

const edit: ContentEdit = {
  admin: { accountId: '0190f3a0-0000-7000-8000-000000000001', roles: ['OWN'] },
  context: { ipAddress: '203.0.113.7', device: 'Firefox 140 on Windows' },
};

async function refusal(action: Promise<unknown>): Promise<string> {
  try {
    await action;
  } catch (error) {
    if (error instanceof ContentRefusedError) return error.refusal;
    throw error;
  }
  return 'accepted';
}

describe('the default lists', () => {
  it('seeds every list of the catalogue, and only those', async () => {
    const { rows } = await sql.query<{ list: string }>(
      'SELECT DISTINCT list FROM content.reasons ORDER BY list',
    );
    expect(rows.map((row) => row.list)).toEqual([...reasonListNames].sort());
  });

  it('gives each app the lists the catalogue names for it', () => {
    const forApp = (app: string) =>
      reasonListNames.filter((list) => (reasonLists[list].apps as readonly string[]).includes(app));
    expect([...merchantLists].sort()).toEqual(forApp('merchant').sort());
    expect([...captainLists].sort()).toEqual(forApp('captain').sort());
    expect([...customerLists].sort()).toEqual(forApp('customer').sort());
  });

  it('answers an app its active reasons in order', async () => {
    const lists = await content.listsFor('captain');
    expect(lists.captain_away).toEqual([
      { code: 'customer_requested_other_place', label: 'الزبون طلب مكاناً آخر', needsText: false },
      { code: 'pin_inaccurate', label: 'موقع الزبون على الخريطة غير دقيق', needsText: false },
      { code: 'other', label: 'أخرى', needsText: true },
    ]);
    expect(Object.keys(lists).sort()).toEqual([...captainLists].sort());
  });
});

describe('choosing a reason', () => {
  it('keeps the code, the label as chosen and the text of «أخرى»', async () => {
    expect(await content.choose('shortfall', { code: 'counting_error', note: null })).toEqual({
      code: 'counting_error',
      label: 'خطأ في العد',
      note: null,
    });
    expect(await content.choose('captain_away', { code: 'other', note: ' عند الجار ' })).toEqual({
      code: 'other',
      label: 'أخرى',
      note: 'عند الجار',
    });
  });

  it('refuses an unknown code, a missing text and an unwanted one', async () => {
    expect(await refusal(content.choose('shortfall', { code: 'nope', note: null }))).toBe(
      'unknown_reason',
    );
    expect(await refusal(content.choose('shortfall', { code: 'other', note: '  ' }))).toBe(
      'reason_note_required',
    );
    expect(await refusal(content.choose('shortfall', { code: 'customer_short', note: 'x' }))).toBe(
      'reason_note_not_allowed',
    );
    // A code of another list.
    expect(await refusal(content.choose('shortfall', { code: 'pin_inaccurate', note: null }))).toBe(
      'unknown_reason',
    );
  });

  it('refuses a removed reason, which stays as recorded', async () => {
    await content.updateReason(
      'reassignment',
      'connection_lost',
      { label: 'انقطاع الاتصال', customerText: null, needsText: false, active: false },
      edit,
    );
    expect(
      await refusal(content.choose('reassignment', { code: 'connection_lost', note: null })),
    ).toBe('unknown_reason');
    const all = await content.allLists();
    const reassignment = all.find((list) => list.list === 'reassignment')!.reasons;
    expect(reassignment.find((reason) => reason.code === 'connection_lost')?.active).toBe(false);
  });
});

describe('customer texts', () => {
  it('gives the stored text, or the generic apology', async () => {
    expect(await content.customerText('system_cancellation', 'merchant_auto_cancel')).toBe(
      'لم يرد المطعم على طلبك',
    );
    const added = await content.addReason(
      'ops_cancel',
      { label: 'سبب جديد', customerText: null, needsText: false },
      edit,
    );
    expect(await content.customerText('ops_cancel', added.code)).toBe(
      'نعتذر، لم نتمكن من إكمال طلبك',
    );
  });
});

describe("the panel's edits", () => {
  it('adds a reason at the end with a new code, and audits it', async () => {
    const added = await content.addReason(
      'captain_problem',
      { label: 'الطريق مغلق', customerText: null, needsText: false },
      edit,
    );
    expect(added.code).toMatch(/^custom_[0-9a-f]{8}$/);
    const lists = await content.listsFor('captain');
    expect(lists.captain_problem!.at(-1)).toEqual({
      code: added.code,
      label: 'الطريق مغلق',
      needsText: false,
    });
    const { rows } = await sql.query(
      "SELECT action, actor_role FROM audit.events WHERE target_type = 'content' AND target_id = $1",
      [`captain_problem:${added.code}`],
    );
    expect(rows).toEqual([{ action: 'content.reason.create', actor_role: 'OWN' }]);
  });

  it('refuses a closed list, a fixed removal, a repeated label and a stray customer text', async () => {
    const fields = { label: 'جديد', customerText: null, needsText: false };
    expect(await refusal(content.addReason('merchant_rejection', fields, edit))).toBe(
      'list_closed',
    );
    expect(
      await refusal(
        content.updateReason(
          'captain_problem',
          'pickup_amount',
          { label: 'مشكلة في مبلغ الاستلام', customerText: null, needsText: false, active: false },
          edit,
        ),
      ),
    ).toBe('reason_fixed');
    expect(
      await refusal(content.addReason('shortfall', { ...fields, label: 'خطأ في العد' }, edit)),
    ).toBe('duplicate_label');
    expect(
      await refusal(content.addReason('shortfall', { ...fields, customerText: 'نص' }, edit)),
    ).toBe('customer_text_not_allowed');
    expect(await refusal(content.addReason('no_such_list', fields, edit))).toBe('unknown_list');
  });

  it('changes a label, which a new choice copies', async () => {
    await content.updateReason(
      'shortfall',
      'counting_error',
      { label: 'خطأ في عدّ النقود', customerText: null, needsText: false, active: true },
      edit,
    );
    expect((await content.choose('shortfall', { code: 'counting_error', note: null })).label).toBe(
      'خطأ في عدّ النقود',
    );
  });

  it('reorders a list with every code once', async () => {
    expect(await refusal(content.reorder('order_note', ['no_cutlery'], edit))).toBe(
      'invalid_order',
    );
    await content.reorder(
      'order_note',
      ['no_cutlery', 'send_cutlery', 'do_not_knock', 'call_on_arrival'],
      edit,
    );
    const lists = await content.listsFor('customer');
    expect(lists.order_note!.map((reason) => reason.code)).toEqual([
      'no_cutlery',
      'send_cutlery',
      'do_not_knock',
      'call_on_arrival',
    ]);
  });
});

describe('texts', () => {
  it('seeds the FAQ drafts and the work rules, and stores an edit', async () => {
    expect((await content.faq('captain')).length).toBeGreaterThan(0);
    expect(await content.workRules()).toContain('الخوذة');
    await content.updateFaq('merchant', [{ question: 'س؟', answer: 'ج.' }], edit);
    expect(await content.faq('merchant')).toEqual([{ question: 'س؟', answer: 'ج.' }]);
  });

  it('gives the contact from the variables until the panel stores one', async () => {
    const environment = {
      SUPPORT_PHONE_NUMBER: '+963944000000',
      SUPPORT_WHATSAPP_NUMBER: ' 0944000000 ',
    };
    expect(await content.contact(environment)).toEqual({ phone: '+963944000000' });
    expect(await refusal(content.updateContact({ phone: '0944', whatsapp: null }, edit))).toBe(
      'invalid_value',
    );
    await content.updateContact({ phone: null, whatsapp: '+905321234567' }, edit);
    expect(await content.contact(environment)).toEqual({ whatsapp: '+905321234567' });
  });
});

it('never lets the application role delete a reason', async () => {
  await expect(sql.query("DELETE FROM content.reasons WHERE list = 'order_note'")).rejects.toThrow(
    /permission denied/,
  );
});
