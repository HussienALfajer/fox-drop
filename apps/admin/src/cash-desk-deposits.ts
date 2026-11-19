import type { components } from '@fox-drop/api-schema';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { useRef } from 'react';
import { api } from './api.js';
import { minorOf } from './format.js';

// AP §9.7.1, §8.5 «تأمين العدة» (slice 2.35a; owner decision 2026-11-19): the
// desk records an applicant's deposit at «بانتظار العدة»: the amount (the
// setting captain.kit_deposit_amount offered), the weekly instalment deducted
// on Thursdays (none: paid in full), and the cash paid now with its receipt.

export type AwaitingDeposit =
  components['schemas']['AdminDepositsDto_Output']['applications'][number];
export type DepositBody = components['schemas']['AdminRecordDepositDto'];
type Receipt = NonNullable<components['schemas']['AdminRecordDepositAnswerDto_Output']['receipt']>;

export function useAwaitingDeposits(cityId: string | undefined) {
  return useQuery({
    queryKey: ['cash-desk', 'deposits', cityId ?? ''],
    enabled: cityId !== undefined,
    queryFn: async () => {
      const { data } = await api.GET('/v1/admin/cash-desk/deposits', {
        params: { query: { cityId: cityId! } },
      });
      if (!data) throw new Error('The deposits read failed.');
      return data.applications;
    },
  });
}

export interface DepositForm {
  amount: string;
  instalment: string;
  paidNow: string;
}

export type DepositProblem = 'amount' | 'instalment' | 'paid_now';

// The amounts typed in the base's major units; an empty instalment is none
// and an empty cash is 0. The cash is never more than what is left, and an
// instalment never more than the deposit (the server checks again).
export function depositBodyOf(
  form: DepositForm,
  application: AwaitingDeposit,
  cityId: string,
  currency: string,
): { body: DepositBody } | { problem: DepositProblem } {
  const amount = minorOf(form.amount, currency);
  if (amount === null) return { problem: 'amount' };
  const instalment = form.instalment.trim() === '' ? null : minorOf(form.instalment, currency);
  if (instalment === null && form.instalment.trim() !== '') return { problem: 'instalment' };
  if (instalment !== null && (BigInt(instalment) <= 0n || BigInt(instalment) > BigInt(amount))) {
    return { problem: 'instalment' };
  }
  const paidNow = form.paidNow.trim() === '' ? '0' : minorOf(form.paidNow, currency);
  if (paidNow === null) return { problem: 'paid_now' };
  if (BigInt(application.deposit.paid) + BigInt(paidNow) > BigInt(amount)) {
    return { problem: 'paid_now' };
  }
  return {
    body: { cityId, applicationId: application.applicationId, amount, instalment, paidNow },
  };
}

export type DepositRefusal =
  | 'no_open_session'
  | 'above_balance'
  | 'wrong_stage'
  | 'invalid_amounts'
  | 'unknown_party'
  | 'no_base_currency';

const refusals: readonly string[] = [
  'no_open_session',
  'above_balance',
  'wrong_stage',
  'invalid_amounts',
  'unknown_party',
  'no_base_currency',
] satisfies DepositRefusal[];

export type DepositResult =
  { status: 'recorded'; receipt: Receipt | null } | { status: 'refused'; refusal: DepositRefusal };

// One Idempotency-Key per body until an answer arrives, so a retry after a
// lost answer issues one receipt.
export function useRecordDeposit() {
  const queryClient = useQueryClient();
  const keys = useRef(new Map<string, string>());
  return useMutation({
    mutationFn: async (body: DepositBody): Promise<DepositResult> => {
      const choice = JSON.stringify(body);
      let key = keys.current.get(choice);
      if (key === undefined) {
        key = crypto.randomUUID();
        keys.current.set(choice, key);
      }
      const { data, error, response } = await api.POST('/v1/admin/cash-desk/deposits', {
        params: { header: { 'Idempotency-Key': key } },
        body,
      });
      if (data) {
        keys.current.delete(choice);
        return { status: 'recorded', receipt: data.receipt };
      }
      const refusal = (error as { error?: unknown } | undefined)?.error;
      const status: number = response.status;
      if (
        (status === 400 || status === 404 || status === 409) &&
        typeof refusal === 'string' &&
        refusals.includes(refusal)
      ) {
        keys.current.delete(choice);
        return { status: 'refused', refusal: refusal as DepositRefusal };
      }
      throw new Error(`The deposit failed with ${status}.`);
    },
    onSettled: () => {
      void queryClient.invalidateQueries({ queryKey: ['cash-desk'] });
      void queryClient.invalidateQueries({ queryKey: ['captain-application'] });
    },
  });
}

// The cash limit before activation (D10; FIN, OWN: captains.cash_limit),
// set here so FIN never reads the application's page. It sets a value: no
// key; the answer replaces the list.
export type CashLimitResult =
  | { status: 'saved' }
  | { status: 'refused'; refusal: 'invalid_amounts' | 'invalid_currency' | 'wrong_stage' };

export function useSetCashLimit(cityId: string) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (input: {
      applicationId: string;
      amount: string;
      currency: string;
    }): Promise<CashLimitResult> => {
      const { data, error, response } = await api.PUT(
        '/v1/admin/cash-desk/deposits/{applicationId}/cash-limit',
        {
          params: { path: { applicationId: input.applicationId } },
          body: { cityId, cashLimit: { amount: input.amount, currency: input.currency } },
        },
      );
      if (data) {
        queryClient.setQueryData(['cash-desk', 'deposits', cityId], data.applications);
        return { status: 'saved' };
      }
      const refusal = (error as { error?: unknown } | undefined)?.error;
      if (
        refusal === 'invalid_amounts' ||
        refusal === 'invalid_currency' ||
        refusal === 'wrong_stage'
      ) {
        return { status: 'refused', refusal };
      }
      throw new Error(`The cash limit failed with ${response.status}.`);
    },
  });
}
