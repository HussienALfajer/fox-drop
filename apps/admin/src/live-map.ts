import type { components } from '@fox-drop/api-schema';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { useCallback, useRef } from 'react';
import { api } from './api.js';
import { type AssignResult, postAssign } from './assign-captain.js';
import { mapLive, pollUnlessLive, useOpsChannel, useOpsMapChannel } from './live.js';
import type { AdminSession } from './session.js';
import { can } from './session.js';
import { type Collection, mapCentre, type Point, zonesData } from './zones.js';

// AP §9.4 «الخريطة الحية» (slice 2.39): the city's zones, restaurants,
// captains and active orders on one map, and «عيّنه لطلب» from a
// captain's card. OWN and OPS in full, SUP read (AP §6.2). Unstyled until
// the design (owner decision 2026-11-19): the colours of the spec only tell
// the layers apart.
export const LIVE_MAP_READ = 'live_map.read';
export const OPERATIONS_MANAGE = 'operations.manage';

export const canSeeLiveMap = (session: AdminSession): boolean => can(session, LIVE_MAP_READ);
// The assignment is AP §9.3.2's (operations.manage: OWN, OPS).
export const canAssignFromMap = (session: AdminSession): boolean => can(session, OPERATIONS_MANAGE);

export type LiveMapView = components['schemas']['AdminLiveMapDto_Output'];
export type MapCaptain = LiveMapView['captains'][number];
export type MapRestaurant = LiveMapView['restaurants'][number];
export type MapOrder = LiveMapView['orders'][number];
export type Vehicle = MapCaptain['vehicle'];

// AP §9.4: green available, orange busy (with an order number), grey
// offline (its last known position and time).
export type CaptainColour = 'available' | 'busy' | 'offline';

export function captainColour(captain: Pick<MapCaptain, 'state'>): CaptainColour {
  switch (captain.state) {
    case 'online_available':
    case 'not_receiving_offers':
      return 'available';
    case 'busy':
    case 'last_order':
      return 'busy';
    case 'offline':
    case 'suspended':
      return 'offline';
  }
}

// AP §9.4 «red outline»: unhanded cash or the cash limit.
export const blocked = (captain: Pick<MapCaptain, 'blocks'>): boolean => captain.blocks.length > 0;

// AP §9.4: green open, amber paused, grey closed or suspended.
export type RestaurantColour = 'open' | 'paused' | 'closed';

export function restaurantColour(state: MapRestaurant['state']): RestaurantColour {
  if (state === 'open' || state === 'busy') return 'open';
  if (state === 'paused') return 'paused';
  return 'closed';
}

export const mapLayers = ['restaurants', 'captains', 'orders', 'zones'] as const;
export type MapLayer = (typeof mapLayers)[number];

// AP §9.4 filters: available only, the vehicle type, the layers.
export interface MapFilters {
  availableOnly: boolean;
  vehicle: Vehicle | null;
  layers: MapLayer[];
}

export const noFilters: MapFilters = {
  availableOnly: false,
  vehicle: null,
  layers: [...mapLayers],
};

// «متاح فقط»: online and receiving offers (green, not blocked).
export function shownCaptains(captains: MapCaptain[], filters: MapFilters): MapCaptain[] {
  if (!filters.layers.includes('captains')) return [];
  return captains.filter(
    (captain) =>
      (!filters.availableOnly || captain.state === 'online_available') &&
      (filters.vehicle === null || captain.vehicle === filters.vehicle),
  );
}

// «اتصال»: the number in full opens the phone's dialler.
export const telHref = (phone: string): string => `tel:${phone}`;

// What «عيّنه لطلب» lists: the orders without a captain the assignment takes.
export function ordersToAssign(orders: MapOrder[]): MapOrder[] {
  return orders.filter((order) => order.assignable);
}

// A restaurant's card: its active orders.
export function restaurantOrders(orders: MapOrder[], restaurantId: string): MapOrder[] {
  return orders.filter((order) => order.restaurantId === restaurantId);
}

// Where the map starts: the middle of the zones, else of the restaurants.
export function liveMapCentre(view: LiveMapView): Point | null {
  return (
    mapCentre(view.zones, []) ??
    mapCentre(
      [],
      view.restaurants.map((restaurant) => ({ ...restaurant.location, votes: 0 })),
    )
  );
}

export function liveZonesData(view: LiveMapView, filters: MapFilters): Collection {
  return filters.layers.includes('zones')
    ? zonesData(view.zones, null)
    : { type: 'FeatureCollection', features: [] };
}

export function restaurantsData(view: LiveMapView, filters: MapFilters): Collection {
  return {
    type: 'FeatureCollection',
    features: filters.layers.includes('restaurants')
      ? view.restaurants.map((restaurant) => ({
          type: 'Feature',
          properties: { id: restaurant.id, colour: restaurantColour(restaurant.state) },
          geometry: {
            type: 'Point',
            coordinates: [restaurant.location.longitude, restaurant.location.latitude],
          },
        }))
      : [],
  };
}

export function captainsData(view: LiveMapView, filters: MapFilters): Collection {
  return {
    type: 'FeatureCollection',
    features: shownCaptains(view.captains, filters).flatMap((captain) =>
      captain.position
        ? [
            {
              type: 'Feature' as const,
              properties: {
                id: captain.captainId,
                colour: captainColour(captain),
                blocked: blocked(captain),
                number: captain.order?.number ?? '',
              },
              geometry: {
                type: 'Point' as const,
                coordinates: [captain.position.longitude, captain.position.latitude],
              },
            },
          ]
        : [],
    ),
  };
}

export function ordersData(view: LiveMapView, filters: MapFilters): Collection {
  return {
    type: 'FeatureCollection',
    features: filters.layers.includes('orders')
      ? view.orders.map((order) => ({
          type: 'Feature',
          properties: { id: order.id, assigned: order.captainId !== null },
          geometry: {
            type: 'LineString',
            coordinates: [
              [order.from.longitude, order.from.latitude],
              [order.to.longitude, order.to.latitude],
            ],
          },
        }))
      : [],
  };
}

const liveMapKey = (cityId: string) => ['live-map', cityId] as const;

// The polling fallback while a channel is down (as the board's), and while
// both are up a slower read that also notices a silent map channel
// (mapLive) and keeps the restaurants' timed states current.
const FALLBACK_MS = 10_000;
const LIVE_READ_MS = 30_000;

// The map's read, kept current by both channels: ops:city (orders and
// restaurants change: the read again) and ops_map:city (the captains every
// 10 s, put in place).
export function useLiveMap(cityId: string | undefined) {
  const queryClient = useQueryClient();
  useOpsChannel(cityId);
  const put = useCallback(
    (city: string, captains: MapCaptain[]) => {
      queryClient.setQueryData<LiveMapView>(liveMapKey(city), (view) =>
        view ? { ...view, captains } : view,
      );
    },
    [queryClient],
  );
  useOpsMapChannel<MapCaptain>(cityId, put);
  const opsPoll = pollUnlessLive(cityId, FALLBACK_MS);
  return useQuery({
    queryKey: liveMapKey(cityId ?? ''),
    enabled: cityId !== undefined,
    refetchInterval: () => (mapLive(cityId) && opsPoll() === false ? LIVE_READ_MS : FALLBACK_MS),
    queryFn: async (): Promise<LiveMapView> => {
      const { data } = await api.GET('/v1/admin/live-map', {
        params: { query: { cityId: cityId! } },
      });
      if (!data) throw new Error('The live map read failed.');
      return data;
    },
  });
}

// «عيّنه لطلب» (AP §9.4, §9.3.2): the captain to one of the orders without
// a captain. One key per order until an answer arrives, so a retry after a
// lost answer replays instead of acting twice (architecture §5.3).
export function useAssignFromMap(cityId: string, captainId: string) {
  const queryClient = useQueryClient();
  const keys = useRef(new Map<string, string>());
  return useMutation({
    mutationFn: async (orderId: string): Promise<AssignResult> => {
      let key = keys.current.get(orderId);
      if (key === undefined) {
        key = crypto.randomUUID();
        keys.current.set(orderId, key);
      }
      const result = await postAssign(orderId, captainId, key);
      if (result === null) throw new Error('The assignment failed.');
      keys.current.delete(orderId);
      return result;
    },
    onSettled: () =>
      Promise.all([
        queryClient.invalidateQueries({ queryKey: liveMapKey(cityId) }),
        queryClient.invalidateQueries({ queryKey: ['orders-board'] }),
        queryClient.invalidateQueries({ queryKey: ['order'] }),
      ]),
  });
}
