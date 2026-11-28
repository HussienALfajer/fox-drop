# Figma audit

Two read-only scripts run in Figma after every batch ([`rules.md`](rules.md), Working in Figma with the agent): the page audit on each page the batch touched, and the foundations audit after any change to variables or text styles. They change nothing in the design; the page audit only switches the current page to the one it checks. They live here until the Figma skill moves them into its `scripts/` folder (backlog).

## How to run it

Paste the script into the Figma MCP `use_figma` tool. Set `PAGE_ID` to the page and `ROOT_IDS` to the sections or frames to check, or `'ALL'` for every top-level node of the page; an id that does not exist stops the run with an error instead of passing. One page per call, and the calls for several pages may run in parallel; the script tells the library from a surface file by `figma.fileKey`. The «🧪 Explorations» page is exempt and the script skips it; a direction is audited once it moves to its flow's page. A surface file's flow page holds only screens, inside sections: every top-level frame there is checked as a screen.

## Checks

Every count must be zero before the next batch; there are no tolerated findings. Each finding names the layer path and its node id, so a fix script can target it.

| Check                          | Fails on                                                                                                                                                                    |
| ------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `unboundPaints`                | A visible solid fill or stroke not bound to a variable                                                                                                                      |
| `fallbackMismatch`             | A bound paint whose stored colour differs from the variable's value (the fallback trap)                                                                                     |
| `nonTokenPaints`               | A gradient or image paint on a screen, outside components                                                                                                                   |
| `unboundSpacing`               | Auto-layout gap, wrap gap or padding above 0 and not bound                                                                                                                  |
| `unboundRadius`                | A corner radius above 0 and not bound                                                                                                                                       |
| `unboundStrokeWeight`          | A visible stroke whose weight is not bound to `border-width/*`                                                                                                              |
| `textWithoutStyle`             | A text without a text style                                                                                                                                                 |
| `foreignFonts`, `missingFonts` | A family other than `ALLOWED_FONTS`, or a font Figma cannot load                                                                                                            |
| `rawNodes`                     | A shape on a screen outside a component or an instance, or a text with a raw colour                                                                                         |
| `detached`                     | A frame detached from a component                                                                                                                                           |
| `rawStyleOverrides`            | An instance override of a paint, spacing, radius, stroke weight or type size with an unbound value                                                                          |
| `smallTargets`                 | Any interactive instance, nested ones included, smaller than 48 in either direction                                                                                         |
| `unprefixedComponents`         | A component or set whose name does not start with its layer                                                                                                                 |
| `missingDescription`           | A component or set without a description                                                                                                                                    |
| `missingStates`                | A component set missing a state its kind requires (`STATES`)                                                                                                                |
| `defaultNames`                 | A layer still named «Frame 12», «Rectangle», «Text» and so on (icon and decoration internals exempt)                                                                        |
| `hiddenLayers`, `emptyFrames`  | Leftovers on a screen; a frame with an image fill is not empty                                                                                                              |
| `noAutoLayout`                 | A container with several children and no auto layout, below the screen frame                                                                                                |
| `arabicAlignedLeft`            | Arabic text aligned left                                                                                                                                                    |
| `arabicIndicDigits`            | Arabic-Indic digits (the product uses Western digits)                                                                                                                       |
| `lowContrast`                  | Text below 4.5:1 (3:1 at 24 or 18.66 bold) against its nearest filled ancestor; the declared exception is the primary button; a variant or layer named `Disabled` is exempt |
| `draftOutsideExplorations`     | A `Draft/…` layer outside the Explorations page                                                                                                                             |
| `libraryCopies`                | In a surface file, a Core, Mobile or Web component defined locally or used from a local copy                                                                                |
| `unkeyedText`                  | On a flow page, a text in a screen not named after its `core_l10n` key or `new:` plus a proposed key (rules.md)                                                             |
| `screenSize`                   | On a flow page, a screen frame not 390 × 844, 360 × 800 or 430 × 932 (surfaces.md; other surfaces add theirs when they start)                                               |
| `iconStroke`                   | A vector inside a `…/Icon/…` component whose stroke is not 1.5 (rules.md, Icons)                                                                                            |
| `unboundControlSize`           | An interactive component (`TARGETS`) whose height, minimum height or labelled field's `Box` height is not bound to `size/*` (rules.md, Size and touch)                      |

**Exempt:** the «🧪 Explorations» page; inside the library, the documentation frames around the components, except that their bound colours must still match their variables (`fallbackMismatch`); text named `Expected fail` (the contrast matrix's forbidden pairs, shown on purpose); decoration under `…/Decor/…` and the identity's assets under `…/Brand/…` for paints, radii, raw shapes and layer names (rules.md, Components and screens).

**Limits:** the contrast check reads the nearest ancestor with an opaque solid fill, so text over images or overlapping siblings is checked by eye. Layout direction cannot be checked (Figma's Plugin API has no text or layout direction). The registry match is made by comparing the script's `components` list (library only) with `registry.md`. `STATES` is filled from the registry's «States or variants» column in the batch that builds each interactive component.

**Results:** each run's result is recorded where it applies: in the flow file for a flow page, and in the library's «Changelog» page for the library. Latest, 2026-11-28 (v0.5, prepared): the library's «🧩 Components» page at 0 with its 54 components (the customer sign-in's Core and Mobile parts); the foundations audit at 0 after the scrim's primitive became `alpha/blue-900-32`.

## Script

```js
const PAGE_ID = '1:5';
const ROOT_IDS = 'ALL';
const LIBRARY_FILE = 'ITmxeo3ipw0UH5OiV0880s'; // the library; every other file is a surface file
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
// Kinds of interactive component, by the end of their name; a new kind joins in the batch that builds it.
const TARGETS =
  /(\/Button|\/Icon button|\/Chip|\/Choice tile|\/Checkbox|\/Text field|\/Search field|\/Phone field|\/Country chip|\/List row|\/Paste offer)$/;
const DEFAULT_NAME =
  /^(Frame|Group|Rectangle|Ellipse|Vector|Line|Polygon|Star|Text|Component|Instance)( \d+)?$/;
// One line per interactive component set, copied from its registry.md «States or variants» cell
// in the batch that builds it, e.g. 'Core/Button': ['Default', 'Pressed', 'Loading', 'Disabled'].
const STATES = {
  'Core/Button': ['Default', 'Pressed', 'Disabled', 'Loading'],
  'Core/Icon button': ['Default', 'Pressed', 'Disabled'],
  'Core/Text field': ['Default', 'Pressed', 'Focused', 'Filled', 'Error', 'Disabled'],
  'Core/Phone field': ['Default', 'Focused', 'Filled', 'Valid', 'Error', 'Disabled'],
  'Core/Phone field/Country chip': ['Default', 'Pressed', 'Disabled'],
  'Core/Search field': ['Default', 'Focused', 'Filled', 'Disabled'],
  'Core/Code input': ['Empty', 'Typing', 'Checking', 'Error', 'Success', 'Disabled'],
  'Core/Code input/Cell': ['Empty', 'Focused', 'Filled', 'Error', 'Success', 'Disabled'],
  'Core/Code delivery status': ['Sent', 'Delivered', 'Checking', 'Late'],
  'Core/Checkbox': ['Default', 'Pressed', 'Error', 'Disabled'],
  'Core/Choice tile': ['Default', 'Pressed', 'Selected', 'Error', 'Disabled'],
  'Core/List row': ['Default', 'Pressed', 'Selected', 'Disabled'],
  'Mobile/Top bar': ['Default', 'Scrolled'],
  'Mobile/Progress steps/Step': ['Done', 'Current', 'Upcoming'],
  'Mobile/Paste offer': ['Default', 'Pressed'],
  'Mobile/Date picker': ['Default', 'Today limit'],
};
const CONTRAST_EXCEPTIONS = [
  /Core\/Button.*Style=Primary/, // rules.md: the primary button
  /Expected fail/, // the Foundations contrast matrix shows the forbidden pairs on purpose
  /Decor\/Status bar.*Content=Ivory/, // ivory content is made for blue grounds; the library shows it on a light set
];
const L10N_NAME = /^(new:)?[a-z][A-Za-z0-9]*$/; // a core_l10n key, or new: plus a proposed key
const SCREEN_SIZES = new Set(['390×844', '360×800', '430×932']); // surfaces.md, Frames
const ICON_STROKE = 1.5; // rules.md, Icons
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
const isLibrary = figma.fileKey === LIBRARY_FILE;
const flowPage = !isLibrary && !/components/i.test(page.name); // a surface file's flow page holds screens
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
  'unkeyedText',
  'screenSize',
  'iconStroke',
  'unboundControlSize',
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
      /\/(Decor|Brand)\//.test(n.name)); // decoration and the identity's literal colours
  const owned = !ctx.inInstance; // nodes this file owns, not an instance's insides
  const docs = isLibrary && !ctx.inComponent && !isComp; // a library page's documentation frames around the components
  const hidden = n.visible === false;
  if (hidden && owned && !ctx.inComponent && !isComp) F.hiddenLayers.push(where(n, path));
  if (hidden) return;
  if (n.name.startsWith('Draft/')) F.draftOutsideExplorations.push(where(n, path));

  if (owned) {
    if (DEFAULT_NAME.test(n.name) && !decor && !ctx.names.some((x) => x.includes('/Icon/')))
      F.defaultNames.push(where(n, path));
    if (!decor && n.type !== 'COMPONENT_SET')
      for (const prop of ['fills', 'strokes']) {
        if (prop === 'strokes' && !(n.strokeWeight === figma.mixed || n.strokeWeight > 0)) continue; // mixed: weights per side
        for (const p of visibleSolids(n, prop)) {
          if (!p.boundVariables?.color) {
            if (!docs) F.unboundPaints.push(`${where(n, path)} ${prop}`);
          } else {
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
          !ctx.inComponent &&
          !docs
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
      flowPage &&
      ctx.topLevel &&
      n.type === 'FRAME' &&
      !SCREEN_SIZES.has(`${Math.round(n.width)}×${Math.round(n.height)}`)
    )
      F.screenSize.push(`${where(n, path)} ${Math.round(n.width)}×${Math.round(n.height)}`);
    if (
      n.type === 'VECTOR' &&
      ctx.names.some((x) => x.includes('/Icon/')) &&
      visibleSolids(n, 'strokes').length &&
      n.strokeWeight !== ICON_STROKE
    )
      F.iconStroke.push(`${where(n, path)} ${String(n.strokeWeight)}`);
    if (
      n.type === 'COMPONENT' &&
      TARGETS.test(n.parent?.type === 'COMPONENT_SET' ? n.parent.name : n.name) &&
      !n.boundVariables?.height &&
      !n.boundVariables?.minHeight && // a row that grows with «Text 130%»
      !n.children.some((c) => c.name === 'Box' && c.boundVariables?.height) // a labelled field binds its box
    )
      F.unboundControlSize.push(`${where(n, path)} height=${Math.round(n.height)}`);
    if (
      n.type === 'FRAME' &&
      n.children.length === 0 &&
      !ctx.inComponent &&
      !n.fills.some((p) => p.visible !== false)
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
    if (flowPage && owned && !ctx.inComponent && !L10N_NAME.test(n.name))
      F.unkeyedText.push(`${where(n, path)} «${n.characters.slice(0, 30)}»`);
    if (owned && /[؀-ۿ]/.test(n.characters) && n.textAlignHorizontal === 'LEFT')
      F.arabicAlignedLeft.push(where(n, path));
    if (/[٠-٩۰-۹]/.test(n.characters)) F.arabicIndicDigits.push(where(n, path));
    const fg = visibleSolids(n, 'fills')[0];
    const label = [...ctx.names, n.name].join(' ');
    if (
      fg &&
      n.characters.trim() &&
      !/Disabled/.test(label) &&
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
  file: figma.fileKey,
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

## Foundations audit

Run on the library file, from any page, after a batch that changes variables or text styles, and before every publish. It checks what the page audit cannot see:

| Check                | Fails on                                                                                                                                      |
| -------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- |
| `missingDescription` | A variable or a text style without a description                                                                                              |
| `colourWithoutLimit` | A Color variable whose description does not say where not to use it (no «not», «never», «instead» or «only»)                                  |
| `allScopes`          | A variable left with `ALL_SCOPES`                                                                                                             |
| `primitiveVisible`   | A primitive with a scope, or the Primitives collection not hidden from publishing                                                             |
| `codeSyntax`         | WEB code syntax other than `var(--fd-` + the name with `/` as `-` (Color adds `color-`)                                                       |
| `brokenAlias`        | An alias to a variable that no longer exists, in any mode                                                                                     |
| `lowContrast`        | `text/*` under 4.5:1, or `icon/*` and `border/*` under 3:1, on canvas, surface, subtle and the state's own soft background; inverse on accent |
| `textStyleUnbound`   | A text style whose size, line height or family is not bound to a Typography variable                                                          |
| `tightLineHeight`    | A text style whose line height is under 1.4 times its size                                                                                    |

Exempt from contrast: the disabled tokens, `border/default` and `border/strong` (dividers, not control boundaries), and `text/inverse` on `bg/brand` (the declared primary-button exception).

```js
const BACKGROUNDS = ['bg/canvas', 'bg/surface', 'bg/subtle'];
const LIMIT = /\b(not|never|instead|only)\b/i;
const NO_CONTRAST = new Set(['border/default', 'border/strong']);
const code = (collection, name) =>
  `var(--fd-${collection === 'Color' ? 'color-' : ''}${name.replace(/\//g, '-')})`;

const cols = await figma.variables.getLocalVariableCollectionsAsync();
const vars = await figma.variables.getLocalVariablesAsync();
const byId = new Map(vars.map((v) => [v.id, v]));
const byName = new Map(vars.map((v) => [v.name, v]));
const colOf = new Map(cols.map((c) => [c.id, c]));
const F = {};
for (const k of [
  'missingDescription',
  'colourWithoutLimit',
  'allScopes',
  'primitiveVisible',
  'codeSyntax',
  'brokenAlias',
  'lowContrast',
  'textStyleUnbound',
  'tightLineHeight',
])
  F[k] = [];
const resolve = (v, depth = 0) => {
  const val = v.valuesByMode[colOf.get(v.variableCollectionId).modes[0].modeId];
  if (val?.type !== 'VARIABLE_ALIAS') return val;
  const t = byId.get(val.id);
  return t && depth < 5 ? resolve(t, depth + 1) : null;
};
const lum = ({ r, g, b }) => {
  const f = (c) => (c <= 0.04045 ? c / 12.92 : ((c + 0.055) / 1.055) ** 2.4);
  return 0.2126 * f(r) + 0.7152 * f(g) + 0.0722 * f(b);
};
const ratio = (a, b) => {
  const x = lum(a),
    y = lum(b);
  return (Math.max(x, y) + 0.05) / (Math.min(x, y) + 0.05);
};
const check = (fg, bg, need) => {
  const a = byName.get(fg) && resolve(byName.get(fg));
  const b = byName.get(bg) && resolve(byName.get(bg));
  if (!a || !b) return;
  const r = ratio(a, b);
  if (r + 0.005 < need) F.lowContrast.push(`${fg} on ${bg} ${r.toFixed(2)} < ${need}`);
};

for (const c of cols)
  if (c.name === 'Primitives' && !c.hiddenFromPublishing) F.primitiveVisible.push('collection');
for (const v of vars) {
  const c = colOf.get(v.variableCollectionId);
  if (!v.description.trim()) F.missingDescription.push(v.name);
  if (c.name === 'Color' && !LIMIT.test(v.description)) F.colourWithoutLimit.push(v.name);
  if (v.scopes.includes('ALL_SCOPES')) F.allScopes.push(v.name);
  if (c.name === 'Primitives' && v.scopes.length) F.primitiveVisible.push(v.name);
  if (v.codeSyntax?.WEB !== code(c.name, v.name))
    F.codeSyntax.push(`${v.name} ${v.codeSyntax?.WEB ?? 'none'}`);
  for (const m of c.modes) {
    const val = v.valuesByMode[m.modeId];
    if (val?.type === 'VARIABLE_ALIAS' && !byId.get(val.id))
      F.brokenAlias.push(`${v.name} (${m.name})`);
  }
  const [kind, state] = v.name.split('/');
  if (c.name !== 'Color' || !['text', 'icon', 'border'].includes(kind)) continue;
  if (/disabled/.test(state) || NO_CONTRAST.has(v.name)) continue;
  const need = kind === 'text' ? 4.5 : 3;
  if (state === 'inverse') {
    check(v.name, 'bg/accent', need);
    continue;
  }
  for (const bg of BACKGROUNDS) check(v.name, bg, need);
  if (byName.has(`bg/${state}-soft`)) check(v.name, `bg/${state}-soft`, need);
}
for (const s of await figma.getLocalTextStylesAsync()) {
  if (!s.description.trim()) F.missingDescription.push(`style ${s.name}`);
  const bound = s.boundVariables ?? {};
  if (!bound.fontSize || !bound.lineHeight || !bound.fontFamily) F.textStyleUnbound.push(s.name);
  if (s.lineHeight.unit !== 'PIXELS' || s.lineHeight.value < s.fontSize * 1.4)
    F.tightLineHeight.push(`${s.name} ${s.fontSize}/${s.lineHeight.value ?? 'auto'}`);
}
const counts = Object.fromEntries(Object.entries(F).map(([k, v]) => [k, v.length]));
return {
  file: figma.fileKey,
  variables: vars.length,
  pass: Object.values(counts).every((c) => c === 0),
  counts,
  findings: Object.fromEntries(Object.entries(F).filter(([, v]) => v.length)),
};
```
