import { describe, expect, it, vi } from 'vitest';
import { replyWithin, reportOf } from './support.js';

vi.mock('./api.js', () => ({ api: {} }));

const types = [
  { code: 'app_problem', label: 'مشكلة في التطبيق', note: 'optional' as const },
  { code: 'data_change', label: 'طلب تعديل بيانات', note: 'optional' as const },
  { code: 'other', label: 'أخرى', note: 'required' as const },
];
const form = { typeCode: 'app_problem', subject: '' as const, orderId: '', note: '' };

describe('«إبلاغ عن مشكلة» (RA §15)', () => {
  it('sends the type, an optional order and note', () => {
    expect(reportOf({ ...form, orderId: 'o1', note: ' لا يعمل ' }, types)).toEqual({
      body: { typeCode: 'app_problem', orderId: 'o1', note: 'لا يعمل', subject: null },
    });
  });

  it('asks a data change for its subject and «أخرى» for its note', () => {
    expect(reportOf({ ...form, typeCode: 'data_change' }, types)).toEqual({ invalid: 'subject' });
    expect(reportOf({ ...form, typeCode: 'data_change', subject: 'coverage' }, types)).toEqual({
      body: { typeCode: 'data_change', orderId: null, note: null, subject: 'coverage' },
    });
    expect(reportOf({ ...form, typeCode: 'other' }, types)).toEqual({ invalid: 'note' });
    expect(reportOf({ ...form, typeCode: 'gone' }, types)).toEqual({ invalid: 'type' });
    expect(reportOf({ ...form, note: 'x'.repeat(301) }, types)).toEqual({ invalid: 'note' });
  });

  it('says the reply time in hours when whole, else minutes', () => {
    expect(replyWithin(1440)).toEqual({ hours: 24 });
    expect(replyWithin(30)).toEqual({ minutes: 30 });
    expect(replyWithin(90)).toEqual({ minutes: 90 });
  });
});
