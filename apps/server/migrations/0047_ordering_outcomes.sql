-- Slice 2.11a: the outcomes of AP §8.9 (ordering) and the customer dues account with dues.charge (ledger, AP §8.8).
CREATE TABLE "ordering"."order_outcomes" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"order_id" uuid NOT NULL,
	"order_placed_at" timestamp with time zone NOT NULL,
	"city_id" uuid NOT NULL,
	"outcome" text NOT NULL,
	"responsible" text NOT NULL,
	"status" text NOT NULL,
	"food" text,
	"currency" text NOT NULL,
	"amount_to_collect" bigint NOT NULL,
	"loss" bigint NOT NULL,
	"dues" bigint,
	"merchant_debit" bigint,
	"captain_pay" bigint NOT NULL,
	"customer_text" text,
	"note" text NOT NULL,
	"set_at" timestamp with time zone NOT NULL,
	"set_by" uuid NOT NULL,
	"captain_seen_at" timestamp with time zone,
	CONSTRAINT "order_outcomes_values" CHECK ("ordering"."order_outcomes"."outcome" IN ('free', 'fake', 'damaged', 'wrong_refused', 'failed_other') AND "ordering"."order_outcomes"."responsible" IN ('restaurant', 'captain', 'customer', 'platform') AND "ordering"."order_outcomes"."status" IN ('delivered', 'failed') AND ("ordering"."order_outcomes"."food" IS NULL OR "ordering"."order_outcomes"."food" IN ('kept_by_captain', 'returned_to_restaurant', 'destroyed'))),
	CONSTRAINT "order_outcomes_rules" CHECK (("ordering"."order_outcomes"."outcome" = 'fake') = ("ordering"."order_outcomes"."responsible" = 'customer') AND ("ordering"."order_outcomes"."responsible" = 'customer') = ("ordering"."order_outcomes"."dues" IS NOT NULL) AND ("ordering"."order_outcomes"."status" = 'failed') = ("ordering"."order_outcomes"."food" IS NOT NULL) AND ("ordering"."order_outcomes"."status" = 'delivered' OR "ordering"."order_outcomes"."outcome" <> 'free') AND ("ordering"."order_outcomes"."status" = 'failed' OR "ordering"."order_outcomes"."outcome" IN ('free', 'damaged')) AND ("ordering"."order_outcomes"."food" IS DISTINCT FROM 'returned_to_restaurant' OR "ordering"."order_outcomes"."responsible" = 'restaurant') AND ("ordering"."order_outcomes"."status" = 'failed') = ("ordering"."order_outcomes"."customer_text" IS NOT NULL) AND ("ordering"."order_outcomes"."responsible" = 'restaurant') = ("ordering"."order_outcomes"."merchant_debit" IS NOT NULL)),
	CONSTRAINT "order_outcomes_money" CHECK ("ordering"."order_outcomes"."amount_to_collect" >= 0 AND "ordering"."order_outcomes"."loss" >= 0 AND "ordering"."order_outcomes"."dues" > 0 AND "ordering"."order_outcomes"."merchant_debit" >= 0 AND "ordering"."order_outcomes"."captain_pay" >= 0 AND char_length("ordering"."order_outcomes"."note") BETWEEN 1 AND 500)
);
--> statement-breakpoint
ALTER TABLE "ledger"."accounts" DROP CONSTRAINT "accounts_purpose_values";--> statement-breakpoint
ALTER TABLE "ledger"."accounts" DROP CONSTRAINT "accounts_owner_present";--> statement-breakpoint
ALTER TABLE "ledger"."journals" DROP CONSTRAINT "journals_type_values";--> statement-breakpoint
ALTER TABLE "ordering"."order_outcomes" ADD CONSTRAINT "order_outcomes_order_id_order_placed_at_orders_id_placed_at_fk" FOREIGN KEY ("order_id","order_placed_at") REFERENCES "ordering"."orders"("id","placed_at") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE UNIQUE INDEX "order_outcomes_order" ON "ordering"."order_outcomes" USING btree ("order_id");--> statement-breakpoint
ALTER TABLE "ledger"."accounts" ADD CONSTRAINT "accounts_purpose_values" CHECK ("ledger"."accounts"."purpose" IN ('captain.custody', 'captain.earnings', 'captain.deposit', 'customer.dues', 'merchant.account', 'platform.revenue_commission', 'platform.revenue_delivery', 'platform.discount_cost', 'platform.compensation_cost', 'platform.operating_cost', 'platform.captain_pay', 'platform.test_cost', 'platform.fx_rounding', 'platform.order_clearing', 'platform.adjustments', 'platform.cash'));--> statement-breakpoint
ALTER TABLE "ledger"."accounts" ADD CONSTRAINT "accounts_owner_present" CHECK (("ledger"."accounts"."purpose" IN ('captain.custody', 'captain.earnings', 'captain.deposit', 'customer.dues', 'merchant.account', 'platform.cash')) = ("ledger"."accounts"."owner_id" IS NOT NULL));--> statement-breakpoint
ALTER TABLE "ledger"."journals" ADD CONSTRAINT "journals_type_values" CHECK ("ledger"."journals"."type" IN ('custody.collect', 'custody.change_given', 'custody.pay_merchant', 'custody.hand_in', 'custody.reimburse', 'custody.fx_convert', 'custody.pickup_correction', 'custody.adjustment', 'earn.order_pay', 'earn.waiting_pay', 'earn.peak_bonus', 'earn.bonus', 'earn.charge', 'earn.deposit_instalment', 'earn.payout', 'earn.adjustment', 'merchant.commission', 'merchant.discount_share', 'merchant.credit', 'merchant.debit', 'merchant.settlement', 'merchant.adjustment', 'dues.charge', 'platform.revenue_delivery', 'platform.discount_cost', 'platform.compensation_cost', 'platform.operating_cost', 'platform.test_cost', 'platform.fx_rounding'));--> statement-breakpoint
REVOKE UPDATE ON "ordering"."order_outcomes" FROM fox_drop_app;--> statement-breakpoint
GRANT UPDATE ("captain_seen_at") ON "ordering"."order_outcomes" TO fox_drop_app;
