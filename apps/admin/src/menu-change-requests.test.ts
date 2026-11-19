import { describe, expect, it, vi } from 'vitest';

vi.mock('./api.js', () => ({ api: {} }));

const { ageHours, approvalOf, canReviewMenuChanges, changeKind, correctable, itemAfter } =
  await import('./menu-change-requests.js');

const session = (permissions: string[]) => ({ permissions }) as never;
const values = {
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
};
const view = (over: object) =>
  ({
    id: 'r',
    restaurantId: 'x',
    restaurantName: 'مطعم',
    targetType: 'item',
    targetId: 'i',
    field: 'name',
    targetName: 'شاورما',
    createdAt: '2026-11-19T08:00:00Z',
    status: 'pending',
    before: { ...values, name: 'شاورما' },
    after: { ...values, name: 'شاورما دجاج' },
    parentName: 'وجبات',
    item: {
      name: 'شاورما',
      description: 'مع ثوم',
      photoKey: 'menu/items/a.jpg',
      price: { amount: '10000', currency: 'TRY' },
    },
    itemNames: [],
    ...over,
  }) as never;

// AP §9.6.7, AP §6.2, RA §9.5 (slice 2.32b): «طلبات تعديل القائمة».
describe('the review of the menu change requests', () => {
  it('belongs to menus.review_change_requests (OWN, OPS)', () => {
    expect(canReviewMenuChanges(session(['menus.review_change_requests']))).toBe(true);
    expect(canReviewMenuChanges(session(['restaurants.menus']))).toBe(false);
    expect(canReviewMenuChanges(null)).toBe(false);
  });

  it('names each kind of change, and none it does not know', () => {
    expect(changeKind({ targetType: 'option_group', field: 'choices' })).toBe(
      'menuChanges.kind.option_group.choices',
    );
    expect(changeKind({ targetType: 'category', field: 'photo' })).toBeNull();
  });

  it('counts the age in whole hours', () => {
    const now = new Date('2026-11-20T09:30:00Z');
    expect(ageHours('2026-11-19T08:00:00Z', now)).toBe(25);
    expect(ageHours('2026-11-20T09:40:00Z', now)).toBe(0);
  });

  it('corrects only the text a request asks', () => {
    expect(correctable({ targetType: 'item', field: 'created' })).toEqual({
      name: true,
      description: true,
    });
    expect(correctable({ targetType: 'category', field: 'created' })).toEqual({
      name: true,
      description: false,
    });
    expect(correctable({ targetType: 'item', field: 'photo' })).toEqual({
      name: false,
      description: false,
    });
    expect(
      approvalOf(
        { targetType: 'item', field: 'name' },
        { name: ' شاورما عربي ', description: 'x' },
      ),
    ).toEqual({ kind: 'approve', name: 'شاورما عربي' });
    expect(
      approvalOf({ targetType: 'item', field: 'photo' }, { name: 'x', description: '' }),
    ).toEqual({ kind: 'approve' });
  });

  it('previews the item as customers will see it, the correction last', () => {
    expect(itemAfter(view({}), { name: '', description: '' })).toEqual({
      name: 'شاورما دجاج',
      description: 'مع ثوم',
      photoKey: 'menu/items/a.jpg',
      price: { amount: '10000', currency: 'TRY' },
    });
    expect(itemAfter(view({}), { name: 'شاورما عربي', description: '' })?.name).toBe('شاورما عربي');
    const photo = view({
      field: 'photo',
      before: { ...values, photoKey: 'menu/items/a.jpg' },
      after: { ...values, photoKey: 'menu/items/b.jpg' },
    });
    expect(itemAfter(photo, { name: '', description: '' })?.photoKey).toBe('menu/items/b.jpg');
    const created = view({
      field: 'created',
      before: null,
      item: null,
      after: {
        ...values,
        name: 'كنافه',
        description: 'بالجبنة',
        price: { amount: '7500', currency: 'TRY' },
      },
    });
    expect(itemAfter(created, { name: 'كنافة', description: '' })).toEqual({
      name: 'كنافة',
      description: 'بالجبنة',
      photoKey: null,
      price: { amount: '7500', currency: 'TRY' },
    });
    expect(itemAfter(view({ targetType: 'category' }), { name: '', description: '' })).toBeNull();
  });
});
