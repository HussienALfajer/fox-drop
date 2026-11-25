# DropLoader

The project's one loader: the brand mark, faint, fills with a liquid whose surface sways, then fades back, in one cycle without a pause.

## States

- Sizes `sm` 16 (inside a field: the drop alone, a flat surface), `md` 24 (a button, the default) and `lg` 48 (a page part).
- `onPrimary` on the orange ground: an ivory drop with an orange fox. Under reduced motion it stands still, half full.

## Props worth knowing

`label` («جارٍ التحميل», from the app's translation files) is read in a polite live region; without it the loader is decoration inside a control that is itself busy (`Button loading`, `SearchField loading`). Lists keep `Skeleton`.

## RTL and accessibility

The mark never mirrors. The motion follows `motion.mark-fill` and stops under `prefers-reduced-motion`.
