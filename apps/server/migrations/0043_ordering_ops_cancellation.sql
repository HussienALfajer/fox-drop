CREATE TABLE "customers"."late_cancel_strikes" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"customer_account_id" uuid NOT NULL,
	"order_id" uuid NOT NULL,
	"city_id" uuid NOT NULL,
	"at" timestamp with time zone NOT NULL
);
--> statement-breakpoint
CREATE TABLE "customers"."review_stops" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"customer_account_id" uuid NOT NULL,
	"started_at" timestamp with time zone NOT NULL,
	"order_id" uuid NOT NULL,
	"ended_at" timestamp with time zone,
	"ended_by" uuid,
	CONSTRAINT "review_stops_end" CHECK (("customers"."review_stops"."ended_at" IS NULL) = ("customers"."review_stops"."ended_by" IS NULL))
);
--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "cancel_reason_label" text;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "cancel_responsible" text;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "cancel_cash" text;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "cancel_merchant_credit" bigint;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "cancel_captain_compensation" bigint;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "cancel_acknowledged_at" timestamp with time zone;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "cancel_acknowledged_by" uuid;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "cancel_acknowledged_device" text;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "cancel_captain_seen_at" timestamp with time zone;--> statement-breakpoint
CREATE UNIQUE INDEX "late_cancel_strikes_order" ON "customers"."late_cancel_strikes" USING btree ("order_id");--> statement-breakpoint
CREATE INDEX "late_cancel_strikes_account_at" ON "customers"."late_cancel_strikes" USING btree ("customer_account_id","at");--> statement-breakpoint
CREATE UNIQUE INDEX "review_stops_one_open" ON "customers"."review_stops" USING btree ("customer_account_id") WHERE "customers"."review_stops"."ended_at" IS NULL;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD CONSTRAINT "orders_ops_cancellation" CHECK (("status" = 'cancelled' OR ("cancel_reason_label" IS NULL AND "cancel_responsible" IS NULL AND "cancel_cash" IS NULL AND "cancel_merchant_credit" IS NULL AND "cancel_captain_compensation" IS NULL AND "cancel_acknowledged_at" IS NULL AND "cancel_captain_seen_at" IS NULL)) AND ("cancel_responsible" IS NULL OR "cancel_responsible" IN ('restaurant', 'captain', 'customer', 'platform')) AND ("cancel_cash" IS NULL OR "cancel_cash" IN ('returned', 'not_returned', 'not_paid')) AND ("cancel_acknowledged_at" IS NULL) = ("cancel_acknowledged_by" IS NULL) AND ("cancel_acknowledged_at" IS NOT NULL OR "cancel_acknowledged_device" IS NULL) AND "cancel_merchant_credit" > 0 AND "cancel_captain_compensation" > 0);--> statement-breakpoint
-- docs/domain/08: a strike is never changed; a review stop only ends.
REVOKE UPDATE ON "customers"."late_cancel_strikes" FROM fox_drop_app;--> statement-breakpoint
REVOKE UPDATE ON "customers"."review_stops" FROM fox_drop_app;--> statement-breakpoint
GRANT UPDATE ("ended_at", "ended_by") ON "customers"."review_stops" TO fox_drop_app;
