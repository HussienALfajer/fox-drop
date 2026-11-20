import { describe, expect, it, vi } from 'vitest';

vi.mock('./api.js', () => ({ api: {} }));

const {
  captainColour,
  captainsData,
  noFilters,
  ordersData,
  ordersToAssign,
  restaurantColour,
  restaurantOrders,
  restaurantsData,
  shownCaptains,
} = await import('./live-map.js');
type View = import('./live-map.js').LiveMapView;
type Captain = View['captains'][number];
type Order = View['orders'][number];

const money = (amount: string) => ({ amount, currency: 'TRY' });
const captain = (over: Partial<Captain>): Captain => ({
  captainId: 'c1',
  name: 'كابتن',
  vehicle: 'motorbike',
  state: 'online_available',
  blocks: [],
  custody: { usage: money('0'), limit: money('300000') },
  position: { latitude: 36.59, longitude: 37.04, recordedAt: '2026-11-19T10:00:00.000Z' },
  order: null,
  ...over,
});
const order = (over: Partial<Order>): Order => ({
  id: 'o1',
  number: '10001',
  status: 'accepted',
  restaurantId: 'r1',
  restaurantName: 'مطعم',
  from: { latitude: 36.587, longitude: 37.046 },
  to: { latitude: 36.59, longitude: 37.046 },
  captainId: null,
  assignable: true,
  ...over,
});
const view = (over: Partial<View>): View => ({
  zones: [],
  restaurants: [],
  captains: [],
  orders: [],
  ...over,
});

// AP §9.4 (slice 2.39): the colours and filters of the live map.
describe('the live map', () => {
  it('colours captains green available, orange busy, grey offline', () => {
    expect(captainColour({ state: 'online_available' })).toBe('available');
    expect(captainColour({ state: 'not_receiving_offers' })).toBe('available');
    expect(captainColour({ state: 'busy' })).toBe('busy');
    expect(captainColour({ state: 'last_order' })).toBe('busy');
    expect(captainColour({ state: 'offline' })).toBe('offline');
    expect(captainColour({ state: 'suspended' })).toBe('offline');
  });

  it('colours restaurants green open, amber paused, grey closed or suspended', () => {
    expect(restaurantColour('open')).toBe('open');
    expect(restaurantColour('busy')).toBe('open');
    expect(restaurantColour('paused')).toBe('paused');
    for (const state of ['closed', 'holiday', 'suspended'] as const) {
      expect(restaurantColour(state)).toBe('closed');
    }
  });

  it('filters the captains: available only, by vehicle, or the layer off', () => {
    const captains = [
      captain({ captainId: 'a' }),
      captain({ captainId: 'b', state: 'busy' }),
      captain({ captainId: 'c', vehicle: 'car' }),
      captain({ captainId: 'd', state: 'not_receiving_offers', blocks: ['cash_limit'] }),
    ];
    const ids = (list: Captain[]) => list.map((each) => each.captainId);
    expect(ids(shownCaptains(captains, noFilters))).toEqual(['a', 'b', 'c', 'd']);
    expect(ids(shownCaptains(captains, { ...noFilters, availableOnly: true }))).toEqual(['a', 'c']);
    expect(ids(shownCaptains(captains, { ...noFilters, vehicle: 'car' }))).toEqual(['c']);
    expect(shownCaptains(captains, { ...noFilters, layers: ['zones'] })).toEqual([]);
  });

  it('draws a captain with its colour, red outline and order number; one without a point not at all', () => {
    const data = captainsData(
      view({
        captains: [
          captain({
            captainId: 'a',
            state: 'busy',
            blocks: ['closed_due'],
            order: { id: 'o1', number: '10001' },
          }),
          captain({ captainId: 'b', position: null }),
        ],
      }),
      noFilters,
    );
    expect(data.features).toEqual([
      {
        type: 'Feature',
        properties: { id: 'a', colour: 'busy', blocked: true, number: '10001' },
        geometry: { type: 'Point', coordinates: [37.04, 36.59] },
      },
    ]);
  });

  it('draws each active order from the restaurant to the customer', () => {
    const data = ordersData(view({ orders: [order({})] }), noFilters);
    expect(data.features[0]?.geometry).toEqual({
      type: 'LineString',
      coordinates: [
        [37.046, 36.587],
        [37.046, 36.59],
      ],
    });
    expect(
      ordersData(view({ orders: [order({})] }), { ...noFilters, layers: [] }).features,
    ).toEqual([]);
    const restaurants = restaurantsData(
      view({
        restaurants: [
          {
            id: 'r1',
            name: 'مطعم',
            location: { latitude: 36.587, longitude: 37.046 },
            state: 'paused',
          },
        ],
      }),
      noFilters,
    );
    expect(restaurants.features[0]?.properties).toEqual({ id: 'r1', colour: 'paused' });
  });

  it('lists the orders to assign and a restaurant’s active orders', () => {
    const orders = [
      order({ id: 'o1' }),
      order({ id: 'o2', assignable: false, captainId: 'c1', restaurantId: 'r2' }),
    ];
    expect(ordersToAssign(orders).map((each) => each.id)).toEqual(['o1']);
    expect(restaurantOrders(orders, 'r2').map((each) => each.id)).toEqual(['o2']);
  });
});
