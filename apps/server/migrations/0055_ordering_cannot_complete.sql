CREATE TABLE "ordering"."cannot_complete_requests" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"order_id" uuid NOT NULL,
	"order_placed_at" timestamp with time zone NOT NULL,
	"city_id" uuid NOT NULL,
	"captain_id" uuid NOT NULL,
	"reason" text NOT NULL,
	"reason_label" text NOT NULL,
	"note" text,
	"requested_at" timestamp with time zone NOT NULL,
	"closed_at" timestamp with time zone,
	"closed_how" text,
	CONSTRAINT "cannot_complete_requests_closed" CHECK (("ordering"."cannot_complete_requests"."closed_at" IS NULL) = ("ordering"."cannot_complete_requests"."closed_how" IS NULL)
        AND ("ordering"."cannot_complete_requests"."closed_how" IS NULL OR "ordering"."cannot_complete_requests"."closed_how" IN ('withdrawn', 'reassigned', 'handed_over', 'ended')))
);
--> statement-breakpoint
ALTER TABLE "captains"."online_periods" DROP CONSTRAINT "online_periods_end_reason_values";--> statement-breakpoint
ALTER TABLE "ordering"."handovers" ADD COLUMN "captain_fault" boolean;--> statement-breakpoint
ALTER TABLE "ordering"."cannot_complete_requests" ADD CONSTRAINT "cannot_complete_requests_order_id_order_placed_at_orders_id_placed_at_fk" FOREIGN KEY ("order_id","order_placed_at") REFERENCES "ordering"."orders"("id","placed_at") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE UNIQUE INDEX "cannot_complete_requests_one_open_per_order" ON "ordering"."cannot_complete_requests" USING btree ("order_id") WHERE "ordering"."cannot_complete_requests"."closed_at" IS NULL;--> statement-breakpoint
CREATE INDEX "cannot_complete_requests_order" ON "ordering"."cannot_complete_requests" USING btree ("order_id","order_placed_at");--> statement-breakpoint
CREATE INDEX "cannot_complete_requests_captain" ON "ordering"."cannot_complete_requests" USING btree ("captain_id","requested_at");--> statement-breakpoint
ALTER TABLE "captains"."online_periods" ADD CONSTRAINT "online_periods_end_reason_values" CHECK ("captains"."online_periods"."end_reason" IN ('captain', 'suspended', 'terminated', 'offers_expired', 'handed_over', 'last_order', 'forced', 'cannot_complete'));--> statement-breakpoint
REVOKE UPDATE ON "ordering"."cannot_complete_requests" FROM fox_drop_app;--> statement-breakpoint
GRANT UPDATE ("closed_at", "closed_how") ON "ordering"."cannot_complete_requests" TO fox_drop_app;
