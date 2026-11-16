import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import type { components } from '@fox-drop/api-schema';
import { useRef } from 'react';
import { api } from './api.js';
import type { CashLine } from './cash-desk.js';
import { minorOf } from './format.js';

export type RestaurantSettlementList =
  components['schemas']['AdminRestaurantSettlementsDto_Output'];
export type RestaurantSettlementRow = RestaurantSettlementList['restaurants'][number];
export type MerchantStatement = components['schemas']['AdminMerchantStatementDto_Output'];
export type MerchantStatementLine = MerchantStatement['lines'][number];
export type ExceptionCause = NonNullable<MerchantStatementLine['cause']>;
export type StatementStatus = NonNullable<MerchantStatement['status']>;
export type RestaurantSettlementPreview =
  components['schemas']['AdminRestaurantSettlementPreviewDto_Output'];
export type RestaurantReceipt = components['schemas']['AdminRestaurantReceiptDto_Output'];

// AP §8.7: + the restaurant owes the platform, − the platform owes it.
export function balanceSide(amount: string): 'owes' | 'owed' | 'settled' {
  const value = BigInt(amount);
  return value > 0n ? 'owes' : value < 0n ? 'owed' : 'settled';
}

// RA §12.3: the statement's lines in its three parts, each in the order
// the server gave.
export function statementParts(statement: MerchantStatement) {
  return {
    orders: statement.lines.filter((line) => line.kind === 'order'),
    exceptions: statement.lines.filter((line) => line.kind === 'exception'),
    payments: statement.lines.filter((line) => line.kind === 'payment'),
  };
}

// AP §9.10.3 «تسوية المطاعم» (slice 2.19a): every restaurant with a balance,
// the overdue first.
export function useRestaurantSettlements(cityId: string | undefined) {
  return useQuery({
    queryKey: ['cash-desk', 'restaurants', cityId ?? ''],
    enabled: cityId !== undefined,
    queryFn: async (): Promise<RestaurantSettlementList> => {
      const { data } = await api.GET('/v1/admin/cash-desk/restaurants', {
        params: { query: { cityId: cityId! } },
      });
      if (!data) throw new Error('The restaurant settlement read failed.');
      return data;
    },
  });
}

export function useMerchantStatement(statementId: string) {
  return useQuery({
    queryKey: ['cash-desk', 'merchant-statement', statementId],
    queryFn: async (): Promise<MerchantStatement> => {
      const { data } = await api.GET('/v1/admin/cash-desk/merchant-statements/{statementId}', {
        params: { path: { statementId } },
      });
      if (!data) throw new Error('The restaurant statement read failed.');
      return data;
    },
  });
}

// AP §9.10.3 tab 3 (slice 2.19b): the cash typed per currency in its major
// units as lines of minor units, an empty field or a zero left out; the
// first currency typed wrong otherwise, or none at all.
export function settlementLinesOf(
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
    if (amount !== '0') lines.push({ currency, amount });
  }
  return lines.length === 0 ? { status: 'empty' } : { status: 'lines', lines };
}

// Whether the review asks more than is owed: the total in the base against
// the balance, either way.
export function aboveDue(preview: RestaurantSettlementPreview): boolean {
  const due = BigInt(preview.due);
  return BigInt(preview.total) > (due < 0n ? -due : due);
}

// «تأكيد وإصدار الإيصال»: exactly what the review showed, so the server
// refuses it once the balance or a rate moved.
export function restaurantSettleBodyOf(preview: RestaurantSettlementPreview) {
  return {
    restaurantId: preview.restaurantId,
    due: preview.due,
    lines: preview.lines.map(({ currency, amount, base, rates }) => ({
      currency,
      amount,
      base,
      rates,
    })),
  };
}

// The balance alone (no lines), or each line's value in the base at the
// current rate; 'refused' for a currency without a rate or a restaurant
// not found.
export function useRestaurantSettlementPreview(restaurantId: string, lines: CashLine[]) {
  return useQuery({
    queryKey: ['cash-desk', 'restaurant-settlement-preview', restaurantId, lines],
    queryFn: async (): Promise<RestaurantSettlementPreview | 'refused'> => {
      const { data, response } = await api.POST(
        '/v1/admin/cash-desk/restaurant-settlements/preview',
        { body: { restaurantId, lines } },
      );
      if (data) return data;
      if (response.status === 400 || response.status === 404 || response.status === 409) {
        return 'refused';
      }
      throw new Error(`The restaurant settlement preview failed with ${response.status}.`);
    },
  });
}

export type RestaurantSettleRefusal =
  | 'above_balance'
  | 'balance_changed'
  | 'rate_changed'
  | 'rate_missing'
  | 'nothing_due'
  | 'drawer_short'
  | 'no_open_session'
  | 'unknown_restaurant'
  | 'invalid_amounts';
export const restaurantSettleRefusals = [
  'above_balance',
  'balance_changed',
  'rate_changed',
  'rate_missing',
  'nothing_due',
  'drawer_short',
  'no_open_session',
  'unknown_restaurant',
  'invalid_amounts',
] as const satisfies readonly RestaurantSettleRefusal[];

export type RestaurantSettleResult =
  | { status: 'settled'; receipt: RestaurantReceipt }
  | { status: 'refused'; refusal: RestaurantSettleRefusal };

// One key per body until an answer, so a retry after a lost answer gets the
// same receipt instead of recording the payment twice.
export function useRestaurantSettle() {
  const queryClient = useQueryClient();
  const keys = useRef(new Map<string, string>());
  return useMutation({
    mutationFn: async (
      body: ReturnType<typeof restaurantSettleBodyOf>,
    ): Promise<RestaurantSettleResult> => {
      const choice = JSON.stringify(body);
      let key = keys.current.get(choice);
      if (key === undefined) {
        key = crypto.randomUUID();
        keys.current.set(choice, key);
      }
      const { data, error, response } = await api.POST(
        '/v1/admin/cash-desk/restaurant-settlements',
        { params: { header: { 'Idempotency-Key': key } }, body },
      );
      if (data) {
        keys.current.delete(choice);
        return { status: 'settled', receipt: data };
      }
      const refusal = (error as { error?: unknown } | undefined)?.error;
      const status: number = response.status;
      if (
        (status === 400 || status === 404 || status === 409) &&
        typeof refusal === 'string' &&
        (restaurantSettleRefusals as readonly string[]).includes(refusal)
      ) {
        keys.current.delete(choice);
        return { status: 'refused', refusal: refusal as RestaurantSettleRefusal };
      }
      throw new Error(`The restaurant settlement failed with ${status}.`);
    },
    onSettled: () => queryClient.invalidateQueries({ queryKey: ['cash-desk'] }),
  });
}

export function useRestaurantReceipt(receiptId: string) {
  return useQuery({
    queryKey: ['cash-desk', 'restaurant-receipt', receiptId],
    queryFn: async (): Promise<RestaurantReceipt> => {
      const { data } = await api.GET('/v1/admin/cash-desk/restaurant-receipts/{receiptId}', {
        params: { path: { receiptId } },
      });
      if (!data) throw new Error('The restaurant receipt read failed.');
      return data;
    },
  });
}
