# FOX DROP design directions (D.3)

Four directions drawn on the same three screens and one icon sheet, each scored against the principles of [`expression.md`](expression.md) §1, so the owner picks the look the design system (D.4 to D.7) is built in. They were drawn on a private Claude design canvas, «Fox Drop Directions» (architecture §9.8: exploration stays on its own canvas, and its link stays out of this repository), from the D.2 tokens by semantic name, CoFo Sans Pro Arabic 400, 500 and 700, and synthetic data only.

## The Figma file (mood board)

The owner's Figma file "Fox Drop" was read on 2026-11-22 as a mood board, not a source of values (§9.8). What it holds, in words:

- **Three pages.** «Colors»: three swatches, the brand blue, the brand orange and the ivory. «Typography»: a specimen of a rounded bold Arabic display face with its digits and symbols. «Components»: customer screens (a dark onboarding slide, home, a dish's details, the cart, three menu variants) and their parts: badges (neutral, active), the bottom navigation, inputs (default, focused, disabled, error), a product card and the order button's states.
- **Home.** Ivory ground; a top row with the avatar, a rounded search pill and a bell; four category circles (offers, restaurants, groceries, breakfast) with orange line icons on white discs and orange labels; one large orange banner card with very round corners, a dish photo bleeding over its edge, a heart badge, a discount headline and outlined pill tags.
- **Dish details.** A full-width photo on top, an ivory sheet with large top corners overlapping it, the rating with an icon, outlined pill tags, add-on rows with orange line icons, and a full-width pill button «أطلب الآن».
- **Cart.** Each item a card with a thin orange outline and large radius; round outlined orange steppers; a white totals card with amounts in blue and the discount in orange; the total as a filled orange bar; a pill button «تأكيد الطلب».
- **Onboarding.** A black slide, white headline, orange page dashes with one blue active dash.

**What direction A keeps:** pill shapes for search, tags and the main button; round category discs with line icons; outlined cards on ivory; blue for amounts; large, soft corners; a warm, friendly density.

**What does not carry over, and why:**

| In the Figma file                                 | In direction A                                                    | Rule                                   |
| ------------------------------------------------- | ----------------------------------------------------------------- | -------------------------------------- |
| Labels and the discount in brand orange `#FF6E31` | Accessible orange `#C2410C` (`primary`) or on-surface text        | 4.5:1 (R4, expression §6)              |
| A rounded display face for headings               | CoFo Sans Pro Arabic only, 700 for headings                       | expression §7                          |
| Corners of about 24 to 32 px                      | `radius-lg` (16) and `radius-full`; a larger step is a token note | No invented values (§9.8); see Not yet |
| An orange outline on every card                   | `border` on cards; orange only on the active or main element      | 60/30/10 (brand README)                |
| Money as `TL 450`, Latin code before the number   | `450 ₺`                                                           | AP §4.7                                |
| A black onboarding slide                          | Not drawn (no such screen in D.3); black is not in the palette    | Brand palette                          |
| «أطلب» with a hamza on the alif                   | «اطلب» (imperative of a form I verb takes hamzat al-wasl)         | Spelling; the specs' strings take over |

## The four directions

Every direction uses only the D.2 tokens and keeps 60% ivory, 30% orange, 10% blue across a screen. They differ in how orange and blue are spent, the shape of surfaces, density and imagery.

### A «اتجاه Figma»

- **Palette use:** ivory ground, white raised cards with a `border` outline; orange on the category icons, the active tab and the main pill button; blue for amounts and the rating.
- **Surfaces and shape:** pill search, pill tags and pill main button (`radius-full`); cards at `radius-lg`.
- **Density:** airy; one restaurant card per row with a 16:9 cover.
- **Imagery:** the cover with the logo overlapping its bottom start corner; category discs with line icons.
- **Type:** titles 700, body 400; amounts 700 in blue.
- **Motion note:** soft fades and lifts at `base`; the pill button presses at `fast`.

### B «دافئ بالصور»

- **Palette use:** ivory everywhere, no coloured headers; orange only on the main action, the active tab and small accents (the free-delivery tag, the selected category); text in near-black.
- **Surfaces and shape:** borderless cards on ivory, separated by space; photos at `radius-md`.
- **Density:** generous; covers large and full width at 16:9, dish photos at 1:1 (R7).
- **Imagery:** the photo leads every card; categories as small square photo tiles with a label.
- **Type:** names 700 at title size; secondary data muted.
- **Motion note:** images fade in over their dominant colour (expression §9); no other motion on the list.

### C «أزرق الثقة»

- **Palette use:** a solid blue (`accent`) header band with the location and search; blue for every number, state and section title; orange for the one main action per screen only.
- **Surfaces and shape:** white cards with `radius-md`, firm `border-strong` dividers, square-ish chips at `radius-sm`.
- **Density:** compact and structured; covers smaller (16:9 at reduced width) with data in aligned rows.
- **Imagery:** photos smaller and secondary to the facts (fee, time, rating) set in a table-like row.
- **Type:** numbers tabular 700 in blue; labels 500.
- **Motion note:** almost still; changes highlight in place.

### D «زاوية القطرة»

- **Palette use:** bold orange blocks: an orange home header, orange category tiles with ivory icons, the main button orange; blue for numbers.
- **Surfaces and shape:** the "drop corner" on cards: three corners at `radius-lg`, the bottom start corner at `radius-xs` (expression §2: tried in one direction only, never on buttons or inputs).
- **Density:** medium.
- **Imagery:** covers 16:9 inside the drop-corner card; logos in a white rounded square.
- **Type:** titles 700; the header title in ivory on orange is large text only (`brand` fails as a text background below large size, so the header uses `primary`).
- **Motion note:** cards enter with a short rise at `base`; the drop corner carries no motion.

### On every direction

- **Captain step 3** keeps the sunlight rules in all four: text and numbers at 7:1 in near-black or blue, no orange text, the sunlight map (route width 8, solid orange after pickup), the main button «وصلت» full width in the thumb zone. The directions differ only in the header, card shapes and button shape.
- **Panel operations board** stays compact in all four (AP §9.2.1); SLA time always shows an icon with its colour (R4).
- **Icons:** about 13 line icons on a 24-point grid with one stroke, drawn in each direction's style as a sketch; D.5 draws the real set.

## Scores

Scored after drawing; see the canvas's last artboard.

## The pick

Pending the owner.

## Not yet

- Larger card corners (24 px or more) would need a new radius token in a later token pull request, if the picked direction wants them.
