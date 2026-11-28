# Figma audit

The script run in Figma after every batch ([`rules.md`](rules.md), Working in Figma with the agent). It reads only; it never changes the file. Every count must be zero before the next batch; a check that cannot pass yet is listed as a known gap with its plan.

## How to run it

Paste the script into the Figma MCP `use_figma` tool. Set `PAGE_ID` to the page and `ROOT_IDS` to the sections or frames to check, or `'ALL'` for every top-level node of the page. One page per call. The «🧪 Explorations» page is exempt and the script skips it; a direction is audited once it moves to its flow's page.

## Checks

| Check                    | Fails on                                                                                                         |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------- |
| `unboundPaints`          | A visible solid fill or stroke not bound to a variable (decoration under `Decor/` exempt)                        |
| `unboundSpacing`         | Auto-layout gap or padding, or a corner radius, above 0 and not bound to a variable, outside instances           |
| `textWithoutStyle`       | A text without a text style                                                                                      |
| `foreignFonts`           | A text in a family other than `ALLOWED_FONTS`                                                                    |
| `missingFonts`           | A text whose font Figma cannot load                                                                              |
| `rawNodes`               | A shape in a screen outside a component or an instance, or a text without a text style and a colour variable     |
| `detached`               | A frame detached from a component                                                                                |
| `rawStyleOverrides`      | An instance override of a style field (fill, stroke, radius, spacing, type) with a value not bound to a variable |
| `smallTargets`           | A button, icon button, choice, checkbox or country row smaller than 44 in either direction                       |
| `unregisteredComponents` | A component or component set whose name does not start with a layer prefix                                       |

## Baseline

First run, 2026-11-28, page «📱 Customer · Sign-in» (six screens): `textWithoutStyle`, `unboundPaints`, `foreignFonts`, `missingFonts`, `detached` and `smallTargets` at 0; `rawNodes` 87 (status bar, hero, brand corner, sheet, search, labels drawn raw), `unboundSpacing` 117 (screen containers and raw parts), `rawStyleOverrides` 3 (link buttons resized and repadded). Phase 1 turns the raw parts into components and binds the containers, to bring every count to 0.

After phase 1, 2026-11-28: the library's components and the six sign-in screens rebuilt in «FOX DROP — Customer app» pass with every count at 0.

The registry match itself (every component has a line in [`registry.md`](registry.md)) is checked by comparing the names this script returns with the registry.

## Script

```js
const PAGE_ID = '1:7';
const ROOT_IDS = 'ALL';
const ALLOWED_FONTS = new Set(['Almarai']);
const PREFIX = /^(Core|Mobile|Web|Customer|Restaurant|Captain|Admin|Portal|Decor)\//;
const RAW = new Set([
  'TEXT',
  'RECTANGLE',
  'ELLIPSE',
  'VECTOR',
  'LINE',
  'POLYGON',
  'STAR',
  'BOOLEAN_OPERATION',
]);
const TARGETS = /^(Core\/)?(Button|Icon button|Choice|Checkbox|Country row)$/;
const STYLE_FIELDS = [
  'fills',
  'strokes',
  'strokeWeight',
  'cornerRadius',
  'topLeftRadius',
  'topRightRadius',
  'bottomLeftRadius',
  'bottomRightRadius',
  'itemSpacing',
  'paddingLeft',
  'paddingRight',
  'paddingTop',
  'paddingBottom',
  'fontName',
  'fontSize',
  'lineHeight',
  'letterSpacing',
  'textStyleId',
];

const page = await figma.getNodeByIdAsync(PAGE_ID);
if (!page || page.type !== 'PAGE') return { error: `page ${PAGE_ID} not found` };
if (page.name.includes('Explorations'))
  return { page: page.name, skipped: 'Explorations pages are exempt (rules.md)' };
await figma.setCurrentPageAsync(page);
const roots =
  ROOT_IDS === 'ALL'
    ? [...page.children]
    : (await Promise.all(ROOT_IDS.map((id) => figma.getNodeByIdAsync(id)))).filter(Boolean);

const found = {
  unboundPaints: [],
  unboundSpacing: [],
  textWithoutStyle: [],
  foreignFonts: [],
  missingFonts: [],
  rawNodes: [],
  detached: [],
  rawStyleOverrides: [],
  smallTargets: [],
  unregisteredComponents: [],
};
const ancestors = (n) => {
  const a = [];
  for (let p = n.parent; p && p.type !== 'PAGE'; p = p.parent) a.push(p);
  return a;
};
const where = (n) =>
  [n, ...ancestors(n)]
    .slice(0, 3)
    .reverse()
    .map((x) => x.name)
    .join(' › ');
const isDecor = (n) =>
  [n, ...ancestors(n)].some((x) => x.name.startsWith('Decor/') || x.name === 'Delivery route');
const solidUnbound = (n, prop) =>
  prop in n &&
  Array.isArray(n[prop]) &&
  n[prop].some((p) => p.type === 'SOLID' && p.visible !== false && !p.boundVariables?.color);
const mainName = (inst) => {
  const m = inst.mainComponent;
  return m ? (m.parent?.type === 'COMPONENT_SET' ? m.parent.name : m.name) : '';
};

for (const root of roots) {
  for (const n of [root, ...('findAll' in root ? root.findAll(() => true) : [])]) {
    const up = ancestors(n);
    const inInstance = up.some((a) => a.type === 'INSTANCE');
    const inComponent =
      n.type === 'COMPONENT' ||
      n.type === 'COMPONENT_SET' ||
      up.some((a) => a.type === 'COMPONENT' || a.type === 'COMPONENT_SET');
    if (n.type === 'SECTION') continue; // sections organise the canvas; they are not design
    const decor = isDecor(n);
    for (const prop of ['fills', 'strokes'])
      if (!decor && solidUnbound(n, prop)) found.unboundPaints.push(`${where(n)} ${prop}`);
    if (!inInstance && 'layoutMode' in n && n.layoutMode !== 'NONE')
      for (const k of ['itemSpacing', 'paddingLeft', 'paddingRight', 'paddingTop', 'paddingBottom'])
        if (n[k] > 0 && !n.boundVariables?.[k])
          found.unboundSpacing.push(`${where(n)} ${k}=${n[k]}`);
    if (!inInstance && !decor && n.type !== 'ELLIPSE' && 'topLeftRadius' in n) {
      const k = ['topLeftRadius', 'topRightRadius', 'bottomLeftRadius', 'bottomRightRadius'].find(
        (k) => n[k] > 0 && !n.boundVariables?.[k],
      );
      if (k) found.unboundSpacing.push(`${where(n)} ${k}=${n[k]}`);
    }
    if (n.type === 'TEXT') {
      if (!n.textStyleId || n.textStyleId === figma.mixed) found.textWithoutStyle.push(where(n));
      for (const s of n.getStyledTextSegments(['fontName']))
        if (!ALLOWED_FONTS.has(s.fontName.family))
          found.foreignFonts.push(`${where(n)} ${s.fontName.family}`);
      if (n.hasMissingFont) found.missingFonts.push(where(n));
    }
    const styledText =
      n.type === 'TEXT' &&
      n.textStyleId &&
      n.textStyleId !== figma.mixed &&
      !solidUnbound(n, 'fills');
    const sectionLabel = n.type === 'TEXT' && n.parent?.type === 'SECTION';
    if (RAW.has(n.type) && !inInstance && !inComponent && !decor && !styledText && !sectionLabel)
      found.rawNodes.push(`${where(n)} (${n.type})`);
    if ('detachedInfo' in n && n.detachedInfo) found.detached.push(where(n));
    if (n.type === 'INSTANCE' && !inInstance) {
      for (const o of n.overrides) {
        if (!o.overriddenFields.some((f) => STYLE_FIELDS.includes(f))) continue;
        const t = await figma.getNodeByIdAsync(o.id);
        if (
          t &&
          (solidUnbound(t, 'fills') ||
            solidUnbound(t, 'strokes') ||
            o.overriddenFields.some(
              (f) =>
                !['fills', 'strokes'].includes(f) &&
                STYLE_FIELDS.includes(f) &&
                !t.boundVariables?.[f],
            ))
        )
          found.rawStyleOverrides.push(`${where(t)} [${o.overriddenFields.join(', ')}]`);
      }
      if (TARGETS.test(mainName(n)) && Math.min(n.width, n.height) < 44)
        found.smallTargets.push(`${where(n)} ${Math.round(n.width)}×${Math.round(n.height)}`);
    }
    if (
      (n.type === 'COMPONENT_SET' ||
        (n.type === 'COMPONENT' && n.parent?.type !== 'COMPONENT_SET')) &&
      !PREFIX.test(n.name)
    )
      found.unregisteredComponents.push(n.name);
  }
}
const counts = Object.fromEntries(Object.entries(found).map(([k, v]) => [k, v.length]));
return {
  page: page.name,
  pass: Object.values(counts).every((c) => c === 0),
  counts,
  samples: Object.fromEntries(
    Object.entries(found)
      .filter(([, v]) => v.length)
      .map(([k, v]) => [k, v.slice(0, 8)]),
  ),
  components: found.unregisteredComponents,
};
```
