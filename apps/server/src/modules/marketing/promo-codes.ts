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
