# FOX DROP

FOX DROP is a food delivery platform for Syria, launching in Azaz: a customer app, a restaurant app with a web portal, a captain (courier) app and an admin panel. This design system is synced from the repository's `packages/design-tokens` and is read-only here: a change starts in code and is synced again. Everything is Arabic first and right to left.

**Personality: «الجار الشاطر»**, the clever, quick, warm neighbour we know. The fox stands for wit and speed; the drop is delivery to your door. Orange carries warmth and appetite, blue carries trust in numbers and states. Friendly, never clowning.

## Principles

In order; when two conflict, the higher one wins.

1. **Clear before beautiful.** The amount, the time and the state read at a glance; no decoration covers information.
2. **Honest numbers.** Every price, fee and time is shown before the user commits.
3. **Light as a fox.** Fewest steps; it works on a low-end Android phone and a weak network.
4. **Each screen its moment.** The captain in the sun with one hand, the kitchen alert seen from afar, the dense panel driven by the keyboard.
5. **Local and warm.** Arabic first, in people's words, calm in errors: every error says what to do next.

## Content fundamentals

**Register:** simplified Modern Standard Arabic, close to speech, with words shared with Levantine: «طلبك في الطريق», «الكابتن وصل». Light Syrian dialect only in marketing: «جوعان؟ الثعلب جاهز».

| Surface                  | Tone                                                    |
| ------------------------ | ------------------------------------------------------- |
| Customer                 | The warmest                                             |
| Captain and restaurant   | Short, direct commands: «استلمتُ الطلب», «ابدأ التوصيل» |
| Panel                    | Neutral and exact                                       |
| Terms, receipts, amounts | Formal MSA                                              |

- **No fixed gender.** Buttons use the verbal noun: «تأكيد الطلب», «إضافة إلى السلة». Messages use neutral forms: «طلبك», «عنوانك».
- **Who speaks:** the platform says "we" when the fault or the promise is ours: «نعتذر، تأخّر طلبك». Never "I". The fox never speaks in copy.
- **Errors:** what happened, then what to do. «انقطع الاتصال. سنرسل طلبك حين يعود». Never «عذراً، حدث خطأ» alone, no technical codes, no blame.
- **Waits:** the time and its honest reason: «المطعم يحضّر طلبك، نحو 15 دقيقة».
- **Humour:** light, in empty states only; never in errors, money or a late order.
- **Writing:** the Arabic comma «،» and question mark «؟»; no exclamation marks in system messages; Western digits; avoid «بنجاح», «يرجى» and «خطأ غير معروف». Prices read «450 ₺».

## Visual foundations

### Colour

Ivory ground, blue words, orange actions.

- **Ground and cards:** `surface` (`#FBF2E7`) is every screen's ground; `surface-raised` (`#FEFEFE`) carries cards, sheets and inputs.
- **Text and numbers are blue:** `on-surface` (`#03428E`, 8.72:1 on the ground) for all text, prices and numbers; `on-surface-muted` (`#416EA4`, 4.75:1 on the ground, 4.59:1 at worst) for hints and captions.
- **Orange acts and titles:** `primary` (`#FF6E31`) fills buttons, bars and the active item, with `on-primary` ivory labels; `heading` sets titles in bold orange; `brand` is the logo and decorative areas.
- **The orange exception.** `#FF6E31` is 2.52:1 on the ground and 2.68:1 under ivory labels, below 4.5:1. The owner accepts this for `brand`, `primary`, `primary-hover`, `primary-pressed` and `heading` only (architecture §9.5 R4). Text and numbers are blue by default; the owner allows orange anywhere, body text, prices and numbers included (2026-11-23).
- **Borders:** `border` for decorative dividers and card outlines only; `border-strong` (3.20:1 at worst) for every control boundary; `focus-ring` blue.
- **States, always with an icon:** `success`, `warning` (a brown amber, not orange), `danger` (the Figma error red `#BF2929`), `info` (the brand blue), each with its `on-*` label colour. `alert` (`#8C1530`, 7:1) is for alerts read from across a kitchen.
- **Interaction states, one model for everything pressed** (R10, «brand tonal steps»): a filled control deepens inside its own ramp: `primary` → `primary-hover` → `primary-pressed`, `danger` → `danger-hover` → `danger-pressed`. A light control (outlined button, ghost, tag, list row, card) takes the brand blue's tint: on the ground `surface-hover` → `surface-pressed`, on white `surface-raised-hover` → `surface-raised-pressed`, and an outline turns `border-hover` blue. Every step is measured: hover is ΔE2000 ≥ 8 from rest and pressed ≥ 5 beyond it, so a state is always seen. The colour fades over 200 ms; nothing moves. A component never invents its own state colour. Phones have no hover, so the pressed colour carries the feedback there.
- **Charts:** `chart-1` to `chart-6`, in that order, blue first; told apart under colour-blind simulation.
- **Themes:** Light is the only designed theme. Dark copies Light until dark mode is designed. Captain light and Captain dark raise text and status colours to 7:1 for the sun.

### Type

**CoFo Sans Pro Arabic** alone, with its own Latin glyphs, at 400, 500 and 700 only: thin Arabic strokes vanish in the sun. Headings are CoFo 700 in `heading` orange.

| Role        | Phone | Panel | Captain | Line height |
| ----------- | ----- | ----- | ------- | ----------- |
| Caption     | 12    | 12    | 14      | 1.6         |
| Secondary   | 14    | 13    | 16      | 1.6         |
| Body        | 16    | 14    | 18      | 1.6         |
| Subtitle    | 18    | 16    | 20      | 1.3         |
| Title       | 20    | 18    | 24      | 1.3         |
| Large title | 24    | 22    | 28      | 1.3         |
| Number      | 30    | 28    | 36      | 1.2         |

- Each style is a class: `phone-body`, `panel-title`, `captain-number`, and so on. Use the phone scale in the customer and restaurant apps, the panel scale on the web, the captain scale in the captain app.
- Never below 12: Arabic dots disappear. No letter spacing, italics or kashida on Arabic.
- Money, timers and tables use Western tabular digits (`font-feature-settings: "tnum"`). Latin names and phone numbers are bidi-isolated; phone numbers run left to right.
- The ₺ glyph is not in CoFo: the money component gives it a fallback font.

### Shape

The Figma file's shape language:

- **The pill** for buttons, tags and the total bar's action, and **the circle** for icon buttons: `radius-full` at `size-control` (50 px) high. Touch targets are at least `size-touch-target` (48 px).
- **The offset shadow:** a flat orange shadow 7 px straight down, no blur (`elevation-offset`), under the main button and the active item. On press the control drops onto its shadow. The soft `elevation-low`, `-medium` and `-high` are for cards, menus and dialogs.
- **The S-curve tab:** a soft bump rising from the top edge of the home banner and of the dish sheet, holding its title.
- **The cut-out dish:** a dish photo without its background, overlapping its card's edge, only in images the platform prepares (the home banner, promotional slots). A restaurant's own photos keep their background and fixed ratio (dish 1:1, cover 16:9).
- **Radii:** `radius-sm` 8 (small cards, image slots), `radius-md` 10 (inputs, badges, product cards), `radius-lg` 15 (cart items, totals, bars), `radius-xl` 30 (banners, sheets), `radius-full` (pills, circles).
- **Space:** a 4-point grid, `space-2xs` 4 to `space-3xl` 64; `space-md` 16 is card padding and the screen margin.

### The drop

The logo's drop (a map pin: round head, pointed tip) appears only where it means "a place" or "on its way to you": map pins, the loading indicator (a drop filling), the order-confirmed moment and the frame of empty-state illustrations. Never on cards, buttons, inputs or anything pressed or typed in.

### Motion

Short motion that shows what changed: 100 ms press, 200 ms appear, 300 ms screen transitions, one calm easing without bounce. The next screen enters from the end side (RTL). Reduced motion turns transitions into fades.

## Iconography

- **Icons, set v4 "Madar"** (assets, Icons): FOX DROP's own 47 icons on Solar's construction: a 24 grid, stroke 1.5 in `currentColor` (1.75 in the captain app), continuous corners, round caps and joins, one body and one meaning element. Six styles come from each drawing: Linear by default; Bold for the selected tab and a chosen favourite; Brand Duo, the meaning element in `brand` orange, for empty states, promo cards and settings chips; Bold Duo for coloured cards and important notices; Duotone and Broken (a bite cut in the body) for marketing. The `Icon` component's `variant` picks one. Sizes `size-icon-sm` 16, `size-icon-md` 24, `size-icon-lg` 32. Blue (`on-surface`) by default; active, ivory (`on-primary`) inside an orange (`primary`) circle of `size-control`. `back`, `motorcycle` and `car` flip in RTL. The drop appears only in `drop-pin` and `map`. A missing icon waits for the next batch or uses text; never borrow one from another library.
- **Logos** (assets, Logos): the fox mark alone in orange, ivory or blue, on a square or a drop backing, and the four lockups (horizontal and vertical, Arabic and Latin). Use the ready lockups; never change the order of the mark and the name, never rotate, stretch, shadow or recolour. Arabic lockups on Arabic screens. Minimum: the mark 24 px, the horizontal lockup 120 px wide.
- **App icon** (assets, App icon): the ivory fox on orange is the official icon; the others are alternatives.

## Usage rules

- Use semantic tokens only: never a raw hex, a length or a shadow that is not a token.
- Text, prices, numbers: `on-surface`. Hints: `on-surface-muted`. Titles: `heading`. Orange text or numbers, where a design wants them, use `primary` (owner, 2026-11-23).
- A primary button: `primary` fill, `on-primary` label in CoFo 700, `radius-full`, `size-control` high, `elevation-offset` under it.
- A card: `surface-raised` on `surface`, `radius-lg`, padding `space-md`, `elevation-low` or a `border` outline.
- An input: `surface-raised`, `radius-md`, a `border-strong` boundary, `focus-ring` on focus, `danger` with an icon and a message on error.
- A state is never colour alone: add an icon and a word.
- Layouts use start and end, never left and right.

## Not synced

- Components are live only on the web (`packages/ui-web`), the design reference; each card shows its Flutter widget (`packages/core_ui`) as the image of its golden test underneath, and a component whose web twin is still pending shows that image alone.
- YR-Speed (marketing only) and Emad-Diana (not used) are not carried; only the three CoFo weights are.
- The `app-icon-broken-edges` SVGs are left out until the owner names their purpose.
- Durations and easing are not a token family here; they are listed under Motion.
- The dark themes copy Light until dark mode is designed.
