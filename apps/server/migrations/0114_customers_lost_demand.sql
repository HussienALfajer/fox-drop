CREATE TABLE "customers"."restaurant_suggestions" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"city_id" uuid NOT NULL,
	"zone_id" uuid NOT NULL,
	"restaurant_name" text NOT NULL,
	"note" text,
	"query" text,
	"customer_account_id" uuid,
	"at" timestamp with time zone NOT NULL,
	"idempotency_key" text NOT NULL,
	"request_hash" text NOT NULL,
	CONSTRAINT "restaurant_suggestions_name" CHECK (length("customers"."restaurant_suggestions"."restaurant_name") BETWEEN 1 AND 60),
	CONSTRAINT "restaurant_suggestions_note" CHECK (length("customers"."restaurant_suggestions"."note") BETWEEN 1 AND 200),
	CONSTRAINT "restaurant_suggestions_query" CHECK (length("customers"."restaurant_suggestions"."query") BETWEEN 1 AND 50)
);
--> statement-breakpoint
CREATE TABLE "customers"."search_misses" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"city_id" uuid NOT NULL,
	"zone_id" uuid NOT NULL,
	"query" text NOT NULL,
	"normalized" text NOT NULL,
	"customer_account_id" uuid,
	"at" timestamp with time zone NOT NULL,
	CONSTRAINT "search_misses_query" CHECK (length("customers"."search_misses"."query") BETWEEN 1 AND 50)
);
--> statement-breakpoint
CREATE UNIQUE INDEX "restaurant_suggestions_key" ON "customers"."restaurant_suggestions" USING btree ("idempotency_key");--> statement-breakpoint
CREATE INDEX "restaurant_suggestions_city_at" ON "customers"."restaurant_suggestions" USING btree ("city_id","at");--> statement-breakpoint
CREATE INDEX "search_misses_city_at" ON "customers"."search_misses" USING btree ("city_id","at");--> statement-breakpoint
REVOKE UPDATE ON "customers"."restaurant_suggestions" FROM fox_drop_app;--> statement-breakpoint
REVOKE UPDATE ON "customers"."search_misses" FROM fox_drop_app;
