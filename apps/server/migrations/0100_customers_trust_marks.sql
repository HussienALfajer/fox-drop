CREATE TABLE "customers"."strike_clears" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"customer_account_id" uuid NOT NULL,
	"at" timestamp with time zone NOT NULL,
	"by" uuid NOT NULL,
	"note" text NOT NULL,
	CONSTRAINT "strike_clears_note" CHECK (length("customers"."strike_clears"."note") BETWEEN 1 AND 500)
);
--> statement-breakpoint
CREATE TABLE "customers"."trust_marks" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"customer_account_id" uuid NOT NULL,
	"trusted" boolean NOT NULL,
	"at" timestamp with time zone NOT NULL,
	"by" uuid NOT NULL,
	"note" text NOT NULL,
	CONSTRAINT "trust_marks_note" CHECK (length("customers"."trust_marks"."note") BETWEEN 1 AND 500)
);
--> statement-breakpoint
ALTER TABLE "customers"."review_stops" ADD COLUMN "end_note" text;--> statement-breakpoint
CREATE INDEX "strike_clears_account_at" ON "customers"."strike_clears" USING btree ("customer_account_id","at");--> statement-breakpoint
CREATE INDEX "trust_marks_account_at" ON "customers"."trust_marks" USING btree ("customer_account_id","at");--> statement-breakpoint
ALTER TABLE "customers"."review_stops" ADD CONSTRAINT "review_stops_end_note" CHECK ("customers"."review_stops"."end_note" IS NULL OR ("customers"."review_stops"."ended_at" IS NOT NULL AND length("customers"."review_stops"."end_note") BETWEEN 1 AND 500)) NOT VALID;--> statement-breakpoint
ALTER TABLE "customers"."review_stops" VALIDATE CONSTRAINT "review_stops_end_note";--> statement-breakpoint
GRANT UPDATE ("end_note") ON "customers"."review_stops" TO fox_drop_app;--> statement-breakpoint
REVOKE UPDATE ON "customers"."strike_clears" FROM fox_drop_app;--> statement-breakpoint
REVOKE UPDATE ON "customers"."trust_marks" FROM fox_drop_app;