CREATE TABLE "ordering"."order_edits" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"order_id" uuid NOT NULL,
	"order_placed_at" timestamp with time zone NOT NULL,
	"city_id" uuid NOT NULL,
	"at" timestamp with time zone NOT NULL,
	"admin_id" uuid NOT NULL,
	"status" text NOT NULL,
	"changes" jsonb NOT NULL,
	"adds_items" boolean NOT NULL,
	"currency" text NOT NULL,
	"items_value_before" bigint NOT NULL,
	"items_value_after" bigint NOT NULL,
	"delivery_fee_before" bigint NOT NULL,
	"delivery_fee_after" bigint NOT NULL,
	"total_before" bigint NOT NULL,
	"total_after" bigint NOT NULL,
	"extra_prep_min" smallint,
	"prep_min_before" smallint,
	"prep_min_after" smallint,
	"promised_before" timestamp with time zone,
	"promised_after" timestamp with time zone,
	"acknowledged_at" timestamp with time zone,
	"acknowledged_by" uuid,
	"acknowledged_device" text,
	CONSTRAINT "order_edits_status" CHECK ("ordering"."order_edits"."status" IN ('placed', 'accepted', 'ready')),
	CONSTRAINT "order_edits_money" CHECK ("ordering"."order_edits"."items_value_before" >= 0 AND "ordering"."order_edits"."items_value_after" > 0 AND "ordering"."order_edits"."delivery_fee_before" >= 0 AND "ordering"."order_edits"."delivery_fee_after" >= 0 AND "ordering"."order_edits"."total_before" >= 0 AND "ordering"."order_edits"."total_after" >= 0),
	CONSTRAINT "order_edits_back_to_preparing" CHECK (("ordering"."order_edits"."extra_prep_min" IS NULL) = ("ordering"."order_edits"."prep_min_before" IS NULL) AND ("ordering"."order_edits"."extra_prep_min" IS NULL) = ("ordering"."order_edits"."prep_min_after" IS NULL) AND ("ordering"."order_edits"."extra_prep_min" IS NULL) = ("ordering"."order_edits"."promised_before" IS NULL) AND ("ordering"."order_edits"."extra_prep_min" IS NULL) = ("ordering"."order_edits"."promised_after" IS NULL) AND "ordering"."order_edits"."extra_prep_min" > 0 AND ("ordering"."order_edits"."extra_prep_min" IS NULL OR ("ordering"."order_edits"."status" = 'ready' AND "ordering"."order_edits"."adds_items"))),
	CONSTRAINT "order_edits_acknowledged" CHECK (("ordering"."order_edits"."acknowledged_at" IS NULL) = ("ordering"."order_edits"."acknowledged_by" IS NULL) AND ("ordering"."order_edits"."acknowledged_at" IS NULL) = ("ordering"."order_edits"."acknowledged_device" IS NULL))
);
--> statement-breakpoint
ALTER TABLE "ordering"."item_reports" DROP CONSTRAINT "item_reports_closed";--> statement-breakpoint
ALTER TABLE "ordering"."order_lines" ADD COLUMN "added_by_edit" uuid;--> statement-breakpoint
ALTER TABLE "ordering"."order_lines" ADD COLUMN "removed_by_edit" uuid;--> statement-breakpoint
ALTER TABLE "ordering"."order_lines" ADD COLUMN "quantity_before" smallint;--> statement-breakpoint
ALTER TABLE "ordering"."order_edits" ADD CONSTRAINT "order_edits_order_id_order_placed_at_orders_id_placed_at_fk" FOREIGN KEY ("order_id","order_placed_at") REFERENCES "ordering"."orders"("id","placed_at") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "order_edits_order" ON "ordering"."order_edits" USING btree ("order_id","order_placed_at");--> statement-breakpoint
CREATE INDEX "order_edits_unacknowledged" ON "ordering"."order_edits" USING btree ("order_id") WHERE "ordering"."order_edits"."acknowledged_at" IS NULL;--> statement-breakpoint
ALTER TABLE "ordering"."item_reports" ADD CONSTRAINT "item_reports_closed" CHECK (("ordering"."item_reports"."closed_at" IS NULL) = ("ordering"."item_reports"."closed_how" IS NULL) AND ("ordering"."item_reports"."closed_how" IS NULL OR "ordering"."item_reports"."closed_how" IN ('withdrawn', 'closed', 'cancelled', 'edited')) AND ("ordering"."item_reports"."closed_how" IS NOT DISTINCT FROM 'closed') = ("ordering"."item_reports"."close_reason" IS NOT NULL) AND ("ordering"."item_reports"."closed_how" IS NULL OR ("ordering"."item_reports"."closed_by_type" IS NOT NULL AND "ordering"."item_reports"."closed_by_id" IS NOT NULL)));--> statement-breakpoint
ALTER TABLE "ordering"."order_lines" ADD CONSTRAINT "order_lines_quantity_before" CHECK ("quantity_before" BETWEEN 1 AND 20);--> statement-breakpoint
-- An edit changes only when the restaurant acknowledges it (RA §8.13).
REVOKE UPDATE ON "ordering"."order_edits" FROM fox_drop_app;--> statement-breakpoint
GRANT UPDATE ("acknowledged_at", "acknowledged_by", "acknowledged_device") ON "ordering"."order_edits" TO fox_drop_app;
