import { type GeoJSONSource, Map as MapLibre, Marker } from 'maplibre-gl';
import 'maplibre-gl/dist/maplibre-gl.css';
import { useEffect, useRef, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { drawable, prepare } from './pin-map.js';
import './pin-map.css';
import { localStyle } from './restaurant-drafts.js';
import type { Point, VoteCell, Zone } from './zones.js';

const CITY_ZOOM = 13;

// GeoJSON as a source takes it (maplibre-gl's own types).
type Collection = Exclude<Parameters<GeoJSONSource['setData']>[0], string>;

const ring = (corners: Point[]) => [
  ...corners.map((point) => [point.longitude, point.latitude]),
  [corners[0]!.longitude, corners[0]!.latitude],
];

function zonesData(zones: Zone[], editingId: string | null): Collection {
  return {
    type: 'Collection',
    features: zones
      .filter((zone) => zone.id !== editingId && zone.area.length >= 3)
      .map((zone) => ({
        type: 'Feature',
        properties: { name: zone.name, active: zone.active },
        geometry: { type: 'Polygon', coordinates: [ring(zone.area)] },
      })),
  };
}

function votesData(votes: VoteCell[]): Collection {
  return {
    type: 'Collection',
    features: votes.map((cell) => ({
      type: 'Feature',
      properties: { votes: cell.votes },
      geometry: { type: 'Point', coordinates: [cell.longitude, cell.latitude] },
    })),
  };
}

function outlineData(corners: Point[]): Collection {
  if (corners.length < 2) return { type: 'Collection', features: [] };
  return {
    type: 'Collection',
    features: [
      {
        type: 'Feature',
        properties: {},
        geometry: {
          type: 'LineString',
          coordinates: corners.length >= 3 ? ring(corners) : ring(corners).slice(0, -1),
        },
      },
    ],
  };
}

// AP §9.12.2 (slice 2.37c; owner decision 2026-11-19: our own corner
// editing): the city's zones, the votes from outside them and, while one is
// edited, its outline with a marker per corner. A tap adds a corner at the
// end and a drag moves one. Without WebGL or the map's files the page's
// typed corners remain. The layers only tell the zones apart (an active
// zone darker, a vote's circle by its count) until the design.
export function ZoneMap(props: {
  zones: Zone[];
  votes: VoteCell[];
  centre: Point | null;
  editing: { id: string; corners: Point[] } | null;
  onCorners: (corners: Point[]) => void;
}) {
  const { t } = useTranslation();
  const container = useRef<HTMLDivElement>(null);
  const map = useRef<MapLibre | null>(null);
  const markers = useRef<Marker[]>([]);
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
    created.on('load', () => {
      const empty: Collection = { type: 'Collection', features: [] };
      created.addSource('zones', { type: 'geojson', data: empty });
      created.addSource('votes', { type: 'geojson', data: empty });
      created.addSource('outline', { type: 'geojson', data: empty });
      created.addLayer({
        id: 'zones-fill',
        type: 'fill',
        source: 'zones',
        paint: { 'fill-opacity': ['case', ['get', 'active'], 0.35, 0.1] },
      });
      created.addLayer({ id: 'zones-line', type: 'line', source: 'zones' });
      created.addLayer({
        id: 'votes',
        type: 'circle',
        source: 'votes',
        paint: { 'circle-radius': ['min', 20, ['+', 4, ['*', 2, ['get', 'votes']]]] },
      });
      created.addLayer({
        id: 'outline',
        type: 'line',
        source: 'outline',
        paint: { 'line-width': 3 },
      });
      setLoaded(true);
    });
    created.on('click', (event) => {
      const editing = latest.current.editing;
      if (!editing) return;
      latest.current.onCorners([
        ...editing.corners,
        { latitude: event.lngLat.lat, longitude: event.lngLat.lng },
      ]);
    });
    map.current = created;
    return () => {
      created.remove();
      map.current = null;
      markers.current = [];
      setLoaded(false);
    };
    // The map is made once; the layers follow below.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [props.centre === null, failed]);

  const editingId = props.editing?.id ?? null;
  const corners = props.editing?.corners;
  useEffect(() => {
    const current = map.current;
    if (!current || !loaded) return;
    current.getSource<GeoJSONSource>('zones')?.setData(zonesData(props.zones, editingId));
    current.getSource<GeoJSONSource>('votes')?.setData(votesData(props.votes));
    current.getSource<GeoJSONSource>('outline')?.setData(outlineData(corners ?? []));
  }, [loaded, props.zones, props.votes, editingId, corners]);

  // A marker per corner of the zone edited, dragged to move it.
  useEffect(() => {
    const current = map.current;
    if (!current || !loaded) return;
    for (const marker of markers.current) marker.remove();
    markers.current = (corners ?? []).map((point, index) => {
      const marker = new Marker({ draggable: true, scale: 0.6 })
        .setLngLat([point.longitude, point.latitude])
        .addTo(current);
      marker.on('dragend', () => {
        const { lat, lng } = marker.getLngLat();
        const editing = latest.current.editing;
        if (!editing) return;
        latest.current.onCorners(
          editing.corners.map((each, at) =>
            at === index ? { latitude: lat, longitude: lng } : each,
          ),
        );
      });
      return marker;
    });
  }, [loaded, corners]);

  if (props.centre === null) return <p>{t('zones.noMap')}</p>;
  return (
    <>
      <div ref={container} className="pin-map" aria-label={t('zones.map')} />
      {failed && <p role="status">{t('zones.mapFailed')}</p>}
    </>
  );
}
