import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import type { components } from '@fox-drop/api-schema';
import { useRef } from 'react';
import { api } from './api.js';
import type { AdminSession } from './session.js';

export type SettlementList = components['schemas']['AdminSettlementsDto_Output'];
export type SettlementPreview = components['schemas']['AdminSettlementPreviewDto_Output'];
export type Statement = components['schemas']['AdminStatementDto_Output'];
export type Settlement = components['schemas']['AdminSettlementDto_Output'];
export type PayoutWeekday = SettlementList['payoutWeekday'];

// AP §8.5.5, §9.10.3: on the payout day every desk user settles; on another
// day the tab is read-only, except for OWN (AP §6.3 «Off-cycle captain
// payout»), who settles with a reason.
export function canSettle(session: AdminSession | null | undefined, payoutDay: boolean): boolean {
  return payoutDay || (session?.roles.includes('OWN') ?? false);
}

// What the cash does in one currency: + the captain gives, − the desk pays.
export function netDirection(amount: string): 'gives' | 'receives' {
  return BigInt(amount) >= 0n ? 'gives' : 'receives';
}

export function absolute(amount: string): string {
  return amount.startsWith('-') ? amount.slice(1) : amount;
}

// The confirmation's body: exactly what the preview showed, so the server
// refuses it once the balances or the rate moved; the reason only off the
// payout day.
export function settleBodyOf(preview: SettlementPreview, reason: string) {
  return {
    captainId: preview.captainId,
    custody: preview.custody.map(({ currency, balance }) => ({ currency, balance })),
    earnings: preview.earnings.amount,
    payout: preview.payout && {
      currency: preview.payout.currency,
      amount: preview.payout.amount,
      rates: preview.payout.rates,
    },
    reason: preview.payoutDay ? null : reason.trim() || null,
  };
}

export function useSettlementList(cityId: string | undefined) {
  return useQuery({
    queryKey: ['cash-desk', 'settlements', cityId ?? ''],
    enabled: cityId !== undefined,
    queryFn: async (): Promise<SettlementList> => {
      const { data } = await api.GET('/v1/admin/cash-desk/settlements', {
        params: { query: { cityId: cityId! } },
      });
      if (!data) throw new Error('The settlement list read failed.');
      return data;
    },
  });
}

export function useSettlementPreview(captainId: string, payoutCurrency: string | null) {
  return useQuery({
    queryKey: ['cash-desk', 'settlement-preview', captainId, payoutCurrency],
    queryFn: async (): Promise<SettlementPreview | 'refused'> => {
      const { data, response } = await api.POST('/v1/admin/cash-desk/settlements/preview', {
        body: { captainId, payoutCurrency },
      });
      if (data) return data;
      // A currency without a rate, or a captain of no city.
      if (response.status === 404 || response.status === 409) return 'refused';
      throw new Error(`The settlement preview failed with ${response.status}.`);
    },
  });
}

export type SettleRefusal =
  | 'not_payout_day'
  | 'reason_required'
  | 'balance_changed'
  | 'rate_changed'
  | 'rate_missing'
  | 'nothing_due'
  | 'drawer_short'
  | 'no_open_session'
  | 'unknown_captain';
const settleRefusals: readonly string[] = [
  'not_payout_day',
  'reason_required',
  'balance_changed',
  'rate_changed',
  'rate_missing',
  'nothing_due',
  'drawer_short',
  'no_open_session',
  'unknown_captain',
];

export type SettleResult =
  { status: 'settled'; settlement: Settlement } | { status: 'refused'; refusal: SettleRefusal };

// «تأكيد التصفية»: one key per body until an answer, so a retry after a lost
// answer gets the same settlement instead of paying twice.
export function useSettle() {
  const queryClient = useQueryClient();
  const keys = useRef(new Map<string, string>());
  return useMutation({
    mutationFn: async (body: ReturnType<typeof settleBodyOf>): Promise<SettleResult> => {
      const choice = JSON.stringify(body);
      let key = keys.current.get(choice);
      if (key === undefined) {
        key = crypto.randomUUID();
        keys.current.set(choice, key);
      }
      const { data, error, response } = await api.POST('/v1/admin/cash-desk/settlements', {
        params: { header: { 'Idempotency-Key': key } },
        body,
      });
      if (data) {
        keys.current.delete(choice);
        return { status: 'settled', settlement: data };
      }
      const refusal = (error as { error?: unknown } | undefined)?.error;
      const status: number = response.status;
      if (
        (status === 400 || status === 403 || status === 404 || status === 409) &&
        typeof refusal === 'string' &&
        settleRefusals.includes(refusal)
      ) {
        keys.current.delete(choice);
        return { status: 'refused', refusal: refusal as SettleRefusal };
      }
      throw new Error(`The settlement failed with ${status}.`);
    },
    onSettled: () => queryClient.invalidateQueries({ queryKey: ['cash-desk'] }),
  });
}

export function useStatement(statementId: string) {
  return useQuery({
    queryKey: ['cash-desk', 'statement', statementId],
    queryFn: async () => {
      const { data } = await api.GET('/v1/admin/cash-desk/statements/{statementId}', {
        params: { path: { statementId } },
      });
      if (!data) throw new Error('The statement read failed.');
      return data;
    },
  });
}
