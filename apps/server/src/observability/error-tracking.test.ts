import type { ErrorEvent } from '@sentry/nestjs';
import { describe, expect, it } from 'vitest';
import { scrubEvent, startErrorTracking } from './error-tracking.js';

describe('startErrorTracking', () => {
  it('sends nothing without SENTRY_DSN', () => {
    expect(startErrorTracking({})).toBe(false);
  });
});

describe('scrubEvent', () => {
  it('drops the request body, cookies, headers and query string', () => {
    const event: ErrorEvent = {
      type: undefined,
      request: {
        url: 'https://api.example.test/v1/customer/auth/sign-in?code=123456',
        method: 'POST',
        data: { phone: '+963944123456', code: '123456' },
        cookies: { __Host_session: 'secret' },
        headers: { authorization: 'Bearer abc' },
        query_string: 'code=123456',
      },
    };

    expect(scrubEvent(event).request).toEqual({
      url: 'https://api.example.test/v1/customer/auth/sign-in',
      method: 'POST',
    });
  });

  it('redacts secrets and phone numbers anywhere else', () => {
    const event: ErrorEvent = {
      type: undefined,
      message: 'no account for +963944123456',
      extra: { refreshToken: 'abc', city: 'Azaz' },
    };

    const scrubbed = scrubEvent(event);

    expect(scrubbed.message).not.toContain('944123456');
    expect(scrubbed.extra).toEqual({ refreshToken: '[REDACTED]', city: 'Azaz' });
  });
});
