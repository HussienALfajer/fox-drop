import { describe, expect, it } from 'vitest';
import { PROCESS_ROLES, parseProcessRole } from './process-role.js';

describe('parseProcessRole', () => {
  it.each(PROCESS_ROLES)('accepts %s', (role) => {
    expect(parseProcessRole(role)).toBe(role);
  });

  it('refuses a missing role', () => {
    expect(() => parseProcessRole(undefined)).toThrow(/got nothing/);
  });

  it('refuses an unknown role', () => {
    expect(() => parseProcessRole('cron')).toThrow(
      /api, worker, dispatcher, otp-sender; got "cron"/,
    );
  });
});
