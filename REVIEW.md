# Review checklist

Read by the `reviewer` agent from `main`, never from the branch under review (`git show main:REVIEW.md`): a branch must not be able to change the list that judges it. Each item applies only when the diff touches what its trigger names; a reviewer checks the triggered items one by one and reports each as found or clean. This file adds to the rules the reviewer already checks; it does not replace them.

An item is a bug class with its source (the pull request that first had it, or the test that missed it). Keep each to a trigger, the question and the sign of the bug.

## Missed by all three reviewers in the reviewer test (phase 6 item 4)

1. **Concurrent requests with one idempotency key** (#38, #120). Trigger: a route or job that takes an idempotency key, a request id or a dedupe key. Ask: what happens when two requests with the same key run at the same moment, before either has committed? Bug: the second is refused by what the first changed (a state, a balance, a unique violation turned into a 500), or it answers without the first's results. Wanted: one winner, and the loser returns the winner's stored answer. Wanted in the test: two requests fired together, not one after the other.
2. **A derived value that ignores the outcome** (#137). Trigger: a total, a line, a commission or a statement computed from an order. Ask: does it read the order's outcome and who is responsible (AP §8.9), or only its prices? Bug: a cancelled, refused or restaurant-responsible order still shows the commission or the pickup money. Wanted: the value is tested once per outcome.

## The other bugs of the eight cases

3. **A job's failure** (#39). Trigger: a timer or outbox job. Ask: if it throws once (a database blip), is it retried, and does it leave a state nothing will move? Bug: an order stuck in a state because its one job failed.
4. **An early or late event against a timer** (#44, #116). Trigger: a status change that a timer also acts on, or a pass that loops over many items. Ask: does an early event move the timer's start, and does a long pass read the mode and the clock once? Bug: a search start still ahead of now after an early «الطلب جاهز»; offers shortened because a slow pass used a stale clock. Wanted: read the clock and the settings per item.
5. **A rule that locks itself** (#30, #144). Trigger: a setting, a rule or a reversal that other rows refer to. Ask: after one is entered, can the base ever change, and can a later correction still be made? Bug: a fee rule fixed to the current base; a manual reversal that accepts an order's journals so a later «تغيير النتيجة» fails.

## By what the diff touches

6. **`ledger` or any journal:** every journal balances per currency; the sum is checked in the test, not assumed; a repeated request or job posts once (item 1).
7. **`ordering`, `dispatch`, `cashdesk` state or timers:** each transition has its late, repeated and concurrent job tested (items 3 and 4); a state change and its timers are in one transaction.
8. **A new route:** roles declared; the 401, 403 and out-of-scope tests exist; the response never includes another party's data (a captain's number outside its order, a customer's address after the order ends).
9. **A migration:** expand then contract; grants for the application role; an index for each foreign key and each list filter; the database test covers the new column.
10. **A list or a report:** scope is applied in the service; the business day uses the city's zone; an empty result and a page boundary are tested.
11. **A client, a string or a layout:** generated clients not edited by hand; every string in translation files; start and end, never left and right; Western digits.
12. **A change to `.github/workflows/ci.yml`, `scripts/verify.mjs` or `REVIEW.md`:** the pull request description names it under `## Checks changed`, with what it now lets through or stops. Any check that gets weaker, skipped or removed is blocking until the owner has seen it.
13. **A screen, a component or a semantic colour** (D.3, the owner's brand-orange exception). The owner allowed the brand orange anywhere, text, prices, amounts and timers included (2026-11-23), so where orange is used is not a bug. Ask: does the orange come from the orange tokens (`primary`, `primary-hover`, `primary-pressed`, `heading`, `brand`), and is each orange pair the change uses listed in `src/contrast.ts` under the exception, so the contrast report shows its ratio? Bug: an orange that is a literal or a token outside those five, an orange pair missing from `src/contrast.ts`, or an `exception` given to a non-orange token.
14. **An app screen** (T13, architecture §9.9). Ask: does the slice file record the owner's approval of the batch and the analysis, and does every route field and error the screen receives appear on it or have a stated reason? Does the screen work around a server gap in the app (a client-side sort, a guessed error, a computed value the server should send)? Is there one main action, is every name and number from the shared fixtures, do a command's button and a lost answer keep one `Idempotency-Key`, and does a countdown use `serverClockProvider` and a server object come through a `LiveFeed`? Bug: an unapproved or unexplained difference from the drawing, a workaround, a typed-in name, a double send, a local clock.

15. **A component on either platform** (D.P2, architecture §9.8). The parity gate measures the registry's `metrics` states on both sides against the component tokens. Ask: does a new state, variant or component add its states to `packages/design-tokens/components.json` and its widget to `packages/core_ui/test/parity_table.dart`, and does the pull request's `parity-report` artifact show the two sides alike? Bug: a look changed on one side only, a measured state removed or pointed at another token to make the gate pass, or a component with both twins and no `metrics` once its slice is done.

16. **A web component that scrolls or clips** (PR 300's Tabs). The `functional` gate checks, on every story, that each visible part of an overflowing clipping container lies in its scrollable area and, when absolutely placed, over its in-flow content, at the opening scroll position and scrolled to the far end, and that the scroll range is still after the fonts load; it sees only the states a story shows. Ask: does a component with `overflow-*` have a story in which it overflows on a phone, in RTL? Does a part placed by the UI SDK's physical CSS variables (`--active-tab-left`, a popup's `left`) get checked there? Bug: a scrolling or clipping component whose stories never overflow.

## After a merge

A bug found after a merge becomes a new item here or a test, in the same fix's pull request, with the pull request number as its source. If it is a test, name it in the fix's description; if it is an item, add it under a trigger above. Pruning is in `docs/archive/claude-code-workflow.md`, phase 7 item 4.
