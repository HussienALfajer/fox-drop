import { describe, expect, it } from 'vitest';
import { activationChecklist, type ChecklistFacts } from './activation-checklist.js';

// AP §9.6.3 step 8: «All items are required»; the device check since 2.42
// (RA §4.5: before the activation).
const ready: ChecklistFacts = {
  record: true,
  commission: true,
  contract: true,
  hours: true,
  categoriesWithAvailableItems: 1,
  items: 10,
  itemsWithPhoto: 8,
  imagesWaived: false,
  ownerAccounts: 1,
  passedDeviceChecks: 1,
  deliveredTestOrders: 1,
};

const state = (facts: ChecklistFacts, code: string) =>
  activationChecklist(facts).items.find((item) => item.code === code)?.state;

describe('the activation checklist', () => {
  it('lists every item in order', () => {
    const checklist = activationChecklist(ready);
    expect(checklist.items.map((item) => [item.code, item.state])).toEqual([
      ['record', 'met'],
      ['commission', 'met'],
      ['contract', 'met'],
      ['hours', 'met'],
      ['menu', 'met'],
      ['menu_images', 'met'],
      ['owner_account', 'met'],
      ['device_check', 'met'],
      ['test_order', 'met'],
    ]);
    expect(checklist).toMatchObject({ canStartTest: true, canActivate: true });
  });

  it('needs images on 80% of the items, which OWN can waive', () => {
    expect(state({ ...ready, itemsWithPhoto: 7 }, 'menu_images')).toBe('missing');
    expect(state({ ...ready, items: 5, itemsWithPhoto: 4 }, 'menu_images')).toBe('met');
    expect(state({ ...ready, itemsWithPhoto: 0, imagesWaived: true }, 'menu_images')).toBe(
      'waived',
    );
    expect(activationChecklist({ ...ready, itemsWithPhoto: 0, imagesWaived: true })).toMatchObject({
      canActivate: true,
    });
    expect(activationChecklist({ ...ready, itemsWithPhoto: 7 })).toMatchObject({
      canStartTest: false,
      canActivate: false,
    });
    // No item: the menu is missing and so are its images.
    expect(state({ ...ready, items: 0, itemsWithPhoto: 0 }, 'menu_images')).toBe('missing');
  });

  it('starts test mode with everything but the test order, and activates only after it', () => {
    const before = activationChecklist({ ...ready, deliveredTestOrders: 0 });
    expect(before).toMatchObject({ canStartTest: true, canActivate: false });
    expect(state({ ...ready, deliveredTestOrders: 0 }, 'test_order')).toBe('missing');
  });

  it('needs a device that passed its check to activate, not to start test mode', () => {
    expect(state({ ...ready, passedDeviceChecks: 0 }, 'device_check')).toBe('missing');
    expect(activationChecklist({ ...ready, passedDeviceChecks: 0 })).toMatchObject({
      canStartTest: true,
      canActivate: false,
    });
  });

  it('names each missing item', () => {
    for (const [code, facts] of [
      ['record', { record: false }],
      ['commission', { commission: false }],
      ['contract', { contract: false }],
      ['hours', { hours: false }],
      ['menu', { categoriesWithAvailableItems: 0 }],
      ['owner_account', { ownerAccounts: 0 }],
    ] as const) {
      const checklist = activationChecklist({ ...ready, ...facts });
      expect(state({ ...ready, ...facts }, code)).toBe('missing');
      expect(checklist).toMatchObject({ canStartTest: false, canActivate: false });
    }
  });
});
