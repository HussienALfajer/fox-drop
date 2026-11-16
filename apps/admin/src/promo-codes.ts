import type { components } from '@fox-drop/api-schema';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { useRef } from 'react';
import { api } from './api.js';
import { zonedToUtc } from './emergency-stop.js';
import { decimalOf, minorOf } from './format.js';
import { minuteOf, timeOf } from './peak-bonus.js';
import { type AdminSession, can } from './session.js';

// AP §6: OWN manages the codes, OPS reads them, FIN reads them with their
// cost.
export const MARKETING_PERMISSIONS = [
  'marketing.read',
  'marketing.read_costs',
  'marketing.manage',
] as const;

export function canSeePromoCodes(session: AdminSession | null | undefined): boolean {
  return MARKETING_PERMISSIONS.some((permission) => can(session, permission));
}

export type PromoCodes = components['schemas']['AdminPromoCodesDto_Output'];
export type PromoCode = PromoCodes['codes'][number];
type CreateBody = components['schemas']['AdminCreatePromoCodeDto'];
type GenerateBody = components['schemas']['AdminGeneratePromoCodesDto'];
type EditBody = components['schemas']['AdminEditPromoCodeDto'];
export type PromoKind = PromoCode['kind'];
export type PromoAudience = PromoCode['audience'];
export type PromoFunding = PromoCode['funding'];
export type PromoVisibility = PromoCode['visibility'];
export type PromoState = PromoCode['state'];
type Fields = Omit<EditBody, 'cityId'>;

export const KINDS = [
  'percentage',
  'fixed_amount',
  'free_delivery',
] as const satisfies readonly PromoKind[];
export const AUDIENCES = ['everyone', 'new_users'] as const satisfies readonly PromoAudience[];
export const FUNDINGS = [
  'platform',
  'restaurant',
  'shared',
] as const satisfies readonly PromoFunding[];
export const VISIBILITIES = ['visible', 'secret'] as const satisfies readonly PromoVisibility[];

// The form as typed: amounts in major units, the percentage and the
// restaurant's share as percents, the dates as the city's wall time
// («2026-12-01T00:00»), the hours as «20:00», empty for none.
export interface PromoForm {
  mode: 'typed' | 'batch';
  code: string;
  count: string;
  prefix: string;
  kind: PromoKind;
  percent: string;
  amount: string;
  maxDiscount: string;
  minOrder: string;
  validFrom: string;
  validTo: string;
  start: string;
  end: string;
  totalLimit: string;
  perCustomerLimit: string;
  audience: PromoAudience;
  restaurantIds: string[];
  zoneIds: string[];
  funding: PromoFunding;
  sharedPercent: string;
  dailyBudget: string;
  visibility: PromoVisibility;
}

export const emptyForm: PromoForm = {
  mode: 'typed',
  code: '',
  count: '',
  prefix: '',
  kind: 'percentage',
  percent: '',
  amount: '',
  maxDiscount: '',
  minOrder: '',
  validFrom: '',
  validTo: '',
  start: '',
  end: '',
  totalLimit: '',
  perCustomerLimit: '1',
  audience: 'everyone',
  restaurantIds: [],
  zoneIds: [],
  funding: 'platform',
  sharedPercent: '',
  dailyBudget: '',
  visibility: 'visible',
};

// Basis points as a percent («20», «12.5») and back.
export function percentText(bp: number): string {
  return String(bp / 100);
}

export function basisPointsOf(typed: string): number | null {
  const match = /^(\d{1,3})(?:\.(\d{1,2}))?$/.exec(typed.trim());
  if (!match) return null;
  return Number(match[1]) * 100 + Number((match[2] ?? '').padEnd(2, '0'));
}

// An instant as the city's wall time, for a datetime-local input.
export function utcToZoned(at: string, timeZone: string): string {
  const parts = Object.fromEntries(
    new Intl.DateTimeFormat('en-US', {
      timeZone,
      hourCycle: 'h23',
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
      hour: '2-digit',
      minute: '2-digit',
    })
      .formatToParts(new Date(at))
      .map((part) => [part.type, part.value]),
  );
  return `${parts.year}-${parts.month}-${parts.day}T${parts.hour}:${parts.minute}`;
}

// The form of a saved code, to edit it.
export function formOfCode(code: PromoCode, timeZone: string): PromoForm {
  const major = (minor: string | null) => (minor === null ? '' : decimalOf(minor, code.currency));
  return {
    mode: 'typed',
    code: code.code,
    count: '',
    prefix: '',
    kind: code.kind,
    percent: code.percentBp === null ? '' : percentText(code.percentBp),
    amount: major(code.amount),
    maxDiscount: major(code.maxDiscount),
    minOrder: major(code.minOrder),
    validFrom: utcToZoned(code.validFrom, timeZone),
    validTo: utcToZoned(code.validTo, timeZone),
    start: code.startMinute === null ? '' : timeOf(code.startMinute),
    end: code.endMinute === null ? '' : timeOf(code.endMinute),
    totalLimit: code.totalLimit === null ? '' : String(code.totalLimit),
    perCustomerLimit: code.perCustomerLimit === null ? '' : String(code.perCustomerLimit),
    audience: code.audience,
    restaurantIds: [...code.restaurantIds],
    zoneIds: [...code.zoneIds],
    funding: code.funding,
    sharedPercent: code.sharedMerchantBp === null ? '' : percentText(code.sharedMerchantBp),
    dailyBudget: major(code.dailyBudget),
    visibility: code.visibility,
  };
}

export type FormProblem =
  | 'code'
  | 'count'
  | 'prefix'
  | 'percent'
  | 'amount'
  | 'money'
  | 'dates'
  | 'hours'
  | 'limits'
  | 'share'
  | 'restaurants';

// The fields to send, or the first problem; the server checks them again.
export function fieldsOf(
  form: PromoForm,
  currency: string,
  timeZone: string,
): { fields: Fields } | { problem: FormProblem } {
  // An optional amount: empty is none; anything else above zero.
  const optional = (typed: string): string | null | false => {
    if (typed.trim() === '') return null;
    const minor = minorOf(typed, currency);
    return minor === null || /^0+$/.test(minor) ? false : minor;
  };
  const whole = (typed: string): number | null | false => {
    if (typed.trim() === '') return null;
    return /^\d{1,7}$/.test(typed.trim()) && Number(typed) > 0 ? Number(typed) : false;
  };
  let percentBp: number | null = null;
  let amount: string | null = null;
  let maxDiscount: string | null = null;
  if (form.kind === 'percentage') {
    percentBp = basisPointsOf(form.percent);
    if (percentBp === null || percentBp < 1 || percentBp > 10000) return { problem: 'percent' };
    const cap = optional(form.maxDiscount);
    if (cap === false) return { problem: 'money' };
    maxDiscount = cap;
  } else if (form.kind === 'fixed_amount') {
    const fixed = optional(form.amount);
    if (fixed === false || fixed === null) return { problem: 'amount' };
    amount = fixed;
  }
  const minOrder = optional(form.minOrder);
  const dailyBudget = optional(form.dailyBudget);
  if (minOrder === false || dailyBudget === false) return { problem: 'money' };
  const validFrom = zonedToUtc(form.validFrom, timeZone);
  const validTo = zonedToUtc(form.validTo, timeZone);
  if (validFrom === null || validTo === null || validTo <= validFrom) return { problem: 'dates' };
  let startMinute: number | null = null;
  let endMinute: number | null = null;
  if (form.start.trim() !== '' || form.end.trim() !== '') {
    startMinute = minuteOf(form.start);
    endMinute = minuteOf(form.end);
    if (startMinute === null || endMinute === null || startMinute === endMinute) {
      return { problem: 'hours' };
    }
  }
  const totalLimit = whole(form.totalLimit);
  const perCustomerLimit = whole(form.perCustomerLimit);
  if (
    totalLimit === false ||
    perCustomerLimit === false ||
    (totalLimit !== null && perCustomerLimit !== null && perCustomerLimit > totalLimit)
  ) {
    return { problem: 'limits' };
  }
  let sharedMerchantBp: number | null = null;
  if (form.funding === 'shared') {
    sharedMerchantBp = basisPointsOf(form.sharedPercent);
    if (sharedMerchantBp === null || sharedMerchantBp < 1 || sharedMerchantBp > 9999) {
      return { problem: 'share' };
    }
  }
  if (form.funding !== 'platform' && form.restaurantIds.length === 0) {
    return { problem: 'restaurants' };
  }
  return {
    fields: {
      kind: form.kind,
      percentBp,
      amount,
      maxDiscount,
      minOrder,
      validFrom,
      validTo,
      startMinute,
      endMinute,
      totalLimit,
      perCustomerLimit,
      audience: form.audience,
      restaurantIds: form.restaurantIds,
      zoneIds: form.zoneIds,
      funding: form.funding,
      sharedMerchantBp,
      dailyBudget,
      visibility: form.visibility,
    },
  };
}

export type CreateRequest =
  { mode: 'typed'; body: CreateBody } | { mode: 'batch'; body: GenerateBody };

// What «إنشاء» sends: one typed code or a batch.
export function createRequestOf(
  form: PromoForm,
  cityId: string,
  currency: string,
  timeZone: string,
): CreateRequest | { problem: FormProblem } {
  const checked = fieldsOf(form, currency, timeZone);
  if ('problem' in checked) return checked;
  if (form.mode === 'typed') {
    const code = form.code.trim();
    if (!/^[A-Za-z0-9]{3,20}$/.test(code)) return { problem: 'code' };
    return { mode: 'typed', body: { cityId, code, ...checked.fields } };
  }
  const count = Number(form.count.trim());
  if (!/^\d{1,3}$/.test(form.count.trim()) || count < 2 || count > 500) {
    return { problem: 'count' };
  }
  const prefix = form.prefix.trim();
  if (!/^[A-Za-z0-9]{0,8}$/.test(prefix)) return { problem: 'prefix' };
  return { mode: 'batch', body: { cityId, count, prefix, ...checked.fields } };
}

// The value as the list shows it: «20% (حتى 50)», «30», or none for free
// delivery (its type says it).
export function valueOf(
  code: PromoCode,
): { percent: string; cap: string | null } | { amount: string } | null {
  if (code.kind === 'percentage') {
    return {
      percent: percentText(code.percentBp ?? 0),
      cap: code.maxDiscount,
    };
  }
  if (code.kind === 'fixed_amount') return { amount: code.amount ?? '0' };
  return null;
}

const codesKey = (cityId: string) => ['promo-codes', cityId] as const;

export function usePromoCodes(cityId: string | undefined) {
  return useQuery({
    queryKey: codesKey(cityId ?? ''),
    enabled: cityId !== undefined,
    queryFn: async (): Promise<PromoCodes> => {
      const { data } = await api.GET('/v1/admin/promo-codes', {
        params: { query: { cityId: cityId! } },
      });
      if (!data) throw new Error('The promo codes read failed.');
      return data;
    },
  });
}

export const promoRefusals = [
  'invalid_promo_code',
  'code_taken',
  'no_base_currency',
  'unknown_promo_code',
] as const;
export type PromoRefusal = (typeof promoRefusals)[number];

export type SaveResult =
  { status: 'saved'; codes: PromoCode[] } | { status: 'refused'; refusal: PromoRefusal };

function refusalOf(status: number, error: unknown): PromoRefusal | null {
  const refusal = (error as { error?: unknown } | undefined)?.error;
  if (status !== 400 && status !== 404 && status !== 409) return null;
  return (promoRefusals as readonly unknown[]).includes(refusal) ? (refusal as PromoRefusal) : null;
}

// One Idempotency-Key per request until an answer arrives (architecture
// §5.3), so a retry after a lost answer never creates the codes twice.
export function useCreatePromoCodes(cityId: string) {
  const queryClient = useQueryClient();
  const keys = useRef(new Map<string, string>());
  return useMutation({
    mutationFn: async (request: CreateRequest): Promise<SaveResult> => {
      const id = JSON.stringify(request);
      let key = keys.current.get(id);
      if (key === undefined) {
        key = crypto.randomUUID();
        keys.current.set(id, key);
      }
      const header = { 'Idempotency-Key': key };
      const { data, error, response } =
        request.mode === 'typed'
          ? await api.POST('/v1/admin/promo-codes', { body: request.body, params: { header } })
          : await api.POST('/v1/admin/promo-codes/batch', {
              body: request.body,
              params: { header },
            });
      if (data) {
        keys.current.delete(id);
        await queryClient.invalidateQueries({ queryKey: codesKey(cityId) });
        return { status: 'saved', codes: data.codes };
      }
      const refusal = refusalOf(response.status, error);
      if (refusal) {
        keys.current.delete(id);
        return { status: 'refused', refusal };
      }
      throw new Error(`Creating promo codes failed with ${response.status}.`);
    },
  });
}

// Sets a code's fields, so no key.
export function useEditPromoCode(cityId: string) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async ({
      codeId,
      fields,
    }: {
      codeId: string;
      fields: Fields;
    }): Promise<SaveResult> => {
      const { data, error, response } = await api.PUT('/v1/admin/promo-codes/{codeId}', {
        params: { path: { codeId } },
        body: { cityId, ...fields },
      });
      if (data) {
        await queryClient.invalidateQueries({ queryKey: codesKey(cityId) });
        return { status: 'saved', codes: [data] };
      }
      const refusal = refusalOf(response.status, error);
      if (refusal) return { status: 'refused', refusal };
      throw new Error(`Editing a promo code failed with ${response.status}.`);
    },
  });
}

// Pauses or resumes a code; the same again changes nothing, so no key.
export function useSetPromoCodeStatus(cityId: string) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async ({ codeId, pause }: { codeId: string; pause: boolean }) => {
      const options = { params: { path: { codeId } }, body: { cityId } };
      const { data, response } = pause
        ? await api.POST('/v1/admin/promo-codes/{codeId}/pause', options)
        : await api.POST('/v1/admin/promo-codes/{codeId}/resume', options);
      if (!data) throw new Error(`Changing a promo code failed with ${response.status}.`);
      await queryClient.invalidateQueries({ queryKey: codesKey(cityId) });
      return data;
    },
  });
}
