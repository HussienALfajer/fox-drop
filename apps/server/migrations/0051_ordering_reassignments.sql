CREATE TABLE "ordering"."reassignments" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"order_id" uuid NOT NULL,
	"order_placed_at" timestamp with time zone NOT NULL,
	"city_id" uuid NOT NULL,
	"captain_id" uuid NOT NULL,
	"reason" text NOT NULL,
	"reason_label" text NOT NULL,
	"captain_fault" boolean NOT NULL,
	"cash" text,
	"note" text NOT NULL,
	"admin_id" uuid NOT NULL,
	"at" timestamp with time zone NOT NULL,
	"captain_seen_at" timestamp with time zone,
	CONSTRAINT "reassignments_cash" CHECK ("ordering"."reassignments"."cash" IS NULL OR "ordering"."reassignments"."cash" IN ('returned', 'not_returned', 'not_paid'))
);
--> statement-breakpoint
ALTER TABLE "ordering"."reassignments" ADD CONSTRAINT "reassignments_order_id_order_placed_at_orders_id_placed_at_fk" FOREIGN KEY ("order_id","order_placed_at") REFERENCES "ordering"."orders"("id","placed_at") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "reassignments_order" ON "ordering"."reassignments" USING btree ("order_id","order_placed_at");--> statement-breakpoint
CREATE INDEX "reassignments_captain" ON "ordering"."reassignments" USING btree ("captain_id","at");--> statement-breakpoint
REVOKE UPDATE ON "ordering"."reassignments" FROM fox_drop_app;--> statement-breakpoint
GRANT UPDATE ("captain_seen_at") ON "ordering"."reassignments" TO fox_drop_app;
