import { addProtocol, Map as MapLibre, Marker, setWorkerUrl } from 'maplibre-gl';
import 'maplibre-gl/dist/maplibre-gl.css';
import workerUrl from 'maplibre-gl/dist/maplibre-gl-worker.mjs?url';
import { Protocol } from 'pmtiles';
import { useEffect, useRef, useState } from 'react';
import { useTranslation } from 'react-i18next';
import './pin-map.css';
import { localStyle } from './restaurant-drafts.js';

export interface Point {
  latitude: number;
  longitude: number;
}

// MapLibre's worker is a file of the bundle on the panel's own origin, never
// a blob, and the tiles come through the PMTiles protocol from /maps/
// (architecture §7.2), so the Content-Security-Policy's 'self' covers all.
let ready = false;
function prepare(): void {
  if (ready) return;
  setWorkerUrl(workerUrl);
  addProtocol('pmtiles', new Protocol().tile);
  ready = true;
}

function drawable(): boolean {
  try {
    return document.createElement('canvas').getContext('webgl2') !== null;
  } catch {
    return false;
  }
}

// Zoom 16 or closer for a pin (as the apps' pin, CU §7.3); the city's
// zones from further.
const PIN_ZOOM = 16;
const CITY_ZOOM = 13;

// The wizard's pin (AP §9.6.3 step 2; slice 2.30a): a tap on the map or a
// drag of the marker moves it. Without WebGL or the map's files, the page's
// typed coordinates remain.
export function PinMap(props: {
  pin: Point | null;
  centre: Point | null;
  onChange: (point: Point) => void;
}) {
  const { t } = useTranslation();
  const container = useRef<HTMLDivElement>(null);
  const map = useRef<MapLibre | null>(null);
  const marker = useRef<Marker | null>(null);
  const onChange = useRef(props.onChange);
  useEffect(() => {
    onChange.current = props.onChange;
  });
  // Without WebGL no map draws: the typed coordinates remain.
  const [failed, setFailed] = useState(() => !drawable());
  const start = props.pin ?? props.centre;

  useEffect(() => {
    if (!container.current || start === null || failed) return;
    let created: MapLibre;
    try {
      prepare();
      created = new MapLibre({
        container: container.current,
        center: [start.longitude, start.latitude],
        zoom: props.pin ? PIN_ZOOM : CITY_ZOOM,
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
    created.on('click', (event) => {
      onChange.current({ latitude: event.lngLat.lat, longitude: event.lngLat.lng });
    });
    map.current = created;
    return () => {
      created.remove();
      map.current = null;
      marker.current = null;
    };
    // The map is made once; the pin follows below.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [start === null]);

  useEffect(() => {
    const current = map.current;
    if (!current || !props.pin) return;
    const at: [number, number] = [props.pin.longitude, props.pin.latitude];
    if (marker.current) {
      marker.current.setLngLat(at);
      return;
    }
    const created = new Marker({ draggable: true }).setLngLat(at).addTo(current);
    created.on('dragend', () => {
      const { lat, lng } = created.getLngLat();
      onChange.current({ latitude: lat, longitude: lng });
    });
    marker.current = created;
  }, [props.pin]);

  if (start === null) return <p>{t('drafts.location.noMap')}</p>;
  return (
    <>
      <div ref={container} className="pin-map" aria-label={t('drafts.location.map')} />
      {failed && <p role="status">{t('drafts.location.mapFailed')}</p>}
    </>
  );
}
