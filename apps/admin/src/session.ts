import type { components } from '@fox-drop/api-schema';
import { type QueryClient, queryOptions, useMutation, useQueryClient } from '@tanstack/react-query';
import { api } from './api.js';

export type AdminSession = components['schemas']['AdminSessionDto_Output'];

// The signed-in session, or null without one (AP §5.2). The cookie is
// httpOnly, so the panel learns of its session only from this read.
export const sessionQuery = queryOptions({
  queryKey: ['session'],
  queryFn: async (): Promise<AdminSession | null> => {
    const { data, response } = await api.GET('/v1/admin/auth/session');
    if (response.status === 401) return null;
    if (!data) throw new Error('The session read failed.');
    return data;
  },
  // Read again after a minute when a page opens, so a role change or an ended
  // session shows without waiting for a refused request (AP §6.1, §5.2).
  staleTime: 60_000,
  retry: 1,
});

// A session that ended takes every cached answer with it, so the next person
// to sign in on this tab never sees the last one's data.
export function forgetSession(queryClient: QueryClient) {
  queryClient.clear();
  queryClient.setQueryData(sessionQuery.queryKey, null);
}

// AP §6.1: the panel hides what the session's permissions do not allow.
export function can(session: AdminSession | null | undefined, permission: string): boolean {
  return session?.permissions.includes(permission) ?? false;
}

export type SignInResult = 'signed_in' | 'refused';

export function useSignIn() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (body: {
      login: string;
      password: string;
      code: string;
    }): Promise<SignInResult> => {
      const { data, response } = await api.POST('/v1/admin/auth/sign-in', { body });
      // One answer for every refusal, a locked account included (owner
      // decision 2026-11-05); a malformed field is refused the same way.
      if (response.status === 401 || response.status === 400) return 'refused';
      if (!data) throw new Error('The sign-in failed.');
      queryClient.setQueryData(sessionQuery.queryKey, data);
      return 'signed_in';
    },
  });
}

export function useSignOut() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async () => {
      const { response } = await api.POST('/v1/admin/auth/sign-out');
      // A session that already ended is signed out too.
      if (!response.ok && response.status !== 401) throw new Error('The sign-out failed.');
      forgetSession(queryClient);
    },
  });
}
