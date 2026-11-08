// The reason lists of AP §9.13 «قوائم الأسباب» and «الملاحظات الجاهزة», with
// the customer-facing texts of «نصوص الأسباب للزبون» (CU Appendix C). Their
// defaults are rows of content.reasons, seeded by the migration from AP
// Appendix B; this catalogue says which lists exist and how each behaves.
//
// - apps: the apps that read the list (`GET /v1/<app>/content`); a list
//   without an app is the panel's own (operations' choices).
// - customerText: each reason may carry the text the customer sees.
// - closed: no reason can be added, since each one has a behaviour of its own
//   in the code (a restaurant rejection that pauses the restaurant, an outcome).
export type ContentApp = 'merchant' | 'captain' | 'customer';

interface ReasonListDefinition {
  apps: readonly ContentApp[];
  customerText?: true;
  closed?: true;
}

export const reasonLists = {
  merchant_rejection: { apps: ['merchant'], customerText: true, closed: true },
  merchant_problem: { apps: ['merchant'] },
  item_unavailable_note: { apps: ['merchant'] },
  merchant_ticket_type: { apps: ['merchant'] },
  captain_cannot_complete: { apps: ['captain'] },
  captain_away: { apps: ['captain'] },
  shortfall: { apps: ['captain'] },
  food_after_failed: { apps: ['captain'], closed: true },
  captain_ticket_type: { apps: ['captain'] },
  captain_problem: { apps: ['captain'] },
  customer_cancel: { apps: ['customer'] },
  customer_problem: { apps: ['customer'] },
  order_note: { apps: ['customer'] },
  restaurant_rating_low: { apps: ['customer'] },
  restaurant_rating_mid: { apps: ['customer'] },
  restaurant_rating_high: { apps: ['customer'] },
  captain_rating_low: { apps: ['customer'] },
  captain_rating_mid: { apps: ['customer'] },
  captain_rating_high: { apps: ['customer'] },
  ops_cancel: { apps: [], customerText: true },
  reassignment: { apps: [] },
  captain_suspension: { apps: [] },
  customer_block: { apps: [], customerText: true },
  emergency_stop: { apps: [] },
  // Not chosen by anyone: the texts the customer sees for an order that
  // failed (AP §8.9) and for the automatic cancellation (AP §8.3).
  failed_outcome: { apps: [], customerText: true, closed: true },
  system_cancellation: { apps: [], customerText: true, closed: true },
} as const satisfies Record<string, ReasonListDefinition>;

export type ReasonList = keyof typeof reasonLists;

export const reasonListNames = Object.keys(reasonLists) as ReasonList[];

export function listDefinition(list: ReasonList): ReasonListDefinition {
  return reasonLists[list];
}

export function isReasonList(value: string): value is ReasonList {
  return Object.hasOwn(reasonLists, value);
}

// CU Appendix C: a reason without a customer text shows this apology.
export const GENERIC_CUSTOMER_TEXT = 'نعتذر، لم نتمكن من إكمال طلبك';

// Whether a choice takes a note (AP Appendix B «أخرى» with its text, CU
// §11.5 «سبب آخر» with an optional one, CU §12.2 a problem's optional note).
export const noteModes = ['none', 'optional', 'required'] as const;
export type NoteMode = (typeof noteModes)[number];

// The FAQ sets of AP §9.13, one per audience.
export const faqAudiences = ['customer', 'captain', 'merchant'] as const;
export type FaqAudience = (typeof faqAudiences)[number];

// The longest texts the panel may store.
export const LABEL_MAX = 100;
export const CUSTOMER_TEXT_MAX = 300;
// The longest note any flow takes (CU §12.2); a flow may take less, such as
// the captain's 200 characters.
export const NOTE_MAX = 300;
export const FAQ_MAX_ITEMS = 50;
export const QUESTION_MAX = 200;
export const ANSWER_MAX = 2000;
export const WORK_RULES_MAX = 10_000;

// AP §9.13 «الشروط والخصوصية»: one document per audience.
export const termsAudiences = ['customer', 'captain', 'merchant'] as const;
export type TermsAudience = (typeof termsAudiences)[number];
export const TERMS_MAX = 20_000;
