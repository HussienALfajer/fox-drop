import { keepPreviousData, useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import type { components } from '@fox-drop/api-schema';
import { useRef } from 'react';
import { api } from './api.js';
import { minorOf } from './format.js';

// AP §6.3: OWN and FIN record at the cash desk.
export const CASH_DESK = 'cash_desk.record';

export type DrawerSession = components['schemas']['AdminDrawerSessionDto_Output'];
export type CurrentSession = components['schemas']['AdminCurrentDrawerSessionDto_Output'];
export type DeskCaptain = components['schemas']['AdminDeskCaptainsDto_Output']['captains'][number];
export type DeskCustody = components['schemas']['AdminDeskCustodyDto_Output'];
export type CustodyLine = DeskCustody['currencies'][number];
export type Receipt = components['schemas']['AdminReceiptDto_Output'];
export type ReceiptType = Receipt['type'];

// What a field typed per currency becomes: «40» or «40.50» in major units.
export type Typed = Record<string, string>;

export type CashLine = { currency: string; amount: string };

// A form's amounts as minor units, or the first currency typed wrongly. An
// empty field is left out.
export function cashLinesOf(
  typed: Typed,
  currencies: readonly string[],
): { lines: CashLine[] } | { problem: string } {
  const lines: CashLine[] = [];
  for (const currency of currencies) {
    const text = (typed[currency] ?? '').trim();
    if (text === '') continue;
    const amount = minorOf(text, currency);
    if (amount === null) return { problem: currency };
    lines.push({ currency, amount });
  }
  return { lines };
}

// AP §9.10.3 step 2: in each currency the captain hands in what they hold,
// or the desk pays back what the office owes them; a currency at zero has
// nothing to do.
export type Direction = 'hand_in' | 'reimburse' | 'none';

export function directionOf(line: CustodyLine): Direction {
  const balance = BigInt(line.balance);
  return balance > 0n ? 'hand_in' : balance < 0n ? 'reimburse' : 'none';
}

// The most a field takes: the custody, either way.
export function maximumOf(line: CustodyLine): string {
  const balance = BigInt(line.balance);
  return (balance < 0n ? -balance : balance).toString();
}

export type HandInProblem = { currency: string; problem: 'invalid' | 'above' };

// The hand-in's lines (only the currencies typed above zero), or the first
// one typed wrongly or above the custody; null while nothing is typed.
export function handInLinesOf(
  typed: Typed,
  custody: DeskCustody,
): { lines: CashLine[] } | HandInProblem | null {
  const lines: CashLine[] = [];
  for (const line of custody.currencies) {
    if (directionOf(line) === 'none') continue;
    const text = (typed[line.currency] ?? '').trim();
    if (text === '') continue;
    const amount = minorOf(text, line.currency);
    if (amount === null) return { currency: line.currency, problem: 'invalid' };
    if (BigInt(amount) === 0n) continue;
    if (BigInt(amount) > BigInt(maximumOf(line))) {
      return { currency: line.currency, problem: 'above' };
    }
    lines.push({ currency: line.currency, amount });
  }
  return lines.length === 0 ? null : { lines };
}

// What stays open in a currency after the amount (from the captain's side).
export function remainingOf(line: CustodyLine, amount: string): string {
  const balance = BigInt(line.balance);
  const moved = BigInt(amount);
  return (balance > 0n ? balance - moved : balance + moved).toString();
}

export function phoneOrName(text: string): boolean {
  return text.trim().length >= 2;
}

const currentKey = (cityId: string) => ['cash-desk', 'current', cityId] as const;
const sessionsKey = (cityId: string) => ['cash-desk', 'sessions', cityId] as const;
const custodyKey = (captainId: string) => ['cash-desk', 'custody', captainId] as const;

export function useCurrentSession(cityId: string | undefined) {
  return useQuery({
    queryKey: currentKey(cityId ?? ''),
    enabled: cityId !== undefined,
    queryFn: async (): Promise<CurrentSession> => {
      const { data } = await api.GET('/v1/admin/cash-desk/sessions/current', {
        params: { query: { cityId: cityId! } },
      });
      if (!data) throw new Error('The drawer session read failed.');
      return data;
    },
  });
}

// Every user's sessions for OWN, the user's own otherwise (the server picks).
export function useSessions(cityId: string | undefined) {
  return useQuery({
    queryKey: sessionsKey(cityId ?? ''),
    enabled: cityId !== undefined,
    queryFn: async () => {
      const { data } = await api.GET('/v1/admin/cash-desk/sessions', {
        params: { query: { cityId: cityId! } },
      });
      if (!data) throw new Error('The drawer sessions read failed.');
      return data.sessions;
    },
  });
}

export type SessionRefusal =
  'session_open' | 'session_closed' | 'note_required' | 'invalid_amounts';
const sessionRefusals: readonly string[] = [
  'session_open',
  'session_closed',
  'note_required',
  'invalid_amounts',
];

export type SessionResult =
  { status: 'done'; session: DrawerSession } | { status: 'refused'; refusal: SessionRefusal };

function sessionResult(
  data: DrawerSession | undefined,
  error: unknown,
  status: number,
): SessionResult {
  if (data) return { status: 'done', session: data };
  const refusal = (error as { error?: unknown } | undefined)?.error;
  if ((status === 400 || status === 409) && typeof refusal === 'string') {
    if (sessionRefusals.includes(refusal)) {
      return { status: 'refused', refusal: refusal as SessionRefusal };
    }
  }
  throw new Error(`The drawer session command failed with ${status}.`);
}

// «فتح الصندوق». A second open is refused, so it needs no key.
export function useOpenSession(cityId: string) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (floats: CashLine[]): Promise<SessionResult> => {
      const { data, error, response } = await api.POST('/v1/admin/cash-desk/sessions', {
        body: { cityId, floats },
      });
      return sessionResult(data, error, response.status);
    },
    onSettled: () => queryClient.invalidateQueries({ queryKey: ['cash-desk'] }),
  });
}

// «إقفال الصندوق». A repeat is refused, so it needs no key.
export function useCloseSession() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (input: {
      sessionId: string;
      counted: CashLine[];
      note: string | null;
    }): Promise<SessionResult> => {
      const { data, error, response } = await api.POST(
        '/v1/admin/cash-desk/sessions/{sessionId}/close',
        {
          params: { path: { sessionId: input.sessionId } },
          body: { counted: input.counted, note: input.note },
        },
      );
      return sessionResult(data, error, response.status);
    },
    onSettled: () => queryClient.invalidateQueries({ queryKey: ['cash-desk'] }),
  });
}

// Step 1: a part of the name, or the number.
export function useCaptainSearch(cityId: string | undefined, text: string) {
  const q = text.trim();
  return useQuery({
    queryKey: ['cash-desk', 'search', cityId ?? '', q],
    enabled: cityId !== undefined && phoneOrName(q),
    placeholderData: keepPreviousData,
    queryFn: async () => {
      const { data } = await api.GET('/v1/admin/cash-desk/captains', {
        params: { query: { cityId: cityId!, q } },
      });
      if (!data) throw new Error('The captain search failed.');
      return data.captains;
    },
  });
}

// Step 2: the custody per currency, split into closed days and today.
export function useDeskCustody(captainId: string | undefined) {
  return useQuery({
    queryKey: custodyKey(captainId ?? ''),
    enabled: captainId !== undefined,
    queryFn: async () => {
      const { data } = await api.GET('/v1/admin/cash-desk/captains/{captainId}', {
        params: { path: { captainId: captainId! } },
      });
      if (!data) throw new Error('The custody read failed.');
      return data;
    },
  });
}

export type HandInRefusal =
  'no_open_session' | 'nothing_due' | 'above_custody' | 'unknown_captain' | 'invalid_amounts';
const handInRefusals: readonly string[] = [
  'no_open_session',
  'nothing_due',
  'above_custody',
  'unknown_captain',
  'invalid_amounts',
];

export type HandInResult =
  { status: 'recorded'; receipts: Receipt[] } | { status: 'refused'; refusal: HandInRefusal };

// Steps 3–5: one key per body until an answer, so a retry after a lost
// answer gets the same receipts instead of a second hand-in.
export function useHandIn() {
  const queryClient = useQueryClient();
  const keys = useRef(new Map<string, string>());
  return useMutation({
    mutationFn: async (body: { captainId: string; lines: CashLine[] }): Promise<HandInResult> => {
      const choice = JSON.stringify(body);
      let key = keys.current.get(choice);
      if (key === undefined) {
        key = crypto.randomUUID();
        keys.current.set(choice, key);
      }
      const { data, error, response } = await api.POST('/v1/admin/cash-desk/hand-ins', {
        params: { header: { 'Idempotency-Key': key } },
        body,
      });
      if (data) {
        keys.current.delete(choice);
        return { status: 'recorded', receipts: data.receipts };
      }
      const refusal = (error as { error?: unknown } | undefined)?.error;
      const status: number = response.status;
      if ((status === 400 || status === 404 || status === 409) && typeof refusal === 'string') {
        if (handInRefusals.includes(refusal)) {
          keys.current.delete(choice);
          return { status: 'refused', refusal: refusal as HandInRefusal };
        }
      }
      throw new Error(`The hand-in failed with ${status}.`);
    },
    onSettled: () => queryClient.invalidateQueries({ queryKey: ['cash-desk'] }),
  });
}

export function useReceipt(receiptId: string) {
  return useQuery({
    queryKey: ['cash-desk', 'receipt', receiptId],
    queryFn: async () => {
      const { data } = await api.GET('/v1/admin/cash-desk/receipts/{receiptId}', {
        params: { path: { receiptId } },
      });
      if (!data) throw new Error('The receipt read failed.');
      return data;
    },
  });
}

// The paper a receipt prints on (AP §9.10.3).
export type Paper = 'thermal' | 'a4';
