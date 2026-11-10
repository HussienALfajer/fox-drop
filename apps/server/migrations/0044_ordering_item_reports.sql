CREATE TABLE "ordering"."item_reports" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"order_id" uuid NOT NULL,
	"order_placed_at" timestamp with time zone NOT NULL,
	"city_id" uuid NOT NULL,
	"items" jsonb NOT NULL,
	"note" text,
	"note_label" text,
	"account_id" uuid NOT NULL,
	"device" text NOT NULL,
	"reported_at" timestamp with time zone NOT NULL,
	"closed_at" timestamp with time zone,
	"closed_how" text,
	"closed_by_type" text,
	"closed_by_id" uuid,
	"close_reason" text,
	CONSTRAINT "item_reports_note_label" CHECK (("ordering"."item_reports"."note" IS NULL) = ("ordering"."item_reports"."note_label" IS NULL)),
	CONSTRAINT "item_reports_closed" CHECK (("ordering"."item_reports"."closed_at" IS NULL) = ("ordering"."item_reports"."closed_how" IS NULL) AND ("ordering"."item_reports"."closed_how" IS NULL OR "ordering"."item_reports"."closed_how" IN ('withdrawn', 'closed', 'cancelled')) AND ("ordering"."item_reports"."closed_how" IS NOT DISTINCT FROM 'closed') = ("ordering"."item_reports"."close_reason" IS NOT NULL) AND ("ordering"."item_reports"."closed_how" IS NULL OR ("ordering"."item_reports"."closed_by_type" IS NOT NULL AND "ordering"."item_reports"."closed_by_id" IS NOT NULL)))
);
--> statement-breakpoint
CREATE TABLE "ordering"."time_changes" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"order_id" uuid NOT NULL,
	"order_placed_at" timestamp with time zone NOT NULL,
	"city_id" uuid NOT NULL,
	"at" timestamp with time zone NOT NULL,
	"admin_id" uuid NOT NULL,
	"add_min" smallint NOT NULL,
	"promised_before" timestamp with time zone NOT NULL,
	"promised_after" timestamp with time zone NOT NULL,
	"prep_min_before" smallint NOT NULL,
	"prep_min_after" smallint NOT NULL,
	CONSTRAINT "time_changes_moved" CHECK ("ordering"."time_changes"."add_min" > 0 AND "ordering"."time_changes"."promised_after" > "ordering"."time_changes"."promised_before" AND "ordering"."time_changes"."prep_min_after" >= "ordering"."time_changes"."prep_min_before")
);
--> statement-breakpoint
ALTER TABLE "ordering"."item_reports" ADD CONSTRAINT "item_reports_order_id_order_placed_at_orders_id_placed_at_fk" FOREIGN KEY ("order_id","order_placed_at") REFERENCES "ordering"."orders"("id","placed_at") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "ordering"."time_changes" ADD CONSTRAINT "time_changes_order_id_order_placed_at_orders_id_placed_at_fk" FOREIGN KEY ("order_id","order_placed_at") REFERENCES "ordering"."orders"("id","placed_at") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE UNIQUE INDEX "item_reports_one_open_per_order" ON "ordering"."item_reports" USING btree ("order_id") WHERE "ordering"."item_reports"."closed_at" IS NULL;--> statement-breakpoint
CREATE INDEX "item_reports_order" ON "ordering"."item_reports" USING btree ("order_id","order_placed_at");--> statement-breakpoint
CREATE INDEX "time_changes_order" ON "ordering"."time_changes" USING btree ("order_id","order_placed_at");--> statement-breakpoint
-- An item report changes only when it closes; a time change never.
REVOKE UPDATE ON "ordering"."item_reports" FROM fox_drop_app;--> statement-breakpoint
GRANT UPDATE ("closed_at", "closed_how", "closed_by_type", "closed_by_id", "close_reason") ON "ordering"."item_reports" TO fox_drop_app;--> statement-breakpoint
REVOKE UPDATE ON "ordering"."time_changes" FROM fox_drop_app;
