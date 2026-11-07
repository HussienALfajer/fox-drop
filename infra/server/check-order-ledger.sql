-- Checks one delivered order's money in the ledger against AP §8.4
-- (docs/domain/04-order-money.md), the code that books it
-- (apps/server/src/modules/ordering/CLAUDE.md, «The atomic pickup» and «The
-- atomic delivery») and the counter-accounts of
-- apps/server/src/modules/ledger/CLAUDE.md. Read-only. Run it on the server
-- as the database superuser, with the order's number
-- (docs/runbooks/staging-cycle.md):
--
--   docker exec -i foxdrop-staging-postgres-1 psql -U postgres -d fox_drop \
--     -v number=10001 < check-order-ledger.sql
--
-- Each line shows what is expected, what the ledger holds, and ok. Amounts
-- are in minor units (100 = 1 TRY), from the platform's side: + a debit,
-- − a credit (the captain's custody + what they must hand in, their earnings
-- − what the platform owes them, the restaurant's account + what it owes).
-- The expected values come from the order and from what the pickup and the
-- door recorded, so a payment within rounding of the amount due still
-- checks; ± 250 is half of staging's TRY rounding unit. Phase 1 has no
-- discount and one city; a door payment in another
-- currency than the base fails line 2 (its conversion is not checked here).
\set ON_ERROR_STOP on
\set QUIET on
SET default_transaction_read_only = on;
\set QUIET off

SELECT count(*) = 1 AS found FROM ordering.orders WHERE number = :number AND status = 'delivered' \gset
\if :found
\else
  \echo 'No delivered order with that number (one city only in Phase 1).'
  \quit
\endif

WITH o AS (
  SELECT id, placed_at, status, outcome, currency, items_value, delivery_fee, discount,
         rounding, total, commission_bp, test_order,
         CASE WHEN test_order THEN 0 ELSE (items_value * commission_bp + 5000) / 10000 END AS commission
  FROM ordering.orders
  WHERE number = :number
),
pickup AS (
  -- The lines booked at the confirmed pickup request (AP §8.1).
  SELECT coalesce(sum((line ->> 'amount')::bigint), 0) AS booked
  FROM ordering.pickup_requests r
  JOIN o ON r.order_id = o.id AND r.order_placed_at = o.placed_at
  CROSS JOIN LATERAL jsonb_array_elements(r.booked_lines) AS line
  WHERE r.status = 'confirmed'
),
door AS (
  -- What the captain recorded at the door (CA §9.7).
  SELECT col.net_received, col.shortfall,
         col.base_pay + col.distance_pay + col.top_up_pay AS order_pay,
         col.waiting_pay,
         (SELECT coalesce(sum((line ->> 'amount')::bigint), 0) FROM jsonb_array_elements(col.received_lines) line)
           - (SELECT coalesce(sum((line ->> 'amount')::bigint), 0) FROM jsonb_array_elements(col.change_lines) line)
           AS received_less_change
  FROM ordering.collections col JOIN o ON col.order_id = o.id
),
lines AS (
  SELECT j.id AS journal_id, j.type, a.purpose, e.currency, e.amount
  FROM ledger.journals j
  JOIN o ON j.source_kind = 'order' AND j.source_id = o.id
  JOIN ledger.entries e ON e.journal_id = j.id
  JOIN ledger.accounts a ON a.id = e.account_id
),
total_of AS (
  SELECT type, purpose, sum(amount) AS amount FROM lines GROUP BY type, purpose
),
got AS (
  SELECT
    (SELECT coalesce(sum(amount), 0) FROM total_of WHERE type = 'custody.pay_merchant' AND purpose = 'captain.custody') AS pay_merchant,
    (SELECT coalesce(sum(amount), 0) FROM total_of WHERE type IN ('custody.collect', 'custody.change_given') AND purpose = 'captain.custody') AS collected,
    (SELECT coalesce(sum(amount), 0) FROM total_of WHERE purpose = 'captain.custody') AS custody_delta,
    (SELECT coalesce(sum(amount), 0) FROM total_of WHERE purpose = 'platform.order_clearing') AS clearing,
    (SELECT coalesce(sum(amount), 0) FROM total_of WHERE purpose = 'platform.revenue_delivery') AS revenue_delivery,
    (SELECT coalesce(sum(amount), 0) FROM total_of WHERE type = 'merchant.commission' AND purpose = 'merchant.account') AS commission,
    (SELECT coalesce(sum(amount), 0) FROM total_of WHERE purpose = 'platform.revenue_commission') AS revenue_commission,
    (SELECT coalesce(sum(amount), 0) FROM total_of WHERE type = 'earn.order_pay' AND purpose = 'captain.earnings') AS order_pay,
    (SELECT coalesce(sum(amount), 0) FROM total_of WHERE type = 'earn.waiting_pay' AND purpose = 'captain.earnings') AS waiting_pay,
    (SELECT coalesce(sum(amount), 0) FROM total_of WHERE purpose = 'platform.captain_pay') AS captain_pay,
    (SELECT coalesce(sum(amount), 0) FROM total_of WHERE purpose = 'platform.test_cost') AS test_cost,
    (SELECT coalesce(sum(amount), 0) FROM total_of WHERE purpose = 'platform.fx_rounding') AS fx_rounding,
    (SELECT count(*) FROM (SELECT 1 FROM lines GROUP BY journal_id, currency HAVING sum(amount) <> 0) unbalanced) AS unbalanced,
    (SELECT count(*) FROM lines, o WHERE lines.currency <> o.currency) AS other_currency,
    (SELECT coalesce(string_agg(DISTINCT type, ', ' ORDER BY type), '') FROM lines) AS types
),
checks (n, line, expected, actual) AS (
  SELECT 1, 'order delivered with outcome normal', 'delivered/normal', o.status || '/' || coalesce(o.outcome, '-') FROM o
  UNION ALL SELECT 2, 'every entry in the order''s currency', '0', got.other_currency::text FROM got
  UNION ALL SELECT 3, 'every journal sums to zero', '0', got.unbalanced::text FROM got
  UNION ALL SELECT 4, 'the journals booked (AP §8.4; fx_rounding only for a gap)',
    concat_ws(', ', 'custody.collect', 'custody.pay_merchant', 'earn.order_pay',
      CASE WHEN o.test_order THEN NULL ELSE 'merchant.commission' END, 'platform.revenue_delivery'),
    (SELECT coalesce(string_agg(t, ', ' ORDER BY t), '') FROM unnest(string_to_array(got.types, ', ')) t
     WHERE t NOT IN ('custody.change_given', 'platform.fx_rounding', 'earn.waiting_pay')) FROM o, got
  UNION ALL SELECT 5, 'customer_total = items + fee - discount + rounding', (o.items_value + o.delivery_fee - o.discount + o.rounding)::text, o.total::text FROM o
  UNION ALL SELECT 6, 'pickup payment booked = items value within rounding (D26)', o.items_value::text || ' ± 250', pickup.booked::text FROM o, pickup
  UNION ALL SELECT 7, 'custody.pay_merchant = the lines booked at pickup', (-pickup.booked)::text, got.pay_merchant::text FROM pickup, got
  UNION ALL SELECT 8, 'custody.collect - change_given = received - change at the door', door.received_less_change::text, got.collected::text FROM door, got
  UNION ALL SELECT 9, 'door net = total - shortfall, within rounding', (o.total - door.shortfall)::text || ' ± 250', door.net_received::text FROM o, door
  UNION ALL SELECT 10, 'custody_delta = collected - pickup payment', (door.received_less_change - pickup.booked)::text, got.custody_delta::text FROM door, pickup, got
  UNION ALL SELECT 11, 'order clearing account = shortfall (0 when paid in full)', door.shortfall::text, got.clearing::text FROM door, got
  UNION ALL SELECT 12, 'delivery fee to platform.revenue_delivery', (-o.delivery_fee)::text, got.revenue_delivery::text FROM o, got
  UNION ALL SELECT 13, 'commission = commission_pct x items value (0 on a test order)', o.commission::text, got.commission::text FROM o, got
  UNION ALL SELECT 14, 'commission to platform.revenue_commission', (-o.commission)::text, got.revenue_commission::text FROM o, got
  UNION ALL SELECT 15, 'earn.order_pay = base + distance + top-up recorded', (-door.order_pay)::text, got.order_pay::text FROM door, got
  UNION ALL SELECT 16, 'earn.waiting_pay = waiting pay recorded', (-door.waiting_pay)::text, got.waiting_pay::text FROM door, got
  UNION ALL SELECT 17, 'captain pay to platform.captain_pay (test_cost on a test order)',
    CASE WHEN o.test_order THEN '0 / ' ELSE '' END || (door.order_pay + door.waiting_pay)::text || CASE WHEN o.test_order THEN '' ELSE ' / 0' END,
    got.captain_pay::text || ' / ' || got.test_cost::text FROM o, door, got
  UNION ALL SELECT 18, 'platform margin = commission + fee - discount - captain pay + rounding, plus the pickup and door gaps',
    (o.commission + o.delivery_fee - o.discount - door.order_pay - door.waiting_pay + o.rounding
      + (o.items_value - pickup.booked) - (o.total - door.net_received - door.shortfall))::text,
    (-(got.revenue_commission + got.revenue_delivery + got.captain_pay + got.test_cost + got.fx_rounding))::text
    FROM o, pickup, door, got
)
SELECT n, line, expected, actual,
  CASE
    WHEN n IN (6, 9) THEN CASE WHEN abs(split_part(expected, ' ', 1)::bigint - actual::bigint) <= 250 THEN 'ok' ELSE 'MISMATCH' END
    WHEN expected = actual THEN 'ok'
    ELSE 'MISMATCH'
  END AS result
FROM checks ORDER BY n;

-- The pay to compare with the pay table by eye: the run book's order under
-- 3 km is 2500 (25 TRY).
SELECT o.trip_metres, col.base_pay, col.distance_pay, col.top_up_pay, col.waiting_pay, col.waiting_minutes
FROM ordering.orders o JOIN ordering.collections col ON col.order_id = o.id
WHERE o.number = :number;

-- Every entry of the order, for reading by eye.
SELECT j.created_at, j.type, a.purpose, e.currency, e.amount, j.actor_type
FROM ledger.journals j
JOIN ordering.orders o ON j.source_kind = 'order' AND j.source_id = o.id AND o.number = :number
JOIN ledger.entries e ON e.journal_id = j.id
JOIN ledger.accounts a ON a.id = e.account_id
ORDER BY j.created_at, j.type, a.purpose;
