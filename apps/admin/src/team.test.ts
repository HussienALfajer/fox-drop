import { describe, expect, it, vi } from 'vitest';

vi.mock('./api.js', () => ({ api: {} }));

const { actionsOf, matrixRows, newUserRequestOf, setupLinkOf } = await import('./team.js');

type User = Parameters<typeof actionsOf>[0];
const user = (status: User['status'], id = 'u1'): User => ({
  id,
  name: 'سارة',
  email: null,
  phone: '+963944000000',
  roles: ['OPS'],
  status,
  totpEnrolled: status === 'active',
  lastSignInAt: null,
  openSessions: [],
});

describe('the admin team (AP §9.15)', () => {
  it('offers what each status allows, and nothing on the own account', () => {
    expect(actionsOf(user('pending'), 'me')).toEqual(['setup_link', 'disable']);
    expect(actionsOf(user('active'), 'me')).toEqual(['totp_reset', 'sign_out', 'disable']);
    expect(actionsOf(user('totp_reset'), 'me')).toEqual(['totp_reset', 'sign_out', 'disable']);
    expect(actionsOf(user('disabled'), 'me')).toEqual(['enable']);
    expect(actionsOf(user('active', 'me'), 'me')).toEqual([]);
  });

  it('builds the new user or names the first problem', () => {
    const form = { name: ' سارة ', email: '', phone: ' +963944000000 ', roles: [] };
    expect(newUserRequestOf({ ...form, name: '' })).toEqual({
      ok: false,
      problem: 'name_required',
    });
    expect(newUserRequestOf({ ...form, phone: '' })).toEqual({
      ok: false,
      problem: 'contact_required',
    });
    expect(newUserRequestOf(form)).toEqual({ ok: false, problem: 'roles_required' });
    expect(newUserRequestOf({ ...form, roles: ['FIN', 'OPS'] })).toEqual({
      ok: true,
      body: { name: 'سارة', email: null, phone: '+963944000000', roles: ['OPS', 'FIN'] },
    });
  });

  it('puts the token in the fragment of the setup link', () => {
    expect(setupLinkOf('https://admin.example.test', 'abc')).toBe(
      'https://admin.example.test/setup#token=abc',
    );
  });

  it('lists each permission once with the roles that hold it', () => {
    const rows = matrixRows([
      { role: 'OWN', permissions: ['zones.read', 'admin_team.manage'] },
      { role: 'OPS', permissions: ['zones.read'] },
    ]);
    expect(rows.map((row) => [row.permission, [...row.roles]])).toEqual([
      ['admin_team.manage', ['OWN']],
      ['zones.read', ['OWN', 'OPS']],
    ]);
  });
});
