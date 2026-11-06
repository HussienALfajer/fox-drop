CREATE SCHEMA "dispatch";
--> statement-breakpoint
GRANT USAGE ON SCHEMA "dispatch" TO fox_drop_app;--> statement-breakpoint
ALTER DEFAULT PRIVILEGES IN SCHEMA "dispatch" GRANT SELECT, INSERT, UPDATE ON TABLES TO fox_drop_app;--> statement-breakpoint
ALTER DEFAULT PRIVILEGES IN SCHEMA "dispatch" GRANT USAGE, SELECT ON SEQUENCES TO fox_drop_app;--> statement-breakpoint
CREATE TABLE "dispatch"."idempotency_keys" (
	"account_id" uuid NOT NULL,
	"key" text NOT NULL,
	"request_hash" text NOT NULL,
	"order_id" uuid NOT NULL,
	"order_placed_at" timestamp with time zone NOT NULL,
	"offer_id" uuid,
	"created_at" timestamp with time zone NOT NULL,
	CONSTRAINT "idempotency_keys_account_id_key_pk" PRIMARY KEY("account_id","key")
);
--> statement-breakpoint
CREATE TABLE "dispatch"."offers" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"city_id" uuid NOT NULL,
	"order_id" uuid NOT NULL,
	"order_placed_at" timestamp with time zone NOT NULL,
	"captain_id" uuid NOT NULL,
	"kind" text NOT NULL,
	"offered_by" uuid,
	"offered_at" timestamp with time zone NOT NULL,
	"expires_at" timestamp with time zone NOT NULL,
	"status" text NOT NULL,
	"responded_at" timestamp with time zone,
	"pickup_metres" integer NOT NULL,
	"pay" bigint,
	"pay_currency" text,
	CONSTRAINT "offers_status_values" CHECK ("status" IN ('open', 'accepted', 'declined', 'expired')),
	CONSTRAINT "offers_kind_values" CHECK ("kind" IN ('manual')),
	CONSTRAINT "offers_manual_by" CHECK ("kind" <> 'manual' OR "offered_by" IS NOT NULL),
	CONSTRAINT "offers_response" CHECK (("status" = 'open') = ("responded_at" IS NULL) AND "expires_at" > "offered_at"),
	CONSTRAINT "offers_pay" CHECK (("pay" IS NULL) = ("pay_currency" IS NULL) AND "pay" >= 0 AND "pickup_metres" >= 0)
);
--> statement-breakpoint
ALTER TABLE "captains"."online_periods" DROP CONSTRAINT "online_periods_end_reason_values";--> statement-breakpoint
CREATE UNIQUE INDEX "offers_one_open_per_order" ON "dispatch"."offers" USING btree ("order_id") WHERE "status" = 'open';--> statement-breakpoint
CREATE UNIQUE INDEX "offers_one_open_per_captain" ON "dispatch"."offers" USING btree ("captain_id") WHERE "status" = 'open';--> statement-breakpoint
CREATE INDEX "offers_captain_offered" ON "dispatch"."offers" USING btree ("captain_id","offered_at" DESC NULLS LAST);--> statement-breakpoint
CREATE INDEX "offers_order" ON "dispatch"."offers" USING btree ("order_id","offered_at");--> statement-breakpoint
ALTER TABLE "captains"."online_periods" ADD CONSTRAINT "online_periods_end_reason_values" CHECK ("end_reason" IN ('captain', 'suspended', 'terminated', 'offers_expired'));