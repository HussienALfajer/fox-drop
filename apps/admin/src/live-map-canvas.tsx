import { type GeoJSONSource, Map as MapLibre, Popup } from 'maplibre-gl';
import 'maplibre-gl/dist/maplibre-gl.css';
import { useEffect, useRef, useState } from 'react';
import { useTranslation } from 'react-i18next';
import {
  captainsData,
  liveZonesData,
  type LiveMapView,
  type MapFilters,
  ordersData,
  restaurantsData,
} from './live-map.js';
import { drawable, prepare } from './pin-map.js';
import './pin-map.css';
import { localStyle } from './restaurant-drafts.js';
import type { Collection, Point } from './zones.js';

const CITY_ZOOM = 13;

// AP §9.4's colours, the only look until the design (owner decision
// 2026-11-19): restaurants green open, amber paused, grey closed; captains
// green available, orange busy, grey offline, a red outline when blocked.
const RESTAURANT_COLOURS = [
  'match',
  ['get', 'colour'],
  'open',
  'green',
  'paused',
  'orange',
  'grey',
];
const CAPTAIN_COLOURS = [
  'match',
  ['get', 'colour'],
  'available',
  'green',
  'busy',
  'darkorange',
  'grey',
];

export type MapSelection = { kind: 'captain' | 'restaurant'; id: string };

// AP §9.4 (slice 2.39): the zones, the active orders as lines from the
// restaurant to the customer, the restaurants and the captains. A click on
// a captain or a restaurant selects it (its card is the page's); a busy
// captain shows its order's number on hover. Without WebGL or the map's
// files the page's lists remain.
export function LiveMapCanvas(props: {
  view: LiveMapView;
  filters: MapFilters;
  centre: Point | null;
  onSelect: (selection: MapSelection) => void;
}) {
  const { t } = useTranslation();
  const container = useRef<HTMLDivElement>(null);
  const map = useRef<MapLibre | null>(null);
  const [loaded, setLoaded] = useState(false);
  const [failed, setFailed] = useState(() => !drawable());
  const latest = useRef(props);
  useEffect(() => {
    latest.current = props;
  });

  useEffect(() => {
    if (!container.current || props.centre === null || failed) return;
    let created: MapLibre;
    try {
      prepare();
      created = new MapLibre({
        container: container.current,
        center: [props.centre.longitude, props.centre.latitude],
        zoom: CITY_ZOOM,
        attributionControl: { compact: true },
      });
    } catch {
      const later = window.setTimeout(() => setFailed(true));
      return () => window.clearTimeout(later);
    }
    created.setStyle('/maps/style.json', {
      transformStyle: (_previous, next) => localStyle(next, window.location.origin),
    });
    created.on('error', () => setFailed(true));
    const hover = new Popup({ closeButton: false, closeOnClick: false });
    created.on('load', () => {
      const empty: Collection = { type: 'FeatureCollection', features: [] };
      for (const source of ['zones', 'orders', 'restaurants', 'captains']) {
        created.addSource(source, { type: 'geojson', data: empty });
      }
      created.addLayer({
        id: 'zones-fill',
        type: 'fill',
        source: 'zones',
        paint: { 'fill-opacity': ['case', ['get', 'active'], 0.2, 0.05] },
      });
      created.addLayer({ id: 'zones-line', type: 'line', source: 'zones' });
      created.addLayer({
        id: 'orders',
        type: 'line',
        source: 'orders',
        paint: { 'line-width': 2, 'line-opacity': ['case', ['get', 'assigned'], 0.9, 0.4] },
      });
      created.addLayer({
        id: 'restaurants',
        type: 'circle',
        source: 'restaurants',
        paint: {
          'circle-radius': 7,
          'circle-color': RESTAURANT_COLOURS as never,
        },
      });
      created.addLayer({
        id: 'captains',
        type: 'circle',
        source: 'captains',
        paint: {
          'circle-radius': 6,
          'circle-color': CAPTAIN_COLOURS as never,
          'circle-stroke-width': ['case', ['get', 'blocked'], 3, 0],
          'circle-stroke-color': 'red',
        },
      });
      setLoaded(true);
    });
    for (const kind of ['captain', 'restaurant'] as const) {
      created.on('click', `${kind}s`, (event) => {
        const id = event.features?.[0]?.properties.id as string | undefined;
        if (id) latest.current.onSelect({ kind, id });
      });
    }
    created.on('mousemove', 'captains', (event) => {
      const feature = event.features?.[0];
      const number = feature?.properties.number as string | undefined;
      if (!feature || !number) {
        hover.remove();
        return;
      }
      hover.setLngLat(event.lngLat).setText(t('liveMap.orderTooltip', { number })).addTo(created);
    });
    created.on('mouseleave', 'captains', () => hover.remove());
    map.current = created;
    return () => {
      hover.remove();
      created.remove();
      map.current = null;
      setLoaded(false);
    };
    // The map is made once; the layers follow below.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [props.centre === null, failed]);

  useEffect(() => {
    const current = map.current;
    if (!current || !loaded) return;
    current.getSource<GeoJSONSource>('zones')?.setData(liveZonesData(props.view, props.filters));
    current.getSource<GeoJSONSource>('orders')?.setData(ordersData(props.view, props.filters));
    current
      .getSource<GeoJSONSource>('restaurants')
      ?.setData(restaurantsData(props.view, props.filters));
    current.getSource<GeoJSONSource>('captains')?.setData(captainsData(props.view, props.filters));
  }, [loaded, props.view, props.filters]);

  if (props.centre === null) return <p>{t('liveMap.noMap')}</p>;
  return (
    <>
      <div ref={container} className="pin-map" aria-label={t('liveMap.map')} />
      {failed && <p role="status">{t('liveMap.mapFailed')}</p>}
    </>
  );
}
