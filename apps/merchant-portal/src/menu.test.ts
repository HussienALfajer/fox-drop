import { describe, expect, it, vi } from 'vitest';
import {
  type Menu,
  type MenuGroup,
  type Pending,
  bulkBody,
  groupBodyOf,
  groupFormOf,
  isNew,
  menuCurrency,
  moved,
  photoRefusal,
  priceOf,
  quickRows,
  refusalKey,
  timeOfMinute,
  windowOf,
} from './menu.js';

vi.mock('./api.js', () => ({ api: {} }));

const money = (amount: string) => ({ amount, currency: 'TRY' });

function pending(field: Pending['field'], values: Partial<Pending> = {}): Pending {
  return {
    requestId: `request-${field}`,
    field,
    createdAt: '2026-11-20T10:00:00.000Z',
    name: null,
    description: null,
    photoKey: null,
    price: null,
    categoryId: null,
    groupId: null,
    minChoices: null,
    maxChoices: null,
    itemIds: null,
    options: null,
    ...values,
  };
}

const option = (id: string, name: string) => ({
  id,
  name,
  priceDelta: money('500'),
  available: true,
  switchedOff: null,
});

function item(
  id: string,
  name: string,
  extra: Partial<Menu['categories'][number]['items'][number]> = {},
) {
  return {
    id,
    code: id,
    name,
    description: null,
    photoKey: null,
    price: money('10000'),
    available: true,
    switchedOff: null,
    hidden: false,
    optionGroups: [],
    pending: [],
    ...extra,
  };
}

const sauces = { id: 'g1', name: 'الصلصات', minChoices: 0, maxChoices: 2 };

const menu: Menu = {
  categories: [
    {
      id: 'c1',
      name: 'وجبات',
      hidden: false,
      available: true,
      switchedOff: null,
      window: null,
      pending: [],
      items: [
        item('i1', 'شاورما', {
          optionGroups: [{ ...sauces, options: [option('o1', 'ثوم'), option('o2', 'حار')] }],
        }),
        item('i2', 'كباب', {
          optionGroups: [{ ...sauces, options: [option('o1', 'ثوم'), option('o2', 'حار')] }],
        }),
        item('i3', 'فلافل', { pending: [pending('created')] }),
      ],
    },
    {
      id: 'c2',
      name: 'مشروبات',
      hidden: false,
      available: true,
      switchedOff: null,
      window: { startsAt: 360, endsAt: 720 },
      pending: [],
      items: [item('i4', 'عصير')],
    },
  ],
  optionGroups: [],
};

describe('the menu (RA §9)', () => {
  it('knows the rows waiting for review as new ones (RA §9.5)', () => {
    expect(isNew([pending('created')])).toBe(true);
    expect(isNew([pending('rename', { name: 'جديد' })])).toBe(false);
  });

  it('reads the base currency from the prices', () => {
    expect(menuCurrency(menu)).toBe('TRY');
    expect(menuCurrency({ categories: [], optionGroups: [] })).toBeNull();
  });

  it('moves a published row and never names a new one (RA §9.2)', () => {
    const items = menu.categories[0]!.items;
    expect(moved(items, 'i2', -1)).toEqual(['i2', 'i1']);
    expect(moved(items, 'i2', 1)).toBeNull();
    expect(moved(items, 'i1', -1)).toBeNull();
  });

  it('lists every item and option once for «تعديل سريع» (RA §9.6)', () => {
    const rows = quickRows(menu, '', '').map((row) =>
      row.kind === 'item' ? row.item.id : `${row.item.id}/${row.option.id}`,
    );
    // A shared option shows under its first item; a new item not at all.
    expect(rows).toEqual(['i1', 'i1/o1', 'i1/o2', 'i2', 'i4']);
    expect(quickRows(menu, 'ثوم', '').map((row) => row.kind)).toEqual(['option']);
    expect(quickRows(menu, '', 'c2').map((row) => row.kind === 'item' && row.item.id)).toEqual([
      'i4',
    ]);
  });

  it('takes a price above 0 and a delta of 0 or more (RA §9.4)', () => {
    expect(priceOf('12.5', 'TRY', false)).toBe('1250');
    expect(priceOf('0', 'TRY', false)).toBeNull();
    expect(priceOf('0', 'TRY', true)).toBe('0');
    expect(priceOf('1.234', 'TRY', false)).toBeNull();
    expect(priceOf('abc', 'TRY', true)).toBeNull();
  });

  it('reads a daily window from two times (RA §9.1)', () => {
    expect(windowOf('06:00', '12:00')).toEqual({ startsAt: 360, endsAt: 720 });
    // Midnight as the end is the end of the day; an earlier end crosses it.
    expect(windowOf('18:00', '00:00')).toEqual({ startsAt: 1080, endsAt: 1440 });
    expect(windowOf('22:00', '02:00')).toEqual({ startsAt: 1320, endsAt: 120 });
    expect(windowOf('10:00', '10:00')).toBeNull();
    expect(windowOf('', '10:00')).toBeNull();
    expect(timeOfMinute(1440)).toBe('00:00');
    expect(timeOfMinute(450)).toBe('07:30');
  });

  it('sends a bulk change in basis points or minor units (RA §9.4)', () => {
    const form = {
      categoryId: '',
      kind: 'percent' as const,
      direction: 'up' as const,
      value: '7.5',
    };
    expect(bulkBody(form, 'TRY')).toEqual({
      categoryId: null,
      kind: 'percent',
      direction: 'up',
      value: '750',
    });
    expect(bulkBody({ ...form, kind: 'amount', value: '5', categoryId: 'c1' }, 'TRY')).toEqual({
      categoryId: 'c1',
      kind: 'amount',
      direction: 'up',
      value: '500',
    });
    expect(bulkBody({ ...form, value: '0' }, 'TRY')).toBeNull();
  });

  it('explains each refusal as the app does', () => {
    expect(refusalKey('invalid_menu')).toBe('invalidPrice');
    expect(refusalKey('invalid_menu', true)).toBe('requestInvalid');
    expect(refusalKey('request_not_pending', true)).toBe('requestGone');
    expect(refusalKey('upload_expired', true)).toBe('photoFailed');
    expect(refusalKey('price_reaches_zero')).toBe('bulkRefused');
    expect(refusalKey('restaurant_terminated')).toBe('terminated');
    expect(refusalKey('owner_only')).toBe('saveFailed');
  });

  it('refuses a photo the server would not take (architecture §5.8)', () => {
    expect(photoRefusal({ type: 'image/jpeg', size: 1000 })).toBeNull();
    expect(photoRefusal({ type: 'image/gif', size: 1000 })).toBe('type');
    expect(photoRefusal({ type: 'image/png', size: 9 * 1024 * 1024 })).toBe('size');
  });
});

describe('the option group form (RA §9.2, §9.5)', () => {
  const group: MenuGroup = {
    id: 'g1',
    name: 'الصلصات',
    minChoices: 0,
    maxChoices: 2,
    itemIds: ['i1'],
    options: [
      { id: 'o1', name: 'ثوم', priceDelta: money('500'), switchedOff: null, pending: [] },
      {
        id: 'o3',
        name: 'جبنة',
        priceDelta: money('1000'),
        switchedOff: null,
        pending: [pending('created')],
      },
    ],
    pending: [
      pending('rename', { name: 'صلصات' }),
      pending('choices', { minChoices: 1, maxChoices: 3 }),
    ],
  };

  it('starts from the pending values, so sending it keeps them', () => {
    expect(groupFormOf(group)).toEqual({
      name: 'صلصات',
      minChoices: '1',
      maxChoices: '3',
      itemIds: ['i1'],
      options: [
        { id: 'o1', name: 'ثوم', delta: '5.00', published: true },
        { id: 'o3', name: 'جبنة', delta: '10.00', published: false },
      ],
    });
  });

  it('sends the group with its options in minor units', () => {
    expect(groupBodyOf(groupFormOf(group), 'TRY')).toEqual({
      name: 'صلصات',
      minChoices: 1,
      maxChoices: 3,
      itemIds: ['i1'],
      options: [
        { id: 'o1', name: 'ثوم', priceDelta: money('500') },
        { id: 'o3', name: 'جبنة', priceDelta: money('1000') },
      ],
    });
  });

  it('refuses choices out of order and an option without a name', () => {
    const form = groupFormOf(group);
    expect(groupBodyOf({ ...form, minChoices: '4' }, 'TRY')).toBeNull();
    expect(groupBodyOf({ ...form, maxChoices: '0', minChoices: '0' }, 'TRY')).toBeNull();
    expect(
      groupBodyOf(
        { ...form, options: [{ id: 'o9', name: ' ', delta: '0', published: false }] },
        'TRY',
      ),
    ).toBeNull();
    expect(groupFormOf(null)).toEqual({
      name: '',
      minChoices: '0',
      maxChoices: '1',
      itemIds: [],
      options: [],
    });
  });
});
