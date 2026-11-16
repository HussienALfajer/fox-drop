CREATE TABLE "ordering"."shortfall_resolutions" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"order_id" uuid NOT NULL,
	"order_placed_at" timestamp with time zone NOT NULL,
	"city_id" uuid NOT NULL,
	"collection_id" uuid NOT NULL,
	"responsible" text NOT NULL,
	"currency" text NOT NULL,
	"amount" bigint NOT NULL,
	"journal_id" uuid NOT NULL,
	"captain_id" uuid,
	"note" text NOT NULL,
	"resolved_at" timestamp with time zone NOT NULL,
	"resolved_by" uuid NOT NULL,
	CONSTRAINT "shortfall_resolutions_values" CHECK ("ordering"."shortfall_resolutions"."responsible" IN ('captain', 'customer', 'platform') AND ("ordering"."shortfall_resolutions"."responsible" = 'captain') = ("ordering"."shortfall_resolutions"."captain_id" IS NOT NULL) AND "ordering"."shortfall_resolutions"."amount" > 0 AND char_length("ordering"."shortfall_resolutions"."note") BETWEEN 1 AND 500)
);
--> statement-breakpoint
ALTER TABLE "ordering"."shortfall_resolutions" ADD CONSTRAINT "shortfall_resolutions_collection_id_collections_id_fk" FOREIGN KEY ("collection_id") REFERENCES "ordering"."collections"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "ordering"."shortfall_resolutions" ADD CONSTRAINT "shortfall_resolutions_order_id_order_placed_at_orders_id_placed_at_fk" FOREIGN KEY ("order_id","order_placed_at") REFERENCES "ordering"."orders"("id","placed_at") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE UNIQUE INDEX "shortfall_resolutions_one_per_order" ON "ordering"."shortfall_resolutions" USING btree ("order_id");--> statement-breakpoint
-- A resolution is never changed (AP §8.6: once per order).
REVOKE UPDATE ON "ordering"."shortfall_resolutions" FROM fox_drop_app;
