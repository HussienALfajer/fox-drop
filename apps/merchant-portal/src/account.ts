import type { components } from '@fox-drop/api-schema';
import { queryOptions } from '@tanstack/react-query';
import { api } from './api.js';

export type Account = components['schemas']['MerchantAccountDto_Output'];
export type WeekLine = Account['weekLines'][number];
export type StatementList = components['schemas']['MerchantStatementListDto_Output'];
export type Statement = components['schemas']['MerchantStatementDto_Output'];
export type StatementLine = Statement['lines'][number];
export type ReceiptList = components['schemas']['MerchantReceiptListDto_Output'];
export type Receipt = components['schemas']['MerchantReceiptDto_Output'];
export type Overdue = components['schemas']['MerchantOverdueDto_Output']['overdue'];

// RA §12, §17 (slice 2.45d): the app's money section on the same routes,
// owners only; a terminated restaurant's owners keep it, read only (RA
// §5.5). Read on opening: nothing pushes a change.
export const accountQuery = queryOptions({
  queryKey: ['account'],
  queryFn: async (): Promise<Account> => {
    const { data, response } = await api.GET('/v1/merchant/account');
    if (!data) throw new Error(`The account read failed (${response.status}).`);
    return data;
  },
});

// RA §12.6: the amber banner «لديك مبلغ متأخر: {المبلغ}…».
export const overdueQuery = queryOptions({
  queryKey: ['account', 'overdue'],
  queryFn: async (): Promise<Overdue> => {
    const { data, response } = await api.GET('/v1/merchant/account/overdue');
    if (!data) throw new Error(`The overdue read failed (${response.status}).`);
    return data.overdue;
  },
});

export const statementsQuery = queryOptions({
  queryKey: ['statements'],
  queryFn: async (): Promise<StatementList['statements']> => {
    const { data, response } = await api.GET('/v1/merchant/statements');
    if (!data) throw new Error(`The statements read failed (${response.status}).`);
    return data.statements;
  },
});

// One statement; null for another restaurant's or an unknown one.
export function statementQuery(statementId: string) {
  return queryOptions({
    queryKey: ['statements', statementId],
    queryFn: async (): Promise<Statement | null> => {
      const { data, response } = await api.GET('/v1/merchant/statements/{statementId}', {
        params: { path: { statementId } },
      });
      if (response.status === 404) return null;
      if (!data) throw new Error(`The statement read failed (${response.status}).`);
      return data;
    },
  });
}

export const receiptsQuery = queryOptions({
  queryKey: ['receipts'],
  queryFn: async (): Promise<ReceiptList['receipts']> => {
    const { data, response } = await api.GET('/v1/merchant/receipts');
    if (!data) throw new Error(`The receipts read failed (${response.status}).`);
    return data.receipts;
  },
});

export function receiptQuery(receiptId: string) {
  return queryOptions({
    queryKey: ['receipts', receiptId],
    queryFn: async (): Promise<Receipt | null> => {
      const { data, response } = await api.GET('/v1/merchant/receipts/{receiptId}', {
        params: { path: { receiptId } },
      });
      if (response.status === 404) return null;
      if (!data) throw new Error(`The receipt read failed (${response.status}).`);
      return data;
    },
  });
}

// «هذا الأسبوع» grouped by its business day, newest day first, each day's
// lines in the server's order (RA §12.2).
export function weekByDay(lines: readonly WeekLine[]): { day: string; lines: WeekLine[] }[] {
  const days: { day: string; lines: WeekLine[] }[] = [];
  for (const line of lines) {
    const last = days.at(-1);
    if (last?.day === line.day) last.lines.push(line);
    else days.push({ day: line.day, lines: [line] });
  }
  return days;
}

// The amounts the pickups of today add up to (RA §12.2 «قبضت اليوم»), in
// integers of minor units.
export function pickupsTotal(pickups: Account['pickups']): string {
  return pickups.reduce((total, pickup) => total + BigInt(pickup.amount), 0n).toString();
}

// A balance's sign as the app reads it (+ the restaurant owes).
export function balanceKind(amount: string): 'owed' | 'credit' | 'settled' {
  const value = BigInt(amount);
  return value > 0n ? 'owed' : value < 0n ? 'credit' : 'settled';
}

// A minor amount without its sign, for «يزيد / يُنقص المستحق عليك».
export function absolute(amount: string): string {
  return amount.startsWith('-') ? amount.slice(1) : amount;
}
