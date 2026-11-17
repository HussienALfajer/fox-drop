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
// Slice 2.25b: «توثيق», «إزالة الثقة» and «تغيير الرقم» (OWN, OPS); clearing
// strikes and ending a review stop (OWN, OPS, SUP); the admin test account
// (OWN); «تسجيل الخروج من كل الأجهزة» (OWN, OPS, SUP).
export const CUSTOMERS_MANAGE = 'customers.manage';
export const CUSTOMERS_CLEAR_STRIKES = 'customers.clear_strikes';
export const CUSTOMERS_TEST_ACCOUNT = 'customers.test_account';
export const CUSTOMERS_SIGN_OUT = 'customers.sign_out_everywhere';
export const CUSTOMERS_CLOSE = 'customers.close_account';
// Slice 2.25d: «فك حظر الجهاز» (OWN).
export const CUSTOMERS_LIFT_DEVICE = 'customers.lift_device_block';

export type FoundCustomer =
  components['schemas']['AdminCustomersFoundDto_Output']['customers'][number];
export type CustomerProfile = components['schemas']['AdminCustomerDto_Output'];
export type CustomerStatus = CustomerProfile['status'];
export type BlockKind = components['schemas']['AdminBlockCustomerDto']['kind'];
type BlockBody = components['schemas']['AdminBlockCustomerDto'];
export type DuesPreview = components['schemas']['AdminCustomerDuesPreviewDto_Output'];
export type CustomerReceipt = components['schemas']['AdminCustomerReceiptDto_Output'];

// A device as the profile names it: the first eight characters of its id
// (slice 2.25d; the whole id stays in the command).
export function shortDevice(deviceId: string): string {
  return deviceId.slice(0, 8);
}

// AP §9.8 «الحالة», keyed by the API's statuses.
export const statusKeys = {
  active: 'customers.status.active',
  blocked: 'customers.status.blocked',
  dues_unpaid: 'customers.status.dues_unpaid',
  review_stop: 'customers.status.review_stop',
  closed: 'customers.status.closed',
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

// Slice 2.25b: the profile's commands that answer the profile and take no
// key (each sets a value or names its target), with the refusals the page
// explains.
export const actionRefusals = [
  'nothing_to_clear',
  'not_stopped',
  'invalid_phone',
  'phone_taken',
  'unknown_customer',
  'idempotency_key_reused',
  'active_order',
  'account_closed',
  'unknown_device',
  'device_not_blocked',
] as const;
export type ActionRefusal = (typeof actionRefusals)[number];
export type ActionResult =
  { status: 'done'; profile: CustomerProfile } | { status: 'refused'; refusal: ActionRefusal };

export type CustomerAction =
  | { path: '/v1/admin/customers/{customerId}/trust'; body: { trusted: boolean; note: string } }
  | { path: '/v1/admin/customers/{customerId}/clear-strikes'; body: { note: string } }
  | {
      path: '/v1/admin/customers/{customerId}/end-review-stop';
      body: { stopId: string; note: string };
    }
  | { path: '/v1/admin/customers/{customerId}/test-account'; body: { flagged: boolean } }
  | {
      path: '/v1/admin/customers/{customerId}/change-phone';
      body: { phone: string; note: string };
    }
  | { path: '/v1/admin/customers/{customerId}/close'; body: { note: string } }
  | {
      path: '/v1/admin/customers/{customerId}/lift-device-block';
      body: { deviceId: string; note: string };
    };

function sendAction(
  action: CustomerAction,
  params: { path: { customerId: string } },
  cityId: string,
) {
  switch (action.path) {
    case '/v1/admin/customers/{customerId}/trust':
      return api.POST(action.path, { params, body: { cityId, ...action.body } });
    case '/v1/admin/customers/{customerId}/clear-strikes':
      return api.POST(action.path, { params, body: { cityId, ...action.body } });
    case '/v1/admin/customers/{customerId}/end-review-stop':
      return api.POST(action.path, { params, body: { cityId, ...action.body } });
    case '/v1/admin/customers/{customerId}/test-account':
      return api.POST(action.path, { params, body: { cityId, ...action.body } });
    case '/v1/admin/customers/{customerId}/change-phone':
      return api.POST(action.path, { params, body: { cityId, ...action.body } });
    case '/v1/admin/customers/{customerId}/close':
      return api.POST(action.path, { params, body: { cityId, ...action.body } });
    case '/v1/admin/customers/{customerId}/lift-device-block':
      return api.POST(action.path, { params, body: { cityId, ...action.body } });
  }
}

export function useCustomerAction(cityId: string, customerId: string) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (action: CustomerAction): Promise<ActionResult> => {
      const params = { path: { customerId } };
      const { data, error, response } = await sendAction(action, params, cityId);
      if (data) return { status: 'done', profile: data };
      const refusal = refusalOf(response.status, error, actionRefusals);
      if (refusal) return { status: 'refused', refusal };
      throw new Error(`The customer command failed with ${response.status}.`);
    },
    onSuccess: (result) => {
      if (result.status === 'done') {
        queryClient.setQueryData(customerKey(cityId, customerId), result.profile);
      }
    },
  });
}

// «ملاحظة داخلية»: one Idempotency-Key per body until an answer arrives, so
// a retry after a lost answer adds no second note.
export function useAddNote(cityId: string, customerId: string) {
  const queryClient = useQueryClient();
  const keys = useRef(new Map<string, string>());
  return useMutation({
    mutationFn: async (body: string): Promise<CustomerProfile> => {
      let key = keys.current.get(body);
      if (key === undefined) {
        key = crypto.randomUUID();
        keys.current.set(body, key);
      }
      const { data, response } = await api.POST('/v1/admin/customers/{customerId}/notes', {
        params: { path: { customerId }, header: { 'Idempotency-Key': key } },
        body: { cityId, body },
      });
      if (!data) throw new Error(`The note failed with ${response.status}.`);
      keys.current.delete(body);
      return data;
    },
    onSuccess: (profile) => queryClient.setQueryData(customerKey(cityId, customerId), profile),
  });
}

// «تسجيل الخروج من كل الأجهزة»: a repeat signs out nothing more, so no key.
export function useSignOutEverywhere(cityId: string, customerId: string) {
  return useMutation({
    mutationFn: async (note: string): Promise<number> => {
      const { data, response } = await api.POST(
        '/v1/admin/customers/{customerId}/sign-out-everywhere',
        { params: { path: { customerId } }, body: { cityId, note } },
      );
      if (!data) throw new Error(`The sign-out failed with ${response.status}.`);
      return data.sessionsEnded;
    },
  });
}

// AP §9.8 «الأكواد المستخدمة»: a use's state, keyed by the API's values; a
// state the panel does not know shows nothing.
export const codeUseKeys: Record<string, string> = {
  held: 'customers.codes.held',
  spent: 'customers.codes.spent',
  returned: 'customers.codes.returned',
};

// The saved address's label: «المنزل», «العمل», or the customer's own.
export function addressLabelOf(
  address: CustomerProfile['addresses'][number],
  t: (key: 'customers.address.home' | 'customers.address.work') => string,
): string {
  if (address.label === 'home') return t('customers.address.home');
  if (address.label === 'work') return t('customers.address.work');
  return address.customLabel ?? '';
}
