import type { components } from '@fox-drop/api-schema';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { useRef } from 'react';
import { api } from './api.js';
import type { CashLine } from './cash-desk.js';
import { zonedToUtc } from './emergency-stop.js';
import { minorOf } from './format.js';

// AP §6.2, §9.8: who reads the customers (OWN, OPS, SUP, FIN), who blocks
// (OWN, OPS) and who records a dues payment at the desk (OWN, FIN).
export const CUSTOMERS_READ = 'customers.read';
export const CUSTOMERS_BLOCK = 'customers.block';
export const CASH_DESK_RECORD = 'cash_desk.record';

export type FoundCustomer =
  components['schemas']['AdminCustomersFoundDto_Output']['customers'][number];
export type CustomerProfile = components['schemas']['AdminCustomerDto_Output'];
export type CustomerStatus = CustomerProfile['status'];
export type BlockKind = components['schemas']['AdminBlockCustomerDto']['kind'];
type BlockBody = components['schemas']['AdminBlockCustomerDto'];
export type DuesPreview = components['schemas']['AdminCustomerDuesPreviewDto_Output'];
export type CustomerReceipt = components['schemas']['AdminCustomerReceiptDto_Output'];

// AP §9.8 «الحالة», keyed by the API's statuses.
export const statusKeys = {
  active: 'customers.status.active',
  blocked: 'customers.status.blocked',
  dues_unpaid: 'customers.status.dues_unpaid',
  review_stop: 'customers.status.review_stop',
} as const satisfies Record<CustomerStatus, string>;

export const BLOCK_KINDS = ['until', 'indefinite', 'dues'] as const satisfies readonly BlockKind[];
export const blockKindKeys = {
  until: 'customers.block.kind.until',
  indefinite: 'customers.block.kind.indefinite',
  dues: 'customers.block.kind.dues',
} as const satisfies Record<BlockKind, string>;

export interface BlockForm {
  kind: BlockKind;
  // «حتى»: the city's wall time, as a datetime-local input gives it.
  until: string;
  // The dues amount in the base currency's major units.
  amount: string;
  reason: string;
  note: string;
}

// The block's body once the form fits its kind, else the first problem.
export function blockBodyOf(
  cityId: string,
  form: BlockForm,
  city: { timeZone: string; currency: string | null },
  now: Date,
):
  | { status: 'ready'; body: BlockBody }
  | { status: 'problem'; problem: 'until' | 'amount' | 'reason' | 'note' } {
  if (form.reason === '') return { status: 'problem', problem: 'reason' };
  const note = form.note.trim();
  if (note === '') return { status: 'problem', problem: 'note' };
  const base = { cityId, kind: form.kind, until: null, amount: null, reason: form.reason, note };
  switch (form.kind) {
    case 'until': {
      const until = form.until === '' ? null : zonedToUtc(form.until, city.timeZone);
      if (until === null || new Date(until).getTime() <= now.getTime()) {
        return { status: 'problem', problem: 'until' };
      }
      return { status: 'ready', body: { ...base, until } };
    }
    case 'indefinite':
      return { status: 'ready', body: base };
    case 'dues': {
      const amount = city.currency === null ? null : minorOf(form.amount.trim(), city.currency);
      if (amount === null || /^0+$/.test(amount)) return { status: 'problem', problem: 'amount' };
      return { status: 'ready', body: { ...base, amount } };
    }
  }
}

// The birthday as AP §4.7 writes dates, dd/mm/yyyy, from the API's
// yyyy-mm-dd.
export function birthdayText(birthday: string): string {
  const [year, month, day] = birthday.split('-');
  return `${day}/${month}/${year}`;
}

// The cash typed per currency of the drawer, in major units: empty fields
// and zeros left out.
export function duesLinesOf(
  typed: Readonly<Record<string, string>>,
  currencies: readonly string[],
):
  | { status: 'lines'; lines: CashLine[] }
  | { status: 'invalid'; currency: string }
  | {
      status: 'empty';
    } {
  const lines: CashLine[] = [];
  for (const currency of currencies) {
    const text = typed[currency]?.trim() ?? '';
    if (text === '') continue;
    const amount = minorOf(text, currency);
    if (amount === null) return { status: 'invalid', currency };
    if (!/^0+$/.test(amount)) lines.push({ currency, amount });
  }
  return lines.length === 0 ? { status: 'empty' } : { status: 'lines', lines };
}

// Whether the review takes more than is owed.
export const aboveDues = (preview: DuesPreview): boolean =>
  BigInt(preview.total) > BigInt(preview.due);

// «تأكيد وإصدار الإيصال»: exactly what the review showed.
export function duesPayBodyOf(preview: DuesPreview) {
  return {
    cityId: preview.cityId,
    customerId: preview.customerId,
    due: preview.due,
    lines: preview.lines.map(({ currency, amount, base, rates }) => ({
      currency,
      amount,
      base,
      rates,
    })),
  };
}

const customerKey = (cityId: string, customerId: string) =>
  ['customers', cityId, customerId] as const;

// By the number in any usual form, or a part of a name; sent as a POST so a
// number never sits in a URL.
export function useCustomerSearch(cityId: string | undefined, text: string) {
  const q = text.trim();
  return useQuery({
    queryKey: ['customers', cityId ?? '', 'search', q],
    enabled: cityId !== undefined && q.length >= 2,
    queryFn: async (): Promise<FoundCustomer[]> => {
      const { data } = await api.POST('/v1/admin/customers/search', {
        body: { cityId: cityId!, q },
      });
      if (!data) throw new Error('The customer search failed.');
      return data.customers;
    },
  });
}

export function useCustomer(cityId: string | undefined, customerId: string) {
  return useQuery({
    queryKey: customerKey(cityId ?? '', customerId),
    enabled: cityId !== undefined,
    queryFn: async (): Promise<CustomerProfile | 'unknown'> => {
      const { data, response } = await api.GET('/v1/admin/customers/{customerId}', {
        params: { path: { customerId }, query: { cityId: cityId! } },
      });
      if (data) return data;
      if (response.status === 404) return 'unknown';
      throw new Error(`The customer read failed with ${response.status}.`);
    },
  });
}

export const blockRefusals = [
  'invalid_block',
  'unknown_reason',
  'already_blocked',
  'not_blocked',
  'no_base_currency',
  'unknown_customer',
] as const;
export type BlockRefusal = (typeof blockRefusals)[number];
export type BlockResult =
  { status: 'done'; profile: CustomerProfile } | { status: 'refused'; refusal: BlockRefusal };

function refusalOf<T extends string>(
  status: number,
  error: unknown,
  known: readonly T[],
): T | null {
  const refusal = (error as { error?: unknown } | undefined)?.error;
  if (status !== 400 && status !== 404 && status !== 409) return null;
  return typeof refusal === 'string' && (known as readonly string[]).includes(refusal)
    ? (refusal as T)
    : null;
}

// «حظر»: one Idempotency-Key per body until an answer arrives, so a retry
// after a lost answer never charges a dues block twice.
export function useBlockCustomer(cityId: string, customerId: string) {
  const queryClient = useQueryClient();
  const keys = useRef(new Map<string, string>());
  return useMutation({
    mutationFn: async (body: BlockBody): Promise<BlockResult> => {
      const choice = JSON.stringify(body);
      let key = keys.current.get(choice);
      if (key === undefined) {
        key = crypto.randomUUID();
        keys.current.set(choice, key);
      }
      const { data, error, response } = await api.POST('/v1/admin/customers/{customerId}/block', {
        params: { path: { customerId }, header: { 'Idempotency-Key': key } },
        body,
      });
      if (data) {
        keys.current.delete(choice);
        return { status: 'done', profile: data };
      }
      const refusal = refusalOf(response.status, error, blockRefusals);
      if (refusal) {
        keys.current.delete(choice);
        return { status: 'refused', refusal };
      }
      throw new Error(`The block failed with ${response.status}.`);
    },
    onSuccess: (result) => {
      if (result.status === 'done') {
        queryClient.setQueryData(customerKey(cityId, customerId), result.profile);
      }
    },
  });
}

// «فك الحظر» of the block the profile showed: no key, a repeat (or a block
// replaced since) is not_blocked.
export function useUnblockCustomer(cityId: string, customerId: string) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (lift: { blockId: string; note: string }): Promise<BlockResult> => {
      const { data, error, response } = await api.POST('/v1/admin/customers/{customerId}/unblock', {
        params: { path: { customerId } },
        body: { cityId, blockId: lift.blockId, note: lift.note.trim() },
      });
      if (data) return { status: 'done', profile: data };
      const refusal = refusalOf(response.status, error, blockRefusals);
      if (refusal) return { status: 'refused', refusal };
      throw new Error(`The unblock failed with ${response.status}.`);
    },
    onSuccess: (result) => {
      if (result.status === 'done') {
        queryClient.setQueryData(customerKey(cityId, customerId), result.profile);
      }
    },
  });
}

// The dues alone (no lines), or each line's value in the base at the
// current rate; 'refused' for a currency without a rate.
export function useDuesPreview(cityId: string, customerId: string, lines: CashLine[]) {
  return useQuery({
    queryKey: ['customers', cityId, customerId, 'dues-preview', lines],
    queryFn: async (): Promise<DuesPreview | 'refused'> => {
      const { data, response } = await api.POST('/v1/admin/cash-desk/customer-dues/preview', {
        body: { cityId, customerId, lines },
      });
      if (data) return data;
      if (response.status === 400 || response.status === 404 || response.status === 409) {
        return 'refused';
      }
      throw new Error(`The dues preview failed with ${response.status}.`);
    },
  });
}

export const duesPayRefusals = [
  'above_balance',
  'balance_changed',
  'rate_changed',
  'rate_missing',
  'nothing_due',
  'no_open_session',
  'unknown_party',
  'invalid_amounts',
] as const;
export type DuesPayRefusal = (typeof duesPayRefusals)[number];
export type DuesPayResult =
  { status: 'paid'; receipt: CustomerReceipt } | { status: 'refused'; refusal: DuesPayRefusal };

// «تأكيد وإصدار الإيصال»: one key per body until an answer arrives.
export function usePayDues(cityId: string, customerId: string) {
  const queryClient = useQueryClient();
  const keys = useRef(new Map<string, string>());
  return useMutation({
    mutationFn: async (body: ReturnType<typeof duesPayBodyOf>): Promise<DuesPayResult> => {
      const choice = JSON.stringify(body);
      let key = keys.current.get(choice);
      if (key === undefined) {
        key = crypto.randomUUID();
        keys.current.set(choice, key);
      }
      const { data, error, response } = await api.POST('/v1/admin/cash-desk/customer-dues', {
        params: { header: { 'Idempotency-Key': key } },
        body,
      });
      if (data) {
        keys.current.delete(choice);
        return { status: 'paid', receipt: data };
      }
      const refusal = refusalOf(response.status, error, duesPayRefusals);
      if (refusal) {
        keys.current.delete(choice);
        return { status: 'refused', refusal };
      }
      throw new Error(`The dues payment failed with ${response.status}.`);
    },
    onSettled: () => queryClient.invalidateQueries({ queryKey: ['customers', cityId, customerId] }),
  });
}

export function useCustomerReceipts(customerId: string, enabled: boolean) {
  return useQuery({
    queryKey: ['customers', 'receipts', customerId],
    enabled,
    queryFn: async (): Promise<CustomerReceipt[]> => {
      const { data } = await api.GET('/v1/admin/cash-desk/customers/{customerId}/receipts', {
        params: { path: { customerId } },
      });
      if (!data) throw new Error('The customer receipts read failed.');
      return data.receipts;
    },
  });
}

export function useCustomerReceipt(receiptId: string) {
  return useQuery({
    queryKey: ['customers', 'receipt', receiptId],
    queryFn: async (): Promise<CustomerReceipt> => {
      const { data } = await api.GET('/v1/admin/cash-desk/customer-receipts/{receiptId}', {
        params: { path: { receiptId } },
      });
      if (!data) throw new Error('The customer receipt read failed.');
      return data;
    },
  });
}
