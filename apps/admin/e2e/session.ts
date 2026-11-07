import type { Page } from '@playwright/test';

// A session answered by the fake server, with the permissions the test needs.
// Its role receives no alerts by default, so the sound banner (AP §7.3) does
// not cover the page; e2e/alerts.spec.ts passes a recipient role.
export function sessionBody(permissions: string[] = [], roles: string[] = ['SUP']) {
  return {
    accountId: '01900000-0000-7000-8000-000000000001',
    roles,
    permissions,
    signedInAt: '2026-11-07T08:00:00.000Z',
    expiresAt: '2026-11-07T08:30:00.000Z',
  };
}

// Answers the session read: signed in with these permissions, or 401.
export async function fakeSession(
  page: Page,
  permissions: string[] | null,
  roles: string[] = ['SUP'],
) {
  await page.route('**/v1/admin/auth/session', (route) =>
    permissions === null
      ? route.fulfill({ status: 401, json: { statusCode: 401 } })
      : route.fulfill({ json: sessionBody(permissions, roles) }),
  );
  await page.route('**/v1/admin/status', (route) =>
    route.fulfill({ json: { status: 'ok', serverTime: Date.now() } }),
  );
}
