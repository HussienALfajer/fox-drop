# FOX DROP design direction (D.3)

The owner adopted the Figma file "Fox Drop" on 2026-11-23 as FOX DROP's design direction and the reference of its design system (architecture §9.8, decision T12). Four directions had been drawn and scored on a private design canvas on 2026-11-22; the owner set them aside in favour of the file, so there is no pick among them. The file's values were measured from its nodes through the Figma REST API and written into the tokens (`packages/design-tokens`, version 0.2.0); the tokens stay the source of truth. The file's link and images stay out of this repository (§9.8).

## What the file holds

- **Colors:** three swatches, the brand blue `#03428E`, the brand orange `#FF6E31` and the ivory.
- **Typography:** specimens of CoFo Sans Pro Arabic 400 and Emad-Diana 300, at a line height of about 1.95, and one sample of Arabic-Indic digits.
- **Components:** 11 rough components with a Latin placeholder face: the «اطلب الآن» button (default, pressed, disabled), four input states (default, focused, disabled, error), a product card, the bottom bar and two badges; and six customer screens imported as flat vectors (onboarding, home, dish details, cart, menu variants). No variables, no styles, no auto layout.

## Measurements

| Item           | Figma value                                                                                      | Token                                                 |
| -------------- | ------------------------------------------------------------------------------------------------ | ----------------------------------------------------- |
| Ground         | `#FBF2E7`                                                                                        | `color.surface`                                       |
| Raised cards   | `#FEFEFE` (also `#FBFAF8`)                                                                       | `color.surface-raised`                                |
| Text, prices   | Blue `#03428E`                                                                                   | `color.on-surface`                                    |
| Muted text     | Blue at 9 to 45% alpha                                                                           | `color.on-surface-muted`: blue at 75% over the ground |
| Headings       | Orange `#FF6E31`                                                                                 | `color.heading`                                       |
| Buttons, bars  | Orange `#FF6E31`, ivory label                                                                    | `color.primary`, `color.on-primary`                   |
| Borders        | Blue at 40% (inputs), orange 2 px (focused)                                                      | `color.border` (16%), `color.border-strong` (60%)     |
| Error          | `#BF2929`                                                                                        | `color.danger`                                        |
| Offset shadow  | `#FD6425`, 7 px down, no blur                                                                    | `elevation.offset`                                    |
| Radii          | 8 (add-on cards), 10 (components), 15 (cart cards, totals, total bar), 30 (banner), full (pills) | `radius.sm`, `md`, `lg`, `xl`, `full`                 |
| Controls       | Buttons pills 50 high; icon buttons circles of 50                                                | `size.control`, Button `height` and `radius`          |
| Category discs | 80                                                                                               | Not a token yet (D.6, D.7)                            |
| Tags           | Pills 32 high                                                                                    | Not a token yet (D.6, D.7)                            |
| Bottom bar     | Floating blue bar 301 × 69, circles of 50, the active one orange at 57, ring `#E3DFD8`           | Not a token yet (D.6, D.7)                            |
| Spacing        | 4, 8, 16, 32; screen margins 16 to 18                                                            | `space.*` (4-point grid), margin 16                   |
| Icons          | Rounded line icons, stroke about 2 at 24                                                         | `packages/design-tokens/icons/`, `size.icon-*` (D.5)  |
| Shapes         | The S-curve tab (banner, dish sheet), cut-out dish photos                                        | Brand expression §2, §5                               |

Where the file's values fail the contrast rule, the tokens move them as little as passes: muted text at 75% (`#416EA4`, 4.59:1; the file's 45% and lighter fail 4.5:1), the control border at 60% (`#6688B2`, 3.20:1; the file's 40% fails 3:1). The brand orange stays as drawn, under the owner's exception (architecture §9.5 R4, brand expression §6).

## The owner's decisions per screen (2026-11-23)

- **Home:** the file, with these changes: category labels in blue instead of orange; tags as ivory pills with blue text; «اطلب الآن» instead of «أطلب الآن»; the offset shadow as drawn. The brand orange stays as drawn (a stronger orange was proposed and rejected).
- **Dish details:** the file unchanged.
- **Cart:** the file unchanged, except a minus sign before the discount amount.
- **Everywhere:**
  - The brand-orange exception covers every app, the captain's included (orange on buttons and headings only, never on numbers).
  - Prices keep the «450 ₺» format (AP §4.7), not the file's «TL 450».
  - The radii are the file's exact values.
  - Emad-Diana is not used in the UI; button labels are CoFo 700 (brand expression §7).

## Findings

- **The ₺ glyph** (U+20BA) is in neither CoFo nor Emad-Diana. The money component (D.6, D.7) needs a fallback font for it.
- **The cart's items do not add up** in the file (499.6 against a total of 450); a drawing for approval uses consistent synthetic amounts.
- **The ± stepper** in the cart is 34 px, below the 48 touch target (R4); its touch area grows to 48 while the drawn circle stays.
- **The onboarding slide is black,** which is not in the palette; it is not adopted until the onboarding screen is designed.

## Archived directions

Directions B «دافئ بالصور», C «أزرق الثقة» and D «زاوية القطرة», and direction A as drawn from the D.2 tokens, stay on the private canvas as a record and are not used. The "drop corner" of D is not adopted (brand expression §2).
