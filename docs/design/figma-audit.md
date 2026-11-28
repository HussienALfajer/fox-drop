# Figma audit

The script run in Figma after every batch ([`rules.md`](rules.md), Working in Figma with the agent). It changes nothing in the design; it only switches the current page to the one it checks.

## How to run it

Paste the script into the Figma MCP `use_figma` tool. Set `PAGE_ID` to the page and `ROOT_IDS` to the sections or frames to check, or `'ALL'` for every top-level node of the page; an id that does not exist stops the run with an error instead of passing. One page per call; the script tells the library from a surface file by the library's «Foundations» page. The «🧪 Explorations» page is exempt and the script skips it; a direction is audited once it moves to its flow's page.

## Checks

Every count must be zero before the next batch; there are no tolerated findings. Each finding names the layer path and its node id, so a fix script can target it.

| Check                          | Fails on                                                                                                                                                  |
| ------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `unboundPaints`                | A visible solid fill or stroke not bound to a variable                                                                                                    |
| `fallbackMismatch`             | A bound paint whose stored colour differs from the variable's value (the fallback trap)                                                                   |
| `nonTokenPaints`               | A gradient or image paint on a screen, outside components                                                                                                 |
| `unboundSpacing`               | Auto-layout gap, wrap gap or padding above 0 and not bound                                                                                                |
| `unboundRadius`                | A corner radius above 0 and not bound                                                                                                                     |
| `unboundStrokeWeight`          | A visible stroke whose weight is not bound to `border-width/*`                                                                                            |
| `textWithoutStyle`             | A text without a text style                                                                                                                               |
| `foreignFonts`, `missingFonts` | A family other than `ALLOWED_FONTS`, or a font Figma cannot load                                                                                          |
| `rawNodes`                     | A shape on a screen outside a component or an instance, or a text with a raw colour                                                                       |
| `detached`                     | A frame detached from a component                                                                                                                         |
| `rawStyleOverrides`            | An instance override of a paint, spacing, radius, stroke weight or type size with an unbound value                                                        |
| `smallTargets`                 | Any interactive instance, nested ones included, smaller than 48 in either direction                                                                       |
| `unprefixedComponents`         | A component or set whose name does not start with its layer                                                                                               |
| `missingDescription`           | A component or set without a description                                                                                                                  |
| `missingStates`                | A component set missing a state its kind requires (`STATES`)                                                                                              |
| `defaultNames`                 | A layer still named «Frame 12», «Rectangle», «Text» and so on (icon and decoration internals exempt)                                                      |
| `hiddenLayers`, `emptyFrames`  | Leftovers on a screen                                                                                                                                     |
| `noAutoLayout`                 | A container with several children and no auto layout, below the screen frame                                                                              |
| `arabicAlignedLeft`            | Arabic text aligned left                                                                                                                                  |
| `arabicIndicDigits`            | Arabic-Indic digits (the product uses Western digits)                                                                                                     |
| `lowContrast`                  | Text below 4.5:1 (3:1 at 24 or 18.66 bold) against its nearest filled ancestor; the declared exceptions are the primary button and the status bar mock-up |
| `draftOutsideExplorations`     | A `Draft/…` layer outside the Explorations page                                                                                                           |
| `libraryCopies`                | In a surface file, a Core, Mobile or Web component defined locally or used from a local copy                                                              |

**Exempt:** the «🧪 Explorations» page; inside the library, the documentation frames around the components; decoration under `…/Decor/…` for paints, radii and raw shapes.

**Limits:** the contrast check reads the nearest ancestor with an opaque solid fill, so text over images or overlapping siblings is checked by eye. Layout direction cannot be checked (Figma has no right-to-left flag). The registry match is made by comparing the script's `components` list (library only) with `registry.md`.

**Results:** each run's result is recorded where it applies: in the flow file for a flow page, and in the library's «Changelog» page for the library. Latest, 2026-11-28: the library's components page and the customer «🔑 Sign-in» page at 0.

## Script

```js
const PAGE_ID = '1:5';
const ROOT_IDS = 'ALL';
const ALLOWED_FONTS = new Set(['Almarai']);
const MIN_TARGET = 48;
const LAYER = /^(Core|Mobile|Web|Customer|Restaurant|Captain|Admin|Portal)\//;
const SHAPES = new Set([
  'RECTANGLE',
  'ELLIPSE',
  'VECTOR',
  'LINE',
  'POLYGON',
  'STAR',
  'BOOLEAN_OPERATION',
]);
const TARGETS =
  /(\/Button|\/Icon button|\/Chip|\/Choice|\/Checkbox|\/Country row|\/Text field|\/Phone field|\/Search field|\/OTP cell)$/;
const DEFAULT_NAME =
  /^(Frame|Group|Rectangle|Ellipse|Vector|Line|Polygon|Star|Text|Component|Instance)( \d+)?$/;
const STATES = {
  'Core/Button': ['Default', 'Pressed', 'Loading', 'Disabled'],
  'Core/Icon button': ['Default', 'Pressed', 'Disabled'],
  'Core/Text field': ['Default', 'Focused', 'Error', 'Disabled'],
  'Core/Phone field': ['Default', 'Focused', 'Error', 'Disabled'],
  'Core/Checkbox': ['Default', 'Error', 'Disabled'],
  'Core/Choice': ['Default', 'Disabled'],
  'Core/Search field': ['Default', 'Focused'],
};
const CONTRAST_EXCEPTIONS = [/Core\/Button.*Style=Primary/, /Mobile\/Status bar/]; // rules.md: the primary button; the status bar mocks system UI
const SPACING = ['itemSpacing', 'paddingLeft', 'paddingRight', 'paddingTop', 'paddingBottom'];
const RADII = ['topLeftRadius', 'topRightRadius', 'bottomLeftRadius', 'bottomRightRadius'];
const NUMERIC_OVERRIDES = [
  'strokeWeight',
  'itemSpacing',
  'paddingLeft',
  'paddingRight',
  'paddingTop',
  'paddingBottom',
  ...RADII,
  'fontSize',
  'lineHeight',
  'letterSpacing',
];

const page = await figma.getNodeByIdAsync(PAGE_ID);
if (!page || page.type !== 'PAGE') return { error: `page ${PAGE_ID} not found` };
if (page.name.includes('Explorations'))
  return { page: page.name, skipped: 'Explorations pages are exempt (rules.md)' };
await figma.setCurrentPageAsync(page);
figma.skipInvisibleInstanceChildren = true;
let roots = [...page.children];
if (ROOT_IDS !== 'ALL') {
  roots = await Promise.all(ROOT_IDS.map((id) => figma.getNodeByIdAsync(id)));
  const bad = ROOT_IDS.filter((id, i) => !roots[i]);
  if (bad.length) return { error: `root ids not found: ${bad.join(', ')}` };
}
const isLibrary = figma.root.children.some((p) => p.name.includes('Foundations')); // the library has a Foundations page
const F = {};
for (const k of [
  'unboundPaints',
  'fallbackMismatch',
  'nonTokenPaints',
  'unboundSpacing',
  'unboundRadius',
  'unboundStrokeWeight',
  'textWithoutStyle',
  'foreignFonts',
  'missingFonts',
  'rawNodes',
  'detached',
  'rawStyleOverrides',
  'smallTargets',
  'unprefixedComponents',
  'missingDescription',
  'missingStates',
  'defaultNames',
  'hiddenLayers',
  'emptyFrames',
  'noAutoLayout',
  'arabicAlignedLeft',
  'arabicIndicDigits',
  'lowContrast',
  'draftOutsideExplorations',
  'libraryCopies',
])
  F[k] = [];
const components = [];
const vcache = new Map();
const variable = async (id) => {
  if (!vcache.has(id)) vcache.set(id, await figma.variables.getVariableByIdAsync(id));
  return vcache.get(id);
};
const visibleSolids = (n, prop) =>
  prop in n && Array.isArray(n[prop])
    ? n[prop].filter((p) => p.type === 'SOLID' && p.visible !== false && (p.opacity ?? 1) > 0)
    : [];
const lum = ({ r, g, b }) => {
  const f = (c) => (c <= 0.04045 ? c / 12.92 : ((c + 0.055) / 1.055) ** 2.4);
  return 0.2126 * f(r) + 0.7152 * f(g) + 0.0722 * f(b);
};
const ratio = (a, b) => {
  const x = lum(a),
    y = lum(b);
  return (Math.max(x, y) + 0.05) / (Math.min(x, y) + 0.05);
};
const resolved = async (n, p) => {
  const id = p.boundVariables?.color?.id;
  if (!id) return p.color;
  const v = await variable(id);
  return v ? v.resolveForConsumer(n).value : p.color;
};
const weightBound = (n) => !!(n.boundVariables?.strokeWeight || n.boundVariables?.strokeTopWeight); // Figma binds the weight per side
const where = (n, path) =>
  `${path.slice(-2).join(' › ')}${path.length ? ' › ' : ''}${n.name} [${n.id}]`;

async function visit(n, ctx) {
  if (n.type === 'SECTION') {
    for (const c of n.children) await visit(c, { ...ctx, path: [n.name] });
    return;
  }
  const path = [...ctx.path];
  const isComp = n.type === 'COMPONENT' || n.type === 'COMPONENT_SET';
  const decor =
    ctx.decor ||
    ((n.type === 'COMPONENT' || n.type === 'INSTANCE' || n.type === 'COMPONENT_SET') &&
      n.name.includes('/Decor/'));
  const owned = !ctx.inInstance; // nodes this file owns, not an instance's insides
  const docs = isLibrary && !ctx.inComponent && !isComp; // a library page's documentation frames around the components
  const hidden = n.visible === false;
  if (hidden && owned && !ctx.inComponent && !isComp) F.hiddenLayers.push(where(n, path));
  if (hidden) return;
  if (n.name.startsWith('Draft/')) F.draftOutsideExplorations.push(where(n, path));

  if (owned) {
    if (DEFAULT_NAME.test(n.name) && !decor && !ctx.names.some((x) => x.includes('/Icon/')))
      F.defaultNames.push(where(n, path));
    if (!decor && !docs && n.type !== 'COMPONENT_SET')
      for (const prop of ['fills', 'strokes']) {
        if (prop === 'strokes' && !(n.strokeWeight > 0)) continue;
        for (const p of visibleSolids(n, prop)) {
          if (!p.boundVariables?.color) F.unboundPaints.push(`${where(n, path)} ${prop}`);
          else {
            const v = await variable(p.boundVariables.color.id);
            const c = v?.resolveForConsumer(n).value;
            if (
              c &&
              Math.abs(c.r - p.color.r) + Math.abs(c.g - p.color.g) + Math.abs(c.b - p.color.b) >
                0.03
            )
              F.fallbackMismatch.push(`${where(n, path)} ${prop}`);
          }
        }
        if (
          prop in n &&
          Array.isArray(n[prop]) &&
          n[prop].some((p) => p.visible !== false && p.type !== 'SOLID') &&
          !ctx.inComponent
        )
          F.nonTokenPaints.push(`${where(n, path)} ${prop}`);
      }
    if (!docs && n.type !== 'COMPONENT_SET' && 'layoutMode' in n && n.layoutMode !== 'NONE') {
      for (const k of SPACING)
        if (n[k] > 0 && !n.boundVariables?.[k])
          F.unboundSpacing.push(`${where(n, path)} ${k}=${n[k]}`);
      if (
        n.layoutWrap === 'WRAP' &&
        n.counterAxisSpacing > 0 &&
        !n.boundVariables?.counterAxisSpacing
      )
        F.unboundSpacing.push(`${where(n, path)} counterAxisSpacing`);
    }
    if (
      !decor &&
      !docs &&
      n.type !== 'ELLIPSE' &&
      n.type !== 'COMPONENT_SET' &&
      'topLeftRadius' in n
    ) {
      const k = RADII.find((k) => n[k] > 0 && !n.boundVariables?.[k]);
      if (k) F.unboundRadius.push(`${where(n, path)} ${k}=${n[k]}`);
    }
    if (
      !decor &&
      !docs &&
      n.type !== 'COMPONENT_SET' &&
      'strokeWeight' in n &&
      typeof n.strokeWeight === 'number' &&
      n.strokeWeight > 0 &&
      visibleSolids(n, 'strokes').length &&
      !weightBound(n) &&
      !SHAPES.has(n.type)
    )
      F.unboundStrokeWeight.push(`${where(n, path)} ${n.strokeWeight}`);
    if (SHAPES.has(n.type) && !ctx.inComponent && !decor)
      F.rawNodes.push(`${where(n, path)} (${n.type})`);
    if (n.type === 'FRAME' && 'detachedInfo' in n && n.detachedInfo)
      F.detached.push(where(n, path));
    if (
      n.type === 'FRAME' &&
      n.children.length === 0 &&
      !ctx.inComponent &&
      !visibleSolids(n, 'fills').length
    )
      F.emptyFrames.push(where(n, path));
    if (
      n.type === 'FRAME' &&
      n.layoutMode === 'NONE' &&
      n.children.length > 1 &&
      !ctx.inComponent &&
      !decor &&
      !ctx.topLevel
    )
      F.noAutoLayout.push(where(n, path));
    if (
      n.type === 'COMPONENT_SET' ||
      (n.type === 'COMPONENT' && n.parent?.type !== 'COMPONENT_SET')
    ) {
      components.push(n.name);
      if (!LAYER.test(n.name)) F.unprefixedComponents.push(n.name);
      if (!n.description?.trim()) F.missingDescription.push(n.name);
      if (!isLibrary && /^(Core|Mobile|Web)\//.test(n.name))
        F.libraryCopies.push(`${n.name} (a shared component defined in a surface file)`);
      if (n.type === 'COMPONENT_SET' && STATES[n.name]) {
        const states = n.componentPropertyDefinitions.State?.variantOptions ?? [];
        const miss = STATES[n.name].filter((s) => !states.includes(s));
        if (miss.length) F.missingStates.push(`${n.name}: ${miss.join(', ')}`);
      }
    }
  }

  if (n.type === 'TEXT') {
    if (owned && (!n.textStyleId || n.textStyleId === figma.mixed))
      F.textWithoutStyle.push(where(n, path));
    for (const s of n.getStyledTextSegments(['fontName']))
      if (!ALLOWED_FONTS.has(s.fontName.family))
        F.foreignFonts.push(`${where(n, path)} ${s.fontName.family}`);
    if (n.hasMissingFont) F.missingFonts.push(where(n, path));
    if (owned && !ctx.inComponent && !decor)
      for (const seg of n.getStyledTextSegments(['fills']))
        if (
          seg.fills.some(
            (p) => p.type === 'SOLID' && p.visible !== false && !p.boundVariables?.color,
          )
        ) {
          F.rawNodes.push(`${where(n, path)} (TEXT with a raw colour)`);
          break;
        }
    if (owned && /[؀-ۿ]/.test(n.characters) && n.textAlignHorizontal === 'LEFT')
      F.arabicAlignedLeft.push(where(n, path));
    if (/[٠-٩۰-۹]/.test(n.characters)) F.arabicIndicDigits.push(where(n, path));
    const fg = visibleSolids(n, 'fills')[0];
    const label = [...ctx.names, n.name].join(' ');
    if (
      fg &&
      n.characters.trim() &&
      !/State=Disabled/.test(label) &&
      !CONTRAST_EXCEPTIONS.some((r) => r.test(label))
    ) {
      const bg = ctx.bg;
      if (bg) {
        const r = ratio(await resolved(n, fg), bg);
        const size = typeof n.fontSize === 'number' ? n.fontSize : 16;
        const bold =
          typeof n.fontName === 'object' && /Bold|Black|ExtraBold/.test(n.fontName.style);
        const need = size >= 24 || (size >= 18.66 && bold) ? 3 : 4.5;
        if (r + 0.005 < need) F.lowContrast.push(`${where(n, path)} ${r.toFixed(2)} < ${need}`);
      }
    }
  }

  let bg = ctx.bg;
  const ownFill = visibleSolids(n, 'fills').find((p) => (p.opacity ?? 1) >= 0.99);
  if (ownFill && n.type !== 'TEXT' && (n.opacity ?? 1) >= 0.99) bg = await resolved(n, ownFill);

  if (n.type === 'INSTANCE') {
    const main = await n.getMainComponentAsync();
    const mainName = main
      ? main.parent?.type === 'COMPONENT_SET'
        ? main.parent.name
        : main.name
      : '';
    if (TARGETS.test(mainName) && Math.min(n.width, n.height) < MIN_TARGET)
      F.smallTargets.push(`${where(n, path)} ${Math.round(n.width)}×${Math.round(n.height)}`);
    if (!isLibrary && main && !main.remote && /^(Core|Mobile|Web)\//.test(mainName))
      F.libraryCopies.push(`${where(n, path)} uses a local copy of ${mainName}`);
    if (owned) {
      const targets = await Promise.all(n.overrides.map((o) => figma.getNodeByIdAsync(o.id)));
      n.overrides.forEach((o, i) => {
        const t = targets[i];
        if (!t) return;
        const paintRaw = ['fills', 'strokes'].some(
          (p) =>
            o.overriddenFields.includes(p) &&
            visibleSolids(t, p).some((x) => !x.boundVariables?.color),
        );
        const numRaw = o.overriddenFields.filter(
          (f) =>
            NUMERIC_OVERRIDES.includes(f) &&
            !(f === 'strokeWeight' ? weightBound(t) : t.boundVariables?.[f]),
        );
        if (paintRaw || numRaw.length)
          F.rawStyleOverrides.push(
            `${where(t, path)} [${[paintRaw ? 'paint' : '', ...numRaw].filter(Boolean).join(', ')}]`,
          );
      });
    }
    path.push(n.name);
    for (const c of n.children)
      await visit(c, {
        ...ctx,
        path,
        inInstance: true,
        decor,
        bg,
        topLevel: false,
        names: [...ctx.names, mainName, main?.name ?? ''],
      });
    return;
  }
  if ('children' in n) {
    path.push(n.name);
    for (const c of n.children)
      await visit(c, {
        ...ctx,
        path,
        inComponent: ctx.inComponent || isComp,
        decor,
        bg,
        topLevel: false,
        names: [...ctx.names, n.name],
      });
  }
}

const canvas = visibleSolids(page, 'backgrounds')[0]?.color ?? { r: 1, g: 1, b: 1 };
for (const root of roots)
  await visit(root, {
    path: [],
    inInstance: false,
    inComponent: false,
    decor: false,
    bg: canvas,
    topLevel: true,
    names: [],
  });
const counts = Object.fromEntries(Object.entries(F).map(([k, v]) => [k, v.length]));
return {
  file: figma.root.name,
  page: page.name,
  pass: Object.values(counts).every((c) => c === 0),
  counts,
  findings: Object.fromEntries(
    Object.entries(F)
      .filter(([, v]) => v.length)
      .map(([k, v]) => [k, v.slice(0, 6)]),
  ),
  components: isLibrary ? components : undefined,
};
```
