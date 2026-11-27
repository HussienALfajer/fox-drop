# D.S1 Customer starting screen

Status: Planned · Tier: T2 · Branch: `feat/customer-starting-screen` (D.S1a), `feat/customer-starting-screen-app` (D.S1b)
Spec: CU §4.2, §4.5, §4.7, §5.1, §6.2, §7.1; architecture §9.5 (R6, R11), §9.9 (T16), T14; brand expression §2, §3, budgets · Definition of done: CU §19 items 27 and 28 in part (the start never hides an active order and works with no internet); none closed alone.

## Goal

The first screen of the screen-first cycle (T16): the customer app opens on the approved FOX DROP splash, plays it in full on the first launch and as one pulse on later launches, and opens onto whatever screen the router chooses (home, first location, the blocking screen, a deep link) with the ivory circle, without ever waiting on the network.

## Owner decisions (2026-11-28, planning)

1. **The design is D.11's approved splash, exactly** (customer screens canvas, the boards «شاشة البدء وحدها» and «شاشة البدء · كل الحالات والرسائل» as of version 53; the owner's hand-off doc and its moving reference no longer open, so the canvas version is the reference). Its departures from the brand rules stay allowed for this screen only and are written into `docs/brand/expression.md` §3 as a named exception: a third signature moment with squash and overshoot, the haptic at the landing, the Latin-only name. The 2026-11-24 departures that no longer apply: Rive (decision 4), the ivory retry button (decision 2), the shadow (drawn in `color.info` at 38%, a token).
2. **It waits only for the stored session**, read on the device (`core_auth`: an unreadable value starts signed out), as today. The update, maintenance and terms checks run in the background (`core_platform`: a failed check never locks the app). So D.11's «جارٍ الاتصال…» and «لا يوجد اتصال بالإنترنت» with «إعادة المحاولة» are dropped; the breathing wait loop stays, for a session read slower than the scene.
3. **How long it shows:** the first launch after install plays the whole scene (fall, landing, the name written) and a tap skips it; every later cold launch plays the one-pulse «warm launch» without the name. A launch back from the background shows no splash.
4. **Motion in code, not Rive:** the scene is drawn in code on both sides from one component token file (timings, sizes, colours), within the 50 KB and 60 fps budgets; no new animation library.
5. **Shared later, customer now:** only the customer app uses it in this slice; the component lives in `ui-web` and `core_ui`, so the captain and restaurant apps can take it when their own starting screens are drawn.
6. **Web first (T14):** the scene has a `ui-web` version on the same tokens, so its board on "Fox Drop Components" is generated from code and its Flutter twin is checked on a parity sheet.
7. **Exit:** the ivory circle opens onto the next screen. The mark's flight to home's lockup waits for the home screen's slice, when the lockup's place is approved; until then no flight.
8. **The system launch screen** (Android 12+ `windowSplashScreen`, older Android `launch_background`, iOS `LaunchScreen.storyboard`) is the scene's first frame: the orange ground, with a transparent icon on Android 12+, so the scene starts without a visible jump.
9. **The designer's approval waits for the Figma slices** (roadmap «Figma», owner decision 2026-11-24): the drawing is approved by the owner now; the Figma slices are planned and built next; the designer approves through Figma before D.S1a's code starts.

## Screen inventory (§9.9 step 1)

Sizes: an Arabic phone at 360 × 640 and 412 × 915, both also at 130% text (the name and its semantics label only; the scene does not reflow). Light only (CU §17).

| State                                           | Cause                                                                                       | What it shows                                                                                                        |
| ----------------------------------------------- | ------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- |
| First launch                                    | No first-launch mark stored on the device                                                   | The whole scene as drawn (appear, fall, land with two rings, shadow and the ears' twitch, haptic, the name written)  |
| Later launch («warm launch» of D.11)            | The first-launch mark is stored                                                             | One pulse of the mark, no name                                                                                       |
| Waiting                                         | The session is not read when the scene ends                                                 | The breathing loop (one ring every 1.2 s) until it is read; no text                                                  |
| Skipped                                         | A tap during the first-launch scene                                                         | Jumps to the exit                                                                                                    |
| Reduced motion                                  | The system setting, or frames dropping on a weak phone (expression, budgets)                | The still frame, no haptic; the exit is a fade                                                                       |
| Exit                                            | Scene done and session read                                                                 | The ivory circle opens onto the router's next screen                                                                 |
| R6 loading                                      | —                                                                                           | The screen is the app's loading state itself; no skeleton                                                            |
| R6 empty, partial                               | —                                                                                           | Not applicable: the screen shows no data                                                                             |
| R6 error                                        | The stored session cannot be read                                                           | Nothing different: `core_auth` starts signed out and the exit goes on (a guest lands on home, CU §5.1)               |
| R6 offline                                      | No internet                                                                                 | Nothing different: the splash does not use the network (decision 2); the next screen shows the offline bar (CU §4.5) |
| After it: blocking update or maintenance        | `GET /v1/customer/platform` answers `updateNeed: required` or `maintenance` (CU §4.2, §4.7) | The exit opens onto `/blocked` (its styled screen is its own later slice); an order's screen stays reachable         |
| After it: first location                        | No delivery point chosen yet (CU §7.1)                                                      | The exit opens onto the first-location screen                                                                        |
| After it: a deep link or a push                 | `from` on `/starting` (a push opening an order, a shared link)                              | The exit opens onto it                                                                                               |
| After it: platform hours, emergency stop, terms | `GET platform` hours, the stop, a new terms version (CU §4.7, §6.2)                         | Nothing on the splash; banners and the terms prompt on the next screen                                               |

Data and actions: no route is called by the screen. The router reads the stored session (`customerAuth.session`), the platform check (`platformCheckProvider`, started with the app) and the profile; the first-launch mark is a local flag.

## Analysis (§9.9 step 4, filled at the design checkpoint)

- (a) Routes: `GET /v1/customer/platform` (`updateNeed`, `minVersion`, `updateMessage`, `maintenance`, `maintenanceMessage`, the return time, `hours`): none shown on the splash; `updateNeed`/`maintenance` drive the exit to `/blocked`, the rest are shown by the banners and the blocking screen. No error code is shown: a failed read keeps `PlatformStatus.clear` and retries.
- (b) API gaps: none known.
- (c) Spec gaps: CU §6.1's screen map does not list the starting screen; add it with D.S1a.
- (d) Improvements for Azaz, each with its cost, for the owner at the checkpoint.
- (e) New components: `SplashScene` (the scene, its states as props: `first`, `pulse`, `waiting`, `still`, `exit`) and its tokens `splash.json`; the brand mark drawn from `docs/brand/logo/mark/`.

## Plan

0. **Design checkpoint** (in D.S1a's session, before any code; T16):
   1. Restore the splash boards from customer screens canvas version 53 into the current canvas (server-side copy with `{artifact, path, ver}`); remove the slow and offline states and the retry button (decision 2) and the flight (decision 7); keep the state switcher outside the frame: first, later, waiting, skipped, reduced motion.
   2. Draw `SplashScene` on «المكوّنات المقترحة» of "Fox Drop Components" with all its states.
   3. Check the drawing for literal colours, unknown token names and hand-drawn copies; write the result here.
   4. Fill the analysis above; the owner approves in Play (step 5).
   5. **Stop:** the designer's approval through Figma (step 6), after the Figma slices merge. Edits read back become token changes or are declined; the designer approves. Then D.S1a's code.
1. **D.S1a, web side** (one pull request, after step 0): `splash.json` component tokens; `SplashScene` in `ui-web` with every state, RTL, reduced motion, its stories and tests; synced, and its generated board compared with the approved drawing; the brand exception in `expression.md`; CU §6.1 lists the starting screen.
2. **D.S1b, Flutter and the screen** (one pull request, after D.S1a): the `core_ui` twin on the same tokens, its widgetbook case, goldens and parity sheet (`pnpm parity`, gaps fixed on the side the drawing says); the customer `StartingScreen` on it, the first-launch flag, the router's exit (the ivory circle, a fade under reduced motion), the haptic at the landing; the system launch screens; the screen's goldens and its screenshot compared with the drawing; step 9, the boards moved to «المكوّنات المعتمدة».

Files (hand-written count), D.S1a, 12:

- Tokens: `packages/design-tokens/tokens/component/splash.json` (new), `packages/design-tokens/tokens/semantic/base.json` (only if a motion primitive is missing).
- Web: `packages/ui-web/src/splash-scene/splash-scene.tsx`, `splash-scene.css`, `splash-scene.stories.tsx`, `splash-scene.test.tsx` (new), `packages/ui-web/src/index.ts`.
- Docs: `docs/brand/expression.md` (the exception), `docs/product/v1/customer-app/06-navigation.md` (§6.1), `docs/code/packages/ui-web.md`, `docs/roadmap.md`, this file.

Files (hand-written count), D.S1b, 22:

- `core_ui`: `packages/core_ui/lib/src/splash/splash_scene.dart`, `splash_painter.dart` (new), `packages/core_ui/lib/core_ui.dart`, its widgetbook use case, `packages/core_ui/test/splash_scene_test.dart` (new), the parity case.
- Customer app: `apps/customer/lib/src/starting_screen.dart`, `router.dart`, `first_launch.dart` (new), `apps/customer/test/starting_screen_test.dart` (new); Android `res/values/styles.xml`, `res/values-night/styles.xml`, `res/values-v31/styles.xml` (new), `res/drawable/launch_background.xml`, `res/drawable-v21/launch_background.xml`; iOS `Runner/Base.lproj/LaunchScreen.storyboard` and its launch colour set.
- Strings: the scene's semantics label in `packages/core_l10n` (Arabic ARB).
- Docs: `docs/code/packages/core_ui.md`, `docs/code/apps/customer.md`, `docs/roadmap.md`, this file.

Tests written first (locked in the red phase):

- D.S1a `splash-scene.test.tsx`: each state renders its frame; reduced motion renders the still frame and no animation; `first` calls `onDone` after the scene and at once on a tap; `pulse` shows no name; the timings come from the tokens.
- D.S1b `splash_scene_test.dart`: the same states, goldens of each frame at 360 × 640 and 412 × 915, 130% text, the semantics label; reduced motion still.
- D.S1b `starting_screen_test.dart`: the first launch plays the full scene and stores the flag, the next launch plays the pulse; a tap skips; a slow session read shows the waiting loop and exits once read; no network call is waited on (offline, the exit still happens); the exit goes to `/blocked` when the platform blocks, to an order's screen through `from`, to first location with no point, to home for a guest; a launch back from the background shows no splash.

## Stopped at

Planned 2026-11-28; the design checkpoint is next (step 0).

## Evidence

- `node scripts/verify.mjs --changed`: <summary line>
- Screenshots or recordings (outside the repository): <where>
- Review: <reviewer findings fixed; deferred to the backlog>

## Before deploying

App rebuilds only (no server change).

## To check on staging

After D.S1b: install the customer app fresh and open it (the full scene, a tap skips), close and open it again (one pulse), turn on reduced motion (still frame), open with the internet off (it still opens).

## Notes for the next session

- The Figma slices (roadmap «Figma») are planned in their own `/slice-plan` session after the owner approves this drawing; D.S1a's code waits for them and the designer.
- Customer screens canvas version 53 is the reference; versions 50 and later hold the flight that decision 7 defers to the home screen's slice.
