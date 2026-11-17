ALTER TABLE "identity"."app_sessions" DROP CONSTRAINT "app_sessions_end_reason_values";--> statement-breakpoint
ALTER TABLE "identity"."customer_accounts" DROP CONSTRAINT "customer_accounts_status_values";--> statement-breakpoint
ALTER TABLE "ledger"."journals" DROP CONSTRAINT "journals_type_values";--> statement-breakpoint
ALTER TABLE "ledger"."journals" DROP CONSTRAINT "journals_reason_required";--> statement-breakpoint
ALTER TABLE "identity"."customer_accounts" ADD COLUMN "lineage_id" uuid;--> statement-breakpoint
ALTER TABLE "identity"."customer_accounts" ADD COLUMN "closed_at" timestamp with time zone;--> statement-breakpoint
ALTER TABLE "identity"."customer_accounts" ADD COLUMN "closed_by" uuid;--> statement-breakpoint
ALTER TABLE "identity"."customer_accounts" ADD COLUMN "close_reason" text;--> statement-breakpoint
ALTER TABLE "identity"."customer_accounts" ADD CONSTRAINT "customer_accounts_closed_by_admin_accounts_id_fk" FOREIGN KEY ("closed_by") REFERENCES "identity"."admin_accounts"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "customer_accounts_lineage" ON "identity"."customer_accounts" USING btree ("lineage_id");--> statement-breakpoint
ALTER TABLE "identity"."app_sessions" ADD CONSTRAINT "app_sessions_end_reason_values" CHECK ("identity"."app_sessions"."end_reason" IN ('sign_out', 'sign_out_everywhere', 'refresh_reuse', 'new_sign_in', 'other_device', 'device_released', 'phone_changed', 'account_closed')) NOT VALID;--> statement-breakpoint
ALTER TABLE "identity"."app_sessions" VALIDATE CONSTRAINT "app_sessions_end_reason_values";--> statement-breakpoint
ALTER TABLE "identity"."customer_accounts" ADD CONSTRAINT "customer_accounts_closed" CHECK (("identity"."customer_accounts"."status" = 'closed') = ("identity"."customer_accounts"."closed_at" IS NOT NULL) AND ("identity"."customer_accounts"."closed_at" IS NOT NULL OR ("identity"."customer_accounts"."closed_by" IS NULL AND "identity"."customer_accounts"."close_reason" IS NULL))) NOT VALID;--> statement-breakpoint
ALTER TABLE "identity"."customer_accounts" VALIDATE CONSTRAINT "customer_accounts_closed";--> statement-breakpoint
ALTER TABLE "identity"."customer_accounts" ADD CONSTRAINT "customer_accounts_status_values" CHECK ("identity"."customer_accounts"."status" IN ('active', 'closed')) NOT VALID;--> statement-breakpoint
ALTER TABLE "identity"."customer_accounts" VALIDATE CONSTRAINT "customer_accounts_status_values";--> statement-breakpoint
ALTER TABLE "ledger"."journals" ADD CONSTRAINT "journals_type_values" CHECK ("ledger"."journals"."type" IN ('custody.collect', 'custody.change_given', 'custody.pay_merchant', 'custody.hand_in', 'custody.reimburse', 'custody.fx_convert', 'custody.pickup_correction', 'custody.adjustment', 'earn.order_pay', 'earn.waiting_pay', 'earn.peak_bonus', 'earn.bonus', 'earn.charge', 'earn.deposit_instalment', 'earn.payout', 'earn.adjustment', 'merchant.commission', 'merchant.discount_share', 'merchant.credit', 'merchant.debit', 'merchant.settlement', 'merchant.adjustment', 'dues.charge', 'dues.payment', 'dues.adjustment', 'dues.transfer', 'platform.revenue_delivery', 'platform.discount_cost', 'platform.compensation_cost', 'platform.operating_cost', 'platform.test_cost', 'platform.fx_rounding')) NOT VALID;--> statement-breakpoint
ALTER TABLE "ledger"."journals" VALIDATE CONSTRAINT "journals_type_values";--> statement-breakpoint
ALTER TABLE "ledger"."journals" ADD CONSTRAINT "journals_reason_required" CHECK (("ledger"."journals"."type" NOT IN ('custody.adjustment', 'earn.bonus', 'earn.adjustment', 'merchant.adjustment', 'dues.adjustment', 'dues.transfer') AND "ledger"."journals"."reverses_journal_id" IS NULL) OR coalesce(btrim("ledger"."journals"."reason"), '') <> '') NOT VALID;--> statement-breakpoint
ALTER TABLE "ledger"."journals" VALIDATE CONSTRAINT "journals_reason_required";
