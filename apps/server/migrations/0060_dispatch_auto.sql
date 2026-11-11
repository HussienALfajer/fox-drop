CREATE TABLE "dispatch"."manual_orders" (
	"order_id" uuid PRIMARY KEY NOT NULL,
	"order_placed_at" timestamp with time zone NOT NULL,
	"city_id" uuid NOT NULL,
	"reason" text NOT NULL,
	"failed_offers" integer NOT NULL,
	"at" timestamp with time zone NOT NULL,
	CONSTRAINT "manual_orders_reason_values" CHECK ("dispatch"."manual_orders"."reason" IN ('max_offers', 'no_captain_alert')),
	CONSTRAINT "manual_orders_failed" CHECK ("dispatch"."manual_orders"."failed_offers" >= 0)
);
--> statement-breakpoint
ALTER TABLE "dispatch"."offers" DROP CONSTRAINT "offers_kind_values";--> statement-breakpoint
ALTER TABLE "dispatch"."offers" DROP CONSTRAINT "offers_manual_by";--> statement-breakpoint
ALTER TABLE "dispatch"."offers" ADD CONSTRAINT "offers_kind_values" CHECK ("dispatch"."offers"."kind" IN ('manual', 'auto')) NOT VALID;--> statement-breakpoint
ALTER TABLE "dispatch"."offers" VALIDATE CONSTRAINT "offers_kind_values";--> statement-breakpoint
ALTER TABLE "dispatch"."offers" ADD CONSTRAINT "offers_manual_by" CHECK (("dispatch"."offers"."kind" = 'manual') = ("dispatch"."offers"."offered_by" IS NOT NULL)) NOT VALID;--> statement-breakpoint
ALTER TABLE "dispatch"."offers" VALIDATE CONSTRAINT "offers_manual_by";--> statement-breakpoint
REVOKE UPDATE ON "dispatch"."manual_orders" FROM fox_drop_app;
