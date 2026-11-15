import { useQuery } from '@tanstack/react-query';
import type { components } from '@fox-drop/api-schema';
import { api } from './api.js';

export type RestaurantSettlementList =
  components['schemas']['AdminRestaurantSettlementsDto_Output'];
export type RestaurantSettlementRow = RestaurantSettlementList['restaurants'][number];
export type MerchantStatement = components['schemas']['AdminMerchantStatementDto_Output'];
export type MerchantStatementLine = MerchantStatement['lines'][number];
export type ExceptionCause = NonNullable<MerchantStatementLine['cause']>;

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
