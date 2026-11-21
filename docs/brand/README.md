# FOX DROP brand

The visual identity pack (V1.1, 2026-11-21) under professional names, and the brand rules the design system (architecture §9) builds on. The pack's own guidelines are in `guidelines/`; where this file and a board differ, the board wins.

## Colours

| Colour       | HEX       | Share | Use                              |
| ------------ | --------- | ----- | -------------------------------- |
| Warm ivory   | `#FFFAED` | 60%   | Main backgrounds                 |
| Coral orange | `#FF6E31` | 30%   | The brand, the app icon, accents |
| Royal blue   | `#03428E` | 10%   | Headings, supporting elements    |

`#FF6E31` fails contrast on ivory (2.68:1) and under white text (2.79:1). It is the brand colour, not the text or button colour: a darker accessible orange is chosen in D.2 (architecture §9.2). Blue on ivory is 9.27:1.

## Logo rules (boards 01 to 03)

- Use the ready lockups in `logo/lockups/`: never change the order of the mark and the name, or the space between them. Arabic lockups for Arabic screens, Latin for English.
- Minimum size: the mark alone 24 px, the horizontal lockup 120 px wide.
- Keep the clear space on every side shown on board 03.
- Never rotate, stretch, shadow or recolour the logo. Use it on backgrounds that give enough contrast.
- The official app icon is the white fox on the orange background; the other versions are visual alternatives.

## Files

| Folder              | What                                                                                                                                                                                                                                                                                               |
| ------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `logo/lockups/`     | The four primary lockups (horizontal and vertical, Latin and Arabic), SVG and PNG.                                                                                                                                                                                                                 |
| `logo/mark/`        | The fox mark alone, SVG. Names say the colours: `ivory-on-orange-square` is an ivory fox on an orange square; `-drop` files carry the drop-shaped backing; plain `orange`, `ivory` and `blue` are the fox alone, transparent. Read from the files' fills and structure, not from the pack's notes. |
| `app-icon/ios/`     | iOS icons, 4267 px. `ios-primary-ivory-fox-on-orange.png` is the main one.                                                                                                                                                                                                                         |
| `app-icon/android/` | Android icons, 4267 px. `android-primary-white-fox-on-orange.png` is the main one. The adaptive icon stays as it is until it is seen on a device.                                                                                                                                                  |
| `app-icon/svg/`     | The icon SVGs. `broken-edges-1..3` came with that name in the pack and nobody has checked what they are for.                                                                                                                                                                                       |
| `guidelines/`       | The three boards: primary lockups, colours and typeface; horizontal and vertical lockups; clear space and minimum size.                                                                                                                                                                            |

`variant-b` and `variant-c` icons are alternatives the owner has not named yet. The ten 8961 px PNGs of the mark were left out (5 MB); the SVGs render them at any size.

## Fonts (private)

The typefaces are licensed, so the font files are **not in this repository**, and a test fails if one is committed (`scripts/fonts.test.mjs`; `.fonts/` is ignored).

- CoFo Sans Pro Arabic (UI, seven weights), YR-Speed (display), Emad-Diana (secondary). The guidelines name HTQaysSansPro, which the pack does not contain.
- The files live in the private repository `HussienALfajer/fox-drop-fonts`. `fonts-manifest.json` pins its commit and the SHA-256 of every file.
- `pnpm fonts:fetch` copies them into `.fonts/` and checks them against the manifest. Locally it uses your git sign-in (`gh auth setup-git`); in CI, the `FONTS_REPO_TOKEN` secret, a fine-grained token with `Contents: Read-only` on that repository only. The builds that bundle the fonts (D.6 web, D.7 Flutter) run it first.
- To change a font: commit it to the private repository, then update `ref` and the hashes in the manifest in a pull request here.
