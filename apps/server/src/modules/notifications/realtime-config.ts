// Centrifugo (architecture §6.1). Each process reads what it uses, at each
// call: the API signs connection tokens (CENTRIFUGO_TOKEN_SECRET) and checks
// the proxy's secret (CENTRIFUGO_PROXY_SECRET, in the route guard); the API
// and the worker publish and disconnect through the HTTP API
// (CENTRIFUGO_API_URL, CENTRIFUGO_API_KEY). Without them real time is off:
// the token routes answer 503 and the relay leaves the outbox as it is. In
// production a missing one stops the process at start (requireRealtime).
export interface PublishingConfig {
  // Such as http://127.0.0.1:8000/api.
  apiUrl: string;
  apiKey: string;
}

export function publishingConfig(env = process.env): PublishingConfig | null {
  const apiUrl = env.CENTRIFUGO_API_URL;
  const apiKey = env.CENTRIFUGO_API_KEY;
  if (!apiUrl || !apiKey) return null;
  return { apiUrl: apiUrl.replace(/\/$/, ''), apiKey };
}

export function tokenSecret(env = process.env): string | null {
  return env.CENTRIFUGO_TOKEN_SECRET || null;
}

const NAMES = {
  publishing: ['CENTRIFUGO_API_URL', 'CENTRIFUGO_API_KEY'],
  tokens: ['CENTRIFUGO_TOKEN_SECRET', 'CENTRIFUGO_PROXY_SECRET'],
} as const;

// RA §4.3: restaurant devices ring only through real time, so production never
// starts without it; elsewhere it may be off (staging until Centrifugo joins
// it, the OpenAPI generation, tests).
export function requireRealtime(part: keyof typeof NAMES, env = process.env): void {
  if (env.FOX_DROP_ENVIRONMENT !== 'production') return;
  const missing = NAMES[part].filter((name) => !env[name]);
  if (missing.length > 0) throw new Error(`real time needs ${missing.join(', ')} in production`);
}
