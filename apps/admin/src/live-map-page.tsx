import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link } from '@tanstack/react-router';
import { lazy, Suspense, useMemo, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { assignRefusalKeys, ineligibleKeys, secondsLeft } from './assign-captain.js';
import { canMessage, useCaptainPhone } from './captain-profile.js';
import { chosenCity, citiesQuery, type City } from './cities.js';
import { useServerNow } from './clock.js';
import { formatDateTime, formatMoney } from './format.js';
import {
  blocked,
  canAssignFromMap,
  captainColour,
  liveMapCentre,
  type LiveMapView,
  type MapCaptain,
  type MapFilters,
  type MapLayer,
  mapLayers,
  noFilters,
  ordersToAssign,
  type MapRestaurant,
  restaurantColour,
  restaurantOrders,
  shownCaptains,
  telHref,
  useAssignFromMap,
  useLiveMap,
  type Vehicle,
} from './live-map.js';
import type { MapSelection } from './live-map-canvas.js';
import { statusKeys, vehicleKeys } from './order-labels.js';
import type { AdminSession } from './session.js';

const LiveMapCanvas = lazy(() =>
  import('./live-map-canvas.js').then((module) => ({ default: module.LiveMapCanvas })),
);

const route = getRouteApi('/signed-in/live-map');
const signedIn = getRouteApi('/signed-in');

const captainStateKeys = {
  online_available: 'liveMap.captainState.available',
  not_receiving_offers: 'liveMap.captainState.noOffers',
  busy: 'liveMap.captainState.busy',
  last_order: 'liveMap.captainState.lastOrder',
  offline: 'liveMap.captainState.offline',
  suspended: 'liveMap.captainState.suspended',
} as const satisfies Record<MapCaptain['state'], string>;

const colourKeys = {
  available: 'liveMap.colour.available',
  busy: 'liveMap.colour.busy',
  offline: 'liveMap.colour.offline',
} as const;

const restaurantStateKeys = {
  open: 'liveMap.restaurantState.open',
  busy: 'liveMap.restaurantState.busy',
  paused: 'liveMap.restaurantState.paused',
  closed: 'liveMap.restaurantState.closed',
  holiday: 'liveMap.restaurantState.holiday',
  suspended: 'liveMap.restaurantState.suspended',
} as const satisfies Record<MapRestaurant['state'], string>;

const restaurantColourKeys = {
  open: 'liveMap.colour.open',
  paused: 'liveMap.colour.paused',
  closed: 'liveMap.colour.closed',
} as const;

const blockKeys = {
  closed_due: 'assign.reason.closedDue',
  cash_limit: 'assign.reason.cashLimit',
} as const satisfies Record<MapCaptain['blocks'][number], string>;

const layerKeys = {
  restaurants: 'liveMap.layer.restaurants',
  captains: 'liveMap.layer.captains',
  orders: 'liveMap.layer.orders',
  zones: 'liveMap.layer.zones',
} as const satisfies Record<MapLayer, string>;

// AP §9.4 «الخريطة الحية» (slice 2.39): the map with its filters, the
// captains, restaurants and active orders also as lists (the map needs
// WebGL and its files), and the card of the captain or restaurant chosen,
// on the map or in a list. Unstyled until the design.
export function LiveMapPage() {
  const { t } = useTranslation();
  const search = route.useSearch();
  const { session } = signedIn.useRouteContext();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  const map = useLiveMap(city?.id);
  const [filters, setFilters] = useState<MapFilters>(noFilters);
  const [selected, setSelected] = useState<MapSelection | null>(null);
  return (
    <main>
      <h1>{t('liveMap.title')}</h1>
      <p>{t('liveMap.explain')}</p>
      {map.isError && <p role="alert">{t('status.error')}</p>}
      {!city || map.isPending ? (
        <p>{t('status.loading')}</p>
      ) : map.data ? (
        <LiveMapBody
          view={map.data}
          city={city}
          session={session}
          filters={filters}
          onFilters={setFilters}
          selected={selected}
          onSelect={setSelected}
        />
      ) : null}
    </main>
  );
}

function LiveMapBody(props: {
  view: LiveMapView;
  city: City;
  session: AdminSession;
  filters: MapFilters;
  onFilters: (filters: MapFilters) => void;
  selected: MapSelection | null;
  onSelect: (selection: MapSelection | null) => void;
}) {
  const { t } = useTranslation();
  const { view, city, filters, selected } = props;
  const centre = useMemo(() => liveMapCentre(view), [view]);
  const captains = shownCaptains(view.captains, filters);
  const captain =
    selected?.kind === 'captain'
      ? view.captains.find((each) => each.captainId === selected.id)
      : undefined;
  const restaurant =
    selected?.kind === 'restaurant'
      ? view.restaurants.find((each) => each.id === selected.id)
      : undefined;
  return (
    <>
      <Filters filters={filters} onFilters={props.onFilters} />
      <Suspense fallback={<p>{t('status.loading')}</p>}>
        <LiveMapCanvas view={view} filters={filters} centre={centre} onSelect={props.onSelect} />
      </Suspense>
      {captain && (
        <CaptainCard
          key={captain.captainId}
          captain={captain}
          view={view}
          city={city}
          session={props.session}
          onClose={() => props.onSelect(null)}
        />
      )}
      {restaurant && (
        <RestaurantCard restaurant={restaurant} view={view} onClose={() => props.onSelect(null)} />
      )}
      {filters.layers.includes('captains') && (
        <section aria-labelledby="map-captains">
          <h2 id="map-captains">{t('liveMap.captains', { count: captains.length })}</h2>
          {captains.length === 0 ? (
            <p>{t('liveMap.noCaptains')}</p>
          ) : (
            <ul>
              {captains.map((each) => (
                <li key={each.captainId}>
                  <button
                    type="button"
                    onClick={() => props.onSelect({ kind: 'captain', id: each.captainId })}
                  >
                    {t('liveMap.captainLine', {
                      name: each.name,
                      colour: t(colourKeys[captainColour(each)]),
                      state: t(captainStateKeys[each.state]),
                    })}
                  </button>
                  {blocked(each) && <span> {t('liveMap.blocked')}</span>}
                  {each.order && (
                    <span> {t('liveMap.orderTooltip', { number: each.order.number })}</span>
                  )}
                </li>
              ))}
            </ul>
          )}
        </section>
      )}
      {filters.layers.includes('restaurants') && (
        <section aria-labelledby="map-restaurants">
          <h2 id="map-restaurants">
            {t('liveMap.restaurants', { count: view.restaurants.length })}
          </h2>
          <ul>
            {view.restaurants.map((each) => (
              <li key={each.id}>
                <button
                  type="button"
                  onClick={() => props.onSelect({ kind: 'restaurant', id: each.id })}
                >
                  {t('liveMap.restaurantLine', {
                    name: each.name,
                    colour: t(restaurantColourKeys[restaurantColour(each.state)]),
                    state: t(restaurantStateKeys[each.state]),
                  })}
                </button>
              </li>
            ))}
          </ul>
        </section>
      )}
      {filters.layers.includes('orders') && (
        <section aria-labelledby="map-orders">
          <h2 id="map-orders">{t('liveMap.orders', { count: view.orders.length })}</h2>
          {view.orders.length === 0 ? (
            <p>{t('liveMap.noOrders')}</p>
          ) : (
            <ul>
              {view.orders.map((order) => (
                <li key={order.id}>
                  <OrderLink order={order} />
                  {order.assignable && <span> {t('liveMap.needsCaptain')}</span>}
                </li>
              ))}
            </ul>
          )}
        </section>
      )}
    </>
  );
}

function OrderLink({ order }: { order: LiveMapView['orders'][number] }) {
  const { t } = useTranslation();
  return (
    <Link to="/orders/$orderId" params={{ orderId: order.id }} search>
      {t('liveMap.orderLine', {
        number: order.number,
        status: t(statusKeys[order.status]),
        restaurant: order.restaurantName,
      })}
    </Link>
  );
}

function Filters(props: { filters: MapFilters; onFilters: (filters: MapFilters) => void }) {
  const { t } = useTranslation();
  const { filters } = props;
  const toggle = (layer: MapLayer, on: boolean) =>
    props.onFilters({
      ...filters,
      layers: on
        ? mapLayers.filter((each) => each === layer || filters.layers.includes(each))
        : filters.layers.filter((each) => each !== layer),
    });
  return (
    <fieldset>
      <legend>{t('liveMap.filters')}</legend>
      <label>
        <input
          type="checkbox"
          checked={filters.availableOnly}
          onChange={(event) => props.onFilters({ ...filters, availableOnly: event.target.checked })}
        />
        {t('liveMap.availableOnly')}
      </label>
      <label>
        {t('liveMap.vehicle')}
        <select
          value={filters.vehicle ?? ''}
          onChange={(event) =>
            props.onFilters({
              ...filters,
              vehicle: event.target.value === '' ? null : (event.target.value as Vehicle),
            })
          }
        >
          <option value="">{t('liveMap.allVehicles')}</option>
          {(Object.keys(vehicleKeys) as Vehicle[]).map((vehicle) => (
            <option key={vehicle} value={vehicle}>
              {t(vehicleKeys[vehicle])}
            </option>
          ))}
        </select>
      </label>
      {mapLayers.map((layer) => (
        <label key={layer}>
          <input
            type="checkbox"
            checked={filters.layers.includes(layer)}
            onChange={(event) => toggle(layer, event.target.checked)}
          />
          {t(layerKeys[layer])}
        </label>
      ))}
    </fieldset>
  );
}

// AP §9.4: the captain's name, phone (call), vehicle, current order, last
// GPS time, cash-limit usage and «عيّنه لطلب».
function CaptainCard(props: {
  captain: MapCaptain;
  view: LiveMapView;
  city: City;
  session: AdminSession;
  onClose: () => void;
}) {
  const { t } = useTranslation();
  const { captain, city, session } = props;
  const phone = useCaptainPhone(captain.captainId);
  const [assigning, setAssigning] = useState(false);
  return (
    <section aria-labelledby="map-captain">
      <h2 id="map-captain">{captain.name}</h2>
      <dl>
        <dt>{t('liveMap.card.state')}</dt>
        <dd>
          {t(captainStateKeys[captain.state])}
          {captain.blocks.map((block) => (
            <span key={block}> {t(blockKeys[block])}</span>
          ))}
        </dd>
        <dt>{t('liveMap.card.vehicle')}</dt>
        <dd>{t(vehicleKeys[captain.vehicle])}</dd>
        <dt>{t('liveMap.card.order')}</dt>
        <dd>
          {captain.order ? (
            <Link to="/orders/$orderId" params={{ orderId: captain.order.id }} search>
              {t('liveMap.orderTooltip', { number: captain.order.number })}
            </Link>
          ) : (
            t('liveMap.card.noOrder')
          )}
        </dd>
        <dt>{t('liveMap.card.lastFix')}</dt>
        <dd>
          {captain.position
            ? formatDateTime(captain.position.recordedAt, city.timeZone)
            : t('liveMap.card.noFix')}
        </dd>
        <dt>{t('liveMap.card.cash')}</dt>
        <dd>
          {t('assign.custody', {
            usage: formatMoney(captain.custody.usage),
            limit: formatMoney(captain.custody.limit),
          })}
        </dd>
        {canMessage(session) && (
          <>
            <dt>{t('liveMap.card.phone')}</dt>
            <dd>
              {phone.data ? (
                <a href={telHref(phone.data)} dir="ltr">
                  {phone.data}
                </a>
              ) : phone.data === null ? (
                t('liveMap.card.noPhone')
              ) : (
                // captains.manage calls the captain; each read is audited.
                <button type="button" disabled={phone.isPending} onClick={() => phone.mutate()}>
                  {t('liveMap.card.call')}
                </button>
              )}
            </dd>
          </>
        )}
      </dl>
      {phone.isError && <p role="alert">{t('common.failed')}</p>}
      {canAssignFromMap(session) &&
        (assigning ? (
          <AssignToOrder captain={captain} view={props.view} cityId={city.id} />
        ) : (
          <button type="button" onClick={() => setAssigning(true)}>
            {t('liveMap.assign')}
          </button>
        ))}
      <button type="button" onClick={props.onClose}>
        {t('liveMap.close')}
      </button>
    </section>
  );
}

function AssignToOrder(props: { captain: MapCaptain; view: LiveMapView; cityId: string }) {
  const { t } = useTranslation();
  const assign = useAssignFromMap(props.cityId, props.captain.captainId);
  const now = useServerNow();
  const orders = ordersToAssign(props.view.orders);
  if (assign.data && assign.data.status !== 'refused') {
    return (
      <p role="status">
        {assign.data.status === 'offered'
          ? t('assign.offered', { seconds: secondsLeft(assign.data.expiresAt, now) })
          : t('assign.assigned')}
      </p>
    );
  }
  return (
    <section aria-labelledby="map-assign">
      <h3 id="map-assign">{t('liveMap.assignTitle', { name: props.captain.name })}</h3>
      {assign.data?.status === 'refused' && (
        <p role="alert">
          {t(assignRefusalKeys[assign.data.refusal])}
          {assign.data.reasons.map((reason) => (
            <span key={reason}> {t(ineligibleKeys[reason])}</span>
          ))}
        </p>
      )}
      {assign.isError && <p role="alert">{t('common.failed')}</p>}
      {orders.length === 0 ? (
        <p>{t('liveMap.noOrdersToAssign')}</p>
      ) : (
        <ul>
          {orders.map((order) => (
            <li key={order.id}>
              <button
                type="button"
                disabled={assign.isPending}
                onClick={() => assign.mutate(order.id)}
              >
                {t('liveMap.assignTo', { number: order.number, restaurant: order.restaurantName })}
              </button>
            </li>
          ))}
        </ul>
      )}
    </section>
  );
}

// AP §9.4: the restaurant's state and its active orders.
function RestaurantCard(props: {
  restaurant: MapRestaurant;
  view: LiveMapView;
  onClose: () => void;
}) {
  const { t } = useTranslation();
  const { restaurant } = props;
  const orders = restaurantOrders(props.view.orders, restaurant.id);
  return (
    <section aria-labelledby="map-restaurant">
      <h2 id="map-restaurant">{restaurant.name}</h2>
      <p>{t(restaurantStateKeys[restaurant.state])}</p>
      <h3>{t('liveMap.activeOrders', { count: orders.length })}</h3>
      {orders.length > 0 && (
        <ul>
          {orders.map((order) => (
            <li key={order.id}>
              <OrderLink order={order} />
            </li>
          ))}
        </ul>
      )}
      <button type="button" onClick={props.onClose}>
        {t('liveMap.close')}
      </button>
    </section>
  );
}
