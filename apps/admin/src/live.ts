import { type QueryClient, type QueryKey, useQueryClient } from '@tanstack/react-query';
import { Centrifuge, type Subscription, UnauthorizedError } from 'centrifuge';
import { useEffect, useRef } from 'react';
import { api } from './api.js';

// Architecture §6.2, §10.3: the panel's live screens follow
// ops:city.{city_id}. Its events only name what changed; the panel reads the
// server again, which answers what the session may see.
export const opsChannel = (cityId: string): string => `ops:city.${cityId}`;

// What an event of the channel carries that the panel uses: an order's
// (order.placed, order.accepted…), an alert's (alert.raised,
// alert.acknowledged, alert.resolved), the emergency stop's
// (platform.emergency_stop), a restaurant's state (restaurant.state_changed)
// or a ticket's (ticket.changed, slice 2.23a).
export interface OpsEvent {
  type: string;
  orderId?: string;
  restaurantId?: string;
  ticketId?: string;
}

// The reads an event makes stale. An alert change also refreshes the board
// and the details, whose cards show the order's alerts (AP §9.2.1): a timed
// alert («مطعم لم يقبل») opens without any order event.
export function staleQueries(event: OpsEvent, cityId: string): QueryKey[] {
  if (event.type.startsWith('order.')) {
    return [
      ['orders-board', cityId],
      ['live-map', cityId],
      ...(event.orderId ? [['order', event.orderId]] : []),
    ];
  }
  if (event.type.startsWith('alert.'))
    return [['alerts', cityId], ['orders-board', cityId], ['order']];
  // AP §7: the emergency stop started or ended (the top bar).
  if (event.type === 'platform.emergency_stop') return [['emergency-stop', cityId]];
  // AP §9.6.5: a restaurant paused, resumed, busy or closed, by anyone.
  // The live map colours the restaurant by it (AP §9.4).
  if (event.type === 'restaurant.state_changed' && event.restaurantId) {
    return [
      ['restaurant-status', event.restaurantId],
      ['live-map', cityId],
    ];
  }
  // AP §9.9: a ticket opened or changed: the list, its page, the board's
  // «لها تذكرة» and the order details' tickets.
  if (event.type === 'ticket.changed') {
    return [
      ['tickets', cityId],
      ...(event.ticketId ? [['ticket', event.ticketId]] : []),
      ['orders-board', cityId],
      ['order'],
    ];
  }
  return [];
}

// §10.3: after every (re)subscription the panel reads the city's full state
// again: what it missed while away has no other way in.
export function cityQueries(cityId: string): QueryKey[] {
  return [
    ['orders-board', cityId],
    ['order'],
    ['alerts', cityId],
    ['emergency-stop', cityId],
    ['restaurant-status'],
    ['tickets', cityId],
    ['ticket'],
    ['live-map', cityId],
  ];
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
// follows a channel, and one subscription per channel followed, shared by
// the screens that follow it.
let client: Centrifuge | null = null;
const followed = new Map<string, { subscription: Subscription; screens: number }>();

interface ChannelHandlers {
  subscribed: () => void;
  // The subscription lost, while a screen still follows it.
  down: () => void;
  // The last screen left.
  left: () => void;
  publication: (data: unknown) => void;
}

function follow(channel: string, handlers: ChannelHandlers): () => void {
  client ??= new Centrifuge(websocketUrl(), { getToken: connectionToken });
  const connection = client;
  let entry = followed.get(channel);
  if (!entry) {
    const subscription = connection.newSubscription(channel);
    subscription.on('subscribed', handlers.subscribed);
    subscription.on('subscribing', handlers.down);
    subscription.on('unsubscribed', handlers.down);
    subscription.on('publication', (context) => handlers.publication(context.data));
    subscription.subscribe();
    entry = { subscription, screens: 0 };
    followed.set(channel, entry);
  }
  entry.screens += 1;
  connection.connect();
  const own = entry;
  return () => {
    own.screens -= 1;
    if (own.screens > 0) return;
    followed.delete(channel);
    handlers.left();
    own.subscription.removeAllListeners();
    connection.removeSubscription(own.subscription);
    if (followed.size === 0) connection.disconnect();
  };
}

function followOps(queryClient: QueryClient, cityId: string): () => void {
  return follow(opsChannel(cityId), {
    subscribed: () => {
      live.add(cityId);
      refresh(queryClient, cityQueries(cityId));
    },
    // The fallback starts with a full read, whose answer resets the timers.
    down: () => {
      if (!live.delete(cityId)) return;
      refresh(queryClient, cityQueries(cityId));
    },
    left: () => live.delete(cityId),
    publication: (data) => refresh(queryClient, staleQueries(data as OpsEvent, cityId)),
  });
}

// A screen that shows a city's orders or alerts follows its channel while it
// is open.
export function useOpsChannel(cityId: string | undefined): void {
  const queryClient = useQueryClient();
  useEffect(() => {
    if (cityId === undefined) return;
    return followOps(queryClient, cityId);
  }, [queryClient, cityId]);
}

// Architecture §6.2, AP §9.4 (slice 2.39): the live map screen follows
// ops_map:city.{city_id}, whose publications carry the city's whole
// captains layer every 10 s.
export const opsMapChannel = (cityId: string): string => `ops_map:city.${cityId}`;

// A publication of the channel: { type: "captains", captains }.
export interface OpsMapEvent<Captain> {
  type: string;
  captains?: Captain[];
}

// The captains a publication carries, or null for any other.
export function captainsOf<Captain>(event: OpsMapEvent<Captain>): Captain[] | null {
  return event.type === 'captains' && Array.isArray(event.captains) ? event.captains : null;
}

// The cities whose map channel is subscribed now, with when it last
// answered (the subscription or a publication). The worker publishes every
// 10 s; a channel silent for longer than MAP_SILENT_MS (a stopped worker)
// counts as down, so the map reads again.
const liveMaps = new Map<string, number>();
export const MAP_SILENT_MS = 25_000;

export function mapLive(cityId: string | undefined, now = Date.now()): boolean {
  const heard = cityId === undefined ? undefined : liveMaps.get(cityId);
  return heard !== undefined && now - heard < MAP_SILENT_MS;
}

// The map follows the channel while it is open: each publication replaces
// the captains of the map's read (`put`), and every (re)subscription reads
// the whole map again (no recovery).
export function useOpsMapChannel<Captain>(
  cityId: string | undefined,
  put: (cityId: string, captains: Captain[]) => void,
): void {
  const queryClient = useQueryClient();
  const latest = useRef(put);
  useEffect(() => {
    latest.current = put;
  });
  useEffect(() => {
    if (cityId === undefined) return;
    return follow(opsMapChannel(cityId), {
      subscribed: () => {
        liveMaps.set(cityId, Date.now());
        refresh(queryClient, [['live-map', cityId]]);
      },
      // The fallback starts with a full read, whose answer resets the timer.
      down: () => {
        if (liveMaps.delete(cityId)) refresh(queryClient, [['live-map', cityId]]);
      },
      left: () => liveMaps.delete(cityId),
      publication: (data) => {
        const captains = captainsOf(data as OpsMapEvent<Captain>);
        if (!captains) return;
        liveMaps.set(cityId, Date.now());
        latest.current(cityId, captains);
      },
    });
  }, [queryClient, cityId]);
}
