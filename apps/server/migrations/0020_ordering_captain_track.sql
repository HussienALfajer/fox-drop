ALTER TABLE "ordering"."order_events" ADD COLUMN "type" text;--> statement-breakpoint
ALTER TABLE "ordering"."order_events" ADD COLUMN "captain_id" uuid;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "captain_track" text;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "search_started_at" timestamp with time zone;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "search_alert_at" timestamp with time zone;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "captain_id" uuid;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "assigned_at" timestamp with time zone;--> statement-breakpoint
CREATE INDEX "orders_captain_status" ON "ordering"."orders" USING btree ("captain_id","status") WHERE "captain_id" IS NOT NULL;--> statement-breakpoint
CREATE INDEX "orders_city_status" ON "ordering"."orders" USING btree ("city_id","status");--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD CONSTRAINT "orders_captain_track_values" CHECK ("captain_track" IS NULL OR "captain_track" IN ('searching', 'offered', 'assigned', 'at_merchant', 'pickup_pending', 'picked_up', 'at_customer', 'done'));--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD CONSTRAINT "orders_captain" CHECK (("captain_id" IS NULL) = ("assigned_at" IS NULL) AND ("captain_id" IS NOT NULL) = ("captain_track" IS NOT NULL AND "captain_track" NOT IN ('searching', 'offered')) AND ("search_started_at" IS NULL) = ("search_alert_at" IS NULL) AND ("captain_track" <> 'searching' OR "search_started_at" IS NOT NULL));