// AP §9.6.3 step 8, the activation checklist (slice 2.30b): the pure rule of
// which items are met, from facts the activation service reads.

// What the checklist reads of a restaurant.
export interface ChecklistFacts {
  // The pin and the operations of steps 2 and 3 (a draft may lack them).
  record: boolean;
  // «Commission set by OWN» (step 4).
  commission: boolean;
  // «Contract and price-parity pledge confirmed» (step 5).
  contract: boolean;
  // «Hours set»: a period in the schedule in force.
  hours: boolean;
  // Visible categories with a visible item switched on.
  categoriesWithAvailableItems: number;
  // The visible items of visible categories, and those with a photo.
  items: number;
  itemsWithPhoto: number;
  // OWN's waiver of the image rule.
  imagesWaived: boolean;
  // Owner accounts not removed (step 6).
  ownerAccounts: number;
  // Test orders delivered.
  deliveredTestOrders: number;
}

export const checklistCodes = [
  'record',
  'commission',
  'contract',
  'hours',
  'menu',
  'menu_images',
  'owner_account',
  'device_check',
  'test_order',
] as const;
export type ChecklistCode = (typeof checklistCodes)[number];

// `waived` is the image rule under OWN's waiver; `not_available` the device
// check until 2.42 makes it required (owner decision 2026-11-18): shown,
// never blocking.
export const checklistStates = ['met', 'missing', 'waived', 'not_available'] as const;
export type ChecklistState = (typeof checklistStates)[number];

export interface Checklist {
  items: { code: ChecklistCode; state: ChecklistState }[];
  // «تشغيل الوضع التجريبي»: every item but the test order, which needs test
  // mode (decided by us).
  canStartTest: boolean;
  // «تفعيل وإظهار للزبائن»: every item.
  canActivate: boolean;
}

// The share of items with a photo the rule asks for (AP §9.6.3: «fixed»).
export const MENU_IMAGES_PCT = 80;

export function activationChecklist(facts: ChecklistFacts): Checklist {
  const met = (yes: boolean): ChecklistState => (yes ? 'met' : 'missing');
  const imagesMet = facts.items > 0 && facts.itemsWithPhoto * 100 >= facts.items * MENU_IMAGES_PCT;
  const states: Record<ChecklistCode, ChecklistState> = {
    record: met(facts.record),
    commission: met(facts.commission),
    contract: met(facts.contract),
    hours: met(facts.hours),
    menu: met(facts.categoriesWithAvailableItems > 0),
    menu_images: imagesMet ? 'met' : facts.items > 0 && facts.imagesWaived ? 'waived' : 'missing',
    owner_account: met(facts.ownerAccounts > 0),
    device_check: 'not_available',
    test_order: met(facts.deliveredTestOrders > 0),
  };
  const items = checklistCodes.map((code) => ({ code, state: states[code] }));
  const done = (code: ChecklistCode) => states[code] !== 'missing';
  return {
    items,
    canStartTest: checklistCodes.every((code) => code === 'test_order' || done(code)),
    canActivate: checklistCodes.every(done),
  };
}
