import { describe, expect, it, vi } from 'vitest';

vi.mock('./api.js', () => ({ api: {} }));

const {
  canEditMenu,
  categoryBody,
  categoryFormOf,
  groupBody,
  groupFormOf,
  itemBody,
  itemFormOf,
  moved,
  optionBody,
  optionFormOf,
  toggled,
} = await import('./restaurant-menu.js');
const { activationDone, canActivate, canWaiveImages, menuDone } =
  await import('./restaurant-activation.js');
const { canSaveStep, stepsDone } = await import('./restaurant-drafts.js');

const session = (permissions: string[]) =>
  ({ permissions }) as unknown as Parameters<typeof canEditMenu>[0];

const bounds = { nameMax: 80, descriptionMax: 300, codeMax: 20 };

describe('step 7, the menu (slice 2.30b)', () => {
  it('gives the menu to restaurants.menus and step 8 to restaurants.activate', () => {
    expect(canEditMenu(session(['restaurants.menus']))).toBe(true);
    expect(canSaveStep(session(['restaurants.menus']), 'menu')).toBe(true);
    expect(canSaveStep(session(['restaurants.create']), 'menu')).toBe(false);
    expect(canSaveStep(session(['restaurants.activate']), 'activation')).toBe(true);
    expect(canActivate(session(['restaurants.read']))).toBe(false);
    expect(canWaiveImages(session(['restaurants.waive_menu_images']))).toBe(true);
  });

  it('sends a category with its daily window, midnight as 1440', () => {
    const form = categoryFormOf(null);
    expect(categoryBody({ ...form, name: ' فطور ' }, 80)).toEqual({
      name: 'فطور',
      hidden: false,
      window: null,
    });
    expect(
      categoryBody({ ...form, name: 'فطور', windowOn: true, from: '06:00', to: '12:00' }, 80),
    ).toEqual({ name: 'فطور', hidden: false, window: { startsAt: 360, endsAt: 720 } });
    expect(
      categoryBody({ ...form, name: 'سهرة', windowOn: true, from: '18:00', to: '00:00' }, 80),
    ).toMatchObject({ window: { startsAt: 1080, endsAt: 1440 } });
    expect(categoryBody({ ...form, name: '' }, 80)).toEqual({ problem: 'name' });
    expect(
      categoryBody({ ...form, name: 'x', windowOn: true, from: '10:00', to: '10:00' }, 80),
    ).toEqual({ problem: 'window' });
    // The form shows a window ending at midnight as 00:00.
    expect(
      categoryFormOf({
        id: 'c',
        name: 'سهرة',
        hidden: false,
        switchedOff: null,
        window: { startsAt: 1080, endsAt: 1440 },
        items: [],
      }),
    ).toMatchObject({ windowOn: true, from: '18:00', to: '00:00' });
  });

  it('sends an item priced in minor units, an empty code and badge as null', () => {
    const form = { ...itemFormOf(null, 'cat'), name: 'شاورما', price: '120.50' };
    expect(itemBody(form, 'TRY', bounds)).toEqual({
      categoryId: 'cat',
      code: null,
      name: 'شاورما',
      description: null,
      price: { amount: '12050', currency: 'TRY' },
      hidden: false,
      badge: null,
    });
    expect(itemBody({ ...form, badge: 'spicy', code: ' S1 ' }, 'TRY', bounds)).toMatchObject({
      badge: 'spicy',
      code: 'S1',
    });
    expect(itemBody({ ...form, price: '0' }, 'TRY', bounds)).toEqual({ problem: 'price' });
    expect(itemBody({ ...form, price: '1.234' }, 'TRY', bounds)).toEqual({ problem: 'price' });
    expect(itemBody({ ...form, name: ' ' }, 'TRY', bounds)).toEqual({ problem: 'item_name' });
    expect(itemBody({ ...form, code: 'x'.repeat(21) }, 'TRY', bounds)).toEqual({
      problem: 'code',
    });
    // The form shows a saved price in major units.
    expect(
      itemFormOf(
        {
          id: 'i',
          code: 'I0001',
          name: 'شاورما',
          description: null,
          photoKey: null,
          price: { amount: '12050', currency: 'TRY' },
          hidden: false,
          badge: 'new',
          switchedOff: null,
          optionGroupIds: [],
        },
        'cat',
      ),
    ).toMatchObject({ price: '120.50', badge: 'new', code: 'I0001' });
  });

  it('moves a row one place, and leaves the ends as they are', () => {
    expect(moved(['a', 'b', 'c'], 'c', -1)).toEqual(['a', 'c', 'b']);
    expect(moved(['a', 'b', 'c'], 'a', -1)).toEqual(['a', 'b', 'c']);
    expect(moved(['a', 'b', 'c'], 'c', 1)).toEqual(['a', 'b', 'c']);
  });
});

describe('the steps done by the checklist (slice 2.30b)', () => {
  const checklist = (menu: 'met' | 'missing', accountStatus: 'draft' | 'test' | 'active') => ({
    accountStatus,
    items: [{ code: 'menu' as const, state: menu }],
    canStartTest: false,
    canActivate: false,
    images: { withPhoto: 0, total: 0, requiredPct: 80 },
    imagesWaiver: null,
  });
  it('marks step 7 with the menu item and step 8 once active', () => {
    expect(menuDone(checklist('met', 'draft'))).toBe(true);
    expect(menuDone(checklist('missing', 'draft'))).toBe(false);
    expect(menuDone(undefined)).toBe(false);
    expect(activationDone(checklist('met', 'test'))).toBe(false);
    expect(activationDone(checklist('met', 'active'))).toBe(true);
    expect(stepsDone(null, [], { menu: true, activation: false })).toMatchObject({
      menu: true,
      activation: false,
    });
  });
});

describe('option groups and add-ons (slice 2.31)', () => {
  it('builds a group: a minimum of 0 is add-ons, the maximum at least 1 and the minimum', () => {
    expect(groupFormOf(null)).toEqual({ name: '', minChoices: '0', maxChoices: '1' });
    expect(groupBody({ name: ' الحجم ', minChoices: '1', maxChoices: '1' }, 80)).toEqual({
      name: 'الحجم',
      minChoices: 1,
      maxChoices: 1,
    });
    expect(groupBody({ name: 'إضافات', minChoices: '0', maxChoices: '3' }, 80)).toMatchObject({
      minChoices: 0,
      maxChoices: 3,
    });
    expect(groupBody({ name: '', minChoices: '0', maxChoices: '1' }, 80)).toEqual({
      problem: 'group_name',
    });
    expect(groupBody({ name: 'x', minChoices: '2', maxChoices: '1' }, 80)).toEqual({
      problem: 'choices',
    });
    expect(groupBody({ name: 'x', minChoices: '0', maxChoices: '0' }, 80)).toEqual({
      problem: 'choices',
    });
    expect(groupBody({ name: 'x', minChoices: '-1', maxChoices: '2' }, 80)).toEqual({
      problem: 'choices',
    });
  });

  it('builds an option with its delta in minor units, 0 for free', () => {
    expect(optionFormOf(null)).toEqual({ name: '', delta: '0' });
    expect(
      optionFormOf({
        id: 'o',
        name: 'جبنة',
        priceDelta: { amount: '750', currency: 'TRY' },
        switchedOff: null,
      }),
    ).toEqual({ name: 'جبنة', delta: '7.50' });
    expect(optionBody({ name: 'جبنة', delta: '7.5' }, 'TRY', 80)).toEqual({
      name: 'جبنة',
      priceDelta: { amount: '750', currency: 'TRY' },
      removed: false,
    });
    expect(optionBody({ name: 'صغير', delta: '0' }, 'TRY', 80)).toMatchObject({
      priceDelta: { amount: '0' },
    });
    expect(optionBody({ name: 'x', delta: '-1' }, 'TRY', 80)).toEqual({ problem: 'delta' });
    expect(optionBody({ name: ' ', delta: '1' }, 'TRY', 80)).toEqual({ problem: 'option_name' });
  });

  it('keeps the ticked groups in the order they were ticked', () => {
    expect(toggled(['a'], 'b', true)).toEqual(['a', 'b']);
    expect(toggled(['a', 'b'], 'a', false)).toEqual(['b']);
    expect(toggled(['a', 'b'], 'a', true)).toEqual(['b', 'a']);
  });
});
