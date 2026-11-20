import { type QueryClient, useQueryClient } from '@tanstack/react-query';
import { Centrifuge, UnauthorizedError } from 'centrifuge';
import { createContext, useEffect, useState } from 'react';
import { api } from './api.js';
import { MENU_KINDS } from './menu.js';

// RA §17, §4.3, architecture §6.1–6.2: the live orders follow the
// restaurant's channel, as every device does. The portal never counts as a
// receiving device: the server counts app sessions only (RA §4.6).
export const merchantChannel = (restaurantId: string): string => `merchant:${restaurantId}`;

// What a publication says that the portal uses: an order's event, the
// restaurant's state or the platform's stop.
export interface MerchantEvent {
  type: string;
  orderId?: string;
  // A restaurant.state_changed's kind (RA §18).
  kind?: string;
}

// The menu's reads, after a change of the menu (slice 2.45b).
const menuReads = [['menu'], ['menu-price-log'], ['menu-preview']];

// The reads a publication makes stale: the portal reads the server again,
// which answers what the owner may see.
export function staleKeys(event: MerchantEvent): string[][] {
  if (event.type.startsWith('order.')) {
    return [['board'], ...(event.orderId ? [['order', event.orderId]] : [])];
  }
  if (event.type === 'restaurant.state_changed') {
    // The hours and the prep time change on another device or by
    // operations too (slice 2.45c).
    return event.kind !== undefined && MENU_KINDS.has(event.kind)
      ? [['restaurant-status'], ...menuReads]
      : [['restaurant-status'], ['restaurant-hours']];
  }
  if (event.type === 'platform.emergency_stop') return [['emergency-stop']];
  return [];
}

// After every (re)subscription everything is read again: what was missed
// while away has no other way in (RA §4.3).
const everything = [
  ['board'],
  ['order'],
  ['restaurant-status'],
  ['restaurant-hours'],
  ['pickup-currencies'],
  ['devices'],
  ['portal-sessions'],
  ['emergency-stop'],
  ...menuReads,
];

function refresh(queryClient: QueryClient, keys: string[][]) {
  for (const queryKey of keys) void queryClient.invalidateQueries({ queryKey });
}

// Centrifugo's WebSocket on the portal's own origin: nginx forwards it on
// staging and production, Vite in development (vite.config.ts).
function websocketUrl(): string {
  const scheme = window.location.protocol === 'https:' ? 'wss' : 'ws';
  return `${scheme}://${window.location.host}/connection/websocket`;
}

// The connection token, asked with the session's cookie; no secret is in the
// bundle (E7). A 401 means the session ended: api.ts returns to sign-in.
async function connectionToken(): Promise<string> {
  const { data, response } = await api.POST('/v1/merchant/realtime/token');
  // 401: the session ended; 403: the restaurant was terminated (RA §5.5).
  // Either way the client stops reconnecting.
  if (response.status === 401 || response.status === 403) {
    throw new UnauthorizedError('no connection for this session');
  }
  if (!data) throw new Error(`The real-time token failed (${response.status}).`);
  return data.token;
}

// While a screen follows the restaurant's channel; whether it is live now.
// The reads poll only while it is down (pollUnlessLive).
export function useMerchantChannel(restaurantId: string | undefined): boolean {
  const queryClient = useQueryClient();
  const [live, setLive] = useState(false);
  useEffect(() => {
    if (restaurantId === undefined) return;
    const client = new Centrifuge(websocketUrl(), { getToken: connectionToken });
    const subscription = client.newSubscription(merchantChannel(restaurantId));
    subscription.on('subscribed', () => {
      setLive(true);
      refresh(queryClient, everything);
    });
    const down = () => setLive(false);
    subscription.on('subscribing', down);
    subscription.on('unsubscribed', down);
    subscription.on('publication', (context) =>
      refresh(queryClient, staleKeys(context.data as MerchantEvent)),
    );
    subscription.subscribe();
    client.connect();
    return () => {
      subscription.removeAllListeners();
      client.disconnect();
      setLive(false);
    };
  }, [queryClient, restaurantId]);
  return live;
}

// RA §4.3: the full read every 30 seconds while the socket is down.
export const FALLBACK_POLL_MS = 30_000;

// Whether the layout's channel is live, for the pages that poll without it.
export const LiveContext = createContext(false);

// The restaurant's city clock, from the session, for every time shown.
export const TimeZoneContext = createContext('Asia/Damascus');
