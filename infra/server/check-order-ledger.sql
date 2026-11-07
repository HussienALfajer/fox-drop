-- Checks one delivered order's money in the ledger against AP §8.4
-- (docs/domain/04-order-money.md) and the counter-accounts of
-- apps/server/src/modules/ledger/CLAUDE.md. Read-only. Run it on the server
-- as the database superuser, with the order's number (docs/runbooks/staging-cycle.md):
--
--   docker exec -i foxdrop-staging-postgres-1 psql -U postgres -d fox_drop \
--     -v number=10001 < check-order-ledger.sql
--
-- Each line shows what AP §8.4 expects, what the ledger holds, and ok. Phase 1
-- orders have no discount and are paid in the base currency, so every
-- amount is in the order's currency, in minor units (100 = 1 TRY).
\set ON_ERROR_STOP on

SELECT count(*) = 1 AS found FROM ordering.orders WHERE number = :number AND status = 'delivered' \gset
\if :found
\else
  \echo 'No delivered order with that number (one city only in Phase 1).'
  \quit
\endif

WITH o AS (
  SELECT id, number, status, outcome, currency, items_value, delivery_fee, discount,
         rounding, total, commission_bp, test_order
  FROM ordering.orders
  WHERE number = :number
),
c AS (
  SELECT col.*
  FROM ordering.collections col JOIN o ON col.order_id = o.id
),
lines AS (
  SELECT j.type, a.purpose, e.currency, e.amount, j.id AS journal_id
  FROM ledger.journals j
  JOIN o ON j.source_kind = 'order' AND j.source_id = o.id
  JOIN ledger.entries e ON e.journal_id = j.id
  JOIN ledger.accounts a ON a.id = e.account_id
),
sum_of AS (
  SELECT type, purpose, sum(amount) AS amount FROM lines GROUP BY type, purpose
),
got AS (
  SELECT
    (SELECT coalesce(sum(amount), 0) FROM sum_of WHERE type = 'custody.pay_merchant' AND purpose = 'captain.custody') AS pay_merchant,
    (SELECT coalesce(sum(amount), 0) FROM sum_of WHERE type IN ('custody.collect', 'custody.change_given') AND purpose = 'captain.custody') AS collected_net,
    (SELECT coalesce(sum(amount), 0) FROM sum_of WHERE purpose = 'captain.custody') AS custody_delta,
    (SELECT coalesce(sum(amount), 0) FROM sum_of WHERE purpose = 'platform.order_clearing') AS clearing,
    (SELECT coalesce(sum(amount), 0) FROM sum_of WHERE purpose = 'platform.revenue_delivery') AS revenue_delivery,
    (SELECT coalesce(sum(amount), 0) FROM sum_of WHERE type = 'merchant.commission' AND purpose = 'merchant.account') AS commission,
    (SELECT coalesce(sum(amount), 0) FROM sum_of WHERE purpose = 'platform.revenue_commission') AS revenue_commission,
    (SELECT coalesce(sum(amount), 0) FROM sum_of WHERE type = 'earn.order_pay' AND purpose = 'captain.earnings') AS order_pay,
    (SELECT coalesce(sum(amount), 0) FROM sum_of WHERE type = 'earn.waiting_pay' AND purpose = 'captain.earnings') AS waiting_pay,
    (SELECT coalesce(sum(amount), 0) FROM sum_of WHERE purpose IN ('platform.captain_pay', 'platform.test_cost')) AS pay_cost,
    (SELECT coalesce(sum(amount), 0) FROM sum_of WHERE purpose = 'platform.fx_rounding') AS fx_rounding,
    (SELECT count(*) FROM (SELECT journal_id FROM lines GROUP BY journal_id, currency HAVING sum(amount) <> 0) unbalanced) AS unbalanced_journals,
    (SELECT count(DISTINCT journal_id) FROM lines) AS journals
),
checks (n, line, expected, actual) AS (
  SELECT 1, 'order delivered with outcome normal', 'delivered/normal', o.status || '/' || coalesce(o.outcome, '-') FROM o
  UNION ALL SELECT 2, 'customer_total = items + fee - discount + rounding', (o.items_value + o.delivery_fee - o.discount + o.rounding)::text, o.total::text FROM o
  UNION ALL SELECT 3, 'every journal sums to zero', '0', got.unbalanced_journals::text FROM got
  UNION ALL SELECT 4, 'pickup_payment = items_value (custody.pay_merchant, D26)', (-o.items_value)::text, got.pay_merchant::text FROM o, got
  UNION ALL SELECT 5, 'collected at the door, net of change = net received', (SELECT net_received FROM c)::text, got.collected_net::text FROM got
  UNION ALL SELECT 6, 'custody_delta = customer_total - pickup_payment (no shortfall)', (o.total - o.items_value - coalesce((SELECT shortfall FROM c), 0))::text, got.custody_delta::text FROM o, got
  UNION ALL SELECT 7, 'order clearing account back to zero (no shortfall)', coalesce((SELECT shortfall FROM c), 0)::text, got.clearing::text FROM got
  UNION ALL SELECT 8, 'delivery fee booked to platform.revenue_delivery', (-o.delivery_fee)::text, got.revenue_delivery::text FROM o, got
  UNION ALL SELECT 9, 'commission = commission_pct x items_value (0 on a test order)',
    (CASE WHEN o.test_order THEN 0 ELSE (o.items_value * o.commission_bp + 5000) / 10000 END)::text, got.commission::text FROM o, got
  UNION ALL SELECT 10, 'commission booked to platform.revenue_commission', (-got.commission)::text, got.revenue_commission::text FROM got
  UNION ALL SELECT 11, 'earn.order_pay = base + distance + top-up (recorded parts)', (-(SELECT base_pay + distance_pay + top_up_pay FROM c))::text, got.order_pay::text FROM got
  UNION ALL SELECT 12, 'earn.waiting_pay = recorded waiting pay', (-(SELECT waiting_pay FROM c))::text, got.waiting_pay::text FROM got
  UNION ALL SELECT 13, 'captain pay booked to platform.captain_pay (test_cost on a test order)', (-(got.order_pay + got.waiting_pay))::text, got.pay_cost::text FROM got
  UNION ALL SELECT 14, 'platform_margin = commission + fee - discount - captain_pay + rounding',
    (CASE WHEN o.test_order THEN 0 ELSE (o.items_value * o.commission_bp + 5000) / 10000 END
       + o.delivery_fee - o.discount + (got.order_pay + got.waiting_pay) + o.rounding)::text,
    (-(got.revenue_commission + got.revenue_delivery + got.pay_cost + got.fx_rounding))::text FROM o, got
)
SELECT n, line, expected, actual, CASE WHEN expected = actual THEN 'ok' ELSE 'MISMATCH' END AS result
FROM checks ORDER BY n;

-- Every entry of the order, for reading by eye.
SELECT j.created_at, j.type, a.purpose, e.currency, e.amount, j.actor_type
FROM ledger.journals j
JOIN ordering.orders o ON j.source_kind = 'order' AND j.source_id = o.id AND o.number = :number
JOIN ledger.entries e ON e.journal_id = j.id
JOIN ledger.accounts a ON a.id = e.account_id
ORDER BY j.created_at, j.type, a.purpose;
