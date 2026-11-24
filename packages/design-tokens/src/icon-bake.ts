// The bake of icon set v4 "Madar" (architecture §9.4; owner, 2026-11-24).
// Linear, Duotone and Brand Duo stroke the source paths as they are. Broken,
// Bold and Bold Duo need a dash offset or a mask in SVG, which Flutter's
// Canvas does not have, so they are computed here once, at generate time,
// with CanvasKit (Skia, the engine Flutter draws with) into plain path data
// that both platforms draw: Broken as strokes, Bold and Bold Duo as fills.
import { createRequire } from 'node:module';
import type { CanvasKit, Path } from 'canvaskit-wasm';

export type Skia = CanvasKit;

/** One element of an icon: its path data and its role (§9.4). */
export interface Element {
  d: string;
  role: 'body' | 'detail';
  /** A detail's Bold treatment: knocked `in` the body, or drawn `out` as a solid line. */
  knock?: 'in' | 'out';
  /** The meaning layer: orange in Brand Duo, full ink in Duotone. */
  accent: boolean;
  /** Filled in Bold as well as stroked. */
  fill: boolean;
  /** An open body: never filled in Bold. */
  open: boolean;
  /** Crosses the body: Bold clears 1.25 around it. */
  halo: boolean;
}

/** One fill layer of Bold or Bold Duo. */
export interface Layer {
  d: string;
  /** Drawn at half opacity (Bold Duo's non-accent bodies). */
  faded: boolean;
}

/** The stroke weights baked: the phone's and the captain's (`icon-stroke.*`). */
export const WEIGHTS = [1.5, 1.75] as const;

/** Broken's gap: the bite, 2.25 wide, plus the round caps of the stroke. */
const GAP = 2.25 + 1.5;
/** The bite sits at the body's point nearest the top end corner of the grid. */
const BITE = { x: 22, y: 2 };
/** The clearance around a halo element, on each side. */
const HALO = 1.25;
/** A glyph without a body draws heavier in Bold, as on the Madar sheet. */
const BARE = 1.4;

let skia: Promise<CanvasKit> | undefined;

/** CanvasKit, loaded once. */
export function loadSkia(): Promise<CanvasKit> {
  const init = createRequire(import.meta.url)('canvaskit-wasm') as () => Promise<CanvasKit>;
  skia ??= init();
  return skia;
}

const fixed = (n: number) => String(Number(n.toFixed(2)));

/**
 * Path data with every number rounded to 2 decimals. Skia's round caps and
 * joins are conics, which SVG and Flutter's path data lack (and its own
 * `toSVGString` flattens each into one coarse quad): each becomes the cubic
 * with handles at 4w / 3(1 + w) of the way to its control point, exact for a
 * circular arc to the cubic's own accuracy.
 */
function svg(path: Path): string {
  const cmds = path.toCmds();
  const out: string[] = [];
  const p = (x: number, y: number) => `${fixed(x)} ${fixed(y)}`;
  let x = 0;
  let y = 0;
  for (let i = 0; i < cmds.length; ) {
    const verb = cmds[i++]!;
    const n = (k: number) => cmds[i + k]!;
    switch (verb) {
      case MOVE:
        out.push(`M${p(n(0), n(1))}`);
        [x, y] = [n(0), n(1)];
        i += 2;
        break;
      case LINE:
        out.push(`L${p(n(0), n(1))}`);
        [x, y] = [n(0), n(1)];
        i += 2;
        break;
      case QUAD:
        out.push(`Q${p(n(0), n(1))} ${p(n(2), n(3))}`);
        [x, y] = [n(2), n(3)];
        i += 4;
        break;
      case CONIC: {
        const [cx, cy, ex, ey, w] = [n(0), n(1), n(2), n(3), n(4)];
        const k = (4 * w) / (3 * (1 + w));
        out.push(
          `C${p(x + k * (cx - x), y + k * (cy - y))} ${p(ex + k * (cx - ex), ey + k * (cy - ey))} ${p(ex, ey)}`,
        );
        [x, y] = [ex, ey];
        i += 5;
        break;
      }
      case CUBIC:
        out.push(`C${p(n(0), n(1))} ${p(n(2), n(3))} ${p(n(4), n(5))}`);
        [x, y] = [n(4), n(5)];
        i += 6;
        break;
      case CLOSE:
        out.push('Z');
        break;
      default:
        throw new Error(`unknown path verb ${verb}`);
    }
  }
  return out.join('');
}

// CanvasKit's path verbs, as `toCmds` writes them.
const [MOVE, LINE, QUAD, CONIC, CUBIC, CLOSE] = [0, 1, 2, 3, 4, 5];

function parse(ck: CanvasKit, d: string): Path {
  const path = ck.Path.MakeFromSVGString(d);
  if (!path) throw new Error(`cannot read path data ${d}`);
  return path;
}

/** The first non-accent body, or else the first body: where Broken bites. */
export function primaryBody(elements: Element[]): Element | undefined {
  const bodies = elements.filter((e) => e.role === 'body');
  return bodies.find((e) => !e.accent) ?? bodies[0];
}

/** Broken: the elements' path data, the primary body cut once at the bite. */
export function broken(ck: CanvasKit, elements: Element[]): string[] {
  const primary = primaryBody(elements);
  return elements.map((e) => (e === primary ? bite(ck, e.d) : e.d));
}

function bite(ck: CanvasKit, d: string): string {
  // At resScale 1 Skia measures curves to half a unit, too coarse on the
  // 24 grid: the gap came out 3.87 long.
  const iter = new ck.ContourMeasureIter(parse(ck, d), false, 100);
  const contours = [];
  for (let c = iter.next(); c; c = iter.next()) contours.push(c);
  // The point nearest the bite, over every contour of the body.
  let best = { contour: 0, at: 0, distance: Infinity };
  contours.forEach((contour, index) => {
    const length = contour.length();
    for (let i = 0; i <= 4000; i++) {
      const at = (length * i) / 4000;
      const [x, y] = contour.getPosTan(at);
      const distance = Math.hypot(x! - BITE.x, y! - BITE.y);
      if (distance < best.distance) best = { contour: index, at, distance };
    }
  });
  return contours
    .map((contour, index) => {
      const length = contour.length();
      const piece = (from: number, to: number) => svg(contour.getSegment(from, to, true));
      if (index !== best.contour) return piece(0, length);
      const start = best.at - GAP / 2;
      const end = best.at + GAP / 2;
      if (!contour.isClosed()) {
        if (start <= 0) return piece(end, length);
        if (end >= length) return piece(0, start);
        return `${piece(0, start)} ${piece(end, length)}`;
      }
      if (start < 0) return piece(end, length + start);
      if (end > length) return piece(end - length, start);
      // Round the start of the closed contour: one open line from the end of
      // the gap to its start.
      return `${piece(end, length)} ${piece(0, start).replace(/^M/, 'L')}`;
    })
    .join(' ');
}

/** The stroke weight Bold uses for these elements at `weight`. */
export function strokeWeight(elements: Element[], weight: number): number {
  return elements.some((e) => e.role === 'body') ? weight : weight * BARE;
}

/** Bold: one opaque fill. */
export function bold(ck: CanvasKit, elements: Element[], weight: number): Layer[] {
  const layers = fills(ck, elements, weight, false);
  return [{ d: svg(clean(union(ck, layers.map((layer) => layer.path)))), faded: false }];
}

/** Bold Duo: a fill per body, faded unless it is the accent, then the rest. */
export function boldDuo(ck: CanvasKit, elements: Element[], weight: number): Layer[] {
  return fills(ck, elements, weight, true).map((layer) => ({
    d: svg(clean(layer.path)),
    faded: layer.faded,
  }));
}

function union(ck: CanvasKit, paths: Path[]): Path {
  return paths.reduce(
    (all, path) => ck.Path.MakeFromOp(all, path, ck.PathOp.Union) ?? fail('union'),
    new ck.Path(),
  );
}

// `makeSimplified` is declared by the types of 0.42 but only its embind
// binding ships.
type Simplifiable = Path & { _makeSimplified(): Path | null };

function clean(path: Path): Path {
  return (path as Simplifiable)._makeSimplified()?.makeAsWinding() ?? fail('simplify');
}

function fail(what: string): never {
  throw new Error(`CanvasKit could not ${what} an icon path`);
}

function fills(
  ck: CanvasKit,
  elements: Element[],
  weight: number,
  duo: boolean,
): { path: Path; faded: boolean }[] {
  const w = strokeWeight(elements, weight);
  const stroke = (e: Element, width: number) =>
    parse(ck, e.d).makeStroked({
      width,
      cap: ck.StrokeCap.Round,
      join: ck.StrokeJoin.Round,
    }) ?? fail('stroke');
  const area = (e: Element) => parse(ck, e.d);
  // What the knocked details and the halos clear from the bodies.
  const cuts: Path[] = [];
  for (const e of elements) {
    if (!duo && e.role === 'detail' && e.knock === 'in') {
      cuts.push(stroke(e, w));
      if (e.fill) cuts.push(area(e));
    }
    if (e.halo) {
      cuts.push(stroke(e, w + 2 * HALO));
      if (e.fill || e.role === 'body') cuts.push(area(e));
    }
  }
  const cut = union(ck, cuts);
  const solid = (e: Element) => {
    const parts = [stroke(e, w)];
    if (e.fill) parts.push(area(e));
    return union(ck, parts);
  };
  const layers: { path: Path; faded: boolean }[] = [];
  for (const e of elements) {
    if (e.role !== 'body' || e.halo) continue;
    const body = union(ck, e.open ? [stroke(e, w)] : [area(e), stroke(e, w)]);
    const path = ck.Path.MakeFromOp(body, cut, ck.PathOp.Difference) ?? fail('cut');
    layers.push({ path, faded: duo && !e.accent });
  }
  const rest = [
    ...elements.filter((e) => e.role === 'body' && e.halo).map((e) => union(ck, [area(e), stroke(e, w)])),
    ...elements
      .filter((e) => e.role === 'detail' && (duo || e.knock === 'out'))
      .map(solid),
  ];
  if (rest.length) layers.push({ path: union(ck, rest), faded: false });
  return layers;
}

/** Every baked form of one icon. */
export interface Baked {
  broken: string[];
  bold: Record<(typeof WEIGHTS)[number], Layer[]>;
  boldDuo: Record<(typeof WEIGHTS)[number], Layer[]>;
}

export function bakeIcon(ck: CanvasKit, elements: Element[]): Baked {
  const per = (bake: typeof bold) =>
    Object.fromEntries(WEIGHTS.map((w) => [w, bake(ck, elements, w)])) as Baked['bold'];
  return { broken: broken(ck, elements), bold: per(bold), boldDuo: per(boldDuo) };
}
