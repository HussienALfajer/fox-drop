# packages/ui-web

## Icon (D.6)

- `src/icon/icon.tsx`: `<Icon name size="sm|md|lg" label?>` over `@fox-drop/design-tokens/icons`. Inline SVG, viewBox 24, `stroke="currentColor"`, width 2, round caps and joins, no fill; the size classes read `size.icon-*` as `size-(--fd-size-icon-md)`; a `mirror` icon gets `rtl:-scale-x-100`; no `label` means `aria-hidden="true"`, with it `role="img"` and `aria-label`. Exports `Icon`, `IconName`, `IconProps` and `STATES` (default, sm, md, lg, labelled, mirrored).
- Stories: one per state, named by it (`Default`, `Sm`, `Mirrored` shows `back`). Tests: the paths, the hidden or named role, the size classes, the mirror class only on `back`, `motorcycle`, `car`.

## Button (D.6)

- **The look:** the approved sheet (`button()` in `design-tokens/src/button-sheet.ts`), read from `(--fd-button-*)` tokens: variants primary, secondary (1px inset border, no `border` so the size stays), danger, ghost; comfortable 50 and compact 40; icon-only circle. No shadow. Focus: `ring-2` in `button.focus-ring` with `ring-offset-2` in `surface`, `focus-visible` only.
- **Hover and pressed without an arbitrary value:** a `before:` overlay behind the label (`isolate`, `-z-10`) in the variant's pressed colour at 12% (ghost 60%) over the fill; it equals the sheet's `color-mix(<bg> 88%, <pressed>)`. `active:` sets the pressed colour as the fill and hides the overlay. A disabled or loading button has neither.
- **On the UI SDK:** `@ui-sdk/react/button` (`Button`, a native `<button>`; options `disabled`, `focusableWhenDisabled`, `type`, `pendingAnnouncement`; `onClick(event, details)`). Its `disabled` stops presses and keyboard activation (Enter and Space work natively). `loading` passes `disabled` with `focusableWhenDisabled`, so the button keeps focus (`aria-disabled`) and ignores presses, and sets `aria-busy`. The SDK's own pending (an `onClick` returning a Promise, announcing English «Loading») is not used.
- **Props:** `variant`, `density`, `icon`, `iconEnd`, `loading`, `disabled`, `type`, `onClick`; `children` or, for an icon alone, a required `label` (a union type). Icons are 24 when comfortable and 16 (`size.icon-sm`) when compact. Loading keeps the label in the layout with `invisible` and centres a spinner over it, so the width does not move. The label uses `text-phone-subtitle` (18, 1.3, 500) or `text-panel-subtitle` (16) when compact.
- **Exports:** `Button`, `ButtonProps`, `ButtonVariant`; `STATES` (default, hover, focus, pressed, disabled, loading, comfortable, compact) and `VARIANTS` stay in `src/button/button.tsx`.
- **Stories:** `<Variant><State>` for every pair (`PrimaryHover`, `GhostCompact`) plus `WithIcon*`, `CompactWithIcon` and `IconOnly*`. Hover, focus and pressed are plain interactive stories; the RTL gate drives them. The component has no state prop.

## Story coverage (R3)

`test/setup.ts` loads jest-dom and cleans up after each test. `test/stories.test.ts` takes every capitalised function exported by `src/index.ts`, maps `FooBar` to `src/foo-bar/foo-bar.stories.tsx`, imports `STATES` (and `VARIANTS`) from `src/foo-bar/foo-bar.tsx` and requires a story export ending in each state's PascalCase name, or exactly `<Variant><State>` when `VARIANTS` exists. `STATES` is not exported from `src/index.ts` (two components would collide).

## Package skeleton (D.6, step 3)

- **Package:** `@fox-drop/ui-web`, private, ESM; `exports` point at TypeScript source (`./src/index.ts`) and `./styles.css`. Exact pins as in `TASKS.md` D.6 (`@ui-sdk/react` and `@ui-sdk/core` 0.1.0-beta.14 both exist on npm, Storybook 10.6.8, Tailwind 4.3.5).- **Styles:** `src/styles.css` imports Tailwind, `tokens.css` and `tailwind.css` of `design-tokens`, and declares CoFo 400, 500 and 700 from `/fonts/cofo-sans-pro-arabic/CoFoSansProArabic-{Regular,Medium,Bold}.ttf`, the files and names of `scripts/font-metrics.mjs` (`WEIGHTS`). Storybook serves the repository's `.fonts/` at `/fonts` when the folder exists; without it (a fork's pull request) the build passes and text uses the fallback.
- **Storybook:** `.storybook/main.ts` (react-vite, `@tailwindcss/vite`, telemetry off), `preview.tsx` (decorator `dir="rtl" lang="ar"`, toolbar global `surface`: phone default, captain sets `data-surface="captain"` as `tokens.css` defines it, panel uses the default tokens).
- **Lint (R1, R3, R5, T11):** `eslint.web.mjs` holds a local plugin rule `fd/design` over every string and template literal and the `style` prop: arbitrary Tailwind value, hex colour, physical direction. `webAppConfig` (apps) bans `@ui-sdk/*` and `@base-ui/*`; `uiWebConfig` bans only `@ui-sdk/react/agent`. Stories and `*.test.tsx` skip the JSX-text rule. Known limits: any `-[` in a string counts as arbitrary (so `data-[state=open]:` fails too); a hex-looking anchor such as `#add` would count as a colour.
- **Left for later steps:** `test:e2e` (Playwright and axe are installed; the RTL gate step adds the config and specs), the `design-system` bundle script.
- **Wiring:** Turborepo picks `lint`, `typecheck`, `test` and `build` up from the scripts. `classify-changes.mjs` needed no change: a path under `packages/ui-web/` is not Dart, so it already counts as TypeScript (`code`, `typescript`).
- **Apps (skeleton):** no `style=` or physical class. The lint found four hex literals in `apps/admin` (a white canvas fill in `banners-page.tsx`, the QR's white and black in `setup-page.tsx`); they became `white` and `black`, which stay fixed because a QR code needs that contrast in any theme.
