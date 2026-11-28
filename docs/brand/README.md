# FOX DROP brand files

The owner's visual identity pack (V1.1, 2026-11-21): the logo, the app icon and the pack's three boards, under names that say what each file shows.

| Folder              | What                                                                                                                                                                                                                                                     |
| ------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `guidelines/`       | The pack's three boards (1920 × 960): `01` the primary lockups; `02` the horizontal and vertical lockups in English and Arabic; `03` the wordmark, the approved lockups, the clear space, the minimum sizes and three forbidden uses.                    |
| `logo/lockups/`     | The four primary lockups (horizontal and vertical, Latin and Arabic), SVG and PNG.                                                                                                                                                                       |
| `logo/mark/`        | The fox mark alone, SVG, ten files: `mark-orange`, `mark-ivory`, `mark-blue` on a transparent ground; `mark-<mark>-on-<backing>-square` and `-drop` on a square or drop-shaped backing, where the first colour is the mark's (the pin's), not the fox's. |
| `app-icon/svg/`     | The app icon, SVG at 1024: `app-icon-white-fox-on-orange` (the official one), `app-icon-black-fox-on-ivory` and `app-icon-ivory-fox-on-black` (single-colour versions), each `-square` and `-rounded`.                                                   |
| `app-icon/ios/`     | iOS PNGs, 4267 px, square: `ios-primary-white-fox-on-orange.png` is the one to ship, with the two single-colour versions.                                                                                                                                |
| `app-icon/android/` | Android PNGs, 4267 px, rounded on a transparent ground: `android-primary-white-fox-on-orange.png` is the one to ship, with the two single-colour versions. The adaptive icon's layers are made from the SVGs when the launcher icons are built.          |

## The identity

From the owner's pack (V1.1, 2026-11-21); its boards are the reference.

- **Colours:** ivory `#FFFAED` 60% (backgrounds), coral orange `#FF6E31` 30% (the identity and primary buttons), royal blue `#03428E` 10% (headings).
- **Typeface:** CoFo Sans Pro is the primary UI typeface. Its files are licensed and never enter this repository.
- **Logo use:** the four lockups are used unchanged, with their clear space and at least 24 px for the mark and 120 px wide for the horizontal lockup; never rotated, stretched or given effects.
- **App icon:** the official one is the white fox on orange.

## In Figma

The library's «🏷️ Brand» page holds these SVGs as `Core/Brand/…` components (the lockups, the ten marks and the six app icons) with the three boards as reference images; they keep these literal colours and are never restyled (`docs/design/rules.md`, `docs/design/registry.md`).
