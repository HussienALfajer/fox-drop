import { randomInt } from 'node:crypto';
import type {
  PromoCodeAudience,
  PromoCodeFunding,
  PromoCodeKind,
  PromoCodeStatus,
  PromoCodeVisibility,
} from './schema.js';

// The fields of a promo code an admin sets (AP §9.11.1), amounts in minor
// units of the city's base currency.
export interface PromoFields {
  kind: PromoCodeKind;
  percentBp: number | null;
  amount: bigint | null;
  maxDiscount: bigint | null;
  minOrder: bigint | null;
  validFrom: Date;
  validTo: Date;
  startMinute: number | null;
  endMinute: number | null;
  totalLimit: number | null;
  perCustomerLimit: number | null;
  audience: PromoCodeAudience;
  restaurantIds: string[];
  zoneIds: string[];
  funding: PromoCodeFunding;
  // The restaurant's share in basis points when shared; null otherwise.
  sharedMerchantBp: number | null;
  dailyBudget: bigint | null;
  visibility: PromoCodeVisibility;
}

export const CODE_PATTERN = /^[A-Z0-9]{3,20}$/;

// A typed code as stored: trimmed and upper-case.
export function normalizeCode(code: string): string {
  return code.trim().toUpperCase();
}

// What is wrong with the fields, in English for the log and the panel's
// fallback, or null. The panel checks the same before sending.
export function checkPromoFields(fields: PromoFields): string | null {
  const { kind } = fields;
  if (kind === 'percentage') {
    if (fields.percentBp === null || fields.percentBp < 1 || fields.percentBp > 10000) {
      return 'a percentage code needs a percentage from 0.01 to 100';
    }
    if (fields.amount !== null) return 'a percentage code has no fixed amount';
    if (fields.maxDiscount !== null && fields.maxDiscount <= 0n) return 'the cap must be above 0';
  } else if (kind === 'fixed_amount') {
    if (fields.amount === null || fields.amount <= 0n) return 'a fixed amount must be above 0';
    if (fields.percentBp !== null || fields.maxDiscount !== null) {
      return 'a fixed amount has no percentage or cap';
    }
  } else if (fields.percentBp !== null || fields.amount !== null || fields.maxDiscount !== null) {
    return 'a free-delivery code has no value or cap';
  }
  if (fields.minOrder !== null && fields.minOrder <= 0n) return 'the minimum order must be above 0';
  if (fields.dailyBudget !== null && fields.dailyBudget <= 0n) {
    return 'the daily budget must be above 0';
  }
  if (fields.validTo.getTime() <= fields.validFrom.getTime()) {
    return 'the end must come after the start';
  }
  if ((fields.startMinute === null) !== (fields.endMinute === null)) {
    return 'the hours need a start and an end';
  }
  if (fields.startMinute !== null && fields.startMinute === fields.endMinute) {
    return 'the hours cannot start and end at the same minute';
  }
  if (fields.totalLimit !== null && fields.totalLimit < 1) return 'the total limit must be above 0';
  if (fields.perCustomerLimit !== null && fields.perCustomerLimit < 1) {
    return 'the per-customer limit must be above 0';
  }
  if (
    fields.totalLimit !== null &&
    fields.perCustomerLimit !== null &&
    fields.perCustomerLimit > fields.totalLimit
  ) {
    return 'the per-customer limit cannot exceed the total limit';
  }
  if (fields.funding === 'shared') {
    if (
      fields.sharedMerchantBp === null ||
      fields.sharedMerchantBp < 1 ||
      fields.sharedMerchantBp > 9999
    ) {
      return "a shared code needs the restaurant's share between 0 and 100%";
    }
  } else if (fields.sharedMerchantBp !== null) {
    return 'only a shared code has a ratio';
  }
  // A restaurant pays its share on Saturday (AP §8.4), so it must be named.
  if (fields.funding !== 'platform' && fields.restaurantIds.length === 0) {
    return 'a code funded by restaurants names its restaurants';
  }
  if (new Set(fields.restaurantIds).size !== fields.restaurantIds.length) {
    return 'a restaurant is listed twice';
  }
  if (new Set(fields.zoneIds).size !== fields.zoneIds.length) return 'a zone is listed twice';
  return null;
}

// The restaurant's share kept on the code: 0, all of it, or the ratio.
export function merchantShareBp(fields: Pick<PromoFields, 'funding' | 'sharedMerchantBp'>): number {
  if (fields.funding === 'platform') return 0;
  if (fields.funding === 'restaurant') return 10000;
  return fields.sharedMerchantBp ?? 0;
}

// What the list shows: paused by OWN, not started, ended, or running.
export type PromoCodeState = 'active' | 'paused' | 'scheduled' | 'expired';

export function promoCodeState(
  code: { status: PromoCodeStatus; validFrom: Date; validTo: Date },
  now: Date,
): PromoCodeState {
  if (now.getTime() >= code.validTo.getTime()) return 'expired';
  if (code.status === 'paused') return 'paused';
  if (now.getTime() < code.validFrom.getTime()) return 'scheduled';
  return 'active';
}

// A generated batch's codes: the prefix and random characters that cannot be
// misread (no 0, O, 1, I or L), 8 of them so a guess almost never lands.
const ALPHABET = 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';
export const GENERATED_LENGTH = 8;

export function generatedCode(prefix: string): string {
  let code = prefix;
  for (let i = 0; i < GENERATED_LENGTH; i += 1) code += ALPHABET[randomInt(ALPHABET.length)];
  return code;
}

// The terms of a code an order keeps (its snapshot): what the discount is
// worked out from at placing and again after an edit (AP §9.3.3).
export interface CodeTerms {
  kind: PromoCodeKind;
  percentBp: number | null;
  amount: bigint | null;
  maxDiscount: bigint | null;
  // The restaurant's share in basis points (0 platform, 10000 restaurant).
  merchantShareBp: number;
  // A personal code (compensation, late code; slice 2.22b): its use costs
  // `platform.compensation_cost`, not `platform.discount_cost` (docs/domain/11).
  compensation: boolean;
}

// AP §8.4: the discount of a code on an order, and the restaurant's part of
// it. A percentage or a fixed amount discounts the items value and is capped
// at it (the rest of a fixed amount is lost); free delivery discounts the
// whole fee. A percentage and a shared code's split are rounded half up to
// the minor unit, as the commission is.
export interface PromoDiscount {
  total: bigint;
  // merchant_funded_discount: on the items (item) or the fee (delivery).
  merchant: bigint;
  onDelivery: boolean;
}

const half = (amount: bigint, bp: number) => (amount * BigInt(bp) + 5000n) / 10000n;

export function promoDiscount(
  terms: CodeTerms,
  money: { itemsValue: bigint; deliveryFee: bigint },
): PromoDiscount {
  const { itemsValue, deliveryFee } = money;
  let total: bigint;
  if (terms.kind === 'free_delivery') total = deliveryFee;
  else {
    let value =
      terms.kind === 'percentage' ? half(itemsValue, terms.percentBp ?? 0) : terms.amount!;
    if (terms.maxDiscount !== null && value > terms.maxDiscount) value = terms.maxDiscount;
    total = value > itemsValue ? itemsValue : value;
  }
  return {
    total,
    merchant: half(total, terms.merchantShareBp),
    onDelivery: terms.kind === 'free_delivery',
  };
}

// CU §10.4: «قيمة الكود أكبر من قيمة الأصناف، ولا يُستعاد الفرق».
export function fixedAmountAboveItems(terms: CodeTerms, itemsValue: bigint): boolean {
  return terms.kind === 'fixed_amount' && terms.amount! > itemsValue;
}

// CU Appendix C «Code refusals»: why a code does not apply to this cart.
export type CodeRefusal =
  // «الكود غير صحيح»
  | 'unknown_code'
  // «الكود غير صالح الآن»: paused, not started, ended, outside its hours,
  // or saved in a base the city no longer has.
  | 'not_valid_now'
  // «أضف {المبلغ} لاستخدام هذا الكود»
  | 'below_minimum'
  // «هذا الكود لا يعمل مع هذا المطعم»
  | 'not_for_restaurant'
  // «هذا الكود للطلب الأول فقط»
  | 'first_order_only'
  // «استخدمت هذا الكود من قبل»
  | 'used_before'
  // «انتهت استخدامات هذا الكود»
  | 'uses_ended'
  // «الكود غير متاح اليوم»
  | 'budget_reached';

export interface CodeRow extends Omit<CodeTerms, 'compensation'> {
  status: PromoCodeStatus;
  currency: string;
  minOrder: bigint | null;
  validFrom: Date;
  validTo: Date;
  startMinute: number | null;
  endMinute: number | null;
  totalLimit: number | null;
  perCustomerLimit: number | null;
  audience: PromoCodeAudience;
  restaurantIds: string[];
  zoneIds: string[];
  dailyBudget: bigint | null;
}

// What a code is checked against: the cart, the moment and the code's uses
// (the ones not given back).
export interface CodeContext {
  now: Date;
  // The minute of the day on the city's clock.
  minuteOfDay: number;
  baseCurrency: string;
  restaurantId: string;
  // The delivery point's zone; null outside the zones (the quote shows it).
  zoneId: string | null;
  itemsValue: bigint;
  // The signed-in customer; null for a guest, whose quote leaves the
  // audience and the per-customer limit to placing (CU §5.1).
  customer: {
    // AP §9.11.1, §8.8: no delivered order on any account of the number.
    newUser: boolean;
    // This account's uses of the code.
    uses: number;
    // A use of the code by the same number or the same device.
    phoneOrDeviceUsed: boolean;
  } | null;
  totalUses: number;
  // The business day's cost so far (owner decision 2026-11-16).
  dayCost: bigint;
}

export function codeRefusal(
  code: CodeRow,
  context: CodeContext,
): { refusal: CodeRefusal; missing: bigint | null } | null {
  const refuse = (refusal: CodeRefusal, missing: bigint | null = null) => ({ refusal, missing });
  const at = context.now.getTime();
  if (
    code.status === 'paused' ||
    at < code.validFrom.getTime() ||
    at >= code.validTo.getTime() ||
    code.currency !== context.baseCurrency ||
    !withinHours(code, context.minuteOfDay)
  ) {
    return refuse('not_valid_now');
  }
  if (
    (code.restaurantIds.length > 0 && !code.restaurantIds.includes(context.restaurantId)) ||
    (code.zoneIds.length > 0 && (context.zoneId === null || !code.zoneIds.includes(context.zoneId)))
  ) {
    return refuse('not_for_restaurant');
  }
  if (code.minOrder !== null && context.itemsValue < code.minOrder) {
    return refuse('below_minimum', code.minOrder - context.itemsValue);
  }
  const { customer } = context;
  if (
    code.audience === 'new_users' &&
    customer !== null &&
    (!customer.newUser || customer.phoneOrDeviceUsed)
  ) {
    return refuse('first_order_only');
  }
  if (
    code.perCustomerLimit !== null &&
    customer !== null &&
    customer.uses >= code.perCustomerLimit
  ) {
    return refuse('used_before');
  }
  if (code.totalLimit !== null && context.totalUses >= code.totalLimit) {
    return refuse('uses_ended');
  }
  if (code.dailyBudget !== null && context.dayCost >= code.dailyBudget) {
    return refuse('budget_reached');
  }
  return null;
}

// The optional hours on the city's clock; an end at or before the start
// runs past midnight.
function withinHours(code: Pick<CodeRow, 'startMinute' | 'endMinute'>, minute: number): boolean {
  const { startMinute: start, endMinute: end } = code;
  if (start === null || end === null) return true;
  return start < end ? minute >= start && minute < end : minute >= start || minute < end;
}

// The minute of the day a city's clock shows at an instant.
export function minuteOfDay(instant: Date, timeZone: string): number {
  const parts = Object.fromEntries(
    new Intl.DateTimeFormat('en-US', {
      timeZone,
      hour: '2-digit',
      minute: '2-digit',
      hourCycle: 'h23',
    })
      .formatToParts(instant)
      .map((part) => [part.type, part.value]),
  );
  return Number(parts.hour) * 60 + Number(parts.minute);
}

// CU §10.4 «الأكواد المتاحة لك» (slice 2.21d): a visible code running in the
// city with what it gives this cart, or what its minimum still lacks.
export interface AvailableCode {
  codeId: string;
  code: string;
  kind: PromoCodeKind;
  percentBp: number | null;
  amount: bigint | null;
  maxDiscount: bigint | null;
  minOrder: bigint | null;
  // The hours on the city clock, both or neither.
  startMinute: number | null;
  endMinute: number | null;
  validTo: Date;
  // null while below its minimum.
  discount: PromoDiscount | null;
  // «أضف {المبلغ} لاستخدام هذا الكود»; null when it applies.
  missing: bigint | null;
}

// Q19: «لديك كود يوفر عليك {المبلغ}: {الكود}», the available code with the
// largest discount on the cart, when it gives more than the code applied.
// It is never applied by itself (U11).
export function suggestedCode(
  available: readonly AvailableCode[],
  applied: { code: string; discount: bigint } | null,
): { code: string; discount: bigint } | null {
  let best: { code: string; discount: bigint } | null = null;
  for (const entry of available) {
    const total = entry.discount?.total ?? 0n;
    if (entry.code === applied?.code || total <= (applied?.discount ?? 0n)) continue;
    if (best === null || total > best.discount) best = { code: entry.code, discount: total };
  }
  return best;
}

// CU §12.4 «أكوادي» (slice 2.21d): whether a customer may still use a code,
// whatever the cart: its audience, their uses and the total left. The cart's
// own rules (restaurants, zones, minimum, hours, the day's budget) wait for
// checkout.
export function openToCustomer(
  code: Pick<CodeRow, 'audience' | 'perCustomerLimit' | 'totalLimit'>,
  uses: { newUser: boolean; mine: number; phoneOrDeviceUsed: boolean; total: number },
): boolean {
  if (code.audience === 'new_users' && (!uses.newUser || uses.phoneOrDeviceUsed)) return false;
  if (code.perCustomerLimit !== null && uses.mine >= code.perCustomerLimit) return false;
  return code.totalLimit === null || uses.total < code.totalLimit;
}

// A code in «أكوادي»: «متاحة» while `ended` is null, else «منتهية», used or
// expired within the last 30 days (fixed).
export interface MyCode {
  codeId: string;
  code: string;
  kind: PromoCodeKind;
  percentBp: number | null;
  amount: bigint | null;
  maxDiscount: bigint | null;
  minOrder: bigint | null;
  restaurantIds: string[];
  zoneIds: string[];
  startMinute: number | null;
  endMinute: number | null;
  validTo: Date;
  // What this customer has left of their per-customer limit; null: no limit.
  usesLeft: number | null;
  ended: { reason: 'used' | 'expired'; at: Date } | null;
}

export const ENDED_CODES_DAYS = 30;

// CU §12.4: a visible or personal code customers can use now, whatever the
// cart: active, started, not ended and saved in the city's base. With
// `openToCustomer` it is in «متاحة»; a personal code is read only for its
// customer (slice 2.22b).
export function runsNow(
  code: Pick<CodeRow, 'status' | 'validFrom' | 'validTo' | 'currency'> & {
    visibility: PromoCodeVisibility;
  },
  baseCurrency: string,
  now: Date,
): boolean {
  return (
    code.visibility !== 'secret' &&
    code.status === 'active' &&
    code.currency === baseCurrency &&
    code.validFrom.getTime() <= now.getTime() &&
    code.validTo.getTime() > now.getTime()
  );
}
