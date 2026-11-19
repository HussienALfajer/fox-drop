import { describe, expect, it, vi } from 'vitest';

vi.mock('./api.js', () => ({ api: {} }));

const { cashLimitOf, contractProblem, kitBody, kitLinesOf, missingDocumentOf } =
  await import('./captain-activation.js');
const { depositBodyOf } = await import('./cash-desk-deposits.js');

// AP §9.7.1–9.7.2 (slice 2.35a): what the panel checks before sending.
describe('the activation forms', () => {
  it('ticks the kit issued and sends the items ticked with their sizes', () => {
    const lines = kitLinesOf(
      [
        { code: 'thermal_bag', active: true },
        { code: 'vest', active: true },
        { code: 'old', active: false },
      ],
      { items: [{ code: 'vest', label: 'سترة', size: 'L', quantity: 2 }], issuedAt: '' },
    );
    expect(lines).toEqual([
      { code: 'thermal_bag', picked: false, size: '', quantity: '1' },
      { code: 'vest', picked: true, size: 'L', quantity: '2' },
    ]);
    expect(kitBody(lines)).toEqual({ items: [{ code: 'vest', size: 'L', quantity: 2 }] });
    expect(kitBody(lines.map((line) => ({ ...line, picked: false })))).toBeNull();
    expect(kitBody([{ ...lines[1]!, quantity: '21' }])).toBeNull();
    expect(kitBody([{ ...lines[0]!, picked: true, size: ' ' }])).toEqual({
      items: [{ code: 'thermal_bag', size: null, quantity: 1 }],
    });
  });

  it('takes a cash limit above zero in major units', () => {
    expect(cashLimitOf('400', 'TRY')).toBe('40000');
    expect(cashLimitOf('0', 'TRY')).toBeNull();
    expect(cashLimitOf('abc', 'TRY')).toBeNull();
  });

  it('takes a signing day not after today, a start not before it, and 1 to 6 pages', () => {
    const file = new File(['x'], 'p.jpg', { type: 'image/jpeg' });
    const form = { signedOn: '2026-11-19', startsOn: '2026-11-20', files: [file] };
    expect(contractProblem(form, '2026-11-19')).toBeNull();
    expect(contractProblem({ ...form, signedOn: '2026-11-20' }, '2026-11-19')).toBe('dates');
    expect(contractProblem({ ...form, startsOn: '2026-11-18' }, '2026-11-19')).toBe('dates');
    expect(contractProblem({ ...form, files: [] }, '2026-11-19')).toBe('files');
  });

  it('names a missing document by its kind', () => {
    expect(missingDocumentOf('document:signed_contract')).toBe('signed_contract');
    expect(missingDocumentOf('kit')).toBeNull();
  });
});

describe('the deposit at the desk (AP §9.7.1, §8.5)', () => {
  const application = {
    applicationId: '01900000-0000-7000-8000-0000000000a1',
    fullName: 'خالد',
    deposit: { amount: null, instalment: null, paid: '10000', recorded: false },
    suggested: { amount: '50000', currency: 'TRY' },
  };
  const city = '01900000-0000-7000-8000-0000000000c1';

  it('sends the amount, the instalment (none when empty) and the cash now', () => {
    expect(
      depositBodyOf({ amount: '500', instalment: '100', paidNow: '200' }, application, city, 'TRY'),
    ).toEqual({
      body: {
        cityId: city,
        applicationId: application.applicationId,
        amount: '50000',
        instalment: '10000',
        paidNow: '20000',
      },
    });
    expect(
      depositBodyOf({ amount: '500', instalment: '', paidNow: '' }, application, city, 'TRY'),
    ).toMatchObject({ body: { instalment: null, paidNow: '0' } });
  });

  it('refuses an instalment above the deposit and cash above what is left', () => {
    expect(
      depositBodyOf({ amount: '500', instalment: '600', paidNow: '' }, application, city, 'TRY'),
    ).toEqual({ problem: 'instalment' });
    expect(
      depositBodyOf({ amount: '500', instalment: '', paidNow: '450' }, application, city, 'TRY'),
    ).toEqual({ problem: 'paid_now' });
    expect(
      depositBodyOf({ amount: '', instalment: '', paidNow: '' }, application, city, 'TRY'),
    ).toEqual({ problem: 'amount' });
  });
});
