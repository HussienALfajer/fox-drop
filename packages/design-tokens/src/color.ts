// Colour maths for the token tests: WCAG 2.2 contrast, colour-blindness
// simulation (Machado, Oliveira and Fernandes 2009, severity 1) and CIEDE2000.

type Rgb = [number, number, number];

function channels(hex: string): Rgb {
  const match = /^#([0-9a-f]{6})([0-9a-f]{2})?$/i.exec(hex);
  if (!match?.[1]) throw new Error(`Not an opaque hex colour: ${hex}`);
  const n = Number.parseInt(match[1], 16);
  return [(n >> 16) & 255, (n >> 8) & 255, n & 255];
}

const toLinear = (v: number) => {
  const c = v / 255;
  return c <= 0.04045 ? c / 12.92 : ((c + 0.055) / 1.055) ** 2.4;
};

const linear = (hex: string): Rgb => channels(hex).map(toLinear) as Rgb;

/** WCAG 2.2 relative luminance. */
export function luminance(hex: string): number {
  const [r, g, b] = linear(hex);
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
}

/** WCAG 2.2 contrast ratio, 1 to 21. */
export function contrast(a: string, b: string): number {
  const [hi, lo] = [luminance(a), luminance(b)].sort((x, y) => y - x) as [number, number];
  return (hi + 0.05) / (lo + 0.05);
}

export const DEFICIENCIES = ['protan', 'deutan', 'tritan'] as const;
export type Deficiency = (typeof DEFICIENCIES)[number];

// Machado et al. 2009, severity 1.0, applied to linear RGB.
const MACHADO: Record<Deficiency, number[][]> = {
  protan: [
    [0.152286, 1.052583, -0.204868],
    [0.114503, 0.786281, 0.099216],
    [-0.003882, -0.048116, 1.051998],
  ],
  deutan: [
    [0.367322, 0.860646, -0.227968],
    [0.280085, 0.672501, 0.047413],
    [-0.01182, 0.04294, 0.968881],
  ],
  tritan: [
    [1.255528, -0.076749, -0.178779],
    [-0.078411, 0.930809, 0.147602],
    [0.004733, 0.691367, 0.3039],
  ],
};

/** The colour as seen with a full deficiency, as linear RGB. */
function simulateLinear(hex: string, deficiency: Deficiency | null): Rgb {
  const rgb = linear(hex);
  if (!deficiency) return rgb;
  return MACHADO[deficiency].map(
    (row) => row[0]! * rgb[0] + row[1]! * rgb[1] + row[2]! * rgb[2],
  ) as Rgb;
}

/** CIE Lab (D65) of a linear RGB colour, clipped to the sRGB gamut first. */
function lab(rgbLinear: Rgb): Rgb {
  const [r, g, b] = rgbLinear.map((c) => Math.min(1, Math.max(0, c))) as Rgb;
  const x = (0.4124564 * r + 0.3575761 * g + 0.1804375 * b) / 0.95047;
  const y = 0.2126729 * r + 0.7151522 * g + 0.072175 * b;
  const z = (0.0193339 * r + 0.119192 * g + 0.9503041 * b) / 1.08883;
  const f = (t: number) => (t > 216 / 24389 ? Math.cbrt(t) : (24389 / 27 / 116) * t + 16 / 116);
  return [116 * f(y) - 16, 500 * (f(x) - f(y)), 200 * (f(y) - f(z))];
}

/** CIEDE2000 colour difference of two Lab colours. */
export function deltaE2000([l1, a1, b1]: Rgb, [l2, a2, b2]: Rgb): number {
  const rad = Math.PI / 180;
  const c1 = Math.hypot(a1, b1);
  const c2 = Math.hypot(a2, b2);
  const cMean7 = ((c1 + c2) / 2) ** 7;
  const g = 0.5 * (1 - Math.sqrt(cMean7 / (cMean7 + 25 ** 7)));
  const ap1 = (1 + g) * a1;
  const ap2 = (1 + g) * a2;
  const cp1 = Math.hypot(ap1, b1);
  const cp2 = Math.hypot(ap2, b2);
  const hue = (b: number, a: number) => {
    if (a === 0 && b === 0) return 0;
    const h = Math.atan2(b, a) / rad;
    return h < 0 ? h + 360 : h;
  };
  const hp1 = hue(b1, ap1);
  const hp2 = hue(b2, ap2);
  const dL = l2 - l1;
  const dC = cp2 - cp1;
  let dh = 0;
  if (cp1 * cp2 !== 0) {
    dh = hp2 - hp1;
    if (dh > 180) dh -= 360;
    else if (dh < -180) dh += 360;
  }
  const dH = 2 * Math.sqrt(cp1 * cp2) * Math.sin((dh / 2) * rad);
  const lMean = (l1 + l2) / 2;
  const cpMean = (cp1 + cp2) / 2;
  let hMean = hp1 + hp2;
  if (cp1 * cp2 !== 0) {
    if (Math.abs(hp1 - hp2) <= 180) hMean /= 2;
    else hMean = hp1 + hp2 < 360 ? (hMean + 360) / 2 : (hMean - 360) / 2;
  }
  const t =
    1 -
    0.17 * Math.cos((hMean - 30) * rad) +
    0.24 * Math.cos(2 * hMean * rad) +
    0.32 * Math.cos((3 * hMean + 6) * rad) -
    0.2 * Math.cos((4 * hMean - 63) * rad);
  const sl = 1 + (0.015 * (lMean - 50) ** 2) / Math.sqrt(20 + (lMean - 50) ** 2);
  const sc = 1 + 0.045 * cpMean;
  const sh = 1 + 0.015 * cpMean * t;
  const cpMean7 = cpMean ** 7;
  const rt =
    -2 *
    Math.sqrt(cpMean7 / (cpMean7 + 25 ** 7)) *
    Math.sin(60 * Math.exp(-(((hMean - 275) / 25) ** 2)) * rad);
  return Math.sqrt((dL / sl) ** 2 + (dC / sc) ** 2 + (dH / sh) ** 2 + rt * (dC / sc) * (dH / sh));
}

/** How far apart two colours look, with normal vision or a deficiency. */
export function distance(a: string, b: string, deficiency: Deficiency | null = null): number {
  return deltaE2000(lab(simulateLinear(a, deficiency)), lab(simulateLinear(b, deficiency)));
}
