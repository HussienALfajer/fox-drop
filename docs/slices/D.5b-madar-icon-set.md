# D.5b Madar icon set v4

Status: Done · Tier: T2 · Branch: `feat/madar-icons`
Spec: architecture §9.4 and §9.5 R8 (rewritten by this slice), §9.9 (the set approved by the owner on 2026-11-24), brand expression §10 · Definition of done: the D.5b line of `docs/roadmap.md` Phase D; the D.5 icon rules carried to v4, and the D.6 and D.7 Icon components given a style

## Goal

Every web and app surface draws FOX DROP's icons from the approved set v4 "Madar": stroke 1.5 (1.75 in the captain app), six styles from one source drawing, with Bold and Broken baked into plain paths that Flutter and the web both draw without masks or dash offsets. The owner sees the six styles in Storybook and widgetbook.

**Scope decisions (owner, 2026-11-24):** one slice and one pull request; the styles are used in the existing components as on the Madar sheet (the selected bottom tab Bold, empty states Brand Duo, the favourite heart Bold instead of `filled`, the captain stroke 1.75); all six styles go into `Icon` and `FoxIcon`, Duotone and Broken included.

**Inputs, outside the repository** (the sheet's link stays in Claude's memory, never here): `C:\Users\OMEN\.claude\projects\D--fox-drop\icon-system-v4\`. `icons.mjs` holds the geometry: the continuous corner `P()` and the element fields `r` body or detail, `k` `in` or `out`, `a` accent, `f` filled in Bold, `open` an open body, `h` halo. Running it writes `icons.json`, keyed by icon name. The function `svg(name, style, size, sw)` in `template.html` is the reference renderer of the six styles. `node build.mjs D:/fox-drop <out.html>` builds the sheet for comparison.

## Plan

0. **Design checkpoint:** nothing new to draw; the owner approved the Madar sheet on 2026-11-24. Before the pull request, compare the Storybook and widgetbook renders with the sheet built from `template.html`.
1. **Docs** (first commit):
   - Architecture §9.4, rewritten:
     - The construction: Madar on Solar's construction; the 24 grid; live area 2..22, with bodies inside 2.25..21.75; stroke 1.5 with round caps (1.75 in the captain theme).
     - The continuous corner: two cubics, with handles at 0.5286 s and 0.2929 s and the diagonal at 0.1464 s, generalised to any angle.
     - Dots are zero-length paths.
     - Each icon has one body and one meaning detail; details stay at least 1.5 clear of the body.
     - Element roles: body; detail, knocked `in` or drawn `out` in Bold; accent, the meaning layer; `fill`; `open`; `halo`.
     - The six styles and their uses: Linear is the default; Bold for the selected tab and the captain's large buttons; Brand Duo for empty states, promo cards and settings chips; Bold Duo for coloured cards and important notices; Duotone and Broken for marketing and illustration.
     - Duotone fades the non-accent elements to 0.5. Brand Duo strokes the accent in `brand`. Bold knocks details out at the stroke width. Bold Duo fades the non-accent bodies to 0.5.
     - The bite: Broken cuts one 2.25 gap in the primary body, at its point nearest (22, 2).
     - The halo: in Bold, a 1.25 gap cleared around an element that crosses the body.
     - Mirroring is unchanged. §9.11 gets the decision of 2026-11-24.
   - R8 row: the grid, stroke, roles, styles, bite and halo of §9.4. Enforced by `icons.test.ts` and `icon-bake.test.ts`. Slices D.5 and D.5b.
   - Brand expression §10: stroke 1.5 and Madar; the heart's fill exception is now the Bold style.
   - `packages/design-tokens/CLAUDE.md` (the Icons bullet), `docs/code/packages/design-tokens.md` and `docs/code/packages/core_ui.md`: what the bake does, and why (Flutter has no SVG masks or dash offsets).
2. **Sources** (`packages/design-tokens/icons/`): the 47 SVGs replaced from the v4 `icons.json`.
   - Root: `viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"`.
   - Each element is one `<path d>`, in drawing order, with its role as data attributes:
     - `data-role="body|detail"`;
     - `data-knock="in|out"`, on details only;
     - the flags `data-accent`, `data-fill`, `data-open` and `data-halo`, each with the value `"true"`.
   - `icons.json` keeps its manifest as it is: name, group, mirror, description.
   - The one-off converter script stays in the scratchpad. From then on the SVGs in the repository are the source.
   - Fixes made on import, too small to see, for geometry the tests refuse:
     - `bell`: the clapper reaches y 22.1; move it up to 22.
     - `route`: the pin reaches x 22.1; shift it in to 22.
     - `restaurant`: the awning arcs `A2.375` become `A2.38`, for the 2-decimal rule.

     Record each one in Evidence.
3. **Bake** (`packages/design-tokens/src/`):
   - The dev dependency `canvaskit-wasm`: Skia, the engine Flutter draws with. Pin an exact version at least two weeks old (`pnpm add -D` in this package). It is used at generate time only.
   - `icon-bake.ts`, from one icon's elements:
     - **broken**: take the primary body, which is the first non-accent body, or else the first body; icons without a body get no break. Cut it at the arc-length point nearest (22, 2), with a gap of 2.25 + 1.5 in path length (`ContourMeasure`, `Path.trim(…, isComplement)`). The result is plain stroked path data.
     - **bold** and **boldDuo**, as fills for each stroke weight w in {1.5, 1.75}. Icons without a body use 1.4 × the weight, as `template.html` does.
       - The body region is the union of each body's fill (none for `open`) and its stroke at w.
       - Subtract the knocked `in` details: their stroke at w, plus their fill when `fill`. Bold only.
       - Subtract the halos: their stroke at w + 2.5, plus their fill when `fill` or a body.
       - Add the halo bodies back, without the cuts.
       - Add the `out` details as their stroke outline at w, plus their fill when `fill`. In Bold Duo every detail is added this way.
       - In Bold Duo, the non-accent body layers carry `faded`.
     - Every result goes through `Path.stroke`, `MakeFromOp` and `simplify`, out with `toSVGString`, rounded to 2 decimals.
   - `icons.ts`: `readIcons()` reads the elements with their roles. `webIcons()` and `dartIcons()` write, per icon:
     - `elements`: the path data and the accent flag, shared by Linear, Duotone and Brand Duo;
     - `broken`;
     - `bold` and `boldDuo` fill layers.

     The web output carries weight 1.5 only (no web surface is captain). Dart carries 1.5 and 1.75. The header comments say stroke 1.5.

   - `icon-sheet.ts`, the owner's sheet in `.design-system/icons`: show the six styles of each icon.
   - Bump `version` in `package.json` and add a `CHANGELOG.md` entry.
4. **Tokens:**
   - The icon stroke, a token: 1.5, and 1.75 in the captain theme. Follow the way `FoxThemeData.captain()` already overrides sizes.
   - Brand Duo's accent reads the semantic `brand` colour. Add the icon-on-ground pairs to `src/contrast.ts` under the R4 exception, so the report shows their ratios.
   - Regenerate.
5. **Web** (`packages/ui-web/src/icon/icon.tsx`):
   - The prop `style?: 'linear' | 'duotone' | 'brand-duo' | 'broken' | 'bold' | 'bold-duo'`, default `linear`; stroke 1.5.
   - Linear, Duotone and Brand Duo draw from `elements`. Duotone fades with `opacity` .5; Brand Duo's accent strokes in `--fd-color-brand`.
   - Broken draws from `broken`. Bold and Bold Duo draw as fills in `currentColor`, with `fill-opacity` .5 on the faded layers.
   - `STATES` gains the styles, and the stories show them.
   - Uses: `empty-state.tsx` draws Brand Duo. The sidebar stays as drawn (the web has no bottom tab).
6. **Flutter** (`packages/core_ui/lib/src/icon/fox_icon.dart`):
   - A `FoxIconStyle` enum of the six styles and a `style` property (default `linear`); `filled` goes.
   - The painter strokes at the theme's icon stroke (1.5 on the phone, 1.75 for the captain) and fills the baked layers for that weight. The accent paints in `FoxTheme.of(context).colors.brand`.
   - `iconStates` gains the styles. Their use cases go in `apps/widgetbook/lib/catalogue.dart` (the coverage test).
   - `FoxIconData` in `core_tokens` gains the new fields.
   - Uses: the selected tab in `fox_navigation.dart` draws Bold; `fox_empty_state.dart` draws Brand Duo; the favourite in `fox_restaurant_card.dart` draws Bold when chosen, Linear otherwise.
7. **Goldens and screenshots:**
   - Run `pnpm test:golden --update-goldens` and the Playwright visual update of `packages/ui-web/e2e/__screenshots__`.
   - Look at every diff in `test/golden/failures/` before accepting it. Expected: stroke 2 → 1.5 everywhere, plus the new styles where they are used.
   - A new golden: the six styles of a few icons at both weights.
8. **Design System sync (§9.8):** run the design-tokens `design-system` script, then the ui-web one. Upload, then publish the Design System and the Guide, with the links from Claude's memory.

Tests written first (locked in the red phase):

- `packages/design-tokens/src/icons.test.ts`:
  - The root stroke width is `1.5`.
  - Shapes are `<path>` elements only, carrying `d` and the role attributes: `data-role` on every path, `data-knock` on details only and always on them, flags only with `"true"`.
  - Every icon has at least one body, except the bodiless glyphs `back`, `close`, `chevron-down`, `menu`, `add`, `remove`, `confirm` and `retry`, and at least one accent element.
  - The live area 2..22, the 2-decimal rule, and the manifest and mirror tests are kept.
- `packages/design-tokens/src/icon-bake.test.ts`:
  - The broken body has exactly one gap, 3.75 ± 0.05 long, centred on its point nearest (22, 2).
  - Bold layers are fills only, with no mask or dash, and stay within 2 − w/2 .. 22 + w/2.
  - A knocked detail leaves a hole: the centre of `home`'s door and of `info`'s dot is outside the fill.
  - A halo keeps at least 1.25 between the element and the body (`car`'s wheels, `offline`'s line).
  - Bold Duo marks the non-accent bodies faded.
  - Baking twice gives the same output.
- `packages/core_tokens/test/icons_test.dart`: every icon has elements, `bold` and `boldDuo` at 1.5 and 1.75, and `broken` when it has a body.
- `packages/ui-web/src/icon/icon.test.tsx`:
  - The stroke width is 1.5.
  - Each style renders its own layers: `brand-duo`'s accent uses the brand variable; `bold` draws fills and no stroke.
- `packages/core_ui/test/icon_test.dart`:
  - Each style paints.
  - The captain theme strokes at 1.75.
  - A chosen favourite's heart, the selected navigation item and the empty state use their styles.
- `packages/core_ui/test/golden/icon_golden_test.dart`: the six-styles sheet at 1.5 and 1.75.

Checkpoints:

1. Docs, sources and `icons.test.ts`, with the outputs regenerated (Linear only).
2. The bake, `icon-bake.test.ts` and the generated outputs.
3. The web Icon, its stories and the screenshots.
4. `FoxIcon`, its uses, widgetbook and the goldens.
5. The Design System sync, `checker` green, `reviewer`, the pull request.

Risks:

- **Drift across platforms.** The drift test compares the committed outputs, so CanvasKit's output must be byte-identical on Windows and on Linux CI. The bake-twice test and CI's drift check prove it. If they ever differ, round the baked fills harder (1 decimal); never skip the test.
- **Size.** The baked fills at two weights may add 100 to 200 KB to `icons.g.dart`; record the measured size.
- **Broken at 1.75.** The gap is fixed in path length, so it shows 2.25 at 1.5 and 2.0 at 1.75.

## Stopped at

Done: built, reviewed, synced; the pull request is open.

## Decisions made while building

- **Locked-test changes (owner, 2026-11-24):** `icon-bake.test.ts` measures lengths at CanvasKit resScale 100 (at 1 Skia measures curves only to about 0.3 on the 24 grid, so an exact 3.75 gap read 3.64 to 3.68), and checks the gap's centring along the line, by arc length (chords around the star's tip are not symmetric). On an open body the bite slides to the nearest point where a whole gap fits with a 1.5 stub at each end (`bell`, `restaurant`, `share`); §9.4 records the rule. `core_ui/test/icon_test.dart` sizes its restaurant card with `FoxSize.toast` instead of a literal 360, a lint (R2) fix only.
- **The web prop is `variant`, not `style`:** the web lint refuses any JSX attribute named `style` (R1). Flutter keeps `style` (`FoxIconStyle`).
- **Story state names** are camel case (`brandDuo`, `boldDuo`): the stories test turns a state into its story name by capitalising its first letter.

## Evidence

- `node scripts/verify.mjs --changed`: `verify: the checks of the change passed` (after the code changes; the later commits are images and docs).
- `pnpm test:golden --update-goldens`: 75 tests passed, 66 baselines rewritten (stroke 2 → 1.5 everywhere, the Bold selected tab, the Bold favourite heart, the Brand Duo empty state) and two new sheets, `icon_styles_phone.png` and `icon_styles_captain.png`; the ones looked at match the intent.
- `pnpm --filter @fox-drop/ui-web test:visual --update-snapshots`: 507 passed, one timeout under load (`topbar--emergency` on phone) that passed alone; 286 baselines, ten of them new (the five styles on phone and captain).
- The repo's bake beside the sheet built from `template.html` (`home`, `bell`, `wallet`, `car`, `offline`, `cart`, `share`, `restaurant`, `star`, `retry`; screenshots in the session scratchpad, outside the repository): Linear, Duotone, Brand Duo, Bold and Bold Duo match; Broken differs only where the owner's sliding rule moves the bite (`bell`, `restaurant`, `share`).
- Design System version 20 (icons, the changed Flutter cards, the Icon component with `variant`, tokens 0.9.0, the brand book's iconography) and Guide version 17 (Foundations, Shapes, tokens) published on 2026-11-24.
- Import fixes, too small to see: `bell`'s clapper moved up from y 22.1 to 22; `route`'s pin moved 0.1 left so it ends at x 22; `restaurant`'s awning arcs `A2.375` written `A2.38`; `retry`'s arrowhead reached y 1.09, so both arms are shortened by the same factor (0.714) and the tip sits at y 2 (`M12.76 2L14.07 4.27L11.8 5.58`; owner, 2026-11-24).
- Sizes: `generated/icons.ts` 12 → 130 KB, `icons.g.dart` 14 → 231 KB.
- Review (`reviewer`, two rounds): the missing web screenshots (blocking) were committed; §9.4's body bounds and detail clearance were reworded to what the approved sheet draws (the test holds 2..22); "Stopped at" was updated. Nothing blocking remains. Not deferred: none.
- `tokens.test.ts`'s exception test now allows `primary-subtle` as the ground of an orange pair: the Brand Duo accent in the empty state's drop.

## Before deploying

Nothing: no server change. The apps pick up the set at their next build.

## To check on staging

Nothing new. The owner opens Storybook and widgetbook to see the six styles, the Bold selected tab, the Brand Duo empty state and the captain at 1.75.

## Notes for the next session

- The sheet's link lives in Claude's memory (`fox-drop-icon-system-v4`); never commit it.
- Later change (owner, 2026-11-25, D.11b): the selected bottom tab is Linear, not Bold; its larger orange circle alone marks it.
- Write the SVGs with a script in the scratchpad that reads the v4 `icons.json`; do not copy `icons.mjs` into the repository.
