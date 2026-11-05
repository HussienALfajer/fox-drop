CREATE SCHEMA "ledger";
--> statement-breakpoint
-- The ledger is append-only (architecture §5.6): the application role reads
-- and adds rows, never changes or deletes one; a correction is a reversing
-- journal. The default privileges reach every partition the migration role
-- creates.
GRANT USAGE ON SCHEMA "ledger" TO fox_drop_app;
--> statement-breakpoint
ALTER DEFAULT PRIVILEGES IN SCHEMA "ledger" GRANT SELECT, INSERT ON TABLES TO fox_drop_app;
--> statement-breakpoint
CREATE TABLE "ledger"."accounts" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"city_id" uuid NOT NULL,
	"purpose" text NOT NULL,
	"owner_id" uuid,
	"currency" text NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "accounts_city_purpose_owner_currency" UNIQUE NULLS NOT DISTINCT("city_id","purpose","owner_id","currency"),
	CONSTRAINT "accounts_id_city_currency" UNIQUE("id","city_id","currency"),
	CONSTRAINT "accounts_purpose_values" CHECK ("ledger"."accounts"."purpose" IN ('captain.custody', 'captain.earnings', 'captain.deposit', 'merchant.account', 'platform.revenue_commission', 'platform.revenue_delivery', 'platform.discount_cost', 'platform.compensation_cost', 'platform.operating_cost', 'platform.captain_pay', 'platform.test_cost', 'platform.fx_rounding', 'platform.order_clearing', 'platform.adjustments', 'platform.cash')),
	CONSTRAINT "accounts_owner_present" CHECK (("ledger"."accounts"."purpose" IN ('captain.custody', 'captain.earnings', 'captain.deposit', 'merchant.account', 'platform.cash')) = ("ledger"."accounts"."owner_id" IS NOT NULL)),
	CONSTRAINT "accounts_currency_code" CHECK ("ledger"."accounts"."currency" ~ '^[A-Z]{3}$')
);
--> statement-breakpoint
CREATE TABLE "ledger"."entries" (
	"id" uuid DEFAULT uuidv7() NOT NULL,
	"journal_id" uuid NOT NULL,
	"city_id" uuid NOT NULL,
	"account_id" uuid NOT NULL,
	"currency" text NOT NULL,
	"amount" bigint NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "entries_id_created_at_pk" PRIMARY KEY("id","created_at"),
	CONSTRAINT "entries_amount_not_zero" CHECK ("ledger"."entries"."amount" <> 0)
) PARTITION BY RANGE ("created_at");
--> statement-breakpoint
CREATE TABLE "ledger"."journals" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"city_id" uuid NOT NULL,
	"type" text NOT NULL,
	"source_kind" text,
	"source_id" uuid,
	"actor_type" text NOT NULL,
	"actor_id" uuid,
	"reason" text,
	"reverses_journal_id" uuid,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "journals_id_city" UNIQUE("id","city_id"),
	CONSTRAINT "journals_reversed_once" UNIQUE("reverses_journal_id"),
	CONSTRAINT "journals_type_values" CHECK ("ledger"."journals"."type" IN ('custody.collect', 'custody.change_given', 'custody.pay_merchant', 'custody.hand_in', 'custody.reimburse', 'custody.fx_convert', 'custody.pickup_correction', 'custody.adjustment', 'earn.order_pay', 'earn.waiting_pay', 'earn.peak_bonus', 'earn.bonus', 'earn.charge', 'earn.deposit_instalment', 'earn.payout', 'earn.adjustment', 'merchant.commission', 'merchant.discount_share', 'merchant.credit', 'merchant.debit', 'merchant.settlement', 'merchant.adjustment', 'platform.revenue_delivery', 'platform.discount_cost', 'platform.compensation_cost', 'platform.operating_cost', 'platform.test_cost', 'platform.fx_rounding')),
	CONSTRAINT "journals_source_kind_values" CHECK ("ledger"."journals"."source_kind" IS NULL OR "ledger"."journals"."source_kind" IN ('order')),
	CONSTRAINT "journals_source_complete" CHECK (("ledger"."journals"."source_kind" IS NULL) = ("ledger"."journals"."source_id" IS NULL)),
	CONSTRAINT "journals_actor_type_values" CHECK ("ledger"."journals"."actor_type" IN ('admin', 'merchant', 'captain', 'customer', 'system')),
	CONSTRAINT "journals_actor_id_present" CHECK (("ledger"."journals"."actor_type" = 'system') = ("ledger"."journals"."actor_id" IS NULL)),
	CONSTRAINT "journals_reason_required" CHECK (("ledger"."journals"."type" NOT IN ('custody.adjustment', 'earn.bonus', 'earn.adjustment', 'merchant.adjustment') AND "ledger"."journals"."reverses_journal_id" IS NULL) OR coalesce(btrim("ledger"."journals"."reason"), '') <> '')
);
--> statement-breakpoint
ALTER TABLE "ledger"."entries" ADD CONSTRAINT "entries_journal" FOREIGN KEY ("journal_id","city_id") REFERENCES "ledger"."journals"("id","city_id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "ledger"."entries" ADD CONSTRAINT "entries_account" FOREIGN KEY ("account_id","city_id","currency") REFERENCES "ledger"."accounts"("id","city_id","currency") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "ledger"."journals" ADD CONSTRAINT "journals_reverses_journal" FOREIGN KEY ("reverses_journal_id","city_id") REFERENCES "ledger"."journals"("id","city_id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "entries_by_account" ON "ledger"."entries" USING btree ("account_id");--> statement-breakpoint
CREATE INDEX "entries_by_journal" ON "ledger"."entries" USING btree ("journal_id");--> statement-breakpoint
CREATE INDEX "journals_by_source" ON "ledger"."journals" USING btree ("source_kind","source_id");--> statement-breakpoint
-- One partition of the entries per UTC month (architecture §5.4), for this
-- month and the next, as audit.create_month_partitions does for the audit
-- log. It runs as the migration role, which owns it, so the partitions get
-- the schema's default privileges; the application role may call it but
-- cannot create a partition itself. The worker role calls it at start and
-- every day.
CREATE FUNCTION "ledger"."create_month_partitions"() RETURNS void
LANGUAGE plpgsql SECURITY DEFINER
SET search_path = pg_catalog, pg_temp
SET "TimeZone" = 'UTC'
SET "DateStyle" = 'ISO'
-- Attaching a partition locks the entries; give up rather than hold money
-- movements behind a long transaction. The daily call tries again.
SET lock_timeout = '5s'
AS $$
DECLARE
	month_start timestamp;
BEGIN
	-- Two servers starting together create each partition once.
	PERFORM pg_advisory_xact_lock(hashtext('ledger.create_month_partitions'));
	FOR offset_months IN 0..1 LOOP
		month_start := date_trunc('month', now() AT TIME ZONE 'UTC') + make_interval(months => offset_months);
		EXECUTE format(
			'CREATE TABLE IF NOT EXISTS ledger.%I PARTITION OF ledger.entries FOR VALUES FROM (%L) TO (%L)',
			'entries_' || to_char(month_start, 'YYYY_MM'),
			month_start AT TIME ZONE 'UTC',
			(month_start + interval '1 month') AT TIME ZONE 'UTC'
		);
	END LOOP;
END;
$$;
--> statement-breakpoint
REVOKE EXECUTE ON FUNCTION "ledger"."create_month_partitions"() FROM PUBLIC;
--> statement-breakpoint
GRANT EXECUTE ON FUNCTION "ledger"."create_month_partitions"() TO fox_drop_app;
--> statement-breakpoint
SELECT "ledger"."create_month_partitions"();
--> statement-breakpoint
-- The database guards the double entry beside LedgerService (architecture
-- §5.6). An entry joins only a journal posted in the same transaction, so a
-- journal is never changed after it commits: now() is the transaction's start,
-- which is the journal's created_at only in the transaction that posted it.
CREATE FUNCTION "ledger"."entries_join_a_new_journal"() RETURNS trigger
LANGUAGE plpgsql
SET search_path = pg_catalog, pg_temp
AS $$
BEGIN
	IF NOT EXISTS (
		SELECT 1 FROM ledger.journals WHERE id = NEW.journal_id AND created_at = now()
	) THEN
		RAISE EXCEPTION 'ledger: an entry joins only a journal posted in its transaction'
			USING ERRCODE = 'integrity_constraint_violation';
	END IF;
	RETURN NEW;
END;
$$;
--> statement-breakpoint
CREATE TRIGGER "entries_join_a_new_journal" BEFORE INSERT ON "ledger"."entries"
FOR EACH ROW EXECUTE FUNCTION "ledger"."entries_join_a_new_journal"();
--> statement-breakpoint
-- At commit, every journal posted in the transaction has two entries or more
-- and sums to zero in each currency.
CREATE FUNCTION "ledger"."journal_balances"() RETURNS trigger
LANGUAGE plpgsql
SET search_path = pg_catalog, pg_temp
AS $$
BEGIN
	IF (SELECT count(*) FROM ledger.entries WHERE journal_id = NEW.id) < 2 THEN
		RAISE EXCEPTION 'ledger: journal % has fewer than two entries', NEW.id
			USING ERRCODE = 'integrity_constraint_violation';
	END IF;
	IF EXISTS (
		SELECT 1 FROM ledger.entries WHERE journal_id = NEW.id
		GROUP BY currency HAVING sum(amount) <> 0
	) THEN
		RAISE EXCEPTION 'ledger: journal % does not balance to zero in each currency', NEW.id
			USING ERRCODE = 'integrity_constraint_violation';
	END IF;
	RETURN NULL;
END;
$$;
--> statement-breakpoint
CREATE CONSTRAINT TRIGGER "journal_balances" AFTER INSERT ON "ledger"."journals"
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW EXECUTE FUNCTION "ledger"."journal_balances"();