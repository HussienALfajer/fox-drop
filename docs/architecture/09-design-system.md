# 9. Design system (T2)

> Part of the [technology stack](README.md). A bare "§n" here means §n of the technology stack.

## 9.1 One design language, two implementations

- FOX DROP's own UI/UX design is the source. It is defined once as **design tokens**: colours (light and dark), typography, spacing, radii, shadows, motion, z-order, icon sizes.
- Tokens are stored in the W3C Design Tokens format (JSON) in `packages/design-tokens` and compiled with **Style Dictionary** into:
  - CSS variables and a Tailwind theme for the web
  - a Dart theme file for `core_ui` in Flutter
- A token change reaches both platforms in the same build.

## 9.2 Web components: Base UI

- **Base UI** provides unstyled, accessible primitives: dialog, popover, menu, select, combobox, tabs, tooltip, toast, checkbox, radio, switch, slider, field and form, scroll area, and others. It handles focus, keyboard navigation, ARIA and RTL.
- FOX DROP builds its own component library on top in `packages/ui-web`: buttons, inputs, tables, cards, badges, alert banners, timers, money and status chips, the order card, and so on. Styling is Tailwind CSS on the tokens, with logical properties (`ms-*`, `pe-*`, `start`, `end`) so RTL is the default and LTR works later (AP §12 lists English for V2).
- Variants are written with `tailwind-variants`. Icons come from one icon set chosen by the design (Lucide by default), wrapped in an `Icon` component so the set can change.
- **Storybook** documents every component in RTL, light and dark, with visual tests (§18).

## 9.3 Flutter components: `core_ui`

- `core_ui` implements the same components as Flutter widgets on the tokens. The apps use `core_ui` widgets, not raw Material widgets, so they look like FOX DROP and not like stock Material.
- Material 3 is used only underneath for platform behaviour (text selection, scrolling, accessibility).
- RTL by default (`Directionality` from the Arabic locale). Layouts stay usable with the system font at 130% (RA §4.8, CA §4.7, CU §4.6).
- A widget catalogue app (`widgetbook`) documents the components, like Storybook on the web.

## 9.4 Typography

- One Arabic typeface family with a matching Latin, chosen by the design, bundled in the apps and self-hosted on the web (never loaded from a third-party font CDN in the apps).
- Western digits everywhere (AP §4.7), with tabular figures for money, timers and tables.
