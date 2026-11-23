# apps/merchant-portal

> Moved here from `apps/merchant-portal/CLAUDE.md` on 2026-11-20 (`docs/archive/claude-code-workflow.md`). In these notes, a folder's `CLAUDE.md` (or "its `CLAUDE.md`") means that folder's file under `docs/code/` when there is one, otherwise the folder's own `CLAUDE.md`; the folder's own `CLAUDE.md` now holds only the rules for working there.

The owner web portal «بوابة المطعم» (architecture §10.4, RA §17): the same stack and rules as the admin panel, in `.claude/rules/web-apps.md` (the API through `api` only, same origin, the feature and page pairs, Arabic and right to left, no styling until the design).
It calls the `merchant` route group, serves on port 5174 in development and previews on 4174 for its smoke test.

## Rules

- **Session (RA §5.2–5.3, S14; slice 2.45a):** owners only, by phone and WhatsApp code with no App Check (owner decision 2026-11-20).
  `session.ts`: `sessionQuery` reads `GET /v1/merchant/auth/portal/session` (null on 401; the cookie is HTTP-only), `useRequestCode` and `useSignIn` send the browser's id (`browserId`, kept in `localStorage` when the browser allows it, else one per page load), `phoneOf` takes what an owner types (`09…`, `9…`, `00…`, `+…`) to E.164, and each refusal of RA §5.2 has its sentence (`signIn.refusal.*`; `not_registered` and `unavailable` show the team's call and WhatsApp buttons from `GET /v1/merchant/contact`, `unavailable` also «لديّ رمز من العمليات»).
  Every page but `/sign-in` sits under the `signed-in` route, whose `beforeLoad` sends a request without a session to `/sign-in`.
  A 401 from any route outside `/v1/merchant/auth/portal/` means the session ended: `api.ts` clears the cache and opens `/sign-in`.
- **Translations' types:** never pass `t` to a helper as a parameter (`ReturnType<typeof useTranslation>['t']`): with `ar.json`'s typed keys it reaches TypeScript's instantiation limit (`TS2589`) as the file grows.
  Write a hook that calls `useTranslation()` and returns the function (`useChangeText`, `useDecidedBy`, `useWithin`), as the panel does.
- **Only the routes the server opens to the portal** (`@AppSignedIn({ portal: true })`, the server's `merchant-portal.test.ts`);
  any other answers `403 not_in_portal`.
  A new screen opens its routes on the server in the same slice.
- **The live orders (RA §17, §8.1–8.2):** `/orders` (`board.ts`, `board-page.tsx`) reads `GET /v1/merchant/orders` and shows the four columns with their counts and late counts, RA §8.2's sorting, the captain line (`captainLine`), the column's timer (`timerOf`) on the server's clock and the badges, with the banner «لاستقبال الطلبات استخدم تطبيق أندرويد أو ويندوز»: no sound and no button on an order.
  A delivered order within its dispute window and an order cancelled until «حسناً» are left out (`columnOf`), since both wait for actions the portal has none of.
  `/orders/$orderId` (`order-page.tsx`) reads the order with the owner's money lines and its steps.
- **Real time (`live.ts`):** the layout connects to Centrifugo on the portal's own origin (`/connection/websocket`, the token from `POST /v1/merchant/realtime/token` with the cookie) and follows `merchant:{restaurantId}`;
  each publication invalidates what it changed (`staleKeys`) and every (re)subscription reads everything again.
  While the channel is down the board reads every 30 s (`FALLBACK_POLL_MS`, RA §4.3).
  The server counts receiving devices from app sessions only, so the portal never counts as one (RA §4.6).
- **Status (RA §7.1–7.3, §10):** `/status` (`status.ts`, `status-page.tsx`) shows the state in the app's words (`stateLabel`), pause («إيقاف {د} د», «حتى أعيد الفتح»), resume, busy mode and the holiday close (from, to and the customers' message, or «إنهاء الإغلاق»), as `controlsOf` allows: operations' pause and the auto-pause hold the buttons with «أوقفت العمليات مطعمك — اتصل بهم لإعادة التشغيل».
  Each command answers the status, which replaces the read;
  a refusal reads it again and says the state changed.
  A terminated restaurant's owners (RA §5.5) see one sentence and the money section only (the status answers `restaurant_terminated`, and the channel stops asking for a token).
- **Times:** shown and typed on the restaurant's city clock, the session's `timeZone` (`TimeZoneContext`; `formatTime`, `formatDateTime`, `zonedToUtc` in `format.ts`), never the browser's;
  countdowns on the server's clock (`clock.ts`).
- **Terms (RA §4.10, S13):** the layout shows the pending terms' banner;
  `/terms` shows the version in force with «أوافق على الشروط وسياسة الخصوصية» (`409` reads the newer version);
  until accepted, every screen but «الطلبات» and the terms shows the terms instead (`AfterTerms` in `router.tsx`).
- **The menu (RA §9, §5.4, §17; slice 2.45b):** `/menu` (`menu.ts`, `menu-page.tsx`, `menu-forms.tsx`) is the restaurant app's owner menu on the same routes (`GET /v1/merchant/menu` and the owners' commands, each answering the menu, which replaces the read; `useMenuCommand`): each category, item and option with its own switch (`AvailabilityControl`: «إيقاف حتى الغد» first, «إيقاف حتى أعيده», «تشغيل»; its answer is only the switch, so the menu is read again), «غير متوفر للزبائن», «مخفي عن الزبائن» and the window;
  «تعديل السعر» (`PriceForm`, the price in major units, `priceOf`: above 0, a delta 0 or more, always with «تذكير: سعر التطبيق يجب ألا يزيد على سعر المحل»), «إخفاء»/«إظهار», up and down (`moved`, the published rows only), «فترة التوفر» (`windowOf`: two different times of the city's day, 00:00 as the end is midnight), and the change requests (RA §9.2, §9.5): each row's `pending` with what it asks and «سحب الطلب», «إضافة تصنيف», «إضافة صنف» (with its price and photo), «تعديل الاسم والوصف», «تغيير الصورة», «إضافة مجموعة خيارات» and «تعديل المجموعة» (`groupFormOf` starts from the pending values, since sending the published value withdraws a request; a published option's delta stays read only).
  A new row's id is made once per form (`crypto.randomUUID`), so a request sent again changes the same row, and none takes a key, as in the app.
  Each form is keyed by what it edits (`editingKey`), so opening another starts it afresh and a price typed for one row never reaches another.
  The photo (`usePhotoUpload`, once per chosen file: a request sent again reuses its upload unless refused for it) is asked from `POST /v1/merchant/uploads/item-photo`, which signs it for the portal's own origin, and PUT to `/public-media/incoming/` there (nginx, and Vite in development, forward it), then linked by its request;
  photos show through imgproxy under `/media` (`mediaUrl`).
  `/menu/quick-edit` («تعديل سريع», `quickRows`: search by name, filter by category, an option shared by several items once), `/menu/bulk-price` («تعديل جماعي للأسعار»: a category or the whole menu, a percentage in basis points or an amount, «معاينة قبل وبعد», then «تأكيد التعديل», which sends the change previewed and is off while a price would reach 0 or after the form changed; one `Idempotency-Key` per change until it is answered, `useApplyBulk`), `/menu/price-log` («سجل الأسعار», the user's name or «FOX DROP») and `/menu/preview` («معاينة كما يراها الزبون»).
  A `restaurant.state_changed` of a menu kind (`MENU_KINDS`: `menu_changed`, an admin's price change, a review's decision) reads the menu, the log and the preview again (`staleKeys`).
  Refusals in the app's words (`refusalKey`).
  Tested by `menu.test.ts` and the smoke test «changes an item price from the portal».
- **Settings (RA §10, §14.3, §17; slice 2.45c):** `/settings` («الأوقات والإعدادات», `settings.ts`, `settings-page.tsx`) is the app's «الحالة والأوقات» and «الإعدادات» on the same routes: the weekly schedule (`weekOf`, `withPeriod`, `withoutPeriod`, `withChange`, `scheduleOf`: each weekday Saturday first, `<input type="time">` on the city's clock, the server checking overlaps and the 30 minutes), the default prep time within the chooser and the limit off or 1 to 50 (`orderSettingsOf`), what FOX DROP sets (minimum order, coverage, commission, settlement day) with «طلب تعديل» opening `/support?report=data_change`, and the pickup currencies (`switchedCurrencies`);
  each save answers its read, which replaces it, and the hours read again on any `restaurant.state_changed` but the menu's (`staleKeys`).
  The holiday close stays on «الحالة».
  Tested by `settings.test.ts`.
- **Staff and devices (RA §14.1–14.2, §4.3, §17; slice 2.45c):** `/staff` («الموظفون», `team.ts`, `team-page.tsx`): owners read only, a cashier added by name and number (`phoneOf`) and removed after a confirmation.
  `/devices` («الأجهزة»): each app installation with its user, platform, version, ringing, connection or last sighting and device check, renamed or signed out (the user stays), the banner «لا يوجد جهاز يستقبل الطلبات في مطعمك الآن» (`withoutDevice`), «ربط كمبيوتر بويندوز» (`usePairWindows`: the 8-digit code shown once with its end, never cached), and the portal's own sessions (owner decision 2026-11-20, `GET /v1/merchant/portal-sessions`): each browser by its user agent (`browserOf`), owner and sign-in time, «هذا المتصفح» for the session's own, «تسجيل خروج المتصفح» after a confirmation for the others.
  Each command answers its list (`useTeamCommand`);
  a refusal reads it again.
  The devices are read every 30 s while the page is open (connected or last seen moves on its own), and every (re)subscription reads the devices, the portal sessions and the pickup currencies again.
  Tested by `team.test.ts` and the smoke test «pairs a Windows PC and signs another browser out from the portal».
- **Support (RA §15, §17; slice 2.45c):** `/support` («الدعم», `support.ts`, `support-page.tsx`): the team's call and WhatsApp, «إبلاغ عن مشكلة» (Content's `merchant_ticket_type`, «طلب تعديل بيانات» with its subject, an optional order of the board, a note, which «أخرى» requires, and a photo: `usePhotoUpload('report')`, signed for the portal's origin under `/private-docs/incoming/`; one `Idempotency-Key` per report until answered, `useSendReport`), «استلمنا بلاغك T-{رقم}. سنرد عليك خلال …», «بلاغاتي» (every ticket of the restaurant with its status, subject, order, who opened it and the reply) and the FAQ.
  «مشكلة في الطلب» on an order stays the app's.
  `ContactLinks` (`contact-links.tsx`) puts «اتصال بالعمليات» and «واتساب العمليات» in the top bar and on every order («بخصوص الطلب #{رقم}» prefilled), RA §15. Tested by `support.test.ts`.
- **Periods (RA §11, §13, §17; slice 2.45d, owner decision 2026-11-20):** `period.ts`, `period-picker.tsx`: the reports' periods as buttons and «فترة مخصّصة» with two days (`rangeProblem`: real days, the last not before the first, at most `RANGE_MAX_DAYS`, 366; the server also refuses one ending after today, `invalid_period`), sent as `period` or `from` and `to` (`periodQuery`).
- **Reports (RA §11, §17):** `/reports` («التقارير», `reports.ts`, `reports-page.tsx`) reads `GET /v1/merchant/figures` for a period or a custom range: RA §11's table row by row (`METRICS`, the rating's count and the pause minutes by source included) with the previous period of the same length and the app's arrows (`changeOf`: money compared as integers of minor units), each metric's definition under its name (`<details>`), then the period's rejections, top items and delivered orders by hour (the lists, without a comparison).
  The daily summary image stays the app's (the system share sheet).
- **Excel (owner decision 2026-11-20: built on the server):** `exports.ts`, `export-button.tsx`: «تصدير Excel» posts `POST /v1/merchant/exports/{report|order-history|statement}` (one `Idempotency-Key` per ask until answered, `useRequestExport`), reads `GET /v1/merchant/exports/{exportId}` every 2 s while pending (`useExportState`, giving up after 10 minutes, judged at the last read), then «تنزيل» asks `download=true` at the click and opens the URL signed for the portal's own origin (`/private-docs/exports/`, nginx and Vite forward it).
  The button is keyed by its ask (`askKey`), so another period or statement starts afresh;
  a wait given up can be asked again.
  The file's words are `excel` in `ar.json`, equal to the server's `merchantExportLabels` (its `export-labels.test.ts`);
  the portal shows the same words where it can (the history's columns and statuses, the statement's statuses).
- **«السجل» (RA §8.18, §17):** `/history` (`history.ts`, `history-page.tsx`) reads `GET /v1/merchant/orders/history` by pages (`useInfiniteQuery`, `next`): the range (none: today and the 7 days before), the status, the number (`numberOf`, with or without «#»);
  each order opens `/orders/$orderId`;
  «تصدير Excel» exports the range read with the filters.
- **«التقييمات» (RA §13, §17):** `/ratings` (`ratings.ts`, `ratings-page.tsx`) reads `GET /v1/merchant/ratings`: «الكل» and the periods or a custom range, the stars filter, the summary and distribution, then the ratings by pages with the first page's `asOf`;
  never the customer or the order.
- **The money section (RA §12, §5.5, §17):** `/account`, `/statements`, `/statements/$statementId`, `/receipts`, `/receipts/$receiptId` (`account.ts`, `money-page.tsx`) are the app's «الحساب», «الكشوف» and «الإيصالات» on the same routes, read on opening: the balance, «موعد التسوية», the overdue line, the commission and its change, today's pickups, the week by business day (`weekByDay`), each exception with its cause and «من قرّر»;
  the statement with «طباعة / حفظ PDF» (the browser's print; `data-print="hide"` and the one print rule in `index.html` leave out the bar and the buttons; the layout waits for the design) and «تصدير Excel»;
  each receipt with the safety note.
  The layout shows the amber «لديك مبلغ متأخر…» (`GET /v1/merchant/account/overdue`).
  A terminated restaurant's owners (the status answers `restaurant_terminated`) see the sentence, the money links only and the money pages (`isMoneyPath` in `layout-page.tsx`), read only.
  Tested by `records.test.ts` and the smoke test «opens the statement, prints it and exports it to Excel».
- **Not yet:** «لدي استفسار» on an entry or a statement (RA §12.2; the app has none either);
  a report's order is picked from the live board only (RA §15);
  the statement's PDF layout (the design);
  «تحددها FOX DROP» lacks the contract dates and RA §14.3's restaurant info (name, logo, address, phone, category), as the app's: no route answers them yet (to ask the owner).
