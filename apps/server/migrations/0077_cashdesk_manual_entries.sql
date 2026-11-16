-- Slice 2.20c: «القيود التصحيحية» (AP §9.10.7): the manual entries (cashdesk), dues.adjustment (ledger, AP §8.8) and the key of a manual entry. Expand only.
CREATE TABLE "cashdesk"."manual_entries" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"city_id" uuid NOT NULL,
	"kind" text NOT NULL,
	"party" text NOT NULL,
	"party_id" uuid NOT NULL,
	"journal_id" uuid NOT NULL,
	"reverses_journal_id" uuid,
	"reason" text NOT NULL,
	"admin_account_id" uuid NOT NULL,
	"created_at" timestamp with time zone NOT NULL,
	CONSTRAINT "manual_entries_kind_values" CHECK ("cashdesk"."manual_entries"."kind" IN ('adjustment', 'reversal')),
	CONSTRAINT "manual_entries_party_values" CHECK ("cashdesk"."manual_entries"."party" IN ('captain', 'restaurant', 'customer')),
	CONSTRAINT "manual_entries_reversal_links" CHECK (("cashdesk"."manual_entries"."kind" = 'reversal') = ("cashdesk"."manual_entries"."reverses_journal_id" IS NOT NULL)),
	CONSTRAINT "manual_entries_reason" CHECK (char_length(btrim("cashdesk"."manual_entries"."reason")) BETWEEN 1 AND 500)
);
--> statement-breakpoint
ALTER TABLE "ledger"."journals" DROP CONSTRAINT "journals_type_values";--> statement-breakpoint
ALTER TABLE "ledger"."journals" DROP CONSTRAINT "journals_reason_required";--> statement-breakpoint
ALTER TABLE "cashdesk"."idempotency_keys" ADD COLUMN "manual_entry_id" uuid;--> statement-breakpoint
CREATE UNIQUE INDEX "manual_entries_journal" ON "cashdesk"."manual_entries" USING btree ("journal_id");--> statement-breakpoint
CREATE UNIQUE INDEX "manual_entries_reverses_journal" ON "cashdesk"."manual_entries" USING btree ("reverses_journal_id");--> statement-breakpoint
CREATE INDEX "manual_entries_city_created" ON "cashdesk"."manual_entries" USING btree ("city_id","created_at" DESC NULLS LAST);--> statement-breakpoint
ALTER TABLE "ledger"."journals" ADD CONSTRAINT "journals_type_values" CHECK ("ledger"."journals"."type" IN ('custody.collect', 'custody.change_given', 'custody.pay_merchant', 'custody.hand_in', 'custody.reimburse', 'custody.fx_convert', 'custody.pickup_correction', 'custody.adjustment', 'earn.order_pay', 'earn.waiting_pay', 'earn.peak_bonus', 'earn.bonus', 'earn.charge', 'earn.deposit_instalment', 'earn.payout', 'earn.adjustment', 'merchant.commission', 'merchant.discount_share', 'merchant.credit', 'merchant.debit', 'merchant.settlement', 'merchant.adjustment', 'dues.charge', 'dues.adjustment', 'platform.revenue_delivery', 'platform.discount_cost', 'platform.compensation_cost', 'platform.operating_cost', 'platform.test_cost', 'platform.fx_rounding'));--> statement-breakpoint
ALTER TABLE "ledger"."journals" ADD CONSTRAINT "journals_reason_required" CHECK (("ledger"."journals"."type" NOT IN ('custody.adjustment', 'earn.bonus', 'earn.adjustment', 'merchant.adjustment', 'dues.adjustment') AND "ledger"."journals"."reverses_journal_id" IS NULL) OR coalesce(btrim("ledger"."journals"."reason"), '') <> '');--> statement-breakpoint
REVOKE UPDATE ON "cashdesk"."manual_entries" FROM fox_drop_app;
