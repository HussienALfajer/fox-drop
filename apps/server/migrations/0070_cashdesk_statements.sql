CREATE TABLE "cashdesk"."statements" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"city_id" uuid NOT NULL,
	"captain_id" uuid NOT NULL,
	"captain_name" text NOT NULL,
	"session_id" uuid NOT NULL,
	"admin_account_id" uuid NOT NULL,
	"period_from" timestamp with time zone,
	"created_at" timestamp with time zone NOT NULL,
	"ledger_from" timestamp with time zone,
	"ledger_to" timestamp with time zone NOT NULL,
	"currency" text NOT NULL,
	"orders" integer NOT NULL,
	"base_pay" bigint NOT NULL,
	"distance_pay" bigint NOT NULL,
	"waiting_pay" bigint NOT NULL,
	"peak_bonus" bigint NOT NULL,
	"bonuses" bigint NOT NULL,
	"charges" bigint NOT NULL,
	"instalments" bigint NOT NULL,
	"adjustments" bigint NOT NULL,
	"carried_in" bigint NOT NULL,
	"balance" bigint NOT NULL,
	"paid" bigint NOT NULL,
	"payout_currency" text,
	"payout_amount" bigint,
	"collected" bigint NOT NULL,
	"carried_out" bigint NOT NULL,
	"off_cycle" boolean NOT NULL,
	"reason" text,
	"receipt_ids" uuid[] NOT NULL,
	"journal_ids" uuid[] NOT NULL,
	CONSTRAINT "statements_money" CHECK ("cashdesk"."statements"."orders" >= 0 AND "cashdesk"."statements"."distance_pay" >= 0 AND "cashdesk"."statements"."paid" >= 0 AND "cashdesk"."statements"."collected" >= 0),
	CONSTRAINT "statements_sums" CHECK ("cashdesk"."statements"."balance" = "cashdesk"."statements"."carried_in" + "cashdesk"."statements"."base_pay" + "cashdesk"."statements"."distance_pay" + "cashdesk"."statements"."waiting_pay" + "cashdesk"."statements"."peak_bonus" + "cashdesk"."statements"."bonuses" - "cashdesk"."statements"."charges" - "cashdesk"."statements"."instalments" + "cashdesk"."statements"."adjustments" AND "cashdesk"."statements"."carried_out" = "cashdesk"."statements"."balance" - "cashdesk"."statements"."paid" + "cashdesk"."statements"."collected"),
	CONSTRAINT "statements_payout" CHECK (("cashdesk"."statements"."paid" > 0) = ("cashdesk"."statements"."payout_currency" IS NOT NULL) AND ("cashdesk"."statements"."payout_currency" IS NULL) = ("cashdesk"."statements"."payout_amount" IS NULL) AND ("cashdesk"."statements"."payout_amount" IS NULL OR "cashdesk"."statements"."payout_amount" > 0)),
	CONSTRAINT "statements_reason" CHECK ("cashdesk"."statements"."off_cycle" = ("cashdesk"."statements"."reason" IS NOT NULL) AND ("cashdesk"."statements"."reason" IS NULL OR char_length("cashdesk"."statements"."reason") BETWEEN 1 AND 500))
);
--> statement-breakpoint
ALTER TABLE "cashdesk"."receipts" DROP CONSTRAINT "receipts_type_values";--> statement-breakpoint
ALTER TABLE "cashdesk"."idempotency_keys" ADD COLUMN "statement_id" uuid;--> statement-breakpoint
ALTER TABLE "cashdesk"."statements" ADD CONSTRAINT "statements_session_fk" FOREIGN KEY ("session_id") REFERENCES "cashdesk"."drawer_sessions"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "statements_captain_created" ON "cashdesk"."statements" USING btree ("captain_id","created_at");--> statement-breakpoint
CREATE INDEX "statements_session" ON "cashdesk"."statements" USING btree ("session_id");--> statement-breakpoint
ALTER TABLE "cashdesk"."receipts" ADD CONSTRAINT "receipts_type_values" CHECK ("cashdesk"."receipts"."type" IN ('captain_hand_in', 'captain_reimbursement', 'captain_payout', 'captain_earnings_collection'));--> statement-breakpoint
REVOKE UPDATE ON "cashdesk"."statements" FROM fox_drop_app;
