import type { components } from '@fox-drop/api-schema';
import { queryOptions, useMutation, useQueryClient } from '@tanstack/react-query';
import { api } from './api.js';

// AP §9.15 «فريق الإدارة» (OWN; slice 2.38b): the admin users, their roles
// and the read-only role matrix of AP §6.
export const ADMIN_TEAM = 'admin_team.manage';

export type TeamUser = components['schemas']['TeamUsersDto_Output']['users'][number];
export type RoleMatrix = components['schemas']['RoleMatrixDto_Output']['roles'];

// AP §6.1, in its order.
export const ROLES = ['OWN', 'OPS', 'SUP', 'FIN', 'DATA'] as const;
export type Role = (typeof ROLES)[number];

export function isRole(value: string): value is Role {
  return (ROLES as readonly string[]).includes(value);
}

export const teamQuery = queryOptions({
  queryKey: ['team', 'users'],
  queryFn: async (): Promise<TeamUser[]> => {
    const { data } = await api.GET('/v1/admin/team/users');
    if (!data) throw new Error('The team read failed.');
    return data.users;
  },
});

export const roleMatrixQuery = queryOptions({
  queryKey: ['team', 'roles'],
  queryFn: async (): Promise<RoleMatrix> => {
    const { data } = await api.GET('/v1/admin/team/roles');
    if (!data) throw new Error('The role matrix read failed.');
    return data.roles;
  },
  staleTime: 10 * 60_000,
});

// The matrix as the page shows it: every permission any role holds, sorted
// by its code, with the roles that hold it.
export function matrixRows(matrix: RoleMatrix): { permission: string; roles: Set<string> }[] {
  const rows = new Map<string, Set<string>>();
  for (const { role, permissions } of matrix) {
    for (const permission of permissions) {
      const holders = rows.get(permission) ?? new Set<string>();
      holders.add(role);
      rows.set(permission, holders);
    }
  }
  return [...rows.entries()]
    .sort(([a], [b]) => a.localeCompare(b))
    .map(([permission, roles]) => ({ permission, roles }));
}

// What each status allows (the server's rules): a pending user gets a new
// setup link, an active one a TOTP reset and a sign-out, a user waiting for
// a TOTP reset a new reset link and a sign-out; anyone but a disabled user
// can be disabled, and only a disabled one enabled. The owner never acts on
// their own account but for the roles (`own_account`).
export type TeamAction = 'setup_link' | 'totp_reset' | 'sign_out' | 'disable' | 'enable';

export function actionsOf(user: TeamUser, ownAccountId: string): TeamAction[] {
  if (user.id === ownAccountId) return [];
  switch (user.status) {
    case 'pending':
      return ['setup_link', 'disable'];
    case 'active':
      return ['totp_reset', 'sign_out', 'disable'];
    case 'totp_reset':
      return ['totp_reset', 'sign_out', 'disable'];
    case 'disabled':
      return ['enable'];
  }
}

// AP §5.1 item 3: the link the owner shares, with the token in the
// fragment, which never reaches a server log.
export function setupLinkOf(origin: string, token: string): string {
  return `${origin}/setup#token=${token}`;
}

export interface NewUserForm {
  name: string;
  email: string;
  phone: string;
  roles: Role[];
}

export const emptyNewUser: NewUserForm = { name: '', email: '', phone: '', roles: [] };

export type NewUserProblem = 'name_required' | 'contact_required' | 'roles_required';

// The body of «مستخدم جديد», or its first problem: a name, an email or a
// phone (the server checks their form), and one role or more (AP §6.1).
export function newUserRequestOf(
  form: NewUserForm,
):
  | { ok: true; body: { name: string; email: string | null; phone: string | null; roles: Role[] } }
  | { ok: false; problem: NewUserProblem } {
  const name = form.name.trim();
  const email = form.email.trim();
  const phone = form.phone.trim();
  if (name === '') return { ok: false, problem: 'name_required' };
  if (email === '' && phone === '') return { ok: false, problem: 'contact_required' };
  if (form.roles.length === 0) return { ok: false, problem: 'roles_required' };
  return {
    ok: true,
    body: {
      name,
      email: email === '' ? null : email,
      phone: phone === '' ? null : phone,
      roles: ROLES.filter((role) => form.roles.includes(role)),
    },
  };
}

export type TeamRefusal =
  | 'name_taken'
  | 'last_owner'
  | 'own_account'
  | 'wrong_status'
  | 'not_found'
  | 'forbidden'
  | 'invalid';

export type TeamResult =
  | { status: 'done' }
  | { status: 'link'; token: string; expiresAt: string }
  | { status: 'refused'; refusal: TeamRefusal };

const conflicts: readonly string[] = [
  'name_taken',
  'last_owner',
  'own_account',
  'wrong_status',
] satisfies TeamRefusal[];

function refusalOf(status: number, error: unknown): TeamRefusal | null {
  if (status === 404) return 'not_found';
  if (status === 403) return 'forbidden';
  if (status === 400) return 'invalid';
  if (status !== 409) return null;
  const code = (error as { error?: unknown } | undefined)?.error;
  return typeof code === 'string' && conflicts.includes(code) ? (code as TeamRefusal) : 'invalid';
}

export type TeamCommand =
  | {
      kind: 'create';
      body: { name: string; email: string | null; phone: string | null; roles: Role[] };
    }
  | { kind: 'roles'; accountId: string; roles: Role[] }
  | { kind: TeamAction; accountId: string };

async function send(command: TeamCommand) {
  if (command.kind === 'create') {
    return api.POST('/v1/admin/team/users', { body: command.body });
  }
  const params = { path: { accountId: command.accountId } };
  switch (command.kind) {
    case 'roles':
      return api.PUT('/v1/admin/team/users/{accountId}/roles', {
        params,
        body: { roles: command.roles },
      });
    case 'disable':
      return api.POST('/v1/admin/team/users/{accountId}/disable', { params });
    case 'enable':
      return api.POST('/v1/admin/team/users/{accountId}/enable', { params });
    case 'sign_out':
      return api.POST('/v1/admin/team/users/{accountId}/sign-out', { params });
    case 'totp_reset':
      return api.POST('/v1/admin/team/users/{accountId}/totp-reset', { params });
    case 'setup_link':
      return api.POST('/v1/admin/team/users/{accountId}/setup-link', { params });
  }
}

// Every team command. Each sets a state or answers a new link (a secret
// shown once, so no key: a repeat makes a new one and expires the old). The
// list is read again after.
export function useTeamCommand() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (command: TeamCommand): Promise<TeamResult> => {
      try {
        const { data, error, response } = await send(command);
        const status: number = response.status;
        const refusal = refusalOf(status, error);
        if (refusal !== null) return { status: 'refused', refusal };
        if (error !== undefined || !data) throw new Error(`team failed with ${status}`);
        return 'setupToken' in data
          ? { status: 'link', token: data.setupToken, expiresAt: data.setupExpiresAt }
          : { status: 'done' };
      } finally {
        await queryClient.invalidateQueries({ queryKey: teamQuery.queryKey });
      }
    },
  });
}

// AP §6.4: the settings of the caps the matrix edits, by role.
export const CAP_KEYS = ['support.compensation_cap_pct.OPS', 'support.compensation_cap_pct.SUP'];
