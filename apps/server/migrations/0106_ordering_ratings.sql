CREATE TABLE "ordering"."ratings" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"order_id" uuid NOT NULL,
	"order_placed_at" timestamp with time zone NOT NULL,
	"city_id" uuid NOT NULL,
	"customer_id" uuid NOT NULL,
	"party" text NOT NULL,
	"restaurant_id" uuid NOT NULL,
	"captain_id" uuid,
	"stars" smallint NOT NULL,
	"reasons" jsonb NOT NULL,
	"comment" text,
	"test_order" boolean NOT NULL,
	"at" timestamp with time zone NOT NULL,
	CONSTRAINT "ratings_stars" CHECK ("ordering"."ratings"."stars" BETWEEN 1 AND 5),
	CONSTRAINT "ratings_party" CHECK ("ordering"."ratings"."party" IN ('restaurant', 'captain') AND ("ordering"."ratings"."party" = 'captain') = ("ordering"."ratings"."captain_id" IS NOT NULL)),
	CONSTRAINT "ratings_comment" CHECK ("ordering"."ratings"."comment" IS NULL OR length("ordering"."ratings"."comment") BETWEEN 1 AND 300)
);
--> statement-breakpoint
ALTER TABLE "ordering"."ratings" ADD CONSTRAINT "ratings_order_id_order_placed_at_orders_id_placed_at_fk" FOREIGN KEY ("order_id","order_placed_at") REFERENCES "ordering"."orders"("id","placed_at") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE UNIQUE INDEX "ratings_one_per_party" ON "ordering"."ratings" USING btree ("order_id","party");--> statement-breakpoint
CREATE INDEX "ratings_restaurant" ON "ordering"."ratings" USING btree ("restaurant_id","at") WHERE "ordering"."ratings"."party" = 'restaurant';--> statement-breakpoint
CREATE INDEX "ratings_captain" ON "ordering"."ratings" USING btree ("captain_id","at") WHERE "ordering"."ratings"."party" = 'captain';--> statement-breakpoint
CREATE INDEX "ratings_customer" ON "ordering"."ratings" USING btree ("customer_id","at");--> statement-breakpoint
-- CU §12.1, Q16 (slice 2.26a): a sent rating is never edited.
REVOKE UPDATE ON "ordering"."ratings" FROM fox_drop_app;
