# D.13 Customer screens 3: finding food

Status: Planned · Tier: T2 · Branch: `feat/customer-screens-finding-food`
Spec: architecture §9.5 (R1 to R20; R12 and R13 for photos), §9.9; CU §4.5 (lists first, caching, images, offline), §6.1 (the floating cart button and the active-order bar), §8.1 to §8.4, §9.6 (the heart) · Definition of done: the D.13 line of `docs/roadmap.md`; keeps CU §19 items 7, 8 and 28 (offline browsing) passing

## Goal

Home, its sections and banners, categories, the restaurant cards and lists, search and «لم تجده؟ أخبرنا», styled, with the photos through one `core_ui` image widget. The floating cart button and the active-order bar (deferred from D.10) are drawn and built here, on home and search.

## Screen inventory (§9.9 step 1)

Sizes, R6 states and the cycle as in D.11. Offline here means browsing from the cache (L.1c) with the offline banner.

| Screen                                    | Cites               | Purpose and main action      | States beyond R6                                                                                                                                                                                            | Data and actions                                                  |
| ----------------------------------------- | ------------------- | ---------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------- |
| Home (`home_screen.dart`)                 | CU §7.1, §8.1, §8.2 | Open a restaurant            | The header's location label (opens D.12's picker) and search box; sections in the panel's order, hidden ones absent; banners; a section with no restaurant; cached with fees still loading; pull to refresh | `GET /v1/customer/restaurants` (sections, banners), `/categories` |
| Restaurant card (in every list)           | CU §8.2, Q16, U6    | Open the restaurant          | Open; «مشغول»; «متوقف مؤقتاً»; «مغلق — يفتح {اليوم} {الساعة}» faded and last; «جديد»; «توصيل مجاني»; «تجريبي»; no photo or a poor one; the heart (a guest signs in)                                         | `PUT`/`DELETE /v1/customer/favourites/{id}`                       |
| Category page (`category_screen.dart`)    | CU §8.2             | Open a restaurant            | Open first, closed last; empty                                                                                                                                                                              | `GET /v1/customer/restaurants?category=`                          |
| Banner list (`banner_list_screen.dart`)   | CU §8.1, AP §9.11.2 | Open a restaurant            | A banner's hand-picked list under its title; a code banner opens «أكوادي» (D.17)                                                                                                                            | `GET /v1/customer/restaurants` (banner)                           |
| Search (`search_screen.dart`)             | CU §8.3             | Find a restaurant or an item | Recent searches (10) with «مسح»; typing (debounced); two tabs, restaurants and items with their restaurant and price; closed last; no results with «لم تجده؟ أخبرنا»                                        | `GET /v1/customer/search`                                         |
| «لم تجده؟ أخبرنا» (`suggest_screen.dart`) | CU §8.3             | «إرسال»                      | Name required; sent («شكراً، سنحاول إضافته»)                                                                                                                                                                | `POST /v1/customer/restaurant-suggestions`                        |
| Floating cart button                      | CU §6.1             | Open the cart                | Hidden while the cart is empty; the count and the items value                                                                                                                                               | The local cart                                                    |
| Active-order bar                          | CU §6.1             | Open the order               | One order «طلبك من {المطعم}: {الحالة}»; several (count, opens a list); above the bottom bar                                                                                                                 | `GET /v1/customer/orders/active`, the live feed                   |

## Plan

0. Inventory check against `apps/customer/lib/src/browsing/`, `search/` and `home_screen.dart`.
1. Draw, prototype, analysis, missing components (expected: the image widget's frames per aspect ratio, the category tile, the banner carousel, the section header, the floating cart button, the active-order bar), designer pass, approval: §9.9 steps 2 to 7, as D.11 set up.
2. **R13:** one `core_ui` image widget (fixed aspect ratios, the fallback for a missing or poor photo, requested at the shown size, cached) replacing `media_image.dart`; a `fox_lints` rule refusing `Image.network` outside `core_ui`; the backlog item «Photo ratios as tokens» closed with it.
3. **R12:** the profile run scrolls home and a long category on the 2 GB emulator and holds 60 fps; the result recorded here.
4. Code on `core_ui`; the cart button and the bar in the D.11 frame's slots; the backlog item «One money format everywhere» for the amounts these screens show; the folders join the lint; goldens and the comparison with the drawing.
5. Store review (R18): nothing new expected; record it.

Tests written first (locked in the red phase):

- R11 for every screen and the two new components.
- R14: «إرسال» of the suggestion and the heart cannot send twice.
- R15: a banner opens its target; the bar opens the order; Android back from search and a category.
- The image widget's goldens: each ratio, a missing photo, a failed load; the lint rule's tests.
- Cached browsing in airplane mode still opens home and a category.

## Stopped at

Planned (2026-11-24); after D.12.

## Evidence

- `node scripts/verify.mjs --changed`: —
- Drawings, prototype and analysis: the screens canvas
- R12 profile run: —
- Review: —

## Before deploying

A new customer build.

## To check on staging

The owner reorders a home section in the panel and the home follows, opens a banner and a category, searches for an item, sends «لم تجده؟ أخبرنا», browses in airplane mode.

## Notes for the next session

—
