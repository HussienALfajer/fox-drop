import type { components } from '@fox-drop/api-schema';
import { type QueryClient, queryOptions, useMutation, useQueryClient } from '@tanstack/react-query';
import { api } from './api.js';

export type PortalSession = components['schemas']['MerchantPortalSessionDto_Output'];

// The signed-in owner, or null without a session (RA §5.3). The cookie is
// HTTP-only, so the portal learns of its session only from this read.
export const sessionQuery = queryOptions({
  queryKey: ['session'],
  queryFn: async (): Promise<PortalSession | null> => {
    const { data, response } = await api.GET('/v1/merchant/auth/portal/session');
    if (response.status === 401) return null;
    if (!data) throw new Error('The session read failed.');
    return data;
  },
  staleTime: 60_000,
  retry: 1,
});

// A session that ended takes every cached answer with it, so the next owner
// to sign in on this browser never sees the last one's orders.
export function forgetSession(queryClient: QueryClient) {
  queryClient.clear();
  queryClient.setQueryData(sessionQuery.queryKey, null);
}

// The browser's id, which binds a code to the browser that asked for it
// (architecture §8.3.2). Kept in the browser when it can be; a private window
// that keeps nothing gets one per page load, which only means asking again.
const BROWSER_ID_KEY = 'fox_drop_browser_id';
let memoryBrowserId: string | null = null;

export function browserId(): string {
  try {
    const kept = window.localStorage.getItem(BROWSER_ID_KEY);
    if (kept) return kept;
    const created = crypto.randomUUID();
    window.localStorage.setItem(BROWSER_ID_KEY, created);
    return created;
  } catch {
    memoryBrowserId ??= crypto.randomUUID();
    return memoryBrowserId;
  }
}

// The number as the server takes it (+9639xxxxxxxx or +905xxxxxxxxx), from
// what an owner types: spaces and dashes left out, 00 for +, and a Syrian
// mobile written 09… or 9…; null for anything else.
export function phoneOf(typed: string): string | null {
  let digits = typed.replace(/[\s-]/g, '');
  if (digits.startsWith('00')) digits = `+${digits.slice(2)}`;
  if (/^09\d{8}$/.test(digits)) digits = `+963${digits.slice(1)}`;
  if (/^9\d{8}$/.test(digits)) digits = `+963${digits}`;
  return /^\+9639\d{8}$/.test(digits) || /^\+905\d{9}$/.test(digits) ? digits : null;
}

// RA §5.2, architecture §8.3.3: why no code was sent.
export const codeRefusals = [
  'not_registered',
  'restaurant_draft',
  'owner_only',
  'resend_wait',
  'hourly_limit',
  'daily_limit',
  'ip_limit',
  'not_on_whatsapp',
  'unavailable',
  'invalid_phone',
] as const;
export type CodeRefusal = (typeof codeRefusals)[number];

export type CodeResult =
  | { status: 'sent'; resendAfterSec: number }
  | { status: 'refused'; refusal: CodeRefusal; retryAfterSec: number | null };

function refusalOf(error: unknown): CodeRefusal | null {
  return (codeRefusals as readonly unknown[]).includes(error) ? (error as CodeRefusal) : null;
}

export function useRequestCode() {
  return useMutation({
    mutationFn: async (phone: string): Promise<CodeResult> => {
      const { data, error, response } = await api.POST('/v1/merchant/auth/portal/code', {
        body: { phone, browserId: browserId() },
      });
      if (data) return { status: 'sent', resendAfterSec: data.resendAfterSec };
      const refusal = refusalOf((error as { error?: unknown } | undefined)?.error);
      const retryAfter = Number(response.headers.get('Retry-After'));
      if (refusal) {
        return {
          status: 'refused',
          refusal,
          retryAfterSec: Number.isFinite(retryAfter) && retryAfter > 0 ? retryAfter : null,
        };
      }
      // A malformed number the server refuses by its schema.
      if (response.status === 400) {
        return { status: 'refused', refusal: 'invalid_phone', retryAfterSec: null };
      }
      throw new Error(`The code request failed (${response.status}).`);
    },
  });
}

export type SignInResult =
  | { status: 'signed_in' }
  | { status: 'wrong_code'; attemptsLeft: number }
  | { status: 'code_expired' }
  | { status: 'refused'; refusal: CodeRefusal };

export function useSignIn() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (body: { phone: string; code: string }): Promise<SignInResult> => {
      const { data, error, response } = await api.POST('/v1/merchant/auth/portal/sign-in', {
        body: { ...body, browserId: browserId() },
      });
      if (data) {
        queryClient.clear();
        await queryClient.invalidateQueries({ queryKey: sessionQuery.queryKey });
        return { status: 'signed_in' };
      }
      const answer = error as { error?: unknown; attemptsLeft?: number } | undefined;
      if (answer?.error === 'wrong_code') {
        return { status: 'wrong_code', attemptsLeft: answer.attemptsLeft ?? 0 };
      }
      if (answer?.error === 'code_expired') return { status: 'code_expired' };
      const refusal = refusalOf(answer?.error);
      if (refusal) return { status: 'refused', refusal };
      // A code that is not 6 digits never reaches a code.
      if (response.status === 400) return { status: 'wrong_code', attemptsLeft: 0 };
      throw new Error(`The sign-in failed (${response.status}).`);
    },
  });
}

export function useSignOut() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async () => {
      const { response } = await api.POST('/v1/merchant/auth/portal/sign-out');
      // A session that already ended is signed out too.
      if (!response.ok && response.status !== 401) throw new Error('The sign-out failed.');
      forgetSession(queryClient);
    },
  });
}

// RA §5.2 item 3: the team's call and WhatsApp buttons. Missing numbers are
// left out, and their buttons hidden.
export const contactQuery = queryOptions({
  queryKey: ['contact'],
  queryFn: async () => {
    const { data } = await api.GET('/v1/merchant/contact');
    return data ?? {};
  },
  staleTime: Infinity,
});

// tel: and wa.me links of an E.164 number.
export function callLink(phone: string): string {
  return `tel:${phone}`;
}

export function whatsappLink(phone: string): string {
  return `https://wa.me/${phone.replace(/^\+/, '')}`;
}
