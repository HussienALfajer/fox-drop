CREATE TABLE "cashdesk"."merchant_statement_lines" (
	"statement_id" uuid NOT NULL,
	"position" integer NOT NULL,
	"kind" text NOT NULL,
	"at" timestamp with time zone NOT NULL,
	"order_id" uuid,
	"order_number" bigint,
	"items_value" bigint,
	"pickup_lines" jsonb,
	"commission" bigint,
	"discount_share" bigint,
	"cause" text,
	"amount" bigint,
	"reason" text,
	"journal_id" uuid,
	CONSTRAINT "merchant_statement_lines_statement_id_position_pk" PRIMARY KEY("statement_id","position"),
	CONSTRAINT "merchant_statement_lines_kind_values" CHECK ("cashdesk"."merchant_statement_lines"."kind" IN ('order', 'exception', 'payment')),
	CONSTRAINT "merchant_statement_lines_cause_values" CHECK ("cashdesk"."merchant_statement_lines"."cause" IS NULL OR "cashdesk"."merchant_statement_lines"."cause" IN ('food_credit', 'credit', 'pickup_refund', 'items_removed', 'debit', 'commission_reversal', 'discount_reversal', 'adjustment')),
	CONSTRAINT "merchant_statement_lines_shape" CHECK (CASE "cashdesk"."merchant_statement_lines"."kind" WHEN 'order' THEN "cashdesk"."merchant_statement_lines"."order_id" IS NOT NULL AND "cashdesk"."merchant_statement_lines"."commission" IS NOT NULL AND "cashdesk"."merchant_statement_lines"."discount_share" IS NOT NULL AND "cashdesk"."merchant_statement_lines"."amount" IS NULL AND "cashdesk"."merchant_statement_lines"."cause" IS NULL WHEN 'exception' THEN "cashdesk"."merchant_statement_lines"."cause" IS NOT NULL AND "cashdesk"."merchant_statement_lines"."amount" IS NOT NULL AND "cashdesk"."merchant_statement_lines"."journal_id" IS NOT NULL ELSE "cashdesk"."merchant_statement_lines"."cause" IS NULL AND "cashdesk"."merchant_statement_lines"."amount" IS NOT NULL AND "cashdesk"."merchant_statement_lines"."journal_id" IS NOT NULL END)
);
--> statement-breakpoint
CREATE TABLE "cashdesk"."merchant_statements" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"city_id" uuid NOT NULL,
	"restaurant_id" uuid NOT NULL,
	"restaurant_name" text NOT NULL,
	"cutoff" timestamp with time zone NOT NULL,
	"period_from" timestamp with time zone,
	"created_at" timestamp with time zone NOT NULL,
	"currency" text NOT NULL,
	"orders" integer NOT NULL,
	"items_value" bigint NOT NULL,
	"commission" bigint NOT NULL,
	"discount_share" bigint NOT NULL,
	"exceptions" bigint NOT NULL,
	"week_total" bigint NOT NULL,
	"previous_due" bigint NOT NULL,
	"paid" bigint NOT NULL,
	"earlier_unpaid" bigint NOT NULL,
	"total_due" bigint NOT NULL,
	"journal_ids" uuid[] NOT NULL,
	CONSTRAINT "merchant_statements_sums" CHECK ("cashdesk"."merchant_statements"."orders" >= 0 AND "cashdesk"."merchant_statements"."items_value" >= 0 AND "cashdesk"."merchant_statements"."week_total" = "cashdesk"."merchant_statements"."commission" + "cashdesk"."merchant_statements"."discount_share" + "cashdesk"."merchant_statements"."exceptions" AND "cashdesk"."merchant_statements"."earlier_unpaid" = "cashdesk"."merchant_statements"."previous_due" - "cashdesk"."merchant_statements"."paid" AND "cashdesk"."merchant_statements"."total_due" = "cashdesk"."merchant_statements"."earlier_unpaid" + "cashdesk"."merchant_statements"."week_total"),
	CONSTRAINT "merchant_statements_period" CHECK ("cashdesk"."merchant_statements"."period_from" IS NULL OR "cashdesk"."merchant_statements"."period_from" < "cashdesk"."merchant_statements"."cutoff")
);
--> statement-breakpoint
ALTER TABLE "cashdesk"."merchant_statement_lines" ADD CONSTRAINT "merchant_statement_lines_statement" FOREIGN KEY ("statement_id") REFERENCES "cashdesk"."merchant_statements"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE UNIQUE INDEX "merchant_statements_restaurant_cutoff" ON "cashdesk"."merchant_statements" USING btree ("restaurant_id","cutoff");--> statement-breakpoint
CREATE INDEX "merchant_statements_city_cutoff" ON "cashdesk"."merchant_statements" USING btree ("city_id","cutoff");--> statement-breakpoint
REVOKE UPDATE ON "cashdesk"."merchant_statements" FROM fox_drop_app;--> statement-breakpoint
REVOKE UPDATE ON "cashdesk"."merchant_statement_lines" FROM fox_drop_app;
