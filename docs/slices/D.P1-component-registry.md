# D.P1 The component registry, the web-first rule and one card per component

Status: Planned · Tier: T2 · Branch: `feat/component-registry`
Spec: architecture §9.3, §9.6–§9.9 (rewritten here); workflow §1 item 7, §3.1 · Definition of done: the owner decision of 2026-11-25 (web components are the single design reference) is written and checked by a test; the 51 separate «Flutter ·» cards are gone and each component with both sides has one card, the live web component with its Flutter golden beneath.

## Goal

One file names every component once, with its web and Flutter names, the surfaces that use it and the group it sits in, and a test keeps it true. The architecture says the web component is the reference: sheet, then `ui-web`, then `core_ui` copied from it. The owner opens the Design System and sees one card per component: the live, touchable web component, then «Flutter» and its golden underneath; the 17 Flutter-only components keep an image card marked «Web twin pending» until D.P3 to D.P6 build them.

## Plan

1. Docs: architecture §9.6–§9.9 and §9.3 (the web component is the reference; "same design" means the same anatomy, sizes, states, colours, copy and API names, with the platform's own behaviour written in each component's README; phone-only components; one Design System card per component; the parity check of D.P2); §9.9 step 5 (a missing component is built web first, then Flutter from it); workflow §1 item 7 and §3.1 (web side before Flutter side). The owner's waiver of 2026-11-25: the 17 twins copy the current `core_ui` design and goldens, with no new sheet.
2. Registry: `packages/design-tokens/components.json` replaces `packages/core_ui/design-system/cards.json`. One entry per component: `name` (the web name, the key), `web` (export or null), `flutter` (widget or null), `group` (Actions, Forms, Data, Overlays, Navigation), `surfaces` (customer, captain, restaurant, portal, panel, from the spec sections that use it), `phoneOnly` (no portal or panel surface), `summary`, `golden` (the Flutter card image). `pendingWeb`: the 17 Flutter-only names.
3. `src/design-system-build.ts` reads the registry instead of `cards.json`, and writes no separate Flutter card for a component with a web twin (the Flutter asset group stays as the image store; a pending one keeps its card, retitled). `design_system_cards_test.dart` and its comment point at the registry.
4. `packages/ui-web/scripts/docs.ts`: each preview ends with the Flutter section (the golden from the asset store, by the registry's `golden`); each README gains «Flutter: `<widget>`» and the platform differences line.
5. `packages/design-tokens/design-system/README.md`: the stale «Not synced» line (Flutter widgets "not carried") rewritten.
6. Sync the Design System (`packages/design-tokens/CLAUDE.md` «Sync», without the Guide step) and render each card as the system loads it.

Files (hand-written count, 17): `docs/architecture/09-design-system.md`, `docs/process/development-workflow.md`, `packages/design-tokens/components.json` (new), `packages/core_ui/design-system/cards.json` (removed), `packages/design-tokens/src/design-system-build.ts`, `src/design-system-build.test.ts`, `src/components.test.ts` (new), `packages/design-tokens/design-system/README.md`, `packages/design-tokens/CLAUDE.md`, `packages/core_ui/test/golden/design_system_cards_test.dart` (comment), `packages/ui-web/scripts/docs.ts`, `packages/ui-web/scripts/design-system.ts`, `packages/ui-web/test/design-system.test.ts`, `docs/code/packages/design-tokens.md`, `docs/code/packages/ui-web.md`, `docs/roadmap.md`, this file.

Tests written first (locked in the red phase):

- `src/components.test.ts`: every `ui-web` export in `COMPONENTS` and every public `core_ui` widget has exactly one entry; an entry without a web twin must be in `pendingWeb`; a name in `pendingWeb` that now has a twin fails until removed; every `surfaces` value is known; `phoneOnly` matches `surfaces`.
- The design-system tests: the build reads the registry; a twin's preview carries its golden; no `project/components/Fox*` card for a component with a web twin; a pending one has exactly one card.

## Surfaces: the sources

Each surface is one a spec section cites (CU customer, CA captain, RA restaurant, RA §17 the portal, which has everything an owner can do in the app; AP the panel). Generic controls (Button, Icon, Field, TextField, TextArea, TextLink, PhoneField, DateField, Money, StatusChip, Card, ListRow, AmountsSummary, Dialog) carry all five where each surface has forms, lists and money; DropLoader carries all five because every `Button`'s loading state draws it. Specific ones: CountdownRing CA §8; OrderCard RA §8.2 and RA §17 (read-only); OrderRow CU §12.3; RestaurantCard CU §8.2; DishCard CU §9.3; TrackingSteps CU §11.1; Logo CU §8.2, §9.1; PullToRefresh CU §8.1; SignInHero and CodePreview CU §5.2; CountrySheet CU §5.2.1, CA §5.2, RA §5.2.1; CodeField CU §5.2.2, CA §5.1, RA §5.2.2, RA §17; BottomSheet CU §9.4, CA §8, RA §7.2; BottomNavigation CU §6.1, CA §6.2, RA §6.2; RestaurantBar RA §6.2; Sidebar RA §6.2 (the rail) and AP §7.1; VersionTicket CU §4.2, CA §4.2, RA §4.2; ShopSign (the maintenance sign) CU §4.7, CA §4.8, RA §4.10; TimeField RA §10, RA §17, AP §9.6; Timer CA §9.3, RA §8.2, RA §17, AP §9.2.1; Switch RA §14.3, RA §17, AP §9.1; Select AP §7.2 and the portal's forms; Checkbox CU §5.3, CA §5.2, AP §7.4; RadioGroup CU §5.3, CA §5.2, RA §8.6, RA §17; SearchField CU §8.3, AP §7.2; CountBadge CU §6.1, RA §8.2, AP §7.2; Tabs CU §8.3, RA §8.2, AP §7.4; TopBar CU, CA, AP §7.2; Menu CA §9.1, AP §7.2; Banner CU §6.2, CA §6.3, RA §6.3, RA §17; BannerStack RA §6.3; Skeleton CU §4.5, AP §7.4; EmptyState CU §5.1, AP §7.4; QuantityStepper CU §10.1; ConfirmDialog, DataTable, Drawer, BlockingBanner, Tooltip AP §7.1 to §7.4, §9.4.

**Left out as unclear, for the owner** (adding one later is a registry edit): the portal for ShopSign and Logo (decides whether D.P3 and D.P5 put them in `ui-web/phone`); the panel for CodeField (AP §5.1's authenticator code), OrderCard (the ops room's cards differ), QuantityStepper (AP §9.3.3), Logo and Banner; the captain for TrackingSteps (CA §9.1's four-step bar) and CodePreview, the restaurant for CodePreview; the phone apps for ConfirmDialog (only AP §7.4 specifies it; `FoxConfirmDialog` exists); the portal for DataTable, Sidebar, TopBar and Tabs (RA §17 gives no layout); Skeleton, EmptyState, SearchField, Select, Checkbox and CountBadge on the surfaces no section names. Toaster carries all five with no section naming a toast.

## Decisions while building

- Pending cards sit under the web name (`project/components/DateField/`), not `Fox*`, so the live card replaces each in place; no `Fox*` card remains.
- `flutterParts` (not in the plan) holds the other exported widgets of a component, so the test can require every public widget once: `FoxRadio`, `FoxToaster`, `FoxSkeletonBlock`, `FoxRefreshDrop`.
- The card's group comes from the registry: DropLoader moved from Feedback to Data, Icon from Icons to Actions, Menu and Tooltip from Navigation to Overlays.
- Overlays on a card with its golden (review): the body is the box of fixed overlays, so the toasts stay over the live part; Dialog and ConfirmDialog no longer open by themselves there (the top layer covers the whole card), their golden shows them open.
- `turbo.json`: ui-web's test, build and e2e read the goldens folder and the registry; the design-tokens test reads `core_ui/lib` and ui-web's `bundle.ts` (`scripts/turbo-inputs.test.mjs`).
- Toaster's five surfaces are provisional: no spec names a toast (architecture §22 item 11).
- The ui-web `design-system` script takes `--blobs` too, run after the design-tokens `--blobs` pass.
- The plan cites architecture §9.3 (typography): nothing there changed; the rule went into §9.1, §9.7, §9.8 and §9.9.

## Stopped at

Built and green locally; the Design System sync and the review are next.

## Evidence

- `node scripts/verify.mjs --changed`:
- The published system checked card by card (screenshots outside the repository).
- Review: `reviewer` at medium, short list.

## Before deploying

Nothing.

## To check on staging

Nothing new; the owner opens the Design System.

## Notes for the next session

Surfaces come from the specs (RA, CA, CU, AP sections that use each component); one that is unclear goes to the owner, never guessed. The preview needs the blob ids, so the Flutter section is written by the `--blobs` run. The sync publishes the Design System only: the Guide and the other canvases (the customer screens, the component proposals) are not touched until every D.P slice is done (owner, 2026-11-25). The customer screens (D.11 onward) are paused by the owner (2026-11-25).
