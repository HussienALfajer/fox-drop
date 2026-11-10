import { describe, expect, it, vi } from 'vitest';
import {
  addsItems,
  afterPickupLines,
  canEdit,
  type EditPreview,
  editBody,
  editRequest,
  initialForm,
  type MenuItem,
  needsExtraPrep,
  optionsFit,
} from './order-edit.js';

vi.mock('./api.js', () => ({ api: {} }));

const lines = [
  {
    itemId: 'shawarma',
    position: 0,
    name: 'شاورما',
    quantity: 2,
    added: false,
    quantityBefore: null,
    options: [],
    note: null,
    unitPrice: '12000',
    lineTotal: '24000',
  },
  {
    itemId: 'cola',
    position: 1,
    name: 'كولا',
    quantity: 1,
    added: false,
    quantityBefore: null,
    options: [],
    note: null,
    unitPrice: '3000',
    lineTotal: '3000',
  },
];

const fries = { itemId: 'fries', optionIds: [], quantity: 1 };

// AP §9.3.3 «تعديل الطلب»: OWN and OPS, while the detail offers it.
describe('canEdit', () => {
  const session = (permissions: string[]) => ({ permissions }) as never;
  const choices = { editChoices: { afterPickup: false, extraPrepMaxMin: 60, items: [] } };
  it('needs operations.manage and the detail choice', () => {
    expect(canEdit(session(['operations.manage']), choices)).toBe(true);
    expect(canEdit(session(['operations.read']), choices)).toBe(false);
    expect(canEdit(session(['operations.manage']), { editChoices: null })).toBe(false);
  });
});

describe('the edit request', () => {
  const request = (
    form: ReturnType<typeof initialForm>,
    status: 'accepted' | 'ready' = 'accepted',
  ) => editRequest(form, lines, status, 'TRY', 60);

  it('is nothing until something changes', () => {
    expect(request(initialForm(lines))).toBeNull();
  });

  it('keeps the lines left with their quantities, drops a 0 and adds from the menu', () => {
    const form = { ...initialForm(lines), quantities: { 0: 3, 1: 0 }, added: [fries] };
    expect(request(form)).toEqual({
      keep: [{ position: 0, quantity: 3 }],
      add: [fries],
      deliveryFee: null,
      extraPrepMin: null,
      responsible: null,
    });
  });

  it('reads a new delivery fee typed in major units, and refuses one that is not', () => {
    expect(request({ ...initialForm(lines), fee: '20' })?.deliveryFee).toBe('2000');
    expect(request({ ...initialForm(lines), fee: 'عشرون' })).toBeNull();
  });

  it('refuses a quantity outside 1 to 20 and an edit that removes every line', () => {
    expect(request({ ...initialForm(lines), quantities: { 0: 21, 1: 1 } })).toBeNull();
    expect(request({ ...initialForm(lines), quantities: { 0: 1.5, 1: 1 } })).toBeNull();
    expect(request({ ...initialForm(lines), quantities: { 0: 0, 1: 0 } })).toBeNull();
  });

  it('asks the extra prep time only for items added to a ready order', () => {
    const raised = { ...initialForm(lines), quantities: { 0: 3, 1: 1 } };
    const lowered = { ...initialForm(lines), quantities: { 0: 1, 1: 1 } };
    expect(addsItems(raised, lines)).toBe(true);
    expect(addsItems(lowered, lines)).toBe(false);
    expect(needsExtraPrep('ready', raised, lines)).toBe(true);
    expect(needsExtraPrep('accepted', raised, lines)).toBe(false);
    expect(needsExtraPrep('ready', lowered, lines)).toBe(false);
    expect(request(raised, 'ready')).toBeNull();
    expect(request({ ...raised, extraPrepMin: 10 }, 'ready')?.extraPrepMin).toBe(10);
    expect(request({ ...raised, extraPrepMin: 61 }, 'ready')).toBeNull();
    expect(request({ ...lowered, extraPrepMin: 10 }, 'ready')?.extraPrepMin).toBeNull();
  });

  it("needs operations' note for the command", () => {
    const changed = request({ ...initialForm(lines), quantities: { 0: 1, 1: 1 } });
    expect(editBody(changed, '  ', 4)).toBeNull();
    expect(editBody(changed, ' اتفقنا ', 4)).toMatchObject({ reason: 'اتفقنا', version: 4 });
    expect(editBody(null, 'اتفقنا', 4)).toBeNull();
  });
});

describe('optionsFit', () => {
  const item: MenuItem = {
    id: 'shawarma',
    name: 'شاورما',
    category: 'وجبات',
    price: '12000',
    optionGroups: [
      {
        id: 'size',
        name: 'الحجم',
        minChoices: 1,
        maxChoices: 1,
        options: [
          { id: 'small', name: 'صغير', priceDelta: '0' },
          { id: 'large', name: 'كبير', priceDelta: '2000' },
        ],
      },
    ],
  };
  it("keeps each group's minimum and maximum", () => {
    expect(optionsFit(item, ['large'])).toBe(true);
    expect(optionsFit(item, [])).toBe(false);
    expect(optionsFit(item, ['small', 'large'])).toBe(false);
  });
});

// AP §9.3.3 after the pickup (slice 2.10b): removals and a lower fee only,
// with the responsible party, and the entries in sentences.
describe('an edit after the pickup', () => {
  const after = { deliveryFee: '4000' };
  const request = (form: ReturnType<typeof initialForm>) =>
    editRequest(form, lines, 'picked_up', 'TRY', 0, after);

  it('takes removals and a lower fee with the responsible party', () => {
    const form = { ...initialForm(lines), quantities: { 0: 1 }, fee: '20' };
    expect(request({ ...form, responsible: 'captain' })).toEqual({
      keep: [
        { position: 0, quantity: 1 },
        { position: 1, quantity: 1 },
      ],
      add: [],
      deliveryFee: '2000',
      extraPrepMin: null,
      responsible: 'captain',
    });
    // The preview comes before the party is chosen.
    expect(request(form)?.responsible).toBeNull();
  });

  it('refuses additions, a raised quantity and a higher fee', () => {
    expect(request({ ...initialForm(lines), added: [fries] })).toBeNull();
    expect(request({ ...initialForm(lines), quantities: { 0: 3 } })).toBeNull();
    expect(request({ ...initialForm(lines), fee: '50' })).toBeNull();
  });

  it('names each journal of the preview, and refuses one it cannot', () => {
    const entry = (type: string, account: string, amount: string, name: string | null = null) => ({
      type,
      reason: type === 'merchant.commission' ? 'إلغاء عمولة' : 'أصناف حُذفت بعد الاستلام',
      account,
      party: { kind: 'merchant' as const, id: null, name },
      amount: { amount, currency: 'TRY' },
    });
    const preview = (entries: ReturnType<typeof entry>[]) =>
      ({ entries }) as unknown as EditPreview;
    expect(
      afterPickupLines(
        preview([
          entry('merchant.debit', 'merchant.account', '12000', 'مطعم الشام'),
          entry('merchant.debit', 'platform.order_clearing', '-12000'),
          entry('merchant.commission', 'merchant.account', '-1800', 'مطعم الشام'),
          entry('merchant.commission', 'platform.revenue_commission', '1800'),
        ]),
      ),
    ).toEqual([
      {
        key: 'merchantDebit',
        name: 'مطعم الشام',
        amount: { amount: '12000', currency: 'TRY' },
        reason: 'أصناف حُذفت بعد الاستلام',
      },
      { key: 'commissionReversed', amount: { amount: '1800', currency: 'TRY' } },
    ]);
    expect(
      afterPickupLines(
        preview([
          entry('earn.charge', 'captain.earnings', '12200', 'أحمد'),
          entry('earn.charge', 'platform.order_clearing', '-12200'),
        ]),
      ),
    ).toEqual([
      {
        key: 'captainCharge',
        name: 'أحمد',
        amount: { amount: '12200', currency: 'TRY' },
        reason: 'أصناف حُذفت بعد الاستلام',
      },
    ]);
    expect(
      afterPickupLines(preview([entry('merchant.credit', 'merchant.account', '-100')])),
    ).toEqual([{ key: 'unknown' }]);
  });
});
