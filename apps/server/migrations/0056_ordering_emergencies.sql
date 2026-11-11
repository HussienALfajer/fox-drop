CREATE TABLE "ordering"."emergencies" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"order_id" uuid NOT NULL,
	"order_placed_at" timestamp with time zone NOT NULL,
	"city_id" uuid NOT NULL,
	"captain_id" uuid NOT NULL,
	"location" geometry(Point,4326),
	"accuracy_metres" real,
	"located_at" timestamp with time zone,
	"simulated" boolean,
	"raised_at" timestamp with time zone NOT NULL,
	"closed_at" timestamp with time zone,
	"closed_how" text,
	CONSTRAINT "emergencies_closed" CHECK (("ordering"."emergencies"."closed_at" IS NULL) = ("ordering"."emergencies"."closed_how" IS NULL)
        AND ("ordering"."emergencies"."closed_how" IS NULL OR "ordering"."emergencies"."closed_how" IN ('reassigned', 'handed_over', 'ended'))),
	CONSTRAINT "emergencies_location" CHECK (("ordering"."emergencies"."location" IS NULL) = ("ordering"."emergencies"."accuracy_metres" IS NULL)
        AND ("ordering"."emergencies"."location" IS NULL) = ("ordering"."emergencies"."located_at" IS NULL)
        AND ("ordering"."emergencies"."location" IS NULL) = ("ordering"."emergencies"."simulated" IS NULL)
        AND ("ordering"."emergencies"."accuracy_metres" IS NULL OR "ordering"."emergencies"."accuracy_metres" >= 0))
);
--> statement-breakpoint
ALTER TABLE "captains"."online_periods" DROP CONSTRAINT "online_periods_end_reason_values";--> statement-breakpoint
ALTER TABLE "ordering"."emergencies" ADD CONSTRAINT "emergencies_order_id_order_placed_at_orders_id_placed_at_fk" FOREIGN KEY ("order_id","order_placed_at") REFERENCES "ordering"."orders"("id","placed_at") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE UNIQUE INDEX "emergencies_one_open_per_order" ON "ordering"."emergencies" USING btree ("order_id") WHERE "ordering"."emergencies"."closed_at" IS NULL;--> statement-breakpoint
CREATE INDEX "emergencies_order" ON "ordering"."emergencies" USING btree ("order_id","order_placed_at");--> statement-breakpoint
CREATE INDEX "emergencies_captain" ON "ordering"."emergencies" USING btree ("captain_id","raised_at");--> statement-breakpoint
ALTER TABLE "captains"."online_periods" ADD CONSTRAINT "online_periods_end_reason_values" CHECK ("captains"."online_periods"."end_reason" IN ('captain', 'suspended', 'terminated', 'offers_expired', 'handed_over', 'last_order', 'forced', 'cannot_complete', 'emergency'));--> statement-breakpoint
REVOKE UPDATE ON "ordering"."emergencies" FROM fox_drop_app;--> statement-breakpoint
GRANT UPDATE ("closed_at", "closed_how") ON "ordering"."emergencies" TO fox_drop_app;