// The component registry (architecture §9.6, §9.7): `components.json` names
// every component once, by its web name, with its Flutter widget, the group
// it sits in and the surfaces whose specs use it. `components.test.ts` keeps
// it true against ui-web's COMPONENTS and core_ui's exported widgets.
import { readFileSync } from 'node:fs';
import path from 'node:path';
import { PACKAGE_DIR } from './resolve.ts';

export const SURFACES = ['customer', 'captain', 'restaurant', 'portal', 'panel'] as const;
export const COMPONENT_GROUPS = ['Actions', 'Forms', 'Data', 'Overlays', 'Navigation'] as const;

export interface Component {
  /** The web name: the key, the Design System card's folder. */
  name: string;
  /** The ui-web export, or null while its web twin is pending. */
  web: string | null;
  /** The core_ui widget, or null for a web-only component. */
  flutter: string | null;
  /** Other public core_ui widgets that belong to this component. */
  flutterParts?: string[];
  group: (typeof COMPONENT_GROUPS)[number];
  surfaces: (typeof SURFACES)[number][];
  /** Neither the portal nor the panel uses it. */
  phoneOnly: boolean;
  summary: string;
  /** The Flutter card image under core_ui's design-system goldens. */
  golden: string | null;
  /** What differs between the platforms, by design. */
  platform?: string;
  /** The parity check's states and the token each measured value must equal. */
  metrics?: Metrics;
}

/** What the parity check measures on both platforms (architecture §9.8, D.P2). */
export const DIMENSION_METRICS = [
  'height',
  'width',
  'paddingInline',
  'radius',
  'borderWidth',
  'gap',
] as const;
/** A colour metric may also be `none`: transparent, or no outline at all. */
export const COLOUR_METRICS = ['background', 'border', 'foreground'] as const;
export type Metric = (typeof DIMENSION_METRICS)[number] | (typeof COLOUR_METRICS)[number];
/** How a state is reached once its story or widget is shown. */
export const ACTS = ['hover', 'press', 'focus'] as const;

export interface MetricState {
  /** The state's key: the Flutter table's entry is `<component>/<state>`. */
  state: string;
  /** The ui-web story id; null when the state is Flutter's only. */
  story: string | null;
  /** Measured on one platform only: the other has no such state. */
  only?: 'web' | 'flutter';
  act?: (typeof ACTS)[number];
  /** Each measured value and the dotted token it must equal, over the shared `expect`. */
  expect: Partial<Record<Metric, string>>;
}

export interface Metrics {
  /** The CSS selector of the measured box in the story: its first match. */
  web: string;
  /** The values every state shares; a state's own `expect` overrides them. */
  expect: Partial<Record<Metric, string>>;
  states: MetricState[];
}

export interface Registry {
  /** The components with no web twin yet (D.P3 to D.P6 build them). */
  pendingWeb: string[];
  components: Component[];
}

export const REGISTRY = path.join(PACKAGE_DIR, 'components.json');

export function readRegistry(): Registry {
  return JSON.parse(readFileSync(REGISTRY, 'utf8')) as Registry;
}
