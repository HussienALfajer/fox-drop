import { describe, expect, it } from 'vitest';
import { publishingConfig, requireRealtime } from './realtime-config.js';

// RA §4.3: restaurant devices ring only through real time, so production
// never starts without what its process uses; elsewhere it may be off.
describe('real-time configuration', () => {
  const publishing = { CENTRIFUGO_API_URL: 'http://centrifugo:8000/api/', CENTRIFUGO_API_KEY: 'k' };
  const tokens = { CENTRIFUGO_TOKEN_SECRET: 't', CENTRIFUGO_PROXY_SECRET: 'p' };

  it('stops a production process that lacks what it uses', () => {
    const production = { FOX_DROP_ENVIRONMENT: 'production' };
    expect(() => requireRealtime('publishing', production)).toThrow(
      /CENTRIFUGO_API_URL, CENTRIFUGO_API_KEY/,
    );
    expect(() => requireRealtime('tokens', { ...production, ...publishing })).toThrow(
      /CENTRIFUGO_TOKEN_SECRET, CENTRIFUGO_PROXY_SECRET/,
    );
    // The worker needs no token secret, the API's tokens no API key.
    expect(() => requireRealtime('publishing', { ...production, ...publishing })).not.toThrow();
    expect(() => requireRealtime('tokens', { ...production, ...tokens })).not.toThrow();
  });

  it('lets real time be off elsewhere', () => {
    expect(() => requireRealtime('publishing', { FOX_DROP_ENVIRONMENT: 'staging' })).not.toThrow();
    expect(publishingConfig({})).toBeNull();
    expect(publishingConfig(publishing)).toEqual({
      apiUrl: 'http://centrifugo:8000/api',
      apiKey: 'k',
    });
  });
});
