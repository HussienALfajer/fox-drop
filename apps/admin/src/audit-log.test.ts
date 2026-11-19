import { describe, expect, it, vi } from 'vitest';

vi.mock('./api.js', () => ({ api: {} }));

const { auditActionOf, auditLogQueryOf, auditLogSearchOf, canReadAuditLog, valueText } =
  await import('./audit-log.js');

// AP §9.16 «سجل التدقيق» (slice 2.38a).
describe('canReadAuditLog', () => {
  it('needs audit_log.read (OWN)', () => {
    expect(canReadAuditLog({ permissions: ['audit_log.read'] } as never)).toBe(true);
    expect(canReadAuditLog({ permissions: ['settings.read'] } as never)).toBe(false);
    expect(canReadAuditLog(null)).toBe(false);
  });
});

describe('auditLogSearchOf', () => {
  it('keeps the filters it can read and drops the rest', () => {
    expect(
      auditLogSearchOf({
        city: 'AZ',
        actorType: 'admin',
        actorId: '0190f3a0-0000-7000-8000-000000000001',
        action: 'setting.update',
        targetType: 'setting',
        targetId: 'order.eta_buffer_min',
        from: '2026-11-01',
        to: '2026-11-19',
      }),
    ).toEqual({
      city: 'AZ',
      actorType: 'admin',
      actorId: '0190f3a0-0000-7000-8000-000000000001',
      action: 'setting.update',
      targetType: 'setting',
      targetId: 'order.eta_buffer_min',
      from: '2026-11-01',
      to: '2026-11-19',
    });
    expect(
      auditLogSearchOf({
        actorType: 'robot',
        actorId: 'not-an-id',
        action: 'Setting Update',
        from: '19/11/2026',
        targetId: ' ',
      }),
    ).toEqual({});
  });
});

describe('auditLogQueryOf', () => {
  it('turns the calendar days into instants on the city clock, the last day included', () => {
    expect(
      auditLogQueryOf(
        { from: '2026-11-01', to: '2026-11-19', action: 'setting.update' },
        'Asia/Damascus',
      ),
    ).toEqual({
      action: 'setting.update',
      from: '2026-10-31T21:00:00.000Z',
      to: '2026-11-19T21:00:00.000Z',
    });
    expect(auditLogQueryOf({}, 'Asia/Damascus')).toEqual({});
  });
});

describe('the words of the log', () => {
  it('names the actions it knows and leaves the others to their code', () => {
    expect(auditActionOf('setting.update')).toBe('setting.update');
    expect(auditActionOf('order.accept')).toBe('order.accept');
    expect(auditActionOf('order.timeout')).toBeNull();
  });

  it('shows a value of the diff as written', () => {
    const flag = { on: 'مفعّل', off: 'متوقف' };
    expect(valueText('12', flag)).toBe('12');
    expect(valueText('"زحام"', flag)).toBe('زحام');
    expect(valueText('true', flag)).toBe('مفعّل');
    expect(valueText('false', flag)).toBe('متوقف');
    expect(valueText('{"amountMinor":1500,"currency":"TRY"}', flag)).toBe('15.00 TRY');
    expect(valueText('{"min":1,"max":4}', flag)).toBe('{"min":1,"max":4}');
    expect(valueText('null', flag)).toBeNull();
    expect(valueText(null, flag)).toBeNull();
  });
});
