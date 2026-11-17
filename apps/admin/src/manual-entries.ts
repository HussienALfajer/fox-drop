import type { components } from '@fox-drop/api-schema';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { useRef } from 'react';
import { api } from './api.js';
import { minorOf } from './format.js';

// AP §6.3: OWN and FIN post and reverse manual entries.
export const MANUAL_ADJUSTMENT = 'ledger.manual_adjustment';

export type ManualEntry = components['schemas']['AdminManualEntryDto_Output'];
export type JournalSummary = ManualEntry['journal'];
type AdjustmentBody = components['schemas']['AdminManualAdjustmentDto'];
export type Party = AdjustmentBody['party'];
export type PartyAccount = AdjustmentBody['account'];
export type AccountView = components['schemas']['AdminManualAccountDto_Output'];
export type AccountEntry = AccountView['entries'][number];

// AP §9.10.7: the accounts of each party a manual entry may reach.
export const PARTIES = ['captain', 'restaurant', 'customer'] as const satisfies readonly Party[];
export const partyAccounts = {
  captain: ['captain.custody', 'captain.earnings'],
  restaurant: ['merchant.account'],
  customer: ['customer.dues'],
} as const satisfies Record<Party, readonly PartyAccount[]>;

// Which way an entry moves the account, from the party's view as the specs
// state it: custody + the captain hands in, earnings + the platform owes the
// captain, the restaurant account + the platform owes it (− it owes), dues +
// the customer owes.
export type Direction = 'up' | 'down';

// The amount typed in the currency's major units, signed by the direction,
// as the minor units the server takes; null while it is not an amount above
// zero.
export function signedAmountOf(
  typed: string,
  direction: Direction,
  currency: string,
): string | null {
  const minor = minorOf(typed, currency);
  if (minor === null || /^0+$/.test(minor)) return null;
  return direction === 'down' ? `-${minor}` : minor;
}

export interface AdjustmentForm {
  party: Party;
  partyId: string;
  account: PartyAccount;
  currency: string;
  amount: string;
  direction: Direction;
  reason: string;
}

// The body once the amount and the reason are there, else null.
export function adjustmentBody(cityId: string, form: AdjustmentForm): AdjustmentBody | null {
  const amount = signedAmountOf(form.amount, form.direction, form.currency);
  const reason = form.reason.trim();
  if (amount === null || reason === '') return null;
  return {
    cityId,
    party: form.party,
    partyId: form.partyId,
    account: form.account,
    currency: form.currency,
    amount,
    reason,
  };
}

// A restaurant's account reads from its own side, as «تسوية المطاعم» says
// it: − it owes («عليه»), + the platform owes it («له»). The other accounts
// read as their sign says (custody: to hand in; earnings: owed to the
// captain; dues: owed by the customer).
export function balanceWordsOf(
  account: PartyAccount,
  money: { amount: string; currency: string },
): {
  key: 'manualEntries.restaurantOwes' | 'manualEntries.restaurantOwed';
  money: typeof money;
} | null {
  if (account !== 'merchant.account' || /^-?0+$/.test(money.amount)) return null;
  const owes = money.amount.startsWith('-');
  return {
    key: owes ? 'manualEntries.restaurantOwes' : 'manualEntries.restaurantOwed',
    money: { amount: owes ? money.amount.slice(1) : money.amount, currency: money.currency },
  };
}

// The ledger's journal types that reach a party's account, by their label;
// a type the panel does not know reads «قيد» (never the code in English).
const typeKeys = {
  'custody.collect': 'manualEntries.type.custodyCollect',
  'custody.change_given': 'manualEntries.type.custodyChangeGiven',
  'custody.pay_merchant': 'manualEntries.type.custodyPayMerchant',
  'custody.hand_in': 'manualEntries.type.custodyHandIn',
  'custody.reimburse': 'manualEntries.type.custodyReimburse',
  'custody.fx_convert': 'manualEntries.type.custodyFxConvert',
  'custody.pickup_correction': 'manualEntries.type.custodyPickupCorrection',
  'custody.adjustment': 'manualEntries.type.custodyAdjustment',
  'earn.order_pay': 'manualEntries.type.earnOrderPay',
  'earn.waiting_pay': 'manualEntries.type.earnWaitingPay',
  'earn.peak_bonus': 'manualEntries.type.earnPeakBonus',
  'earn.bonus': 'manualEntries.type.earnBonus',
  'earn.charge': 'manualEntries.type.earnCharge',
  'earn.deposit_instalment': 'manualEntries.type.earnDepositInstalment',
  'earn.payout': 'manualEntries.type.earnPayout',
  'earn.adjustment': 'manualEntries.type.earnAdjustment',
  'merchant.commission': 'manualEntries.type.merchantCommission',
  'merchant.discount_share': 'manualEntries.type.merchantDiscountShare',
  'merchant.credit': 'manualEntries.type.merchantCredit',
  'merchant.debit': 'manualEntries.type.merchantDebit',
  'merchant.settlement': 'manualEntries.type.merchantSettlement',
  'merchant.adjustment': 'manualEntries.type.merchantAdjustment',
  'dues.charge': 'manualEntries.type.duesCharge',
  'dues.adjustment': 'manualEntries.type.duesAdjustment',
  'dues.transfer': 'manualEntries.type.duesTransfer',
} as const;

export function typeKeyOf(
  type: string,
): (typeof typeKeys)[keyof typeof typeKeys] | 'manualEntries.type.other' {
  return (
    (typeKeys as Record<string, (typeof typeKeys)[keyof typeof typeKeys]>)[type] ??
    'manualEntries.type.other'
  );
}

// The list's anchors, so a reversal links to its original and back.
export const entryAnchorOf = (entryId: string) => `entry-${entryId}`;
export const entryLinkOf = (entryId: string) => `#${entryAnchorOf(entryId)}`;
// A new form for each party and account.
export const formKeyOf = (partyId: string, account: PartyAccount) => `${partyId}:${account}`;

const entriesKey = (cityId: string) => ['manual-entries', cityId] as const;

export function useManualEntries(cityId: string | undefined) {
  return useQuery({
    queryKey: entriesKey(cityId ?? ''),
    enabled: cityId !== undefined,
    queryFn: async (): Promise<ManualEntry[]> => {
      const { data } = await api.GET('/v1/admin/manual-entries', {
        params: { query: { cityId: cityId! } },
      });
      if (!data) throw new Error('The manual entries read failed.');
      return data.entries;
    },
  });
}

// A captain by a part of the name or the number, a restaurant by a part of
// the name, a customer by the number; sent as a POST so a number never sits
// in a URL.
export function usePartySearch(cityId: string, party: Party, text: string) {
  const q = text.trim();
  return useQuery({
    queryKey: ['manual-entries', cityId, 'parties', party, q],
    enabled: q.length >= 2,
    queryFn: async () => {
      const { data } = await api.POST('/v1/admin/manual-entries/parties/search', {
        body: { cityId, party, q },
      });
      if (!data) throw new Error('The party search failed.');
      return data.parties;
    },
  });
}

export function useAccount(
  cityId: string,
  chosen: { party: Party; partyId: string; account: PartyAccount } | null,
) {
  return useQuery({
    queryKey: ['manual-entries', cityId, 'account', chosen],
    enabled: chosen !== null,
    queryFn: async (): Promise<AccountView> => {
      const { data } = await api.GET('/v1/admin/manual-entries/account', {
        params: { query: { cityId, ...chosen! } },
      });
      if (!data) throw new Error('The account read failed.');
      return data;
    },
  });
}

// The refusals the screen explains; anything else is an error.
export const manualEntryRefusals = [
  'invalid_amounts',
  'invalid_currency',
  'invalid_account',
  'reason_required',
  'unknown_party',
  'no_base_currency',
  'unknown_journal',
  'already_reversed',
  'not_reversible',
] as const;
export type ManualEntryRefusal = (typeof manualEntryRefusals)[number];

export type ManualEntryResult =
  { status: 'posted'; entry: ManualEntry } | { status: 'refused'; refusal: ManualEntryRefusal };

function refusalOf(status: number, error: unknown): ManualEntryRefusal | null {
  const refusal = (error as { error?: unknown } | undefined)?.error;
  if (status !== 400 && status !== 404 && status !== 409) return null;
  return (manualEntryRefusals as readonly unknown[]).includes(refusal)
    ? (refusal as ManualEntryRefusal)
    : null;
}

// One Idempotency-Key per body until an answer arrives (architecture §5.3),
// so a retry after a lost answer gets the same entry, not a second one.
function useKeyedPost<Body>(
  post: (
    body: Body,
    key: string,
  ) => Promise<{ data?: ManualEntry; error?: unknown; response: Response }>,
  cityId: string,
) {
  const queryClient = useQueryClient();
  const keys = useRef(new Map<string, string>());
  return useMutation({
    mutationFn: async (body: Body): Promise<ManualEntryResult> => {
      const id = JSON.stringify(body);
      let key = keys.current.get(id);
      if (key === undefined) {
        key = crypto.randomUUID();
        keys.current.set(id, key);
      }
      const { data, error, response } = await post(body, key);
      if (data) {
        keys.current.delete(id);
        return { status: 'posted', entry: data };
      }
      const refusal = refusalOf(response.status, error);
      if (refusal) {
        keys.current.delete(id);
        return { status: 'refused', refusal };
      }
      throw new Error(`The manual entry failed with ${response.status}.`);
    },
    onSettled: () => queryClient.invalidateQueries({ queryKey: entriesKey(cityId) }),
  });
}

export function useAdjust(cityId: string) {
  return useKeyedPost<AdjustmentBody>(
    (body, key) =>
      api.POST('/v1/admin/manual-entries', {
        params: { header: { 'Idempotency-Key': key } },
        body,
      }),
    cityId,
  );
}

export function useReverse(cityId: string) {
  return useKeyedPost<{ journalId: string; reason: string }>(
    (body, key) =>
      api.POST('/v1/admin/manual-entries/reversals', {
        params: { header: { 'Idempotency-Key': key } },
        body: { cityId, journalId: body.journalId, reason: body.reason.trim() },
      }),
    cityId,
  );
}
