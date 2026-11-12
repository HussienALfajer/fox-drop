CREATE SCHEMA "cashdesk";
--> statement-breakpoint
GRANT USAGE ON SCHEMA "cashdesk" TO fox_drop_app;
--> statement-breakpoint
ALTER DEFAULT PRIVILEGES IN SCHEMA "cashdesk" GRANT SELECT, INSERT, UPDATE ON TABLES TO fox_drop_app;
--> statement-breakpoint
ALTER DEFAULT PRIVILEGES IN SCHEMA "cashdesk" GRANT USAGE, SELECT ON SEQUENCES TO fox_drop_app;
--> statement-breakpoint
CREATE TABLE "cashdesk"."drawer_session_currencies" (
	"session_id" uuid NOT NULL,
	"currency" text NOT NULL,
	"opening_float" bigint NOT NULL,
	"expected" bigint,
	"counted" bigint,
	CONSTRAINT "drawer_session_currencies_session_id_currency_pk" PRIMARY KEY("session_id","currency"),
	CONSTRAINT "drawer_session_currencies_float" CHECK ("cashdesk"."drawer_session_currencies"."opening_float" >= 0),
	CONSTRAINT "drawer_session_currencies_counted" CHECK ("cashdesk"."drawer_session_currencies"."counted" IS NULL OR "cashdesk"."drawer_session_currencies"."counted" >= 0),
	CONSTRAINT "drawer_session_currencies_closed" CHECK (("cashdesk"."drawer_session_currencies"."expected" IS NULL) = ("cashdesk"."drawer_session_currencies"."counted" IS NULL))
);
--> statement-breakpoint
CREATE TABLE "cashdesk"."drawer_sessions" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"city_id" uuid NOT NULL,
	"admin_account_id" uuid NOT NULL,
	"kind" text NOT NULL,
	"opened_at" timestamp with time zone NOT NULL,
	"closed_at" timestamp with time zone,
	"close_note" text,
	CONSTRAINT "drawer_sessions_kind_values" CHECK ("cashdesk"."drawer_sessions"."kind" IN ('office')),
	CONSTRAINT "drawer_sessions_note_when_closed" CHECK ("cashdesk"."drawer_sessions"."close_note" IS NULL OR "cashdesk"."drawer_sessions"."closed_at" IS NOT NULL)
);
--> statement-breakpoint
CREATE TABLE "cashdesk"."idempotency_keys" (
	"account_id" uuid NOT NULL,
	"key" text NOT NULL,
	"request_hash" text NOT NULL,
	"receipt_ids" uuid[] NOT NULL,
	"created_at" timestamp with time zone NOT NULL,
	CONSTRAINT "idempotency_keys_account_id_key_pk" PRIMARY KEY("account_id","key")
);
--> statement-breakpoint
CREATE TABLE "cashdesk"."receipt_counters" (
	"city_id" uuid NOT NULL,
	"year" integer NOT NULL,
	"last_number" integer NOT NULL,
	CONSTRAINT "receipt_counters_city_id_year_pk" PRIMARY KEY("city_id","year"),
	CONSTRAINT "receipt_counters_last" CHECK ("cashdesk"."receipt_counters"."last_number" > 0)
);
--> statement-breakpoint
CREATE TABLE "cashdesk"."receipt_lines" (
	"receipt_id" uuid NOT NULL,
	"currency" text NOT NULL,
	"expected" bigint NOT NULL,
	"amount" bigint NOT NULL,
	"journal_id" uuid NOT NULL,
	CONSTRAINT "receipt_lines_receipt_id_currency_pk" PRIMARY KEY("receipt_id","currency"),
	CONSTRAINT "receipt_lines_amount" CHECK ("cashdesk"."receipt_lines"."amount" > 0)
);
--> statement-breakpoint
CREATE TABLE "cashdesk"."receipts" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"city_id" uuid NOT NULL,
	"year" integer NOT NULL,
	"sequence" integer NOT NULL,
	"number" text NOT NULL,
	"type" text NOT NULL,
	"session_id" uuid NOT NULL,
	"admin_account_id" uuid NOT NULL,
	"captain_id" uuid NOT NULL,
	"captain_name" text NOT NULL,
	"created_at" timestamp with time zone NOT NULL,
	CONSTRAINT "receipts_sequence" CHECK ("cashdesk"."receipts"."sequence" > 0),
	CONSTRAINT "receipts_type_values" CHECK ("cashdesk"."receipts"."type" IN ('captain_hand_in', 'captain_reimbursement'))
);
--> statement-breakpoint
ALTER TABLE "ledger"."journals" DROP CONSTRAINT "journals_source_kind_values";--> statement-breakpoint
ALTER TABLE "cashdesk"."drawer_session_currencies" ADD CONSTRAINT "drawer_session_currencies_session" FOREIGN KEY ("session_id") REFERENCES "cashdesk"."drawer_sessions"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "cashdesk"."receipt_lines" ADD CONSTRAINT "receipt_lines_receipt" FOREIGN KEY ("receipt_id") REFERENCES "cashdesk"."receipts"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "cashdesk"."receipts" ADD CONSTRAINT "receipts_session_fk" FOREIGN KEY ("session_id") REFERENCES "cashdesk"."drawer_sessions"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE UNIQUE INDEX "drawer_sessions_one_open" ON "cashdesk"."drawer_sessions" USING btree ("admin_account_id","kind") WHERE "cashdesk"."drawer_sessions"."closed_at" IS NULL;--> statement-breakpoint
CREATE INDEX "drawer_sessions_city_opened" ON "cashdesk"."drawer_sessions" USING btree ("city_id","opened_at");--> statement-breakpoint
CREATE UNIQUE INDEX "receipts_city_year_sequence" ON "cashdesk"."receipts" USING btree ("city_id","year","sequence");--> statement-breakpoint
CREATE UNIQUE INDEX "receipts_number" ON "cashdesk"."receipts" USING btree ("number");--> statement-breakpoint
CREATE INDEX "receipts_session" ON "cashdesk"."receipts" USING btree ("session_id");--> statement-breakpoint
CREATE INDEX "receipts_captain_created" ON "cashdesk"."receipts" USING btree ("captain_id","created_at");--> statement-breakpoint
ALTER TABLE "ledger"."journals" ADD CONSTRAINT "journals_source_kind_values" CHECK ("ledger"."journals"."source_kind" IS NULL OR "ledger"."journals"."source_kind" IN ('order', 'receipt')) NOT VALID;--> statement-breakpoint
ALTER TABLE "ledger"."journals" VALIDATE CONSTRAINT "journals_source_kind_values";--> statement-breakpoint
-- AP §9.10.3: a receipt and its lines are never changed.
REVOKE UPDATE ON "cashdesk"."receipts", "cashdesk"."receipt_lines" FROM fox_drop_app;