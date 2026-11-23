// Reads the icon SVG sources (architecture §9.4, §9.5 R8): the root, the
// shape elements, and every point a shape's outline passes through, so the
// grid test can keep each icon inside the live area. A source is one <svg>
// with self-closing shape children only; anything else is rejected.

export interface Point {
  x: number;
  y: number;
}

export interface Shape {
  name: string;
  attributes: Record<string, string>;
}

export interface IconSource {
  root: Record<string, string>;
  shapes: Shape[];
}

function attributes(text: string, where: string): Record<string, string> {
  const result: Record<string, string> = {};
  const rest = text.replace(/([\w:-]+)="([^"]*)"/g, (_, key: string, value: string) => {
    if (key in result) throw new Error(`${where}: attribute ${key} twice`);
    result[key] = value;
    return '';
  });
  if (rest.trim()) throw new Error(`${where}: cannot read "${rest.trim()}"`);
  return result;
}

export function parseIcon(source: string): IconSource {
  const match = /^<svg\b([^>]*)>([\s\S]*)<\/svg>\s*$/.exec(source.trim());
  if (!match) throw new Error('not a single <svg> element');
  const root = attributes(match[1]!, '<svg>');
  const shapes: Shape[] = [];
  const rest = match[2]!.replace(/<(\w+)\b([^>]*?)\/>/g, (_, name: string, text: string) => {
    shapes.push({ name, attributes: attributes(text, `<${name}>`) });
    return '';
  });
  if (rest.trim()) throw new Error(`unexpected content "${rest.trim().slice(0, 40)}"`);
  return { root, shapes };
}

// Path data ----------------------------------------------------------------

type Segment =
  | { type: 'M' | 'L'; to: Point }
  | { type: 'C'; c1: Point; c2: Point; to: Point }
  | { type: 'Q'; c: Point; to: Point }
  | {
      type: 'A';
      rx: number;
      ry: number;
      rotation: number;
      large: boolean;
      sweep: boolean;
      to: Point;
    }
  | { type: 'Z'; to: Point };

const TOKEN = /[MmLlHhVvCcSsQqTtAaZz]|[-+]?(?:\d+\.?\d*|\.\d+)/g;
const ARITY: Record<string, number> = {
  M: 2,
  L: 2,
  H: 1,
  V: 1,
  C: 6,
  S: 4,
  Q: 4,
  T: 2,
  A: 7,
  Z: 0,
};

/** The segments of `d`, in absolute coordinates, with H, V, S and T expanded. */
export function segments(d: string): Segment[] {
  const tokens = d.match(TOKEN) ?? [];
  if (d.replace(TOKEN, '').replace(/[\s,]/g, '')) throw new Error(`cannot read path "${d}"`);
  const result: Segment[] = [];
  let at: Point = { x: 0, y: 0 };
  let start = at;
  let last: Segment | undefined;
  let i = 0;
  let command = '';
  while (i < tokens.length) {
    if (/[a-z]/i.test(tokens[i]!)) command = tokens[i++]!;
    else if (!command || /z/i.test(command))
      throw new Error(`a number without a command in "${d}"`);
    const upper = command.toUpperCase();
    const relative = command !== upper;
    const n = ARITY[upper]!;
    const args = tokens.slice(i, i + n).map(Number);
    if (args.length < n || args.some(Number.isNaN))
      throw new Error(`${command} needs ${n} numbers in "${d}"`);
    i += n;
    const point = (x: number, y: number): Point =>
      relative ? { x: at.x + x, y: at.y + y } : { x, y };
    let segment: Segment;
    switch (upper) {
      case 'M':
        segment = { type: 'M', to: point(args[0]!, args[1]!) };
        start = segment.to;
        command = relative ? 'l' : 'L';
        break;
      case 'L':
        segment = { type: 'L', to: point(args[0]!, args[1]!) };
        break;
      case 'H':
        segment = { type: 'L', to: { x: relative ? at.x + args[0]! : args[0]!, y: at.y } };
        break;
      case 'V':
        segment = { type: 'L', to: { x: at.x, y: relative ? at.y + args[0]! : args[0]! } };
        break;
      case 'C':
        segment = {
          type: 'C',
          c1: point(args[0]!, args[1]!),
          c2: point(args[2]!, args[3]!),
          to: point(args[4]!, args[5]!),
        };
        break;
      case 'S': {
        const c1 = last?.type === 'C' ? { x: 2 * at.x - last.c2.x, y: 2 * at.y - last.c2.y } : at;
        segment = { type: 'C', c1, c2: point(args[0]!, args[1]!), to: point(args[2]!, args[3]!) };
        break;
      }
      case 'Q':
        segment = { type: 'Q', c: point(args[0]!, args[1]!), to: point(args[2]!, args[3]!) };
        break;
      case 'T': {
        const c = last?.type === 'Q' ? { x: 2 * at.x - last.c.x, y: 2 * at.y - last.c.y } : at;
        segment = { type: 'Q', c, to: point(args[0]!, args[1]!) };
        break;
      }
      case 'A': {
        const [rx, ry, rotation, large, sweep] = args as [number, number, number, number, number];
        if (![0, 1].includes(large) || ![0, 1].includes(sweep))
          throw new Error(`arc flags must be 0 or 1, written apart, in "${d}"`);
        segment = {
          type: 'A',
          rx,
          ry,
          rotation,
          large: large === 1,
          sweep: sweep === 1,
          to: point(args[5]!, args[6]!),
        };
        break;
      }
      default:
        segment = { type: 'Z', to: start };
    }
    result.push(segment);
    last = segment;
    at = segment.to;
  }
  if (result[0] && result[0].type !== 'M') throw new Error(`a path starts with M: "${d}"`);
  return result;
}

// Curves and arcs are checked at 32 samples each, so an extreme between two
// samples can pass by up to about 0.05; draw an edge-touching curve with care.
const STEPS = 32;

function arcPoints(from: Point, arc: Extract<Segment, { type: 'A' }>): Point[] {
  // Endpoint to centre parameterisation (SVG 1.1 appendix F.6.5).
  const { to, large, sweep } = arc;
  let rx = Math.abs(arc.rx);
  let ry = Math.abs(arc.ry);
  if (rx === 0 || ry === 0) return [to];
  // An arc that ends where it starts is omitted (SVG 1.1 F.6.2).
  if (from.x === to.x && from.y === to.y) return [];
  const phi = (arc.rotation * Math.PI) / 180;
  const cos = Math.cos(phi);
  const sin = Math.sin(phi);
  const dx = (from.x - to.x) / 2;
  const dy = (from.y - to.y) / 2;
  const x1 = cos * dx + sin * dy;
  const y1 = -sin * dx + cos * dy;
  const lambda = (x1 * x1) / (rx * rx) + (y1 * y1) / (ry * ry);
  if (lambda > 1) {
    rx *= Math.sqrt(lambda);
    ry *= Math.sqrt(lambda);
  }
  const numerator = rx * rx * ry * ry - rx * rx * y1 * y1 - ry * ry * x1 * x1;
  const denominator = rx * rx * y1 * y1 + ry * ry * x1 * x1;
  let k = denominator === 0 ? 0 : Math.sqrt(Math.max(0, numerator / denominator));
  if (large === sweep) k = -k;
  const cx1 = (k * rx * y1) / ry;
  const cy1 = (-k * ry * x1) / rx;
  const cx = cos * cx1 - sin * cy1 + (from.x + to.x) / 2;
  const cy = sin * cx1 + cos * cy1 + (from.y + to.y) / 2;
  const angle = (ux: number, uy: number, vx: number, vy: number) =>
    Math.atan2(ux * vy - uy * vx, ux * vx + uy * vy);
  const ux = (x1 - cx1) / rx;
  const uy = (y1 - cy1) / ry;
  const theta = angle(1, 0, ux, uy);
  let delta = angle(ux, uy, (-x1 - cx1) / rx, (-y1 - cy1) / ry);
  if (!sweep && delta > 0) delta -= 2 * Math.PI;
  if (sweep && delta < 0) delta += 2 * Math.PI;
  return Array.from({ length: STEPS }, (_, step) => {
    const t = theta + (delta * (step + 1)) / STEPS;
    return {
      x: cx + rx * Math.cos(t) * cos - ry * Math.sin(t) * sin,
      y: cy + rx * Math.cos(t) * sin + ry * Math.sin(t) * cos,
    };
  });
}

/** Every point the outline of `d` passes through, curves and arcs sampled. */
export function pathPoints(d: string): Point[] {
  const points: Point[] = [];
  let at: Point = { x: 0, y: 0 };
  for (const segment of segments(d)) {
    if (segment.type === 'C' || segment.type === 'Q') {
      for (let step = 1; step <= STEPS; step++) {
        const t = step / STEPS;
        const u = 1 - t;
        const point =
          segment.type === 'C'
            ? {
                x:
                  u ** 3 * at.x +
                  3 * u * u * t * segment.c1.x +
                  3 * u * t * t * segment.c2.x +
                  t ** 3 * segment.to.x,
                y:
                  u ** 3 * at.y +
                  3 * u * u * t * segment.c1.y +
                  3 * u * t * t * segment.c2.y +
                  t ** 3 * segment.to.y,
              }
            : {
                x: u * u * at.x + 2 * u * t * segment.c.x + t * t * segment.to.x,
                y: u * u * at.y + 2 * u * t * segment.c.y + t * t * segment.to.y,
              };
        points.push(point);
      }
    } else if (segment.type === 'A') points.push(...arcPoints(at, segment));
    else points.push(segment.to);
    at = segment.to;
  }
  return points;
}

const numbers = (text: string) => (text.match(/[-+]?(?:\d+\.?\d*|\.\d+)/g) ?? []).map(Number);

function pairs(text: string): Point[] {
  const values = numbers(text);
  if (values.length % 2) throw new Error(`odd number of coordinates in "${text}"`);
  return Array.from({ length: values.length / 2 }, (_, i) => ({
    x: values[2 * i]!,
    y: values[2 * i + 1]!,
  }));
}

/** The extreme points of one shape. */
export function shapePoints({ name, attributes: a }: Shape): Point[] {
  const n = (key: string) => Number(a[key] ?? 0);
  switch (name) {
    case 'path':
      return pathPoints(a.d ?? '');
    case 'circle':
    case 'ellipse': {
      const rx = name === 'circle' ? n('r') : n('rx');
      const ry = name === 'circle' ? n('r') : n('ry');
      return [
        { x: n('cx') - rx, y: n('cy') - ry },
        { x: n('cx') + rx, y: n('cy') + ry },
      ];
    }
    case 'line':
      return [
        { x: n('x1'), y: n('y1') },
        { x: n('x2'), y: n('y2') },
      ];
    case 'polyline':
    case 'polygon':
      return pairs(a.points ?? '');
    case 'rect':
      return [
        { x: n('x'), y: n('y') },
        { x: n('x') + n('width'), y: n('y') + n('height') },
      ];
    default:
      return [];
  }
}
