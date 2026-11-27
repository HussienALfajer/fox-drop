# FOX DROP brand

The visual identity pack (V1.1, 2026-11-21) under professional names, and the brand rules the design system (architecture §9) builds on. The pack's own boards are in `guidelines/`; where this file and a board differ, the board wins.

| Document                         | What it decides                                                                                                                       |
| -------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| This file                        | The pack: colours, logo rules, every file and what it is, the private fonts                                                           |
| [`expression.md`](expression.md) | The brand's character (D.1b): principles, shape, motion, map, illustration, palette, Arabic type, voice, device budgets, icons        |
| [`directions.md`](directions.md) | The design direction (D.3, T12): what the Figma file "Fox Drop" holds, its measurements into the tokens, the owner's per-screen calls |

## Colours

| Colour       | HEX       | Share | Use                              |
| ------------ | --------- | ----- | -------------------------------- |
| Warm ivory   | `#FFFAED` | 60%   | Main backgrounds                 |
| Coral orange | `#FF6E31` | 30%   | The brand, the app icon, accents |
| Royal blue   | `#03428E` | 10%   | Headings, supporting elements    |

In the apps the owner adopted the Figma file's use of these colours (2026-11-23, `directions.md`): the ground is a warmer ivory `#FBF2E7` with raised cards `#FEFEFE`; text, prices, numbers and headings are blue by default (8.72:1; headings since 2026-11-25, as the identity package V1.1 sets them); the orange carries buttons and bars in every app, and the owner allowed it anywhere else too, text and numbers included (2026-11-23). `#FF6E31` misses 4.5:1 (2.52:1 on the ground, 2.68:1 under ivory text): the owner accepts this as a named exception to the contrast rule (architecture §9.5 R4), limited to the orange tokens by a test. The accessible orange `#C2410C` of D.2 is retired. The values live in `packages/design-tokens`; this table is the pack's, not a second source.

## Logo rules (boards 01 to 03)

- Use the ready lockups in `logo/lockups/`: never change the order of the mark and the name, or the space between them. Arabic lockups for Arabic screens, Latin for English.
- Minimum size: the mark alone 24 px, the horizontal lockup 120 px wide.
- Keep the clear space `X` that board 03 marks on every side of the lockup.
- Never rotate, stretch, shadow or recolour the logo. Use it on backgrounds that give enough contrast.
- The official app icon is the white fox on the orange background.

## Files

Every name says what the file shows, read from its fills and pixels, not from the pack's own notes.

| Folder                | What                                                                                                                                                                                                                                                                                                 |
| --------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `guidelines/`         | The pack's three boards (1920 × 960): `01` the primary lockups, the three colours and the typeface; `02` the horizontal and vertical lockups in English and Arabic; `03` the wordmark, the approved lockups, the clear space, the minimum sizes and three forbidden uses (rotate, stretch, shadow).  |
| `logo/lockups/`       | The four primary lockups (horizontal and vertical, Latin and Arabic): the orange mark beside the blue name, SVG and PNG.                                                                                                                                                                             |
| `logo/mark/`          | The fox mark alone, SVG, ten files: `mark-orange`, `mark-ivory`, `mark-blue` are the fox alone on a transparent ground; `mark-<fox>-on-<backing>-square` and `-drop` put it on a square or on the drop-shaped backing (`ivory-on-orange-square` is an ivory fox on an orange square).                |
| `app-icon/svg/`       | The app icon, SVG at 1024: `app-icon-white-fox-on-orange` (the official one), `app-icon-black-fox-on-ivory` and `app-icon-ivory-fox-on-black` (single-colour versions), each `-square` (the stores round it) and `-rounded` (corners of about 10%; the pack named these three «broken edges»).       |
| `app-icon/ios/`       | iOS PNGs, 4267 px, square (iOS rounds them): `ios-primary-white-fox-on-orange.png` is the one to ship; `ios-black-fox-on-ivory.png` and `ios-ivory-fox-on-black.png` are the single-colour versions.                                                                                                 |
| `app-icon/android/`   | Android PNGs, 4267 px, with rounded corners on a transparent ground: `android-primary-white-fox-on-orange.png` is the one to ship, and the two single-colour versions as on iOS. The adaptive icon's layers are made from the SVGs when the apps' launcher icons are built, and checked on a device. |
| `fonts-manifest.json` | The private font repository's commit and the SHA-256 of each of the nine font files (below).                                                                                                                                                                                                         |

The single-colour versions use black (`#000000`), which is not a brand colour; what they are for (a monochrome source, a dark variant) waits for the owner (`docs/backlog.md`). The ten 8961 px PNGs of the mark were left out (5 MB); the SVGs render them at any size.

## Fonts (private)

The typefaces are licensed, so the font files are **not in this repository**, and a test fails if one is committed in any commit of a pull request (`scripts/fonts.test.mjs`; `.fonts/` is ignored).

- **CoFo Sans Pro Arabic** (seven weights; the UI uses 400, 500 and 700), **YR-Speed** (marketing, outside the apps) and **Emad-Diana** (in the pack, not used in the UI: owner, 2026-11-23). Board 01 names CoFo Sans Pro; HTQaysSansPro, named elsewhere in the pack, is not in it.
- **The ₺ glyph** is in neither CoFo nor Emad-Diana: «Fox Lira» (SIL OFL, owner 2026-11-24, D.9) draws it after CoFo. It is open, so it is committed (`packages/ui-web/fonts/fox-lira/`, `packages/core_ui/assets/fonts/fox-lira/`) and is the one font file the test allows.
- The licensed files live in the private repository `HussienALfajer/fox-drop-fonts`; `fonts-manifest.json` pins its commit and every file's SHA-256.
- `pnpm fonts:fetch` copies them into `.fonts/` and checks them against the manifest. Locally it uses your git sign-in (`gh auth setup-git`); in CI, the `FONTS_DEPLOY_KEY` secret, the private half of a read-only deploy key of that repository (no expiry, that one repository only; set on 2026-11-21). The `format`, `visual` and `golden` CI jobs fetch them; locally Storybook, the goldens, the parity sheet, the components canvas check and `scripts/font-metrics.mjs` read `.fonts/`.
- To set the CI key up again (PowerShell): `ssh-keygen -t ed25519 -N '""' -C fox-drop-fonts-ci -f $env:TEMP\fd_key`; `gh repo deploy-key add $env:TEMP\fd_key.pub --repo HussienALfajer/fox-drop-fonts --title fox-drop-ci` (read-only by default); `Get-Content -Raw $env:TEMP\fd_key | gh secret set FONTS_DEPLOY_KEY --repo HussienALfajer/fox-drop`; then delete both key files. To revoke it, remove the deploy key from the private repository's settings.
- To change a font: commit it to the private repository, then update `ref` and the hashes in the manifest in a pull request here.
