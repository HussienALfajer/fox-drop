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
