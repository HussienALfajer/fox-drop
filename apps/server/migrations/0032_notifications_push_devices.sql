CREATE TABLE "notifications"."push_devices" (
	"session_id" uuid PRIMARY KEY NOT NULL,
	"party" text NOT NULL,
	"account_id" uuid NOT NULL,
	"restaurant_id" uuid,
	"merchant_role" text,
	"captain_id" uuid,
	"platform" text NOT NULL,
	"token" text NOT NULL,
	"registered_at" timestamp with time zone NOT NULL,
	"ended_at" timestamp with time zone,
	"end_reason" text,
	CONSTRAINT "push_devices_party" CHECK ("notifications"."push_devices"."party" IN ('customer', 'merchant', 'captain')),
	CONSTRAINT "push_devices_platform" CHECK ("notifications"."push_devices"."platform" IN ('android')),
	CONSTRAINT "push_devices_merchant" CHECK (("notifications"."push_devices"."party" = 'merchant') = ("notifications"."push_devices"."restaurant_id" IS NOT NULL AND "notifications"."push_devices"."merchant_role" IS NOT NULL)),
	CONSTRAINT "push_devices_captain" CHECK (("notifications"."push_devices"."party" = 'captain') = ("notifications"."push_devices"."captain_id" IS NOT NULL)),
	CONSTRAINT "push_devices_ended" CHECK (("notifications"."push_devices"."ended_at" IS NULL) = ("notifications"."push_devices"."end_reason" IS NULL) AND ("notifications"."push_devices"."end_reason" IS NULL OR "notifications"."push_devices"."end_reason" IN ('token_invalid', 'token_moved'))),
	CONSTRAINT "push_devices_token" CHECK (length("notifications"."push_devices"."token") BETWEEN 1 AND 4096)
);
--> statement-breakpoint
CREATE UNIQUE INDEX "push_devices_token_live" ON "notifications"."push_devices" USING btree ("token") WHERE "notifications"."push_devices"."ended_at" IS NULL;--> statement-breakpoint
CREATE INDEX "push_devices_account" ON "notifications"."push_devices" USING btree ("party","account_id") WHERE "notifications"."push_devices"."ended_at" IS NULL;--> statement-breakpoint
CREATE INDEX "push_devices_restaurant" ON "notifications"."push_devices" USING btree ("restaurant_id") WHERE "notifications"."push_devices"."ended_at" IS NULL;--> statement-breakpoint
CREATE INDEX "push_devices_captain" ON "notifications"."push_devices" USING btree ("captain_id") WHERE "notifications"."push_devices"."ended_at" IS NULL;