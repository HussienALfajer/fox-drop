// Centrifugo (architecture §6.1): its HTTP API, which the outbox relay
// publishes through, the secret of the connection tokens the API issues, and
// the secret Centrifugo sends with every subscription it asks the API about.
// Real time is off while any of them is missing: the token routes answer 503
// and the relay waits.
export interface RealtimeConfig {
  // Such as http://127.0.0.1:8000/api.
  apiUrl: string;
  apiKey: string;
  tokenSecret: string;
}

export function realtimeConfigFromEnvironment(env = process.env): RealtimeConfig | null {
  const apiUrl = env.CENTRIFUGO_API_URL;
  const apiKey = env.CENTRIFUGO_API_KEY;
  const tokenSecret = env.CENTRIFUGO_TOKEN_SECRET;
  if (!apiUrl || !apiKey || !tokenSecret || !env.CENTRIFUGO_PROXY_SECRET) return null;
  return { apiUrl: apiUrl.replace(/\/$/, ''), apiKey, tokenSecret };
}
