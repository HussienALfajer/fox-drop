import { type QueryClient, type QueryKey, useQueryClient } from '@tanstack/react-query';
import { Centrifuge, type Subscription, UnauthorizedError } from 'centrifuge';
import { useEffect } from 'react';
import { api } from './api.js';

// Architecture §6.2, §10.3: the panel's live screens follow
// ops:city.{city_id}. Its events only name what changed; the panel reads the
// server again, which answers what the session may see.
export const opsChannel = (cityId: string): string => `ops:city.${cityId}`;

// What an event of the channel carries that the panel uses: an order's
// (order.placed, order.accepted…) or an alert's (alert.raised,
// alert.acknowledged, alert.resolved).
export interface OpsEvent {
  type: string;
  orderId?: string;
}

// The reads an event makes stale.
export function staleQueries(event: OpsEvent, cityId: string): QueryKey[] {
  if (event.type.startsWith('order.')) {
    return [['orders-board', cityId], ...(event.orderId ? [['order', event.orderId]] : [])];
  }
  if (event.type.startsWith('alert.')) return [['alerts', cityId]];
  return [];
}

// §10.3: after every (re)subscription the panel reads the city's full state
// again: what it missed while away has no other way in.
export function cityQueries(cityId: string): QueryKey[] {
  return [['orders-board', cityId], ['order'], ['alerts', cityId]];
}

// The cities whose channel is subscribed now. A read of a live city waits
// for the channel's events; one of a city whose socket is down reads again
// every `ms` (the fallback, owner decision 2026-11-07).
const live = new Set<string>();

export function pollUnlessLive(cityId: string | undefined, ms: number): () => number | false {
  return () => (cityId !== undefined && live.has(cityId) ? false : ms);
}

// Centrifugo's WebSocket on the panel's own origin: nginx forwards it on
// staging and production, Vite in development (vite.config.ts).
function websocketUrl(): string {
  const scheme = window.location.protocol === 'https:' ? 'wss' : 'ws';
  return `${scheme}://${window.location.host}/connection/websocket`;
}

// The connection token, asked with the session's cookie; no secret is in the
// bundle (E7). A 401 means the session ended: the client stops reconnecting
// and api.ts returns to the sign-in page.
async function connectionToken(): Promise<string> {
  const { data, response } = await api.POST('/v1/admin/realtime/token');
  if (response.status === 401) throw new UnauthorizedError('the session ended');
  if (!data) throw new Error(`The real-time token failed (${response.status}).`);
  return data.token;
}

function refresh(queryClient: QueryClient, keys: QueryKey[]): void {
  for (const queryKey of keys) void queryClient.invalidateQueries({ queryKey });
}

// One connection for the panel (architecture §6.1), open while a screen
// follows a city, and one subscription per city followed, shared by the
// screens that follow it.
let client: Centrifuge | null = null;
const followed = new Map<string, { subscription: Subscription; screens: number }>();

function follow(queryClient: QueryClient, cityId: string): () => void {
  client ??= new Centrifuge(websocketUrl(), { getToken: connectionToken });
  const connection = client;
  let entry = followed.get(cityId);
  if (!entry) {
    const subscription = connection.newSubscription(opsChannel(cityId));
    const down = () => {
      if (!live.delete(cityId)) return;
      // The fallback starts with a full read, whose answer resets the timers.
      refresh(queryClient, cityQueries(cityId));
    };
    subscription.on('subscribed', () => {
      live.add(cityId);
      refresh(queryClient, cityQueries(cityId));
    });
    subscription.on('subscribing', down);
    subscription.on('unsubscribed', down);
    subscription.on('publication', (context) => {
      refresh(queryClient, staleQueries(context.data as OpsEvent, cityId));
    });
    subscription.subscribe();
    entry = { subscription, screens: 0 };
    followed.set(cityId, entry);
  }
  entry.screens += 1;
  connection.connect();
  const own = entry;
  return () => {
    own.screens -= 1;
    if (own.screens > 0) return;
    followed.delete(cityId);
    live.delete(cityId);
    own.subscription.removeAllListeners();
    connection.removeSubscription(own.subscription);
    if (followed.size === 0) connection.disconnect();
  };
}

// A screen that shows a city's orders or alerts follows its channel while it
// is open.
export function useOpsChannel(cityId: string | undefined): void {
  const queryClient = useQueryClient();
  useEffect(() => {
    if (cityId === undefined) return;
    return follow(queryClient, cityId);
  }, [queryClient, cityId]);
}
