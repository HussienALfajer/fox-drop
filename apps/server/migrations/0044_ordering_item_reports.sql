CREATE TABLE "ordering"."item_reports" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"order_id" uuid NOT NULL,
	"order_placed_at" timestamp with time zone NOT NULL,
	"city_id" uuid NOT NULL,
	"items" jsonb NOT NULL,
	"note" text,
	"account_id" uuid NOT NULL,
	"device" text NOT NULL,
	"reported_at" timestamp with time zone NOT NULL,
	"closed_at" timestamp with time zone,
	"closed_how" text,
	"closed_by_type" text,
	"closed_by_id" uuid,
	"close_reason" text,
	CONSTRAINT "item_reports_note_values" CHECK ("ordering"."item_reports"."note" IS NULL OR "ordering"."item_reports"."note" IN ('similar_substitute', 'not_enough')),
	CONSTRAINT "item_reports_closed" CHECK (("ordering"."item_reports"."closed_at" IS NULL) = ("ordering"."item_reports"."closed_how" IS NULL) AND ("ordering"."item_reports"."closed_how" IS NULL OR "ordering"."item_reports"."closed_how" IN ('withdrawn', 'closed', 'cancelled')) AND ("ordering"."item_reports"."closed_how" IS NOT DISTINCT FROM 'closed') = ("ordering"."item_reports"."close_reason" IS NOT NULL) AND ("ordering"."item_reports"."closed_how" IS NULL OR ("ordering"."item_reports"."closed_by_type" IS NOT NULL AND "ordering"."item_reports"."closed_by_id" IS NOT NULL)))
);
--> statement-breakpoint
ALTER TABLE "ordering"."item_reports" ADD CONSTRAINT "item_reports_order_id_order_placed_at_orders_id_placed_at_fk" FOREIGN KEY ("order_id","order_placed_at") REFERENCES "ordering"."orders"("id","placed_at") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE UNIQUE INDEX "item_reports_one_open_per_order" ON "ordering"."item_reports" USING btree ("order_id") WHERE "ordering"."item_reports"."closed_at" IS NULL;--> statement-breakpoint
CREATE INDEX "item_reports_order" ON "ordering"."item_reports" USING btree ("order_id","order_placed_at");