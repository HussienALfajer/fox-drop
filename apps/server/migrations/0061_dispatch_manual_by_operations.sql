ALTER TABLE "dispatch"."manual_orders" DROP CONSTRAINT "manual_orders_reason_values";--> statement-breakpoint
ALTER TABLE "dispatch"."manual_orders" ADD COLUMN "by" uuid;--> statement-breakpoint
ALTER TABLE "dispatch"."manual_orders" ADD CONSTRAINT "manual_orders_by" CHECK (("dispatch"."manual_orders"."reason" = 'operations') = ("dispatch"."manual_orders"."by" IS NOT NULL)) NOT VALID;--> statement-breakpoint
ALTER TABLE "dispatch"."manual_orders" VALIDATE CONSTRAINT "manual_orders_by";--> statement-breakpoint
ALTER TABLE "dispatch"."manual_orders" ADD CONSTRAINT "manual_orders_reason_values" CHECK ("dispatch"."manual_orders"."reason" IN ('max_offers', 'no_captain_alert', 'operations')) NOT VALID;--> statement-breakpoint
ALTER TABLE "dispatch"."manual_orders" VALIDATE CONSTRAINT "manual_orders_reason_values";
