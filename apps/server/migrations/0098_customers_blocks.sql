CREATE TABLE "customers"."blocks" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"customer_account_id" uuid NOT NULL,
	"kind" text NOT NULL,
	"reason" text NOT NULL,
	"reason_label" text NOT NULL,
	"customer_text" text NOT NULL,
	"note" text NOT NULL,
	"until" timestamp with time zone,
	"city_id" uuid,
	"dues_amount" bigint,
	"dues_currency" text,
	"dues_journal_id" uuid,
	"started_at" timestamp with time zone NOT NULL,
	"started_by" uuid NOT NULL,
	"ended_at" timestamp with time zone,
	"ended_by" uuid,
	"end_note" text,
	"idempotency_key" text NOT NULL,
	"request_hash" text NOT NULL,
	CONSTRAINT "blocks_kind_values" CHECK ("customers"."blocks"."kind" IN ('until', 'indefinite', 'dues')),
	CONSTRAINT "blocks_until" CHECK (("customers"."blocks"."kind" = 'until') = ("customers"."blocks"."until" IS NOT NULL)),
	CONSTRAINT "blocks_dues" CHECK (CASE WHEN "customers"."blocks"."kind" = 'dues' THEN "customers"."blocks"."city_id" IS NOT NULL AND "customers"."blocks"."dues_amount" > 0 AND "customers"."blocks"."dues_currency" IS NOT NULL AND "customers"."blocks"."dues_journal_id" IS NOT NULL AND "customers"."blocks"."ended_at" IS NULL ELSE "customers"."blocks"."city_id" IS NULL AND "customers"."blocks"."dues_amount" IS NULL AND "customers"."blocks"."dues_currency" IS NULL AND "customers"."blocks"."dues_journal_id" IS NULL END),
	CONSTRAINT "blocks_end" CHECK (("customers"."blocks"."ended_at" IS NOT NULL OR ("customers"."blocks"."ended_by" IS NULL AND "customers"."blocks"."end_note" IS NULL)) AND ("customers"."blocks"."ended_by" IS NULL) = ("customers"."blocks"."end_note" IS NULL)),
	CONSTRAINT "blocks_note" CHECK (length("customers"."blocks"."note") BETWEEN 1 AND 500)
);
--> statement-breakpoint
CREATE UNIQUE INDEX "blocks_key" ON "customers"."blocks" USING btree ("started_by","idempotency_key");--> statement-breakpoint
CREATE INDEX "blocks_account" ON "customers"."blocks" USING btree ("customer_account_id","started_at");--> statement-breakpoint
CREATE UNIQUE INDEX "blocks_one_open" ON "customers"."blocks" USING btree ("customer_account_id") WHERE "customers"."blocks"."ended_at" IS NULL AND "customers"."blocks"."kind" <> 'dues';--> statement-breakpoint
-- AP §9.8: a block only ends («فك الحظر», or closed at its time when the next starts).
REVOKE UPDATE ON "customers"."blocks" FROM fox_drop_app;--> statement-breakpoint
GRANT UPDATE ("ended_at", "ended_by", "end_note") ON "customers"."blocks" TO fox_drop_app;
