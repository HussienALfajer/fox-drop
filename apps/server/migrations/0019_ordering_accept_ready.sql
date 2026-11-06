ALTER TABLE "ordering"."order_events" ADD COLUMN "actor_device" text;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "trip_seconds" integer;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "trip_metres" integer;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "accepted_at" timestamp with time zone;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "prep_min" smallint;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "promised_at" timestamp with time zone;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "search_start_at" timestamp with time zone;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "prep_late_alert_at" timestamp with time zone;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "ready_at" timestamp with time zone;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "no_captain_alert_at" timestamp with time zone;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD CONSTRAINT "orders_acceptance" CHECK (("accepted_at" IS NULL) = ("prep_min" IS NULL) AND ("accepted_at" IS NULL) = ("promised_at" IS NULL) AND ("accepted_at" IS NULL) = ("search_start_at" IS NULL) AND ("accepted_at" IS NULL) = ("prep_late_alert_at" IS NULL) AND "prep_min" > 0);--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD CONSTRAINT "orders_accepted_states" CHECK ("status" NOT IN ('accepted', 'ready', 'picked_up', 'arrived', 'delivered', 'failed') OR "accepted_at" IS NOT NULL);--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD CONSTRAINT "orders_ready" CHECK ("status" <> 'ready' OR "ready_at" IS NOT NULL);--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD CONSTRAINT "orders_trip" CHECK (("trip_seconds" IS NULL) = ("trip_metres" IS NULL) AND "trip_seconds" >= 0 AND "trip_metres" >= 0);