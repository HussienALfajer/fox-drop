# FOX DROP brand expression

The character of the design system (architecture §9.12), decided item by item by the owner in chat on 2026-11-22 (slice D.1b). Architecture §9.1 to §9.10 govern the system; this brief says what it should feel like. D.2 turns the values into tokens, D.3 draws the design directions and scores each against the principles below, D.5 draws the icons, D.6 and D.7 build the components.

On 2026-11-23 (slice D.3) the owner adopted the Figma file "Fox Drop" as the design direction; §2, §3, §5, §6 and §10 say what it changed, and `directions.md` holds its measurements. Values given as candidates are settled by the contrast test in D.2. A machine-checkable rule here becomes a test or a lint rule in the slice named beside it; until then this text is the rule.

## 1. Personality and principles

**Personality: «الجار الشاطر»**, the clever, quick, warm neighbour we know. The fox stands for wit and speed; the drop is delivery to your door. Orange carries warmth and appetite, blue carries trust in numbers and states. Friendly, never clowning.

Rejected: loud and playful (it weakens trust where cash and restaurant and captain dues are involved, and tires the dense panel and weak phones); calm and premium (it loses appetite, reads like a bank and breaks the 30% orange of the brand pack).

**Principles, in order. When two conflict, the higher one wins.**

1. **Clear before beautiful.** The amount, the time and the state read at a glance; no decoration covers information.
2. **Honest numbers.** Every price, fee and time is shown before the user commits; no surprise at the door. The base of trust in a cash market.
3. **Light as a fox.** Fewest steps, speed the user feels, works on a low-end Android phone and a weak network.
4. **Each screen its moment.** The captain in the sun with one hand, the kitchen alert seen from afar, the dense panel driven by the keyboard. No single template forced on every surface.
5. **Local and warm.** Arabic first, in people's words, calm in errors: every error says what to do next.

Example: if a faster checkout conflicts with showing every fee, the fee is shown (2 above 3).

## 2. Signature shape

The logo's drop (a map pin: round head, pointed tip) appears **where it means "a place" or "on its way to you"**, and nowhere else:

- the map pins (§4);
- the loading indicator: a drop filling, instead of a spinner;
- the order-confirmed moment: the fox leaving the drop (§3);
- the frame of the empty-state illustrations (§5).

It never appears on cards, buttons, inputs or anything pressed or typed in, and never crops a restaurant's logo or a food photo. In the panel it appears only as map pins.

**The Figma file's shape language** (D.3) sits beside the drop and does not replace it:

- the **pill** for buttons, tags and the total bar's action, and the **circle** for icon buttons and the floating bar's items;
- the **S-curve tab**: a soft bump rising from the top edge of the home banner and of the dish sheet, holding its title;
- the **offset shadow**: a flat orange shadow 7 px straight down, no blur (`elevation.offset`), under the main button and the active item;
- the **cut-out dish**: a dish photo without its background, overlapping its card's edge (§5);
- radii of 8 (small cards), 10 (inputs), 15 (cards and totals), 30 (banner) and full (§6 tokens).

The "drop corner" of D.1b is not used: the file has no such corner.

## 3. Motion

**Motion with meaning:** short motion that shows what changed and where it came from, plus two signature moments.

| Token (D.2) | Duration | Use                            |
| ----------- | -------- | ------------------------------ |
| fast        | 100 ms   | Press, state toggle            |
| base        | 200 ms   | Appear, disappear              |
| slow        | 300 ms   | Screen transitions             |
| moment      | ≤ 1.2 s  | A signature moment, never more |

- Calm easing, no bounce. Transitions follow RTL: the next screen enters from the end side.
- **The press:** a control with the offset shadow drops onto its shadow (moves 7 px down while the shadow shrinks to 0) in `fast`; the others darken to their pressed colour.
- **Signature moments, two only:**
  1. **Order confirmed:** the fox leaps out of the drop and the screen goes straight to tracking. It never blocks or delays the user and a tap skips it.
  2. **Delivered:** the drop settles at the door, then the rating screen.
- **The captain on the map:** the location arrives every 10 seconds (CA §4.3); the pin glides along the route line between two points instead of jumping. After 30 seconds without an update the pin stops and shows «آخر تحديث قبل …». No motion without a fact behind it (principle 2).
- **Per surface:** the captain's new offer enters strongly with a pulse, a countdown ring for its 45 seconds and the existing C3 sound; the restaurant's new order pulses in a strong colour until it is accepted; the panel is almost still (a row whose state changes lights briefly, then settles).
- **Haptics:** light on order confirmed and on add to cart; a distinct pattern for the captain's new offer; none in the restaurant app (a fixed tablet: sound and light instead).
- **Reduced motion** (the system setting): transitions become fades or are instant, the signature moments become a still image, the captain's pin jumps; haptics stay.
- Motion is drawn in code or in small vector files: no video, no Lottie or Rive in V1 (§9).

## 4. Map style

The base is Protomaps' style on our own tiles (architecture §7.2), recoloured as **our "ivory map"**:

- faint ivory land, white roads with warm grey edges, pale water derived from our blue, calm green parks;
- **no orange in the base map**: orange belongs to our pins and the route;
- Arabic names (`name:ar`, else the name);
- most points of interest hidden; landmarks kept (mosques, schools, hospitals, roundabouts), because addresses in Azaz are given by landmarks;
- never a competitor's logo.

**Pins** are drops, never told apart by colour alone (R4):

| Pin        | Colour                      | Icon                                                | Size    |
| ---------- | --------------------------- | --------------------------------------------------- | ------- |
| Captain    | Orange (the one that moves) | The vehicle (motorcycle or car) and a heading arrow | Largest |
| Restaurant | Filled blue                 | Plate                                               | Medium  |
| Customer   | Ivory with a blue edge      | House                                               | Medium  |

**Route line:** dashed from the captain to the restaurant before pickup; after pickup solid brand orange, width 5 with a white casing, restaurant to customer. The part already travelled disappears.

**Captain's sunlight style:** the captain app always uses a high-contrast style (darker road edges, larger names, fewer points of interest, route width 8). No automatic switching: light sensors are unreliable on cheap phones.

**Panel:** the same ivory map with small pins; a captain's state (free, busy, offline) by colour and a symbol.

**Night:** the night style waits for dark mode. Until then the captain uses the sunlight style at night; it is tried at night on a device in L.9.

## 5. Illustration and photos

**Illustration:**

- In the customer, captain and restaurant apps: the fox in simple flat scenes, lines at the icon stroke width, the three brand colours only, inside the drop frame. The fox searches, waits, apologises.
- In the panel and the restaurant web portal: a large icon in a drop with text, no scenes.
- First set, about 8 SVG scenes, drawn in D.3 and D.5 and each approved by the owner: empty cart; no search results; outside the delivery zone; offline; general error; restaurant closed; captain with no orders yet; restaurant with no new orders.

**Missing photos:**

- A dish without a photo is a text row without an image slot; never a fake placeholder (principle 2).
- A restaurant without a cover shows its logo centred on a light tint.
- A restaurant without a logo shows the first letter of its name in a rounded square (not a drop, §2).

**Food photo guide** (given to the restaurants, applied by the panel on review):

- Fixed ratios (R7): dish 1:1, restaurant cover 16:9, at least 1080 px.
- Daylight, no flash.
- Plain background; the dish fills about 70% of the frame; shot from above or at 45°.
- Never: text on the photo, phone numbers, watermarks, photos from the internet, or AI-generated photos of a real dish. The customer sees what will arrive.

**Who photographs (V1):** each restaurant photographs its own dishes with its phone, following the guide with one good and one bad example. No platform photography in V1.

**Cut-out dishes** (the Figma file's dish without its background, §2) are used only in images the platform prepares: the home banner and promotional slots. A restaurant's own photos keep their background and their fixed ratio, since cutting out every phone photo cannot be done well by hand or honestly by machine (principle 2).

## 6. Palette

Ten steps, 50 to 900, for each colour on one shared scale, plus the in-between steps the Figma file needs (neutral 25 and 75, orange 450, and the blue over the ground at 16, 60 and 75%). D.2's contrast test settled the values below (`packages/design-tokens/tokens/`, report in `packages/design-tokens/generated/contrast-report.md`).

| Scale        | Anchor                                                                                                                                               |
| ------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------- |
| Orange       | Brand `#FF6E31` at 400; the offset shadow `#FD6425` at 450                                                                                           |
| Blue         | Brand `#03428E` at 500; the blue over the ground at 16, 60 and 75%                                                                                   |
| Warm neutral | Ivory `#FFFAED` at 50, the Figma ground `#FBF2E7` at 75, raised `#FEFEFE` at 25; greys derived from the ivory, leaning slightly beige, not cold grey |

- **The Figma file's colours (D.3, owner 2026-11-23):**
  - Ground `#FBF2E7`, raised cards `#FEFEFE`.
  - Text, prices and numbers in the brand blue `#03428E` by default (8.72:1); orange may be used for them too (below). Muted text is the blue at 75% over the ground, `#416EA4` (4.59:1), because the file's lighter blues fail 4.5:1.
  - Headings, buttons, bars and the active item in the brand orange `#FF6E31`, with ivory labels.
  - Borders in the blue at 16% (decorative) and 60% (control boundary, 3.20:1; the file's 40% fails 3:1).
  - The offset shadow `#FD6425` (§2).
- **The brand-orange exception (owner 2026-11-23, every app, the captain's included):** `#FF6E31` is 2.52:1 on the ground and 2.68:1 under ivory text, below 4.5:1. The owner accepts this for the orange tokens only (`brand`, `primary`, `primary-pressed`, `heading`); the contrast report marks those pairs «owner exception» and a test keeps the exception from spreading (architecture §9.5 R4). In D.8 the owner allowed orange anywhere, body text, prices, numbers and timers included (2026-11-23); each orange pair a design uses is listed in the contrast report. The accessible orange `#C2410C` of D.2 is retired.
- **Status colours, kept apart from the brand orange and always with an icon (R4):**

| Status  | Settled   | On the ground `#FBF2E7` | Note                                                  |
| ------- | --------- | ----------------------- | ----------------------------------------------------- |
| Danger  | `#BF2929` | 5.32:1                  | The Figma file's error red (D.3); always with an icon |
| Warning | `#8A5A00` | 5.35:1                  | A brown amber, not orange                             |
| Success | `#067647` | 5.14:1                  |                                                       |
| Info    | `#03428E` | 8.72:1                  | The brand blue                                        |

- **Status in the captain app:** success, warning and danger text darken to `#055A37`, `#6B4500` and `#8C1530` to reach 7:1. **Alerts** (restaurant, panel): `#8C1530`, 8.90:1 on ivory.
- **Charts (panel):** six categorical colours, blue `#03428E` first, then orange `#EA580C`, teal `#0F766E`, violet `#7C3AED`, olive green `#4D5A12` and pink `#BE185D`, each at 3:1 or more on the surfaces and at CIEDE2000 11 or more from each other (the closest pair, orange and olive under protanopia, is 11.97) under protan, deutan and tritan simulation (D.2). Sequential charts (heat maps, the vote map) use the blue scale only.
- **Contrast targets:** WCAG 2.2 AA (4.5:1) everywhere (R4), and more on two surfaces:
  - **Captain app:** text and numbers (amount, address, time) at **7:1** or more, in near-black or blue; buttons in the brand orange with large bold labels, under the exception above. Orange only on buttons and headings, never on numbers.
  - **Restaurant app:** alerts at 7:1, because they are read from across the kitchen.

## 7. Arabic typography

**Typefaces:**

- **CoFo Sans Pro Arabic alone** in the apps, the restaurant portal and the panel, with its own Latin glyphs (no second Latin typeface).
- **YR-Speed** for marketing only: store screenshots, social posts, at most one headline on the welcome screen.
- **Emad-Diana** is not used: one light weight and 323 glyphs. The Figma file sets its button label in it; the apps use CoFo 700 instead (owner, 2026-11-23). Headings are CoFo 700 in the brand orange.
- **The ₺ glyph** (U+20BA) is in neither CoFo nor Emad-Diana: the money component of D.6 and D.7 must give it a fallback font. Prices keep the «450 ₺» format.

**Weights:** 400, 500 and 700 only. No hairline or light weights for text: thin Arabic strokes vanish in the sun and on cheap screens.

**Type scale** (points):

| Role                             | Phone | Panel | Captain |
| -------------------------------- | ----- | ----- | ------- |
| Caption                          | 12    | 12    | 14      |
| Secondary                        | 14    | 13    | 16      |
| **Body**                         | 16    | 14    | 18      |
| Subtitle                         | 18    | 16    | 20      |
| Title                            | 20    | 18    | 24      |
| Large title                      | 24    | 22    | 28      |
| Prominent number (amount, timer) | 30    | 28    | 36      |

Never below 12: Arabic dots disappear.

**Line heights,** set explicitly (CoFo's own metrics are very tall): text 1.6, headings 1.3, prominent numbers 1.2.

**Mixed script and digits:**

- Money, timers and tables in Western tabular digits through the `tnum` feature, which CoFo has (its default digits are proportional). D.2's test checks that the tabular digits have equal widths.
- Latin names and phone numbers are bidi-isolated (R5); phone numbers always run left to right.
- On Arabic text: no letter spacing (it breaks the joins), no italics, no kashida.

## 8. Voice and tone

**Register:** simplified Modern Standard Arabic, close to speech, choosing words shared with Levantine («طلبك في الطريق», «الكابتن وصل»). Light Syrian dialect only in marketing and promotional pushes («جوعان؟ الثعلب جاهز»). This keeps the UI labels already written in the specs, which are MSA.

| Surface                  | Tone                                                     |
| ------------------------ | -------------------------------------------------------- |
| Customer                 | The warmest                                              |
| Captain and restaurant   | Short, direct commands («استلمتُ الطلب», «ابدأ التوصيل») |
| Panel                    | Neutral and exact                                        |
| Terms, receipts, amounts | Formal MSA                                               |

**Addressing the user without fixing a gender:**

- Buttons use the verbal noun: «تأكيد الطلب», «إضافة إلى السلة», «إدخال الرقم».
- Messages use forms whose written gender is neutral: «طلبك», «عنوانك».
- Masculine only when no neutral form exists.

**Who speaks:** the platform says "we" when the fault or the promise is ours («نعتذر، تأخّر طلبك»); never "I". The fox never speaks in copy; it lives in the illustrations.

**Hard moments:**

- **Errors:** what happened, then what to do (principle 5). No blame on the user, no technical codes, never «عذراً، حدث خطأ» alone. Example: «انقطع الاتصال. سنرسل طلبك حين يعود».
- **Waits:** the time and its honest reason (principle 2): «المطعم يحضّر طلبك، نحو 15 دقيقة». A delay is said before the customer has to ask.
- **Apologies:** once, concrete, only when the fault is ours, together with the remedy (a refund, a credit). When it is not our fault, explain what happened without an empty apology.
- **Humour:** light, in empty states only. Never in errors, money or a late order.

**Writing rules:** the Arabic comma «،» and question mark «؟»; no exclamation marks in system messages; Western digits; a push notification at most about 60 characters with the fact first. Avoid «بنجاح» (the message itself says it worked), «يرجى» (use the verbal noun) and «خطأ غير معروف».

## 9. Device budgets

Each budget becomes a CI check in D.6 or D.7 (or the slice that first ships the thing it limits), not a line of prose.

**Reference device:** an Android phone with 2 GB of RAM (Galaxy A03 class), common in northern Syria. Minimum Android 7 (Flutter's default today). A real one is tried in L.9.

**Fonts,** subset to Arabic, Latin and punctuation (measured on 2026-11-22 with the three weights of §7):

| Where       | Per weight | Three weights | Budget |
| ----------- | ---------- | ------------- | ------ |
| Full file   | ~255 KB    | ~765 KB       | —      |
| Apps (TTF)  | ~135 KB    | ~405 KB       | 450 KB |
| Web (WOFF2) | ~40 KB     | ~120 KB       | 150 KB |

The owner confirmed on 2026-11-22 that CoFo's licence allows subsetting the fonts and converting them to WOFF2 for the web.

**Images,** resized by the server; the original never reaches the phone:

| Use              | Size         | Budget |
| ---------------- | ------------ | ------ |
| Dish thumbnail   | 400 px, WebP | 30 KB  |
| Dish detail      | 1080 px      | 120 KB |
| Restaurant cover | 16:9         | 80 KB  |

On a weak connection only thumbnails load. While an image loads, its dominant colour fills the slot, never a fake picture.

**Apps:**

- Download at most 30 MB per app (split per ABI).
- Cold start at most 3 seconds on the reference device.
- 60 frames per second; when frames drop on a weak device, motion falls back to the reduced-motion level by itself.
- One motion file at most 50 KB; no Lottie or Rive in V1.

**Weak networks:**

- The first useful screen (the restaurant list) within 5 seconds on simulated slow 3G.
- What was opened before (restaurants, menus, map tiles) is cached and shown at once without a connection, with the offline state (R6).
- An order or a captain action is resent safely after a drop, without duplication.

**Web** (panel and restaurant portal): the JavaScript loaded first at most 350 KB compressed.

## 10. First icon set

FOX DROP's own line icons (architecture §9.4), drawn in D.5 in the Figma file's style: rounded line icons, a stroke of about 2 at 24, round caps and joins, blue by default and ivory inside an orange circle when active. The first batch is **44 icons**:

| Group                  | Icons                                                                                     |
| ---------------------- | ----------------------------------------------------------------------------------------- |
| Navigation (10)        | Home, search, cart, orders, account, settings, back (mirrors in RTL), close, more, filter |
| Actions (9)            | Add, remove, delete, edit, confirm, retry, share, camera, image                           |
| States (7)             | Info, warning, error, success, bell, offline, clock                                       |
| Place and delivery (8) | Drop pin, map, route and navigation, motorcycle, car, restaurant, plate, house            |
| Money (5)              | Cash, wallet, discount coupon, receipt, gift                                              |
| Contact and rating (5) | Phone, chat and support, star, heart and favourite, language                              |

**Second batch, later:** the panel's own icons (zones, charts, team and permissions, reports), the restaurant's own (pause orders, printer), and seasonal or promotional icons.

**Until the second batch:** a screen that needs a missing icon waits or uses text. No icon is borrowed from another library (§9.4, R3).
