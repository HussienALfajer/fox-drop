# 9. Design system (T2, T10, T11)

> Part of the [technology stack](README.md). A bare "§n" here means §n of the technology stack. Method and rules decided by the owner on 2026-11-21 (T10); headless bases in T11. The slices that build it are Phase D in `docs/roadmap.md`.

## 9.1 Method: code is the source, design comes first

- **Code is the source of truth.** Tokens and components are edited in code. The Claude design project (§9.8) mirrors them and is never edited by hand.
- **Design before code, with the owner's approval as the gate.** A component batch and a screen are drawn in the design project and approved by the owner before they are coded. The design is not bound by the feature specs; the specs decide behaviour, the owner decides the look.
- **What a drawing does not decide.** Keyboard behaviour in RTL, focus, typeahead, screen-reader output and digit entry are proven by tests only. Flutter drawings are a visual reference, not a pixel contract: golden tests are the check.
- **Direction of flow:**

```
packages/design-tokens ──generate──▶ web theme · Dart theme · design-project tokens
packages/ui-web, core_ui (tested) ──sync──▶ Fox Drop Design System (components)
approved sheet ──▶ component code        approved screen ──▶ screen code
```

- A token changes in `packages/design-tokens`, is regenerated and synced. A component enters the design project only after it is built and tested.

## 9.2 Token layers

Tokens are W3C Design Tokens (JSON) in `packages/design-tokens`, compiled by **Style Dictionary** into CSS variables and a Tailwind theme (web) and a Dart theme (`core_ui`). A change reaches both platforms in the same build.

| Layer         | Holds                                                                                                                                                                        | Used by                                    |
| ------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------ |
| **Primitive** | Raw values: the brand colours (ivory `#FFFAED`, orange `#FF6E31`, blue `#03428E`), their scales, the accessible orange, spacing steps, radii, shadows, durations, type sizes | Semantic tokens only                       |
| **Semantic**  | Meanings: surface, on-surface, primary, accent, border, success, warning, danger, focus ring, and so on. Each has a light value and a **dark slot**                          | Components and screens; the Tailwind theme |
| **Component** | Per component: its height, padding, radius, colour roles per state                                                                                                           | That component only                        |

- **The accessible orange.** `#FF6E31` fails contrast on ivory (2.68:1) and under white text (2.79:1). A darker orange, chosen in D.2 to reach at least 4.5:1 for text and for button fills, carries text and filled controls; `#FF6E31` stays for the logo, the app icon and large decorative areas. Blue `#03428E` on ivory is 9.27:1.
- **Dark mode comes later.** Every semantic token has its dark slot from D.2 so no component has to change when dark mode is built; V1 ships light only.
- **Foundations:** a 4-point spacing grid; a functional type scale; radius, elevation and motion tokens (reduced motion is respected); two densities, comfortable for the phone apps and compact for the panel; web breakpoints; phone safe areas.
- **Governance:** tokens are versioned with a changelog; a token is deprecated for a release before it is removed.

## 9.3 Typography

- **CoFo Sans Pro Arabic** is the UI typeface (text, headings, buttons). **YR-Speed** is for display and promotional use and **Emad-Diana** is secondary. The brand guidelines name HTQaysSansPro, which is not in the pack; Emad-Diana is.
- The fonts are licensed, not open: CoFo is "All rights reserved" (embedding flag `fsType` 4). **The font files stay outside this public repository** (they live in the private repository `HussienALfajer/fox-drop-fonts`; `docs/brand/fonts-manifest.json` pins its commit and every file's SHA-256, and `pnpm fonts:fetch` puts them in the ignored `.fonts/` before the apps and web bundles are built; a test refuses a font file in any commit of a pull request, by extension or by signature); the repository holds only their names, weights and metrics. Fonts are bundled in the apps and self-hosted on the web, never loaded from a third-party font CDN.
- **Western digits everywhere** (AP §4.7), with tabular figures for money, timers and tables.

## 9.4 Icons

- FOX DROP's own hand-drawn **line icon set**, in the style of the owner's Figma file, one source for web and Flutter: a 24-point grid, one stroke width, the same caps and joins, a safe area. Built in D.5.
- The set is exposed through an `Icon` component on each platform, so the set can change without touching screens. Directional icons mirror in RTL.

## 9.5 Rules (owner, 2026-11-21)

Every rule names the slice that builds its enforcement. A rule a machine can check is a test or a lint rule, not prose.

| #   | Rule                                                                                                                                                                                                                                                                                                                                           | Enforced by                                                                                                                        | Slice             |
| --- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ----------------- |
| R1  | **One source.** Every colour, length, font, radius, shadow and duration comes from the tokens. Screens use the semantic layer only                                                                                                                                                                                                             | Web lint: no arbitrary Tailwind value, no hex, no length in `style`; the Tailwind theme carries semantic tokens only               | D.6               |
| R2  | Flutter: no `Color(0x…)`, no number literal in `EdgeInsets`, `SizedBox` gaps or `TextStyle`; no Material or Cupertino widget in an app (only `core_ui` may)                                                                                                                                                                                    | Custom lint (`custom_lint`) over `apps/*`                                                                                          | D.7               |
| R3  | **Components only from the libraries.** Nothing is built inside a screen; a new component goes through the cycle (§9.9); one API naming scheme; every component appears in Storybook or widgetbook with all its states                                                                                                                         | Lint: apps import UI only from `ui-web` and `core_ui`; a test that every exported component has a story with its states            | D.6, D.7          |
| R4  | **Accessibility, WCAG 2.2 AA:** contrast for every foreground and background pair; 48 dp touch targets; visible focus; never colour alone; a name for every control; layouts intact at 130% text and more                                                                                                                                      | Token contrast test; axe on the web; semantics and 130% text tests in Flutter                                                      | D.2, D.6, D.7     |
| R5  | **Arabic first:** start and end only, never left and right; mirrored directional icons; Western tabular digits for money and timers; bidi isolation of Latin runs; every string in the translation files; a voice and tone guide for Arabic copy                                                                                               | Lint on physical directions; the RTL gate; the translation-key lint that already exists; the guide is a doc, reviewed by the owner | D.6, D.7          |
| R6  | **Five states for every screen:** loading (skeleton), empty, error, offline, partial                                                                                                                                                                                                                                                           | The screen cycle (§9.9) draws and tests all five; `REVIEW.md` item                                                                 | each screen slice |
| R7  | **Per surface.** Customer: appetite and trust, large photos with a fallback for missing or poor ones, fixed aspect ratios. Captain: outdoors, one hand, actions in the thumb zone, sunlight contrast, glanceable. Restaurant: busy kitchen, alerts seen from afar, fewest taps, tablet. Panel: dense data, keyboard shortcuts, compact density | The component sheets and screens are drawn per surface and approved by the owner                                                   | D.3 on            |
| R8  | **Icons:** the grid, stroke, caps, joins and safe area of §9.4                                                                                                                                                                                                                                                                                 | A test over the icon source files                                                                                                  | D.5               |
| R9  | **Governance:** on every pull request, screenshot comparison on the web, golden tests in Flutter, the RTL gate, and the comparison of a built screen with its approved drawing; UI items in `REVIEW.md` for the `reviewer`                                                                                                                     | CI jobs and `REVIEW.md`                                                                                                            | D.6, D.7          |

## 9.6 Web components: `packages/ui-web`

- The headless base is **UI SDK** (`@ui-sdk/react`), with **Base UI** as the per-component fallback (T11, §9.10). They handle focus, keyboard navigation, ARIA and RTL behaviour; FOX DROP supplies every look.
- `packages/ui-web` builds FOX DROP's own components on them: buttons, inputs, tables, cards, badges, alert banners, timers, money and status chips, the order card, and so on. Styling is Tailwind CSS on the semantic tokens, with logical properties (`ms-*`, `pe-*`, `start`, `end`) so RTL is the default and LTR works later (AP §12 lists English for V2). Variants use `tailwind-variants`.
- **Storybook** documents every component in RTL with all its states, with visual tests (§18).

## 9.7 Flutter components: `core_ui`

- `core_ui` implements the same components as Flutter widgets on the Dart theme. The apps use only `core_ui` widgets, never Material or Cupertino widgets (R2), so they look like FOX DROP.
- The behaviour base is Flutter's own widgets layer alone, with no third-party UI package, behind the `core_ui` API (T11, §9.10).
- RTL by default (`Directionality` from the Arabic locale). Layouts stay usable with the system font at 130% (RA §4.8, CA §4.7, CU §4.6).
- A widget catalogue app (**widgetbook**) documents the components with all their states, like Storybook on the web.

## 9.8 The Claude design project

One design project, private to the owner's account; its links are never committed to this public repository.

| Part                   | Type                                                                                              | Holds                                                                                                  | Changed by                   |
| ---------------------- | ------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------ | ---------------------------- |
| Fox Drop Design System | Design System, synced from code (read-only)                                                       | Brand book, tokens, type, fonts, logo and icons, and the built components with previews and guidelines | The repository only (sync)   |
| Fox Drop Guide         | Design canvas                                                                                     | One guide page drawn from the tokens: the layer flow, foundations, theme, tokens, effects, type, rules | Redrawn after a token change |
| Component proposals    | Design canvas, one page per batch                                                                 | The sheet of a batch before it is coded                                                                | The session with the owner   |
| Screens                | One canvas per app (customer, captain, restaurant, restaurant portal, panel), one page per module | Screens assembled from the design system's components, synthetic data only                             | The session with the owner   |

Inputs: the owner's brand pack and the Figma file "Fox Drop" (a mood board: no variables, screens imported as flat vectors, so it guides the look and is not a source of values). Three design directions are drawn in D.3 and the owner picks one.

A design is made with the Fox Drop Design System only; a missing value or component is added in code and synced, never invented on the canvas. Exploration outside the system happens on a separate canvas. Synthetic data only; no secret, production host or real personal data enters a design.

## 9.9 The cycles

- **Component cycle (per batch):** (1) a sheet shows every component of the batch in all states (default, hover, focus, pressed, disabled, invalid, loading), both densities, RTL, with the real tokens; (2) the owner approves it once per batch; (3) the batch is coded with its tests; (4) it is synced and the sheet is marked superseded.
- **Screen cycle:** (1) each screen of a feature is drawn in Arabic RTL from the design system's components, at the sizes the feature needs, with its five states (R6); (2) the owner approves the screens with the feature's slice plan; (3) it is coded, and the screenshot of the built screen is compared with the drawing, each difference fixed or explained; (4) a missing component goes through the component cycle first and is never a one-off in a screen.
- **Later changes:** a colour, type or component change starts in code and is synced; a screen change starts in its drawing, then its code.

## 9.10 Headless bases (T11)

| Platform | Base                                                                       | Safeguards                                                                                                                                                                                                         |
| -------- | -------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Web      | UI SDK `@ui-sdk/react` (React 19, beta), pinned to an exact version        | Imported only by `packages/ui-web` (lint); its agent bridge is forbidden (lint); an Arabic RTL gate passes before the core set is built; Base UI is the fallback per component; an upgrade is its own pull request |
| Flutter  | Flutter's own widgets layer only (no UI package), behind the `core_ui` API | Flutter widgets used only inside `core_ui` (R2 lint); the RTL gate before the core set; the Flutter version is pinned (`.fvmrc`)                                                                                   |

Flutter 3.47 moved Material and Cupertino out of the framework into `material_ui` and `cupertino_ui`, so `core_ui` does not depend on them for its look. Styled kits (forui, shadcn_ui, shadcn_flutter) are not used: their look fights the FOX DROP identity.

## 9.11 Open until D.2 and D.3

The darker orange's value, the three design directions, and the icon grid details are decided in their slices, each with the owner's approval.

## 9.12 Brand expression (D.1b)

Sections §9.1 to §9.10 govern the system; this one gives it its character. Slice D.1b decides each item below with the owner (discussed in chat, written once decided) in `docs/brand/expression.md`, before D.2 and D.3 use it. Nothing here is decided yet.

| Item                       | Decides                                                                                                                                                       | Feeds      |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------- |
| Principles and personality | Three to five design principles and the brand's personality, the yardstick every design decision and every D.3 direction is judged against                    | D.3 on     |
| Signature shape            | Whether the logo's drop becomes a shape language (cards, badges, the map pin, loading), and where it stops                                                    | D.2, D.3   |
| Motion language            | What motion means for FOX DROP: the order-confirmed moment, the courier moving on the map, transitions, haptics; the reduced-motion fallback                  | D.2, D.6/7 |
| Map style                  | Base map colours, restaurant, customer and captain pins, the route line, the captain's sunlight view                                                          | D.3        |
| Illustration and photos    | The illustration style for empty, error and offline states and missing photos; a food-photo guide for restaurants                                             | D.3, R6/R7 |
| Full palette               | Tonal scales of the three brand colours, status colours that fit them, a chart palette for the panel, and whether the captain app targets 7:1 for sunlight    | D.2        |
| Arabic typography          | The Arabic type scale and line heights, the Latin companion of CoFo, mixed-script alignment, a check that CoFo has tabular Western digits, how many typefaces | D.2        |
| Voice and tone             | Modern Standard Arabic or Syrian dialect, per surface; the tone of errors, waits and apologies                                                                | R5         |
| Device budgets             | Font subsetting and size limits, image weights, behaviour on low-end Android phones and weak networks                                                         | D.2, D.6/7 |
| First icon set             | The size of the first hand-drawn set (about 40 core icons) and what waits                                                                                     | D.5        |
