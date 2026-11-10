CREATE TABLE "ordering"."handovers" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"order_id" uuid NOT NULL,
	"order_placed_at" timestamp with time zone NOT NULL,
	"city_id" uuid NOT NULL,
	"from_captain_id" uuid NOT NULL,
	"to_captain_id" uuid NOT NULL,
	"offer_id" uuid,
	"note" text NOT NULL,
	"admin_id" uuid NOT NULL,
	"opened_at" timestamp with time zone NOT NULL,
	"assigned_at" timestamp with time zone,
	"received_at" timestamp with time zone,
	"closed_at" timestamp with time zone,
	"close_reason" text,
	"from_seen_at" timestamp with time zone,
	CONSTRAINT "handovers_two_captains" CHECK ("ordering"."handovers"."from_captain_id" <> "ordering"."handovers"."to_captain_id"),
	CONSTRAINT "handovers_close" CHECK (("ordering"."handovers"."closed_at" IS NULL) = ("ordering"."handovers"."close_reason" IS NULL)
        AND ("ordering"."handovers"."close_reason" IS NULL OR "ordering"."handovers"."close_reason" IN ('declined', 'expired', 'withdrawn', 'ended', 'replaced'))),
	CONSTRAINT "handovers_steps" CHECK (("ordering"."handovers"."received_at" IS NULL OR ("ordering"."handovers"."assigned_at" IS NOT NULL AND "ordering"."handovers"."closed_at" IS NULL))
        AND ("ordering"."handovers"."offer_id" IS NOT NULL OR "ordering"."handovers"."assigned_at" IS NOT NULL)
        AND ("ordering"."handovers"."from_seen_at" IS NULL OR "ordering"."handovers"."received_at" IS NOT NULL))
);
--> statement-breakpoint
ALTER TABLE "captains"."online_periods" DROP CONSTRAINT "online_periods_end_reason_values";--> statement-breakpoint
ALTER TABLE "dispatch"."offers" ADD COLUMN "handover" boolean DEFAULT false NOT NULL;--> statement-breakpoint
ALTER TABLE "ordering"."handovers" ADD CONSTRAINT "handovers_order_id_order_placed_at_orders_id_placed_at_fk" FOREIGN KEY ("order_id","order_placed_at") REFERENCES "ordering"."orders"("id","placed_at") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE UNIQUE INDEX "handovers_one_open_per_order" ON "ordering"."handovers" USING btree ("order_id") WHERE "ordering"."handovers"."received_at" IS NULL AND "ordering"."handovers"."closed_at" IS NULL;--> statement-breakpoint
CREATE INDEX "handovers_order" ON "ordering"."handovers" USING btree ("order_id","order_placed_at");--> statement-breakpoint
CREATE INDEX "handovers_to_captain" ON "ordering"."handovers" USING btree ("to_captain_id","opened_at");--> statement-breakpoint
CREATE INDEX "handovers_from_captain" ON "ordering"."handovers" USING btree ("from_captain_id","opened_at");--> statement-breakpoint
ALTER TABLE "captains"."online_periods" ADD CONSTRAINT "online_periods_end_reason_values" CHECK ("captains"."online_periods"."end_reason" IN ('captain', 'suspended', 'terminated', 'offers_expired', 'handed_over'));--> statement-breakpoint
REVOKE UPDATE ON "ordering"."handovers" FROM fox_drop_app;--> statement-breakpoint
GRANT UPDATE ("assigned_at", "received_at", "closed_at", "close_reason", "from_seen_at") ON "ordering"."handovers" TO fox_drop_app;