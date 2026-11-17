CREATE TABLE "customers"."notes" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"customer_account_id" uuid NOT NULL,
	"body" text NOT NULL,
	"author_id" uuid NOT NULL,
	"created_at" timestamp with time zone NOT NULL,
	"idempotency_key" text NOT NULL,
	"request_hash" text NOT NULL,
	CONSTRAINT "notes_body" CHECK (length("customers"."notes"."body") BETWEEN 1 AND 500)
);
--> statement-breakpoint
CREATE UNIQUE INDEX "notes_key" ON "customers"."notes" USING btree ("author_id","idempotency_key");--> statement-breakpoint
CREATE INDEX "notes_account" ON "customers"."notes" USING btree ("customer_account_id","created_at");--> statement-breakpoint
REVOKE UPDATE ON "customers"."notes" FROM fox_drop_app;
