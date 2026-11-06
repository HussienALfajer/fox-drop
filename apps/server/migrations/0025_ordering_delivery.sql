CREATE TABLE "ordering"."collections" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"order_id" uuid NOT NULL,
	"order_placed_at" timestamp with time zone NOT NULL,
	"city_id" uuid NOT NULL,
	"captain_id" uuid NOT NULL,
	"currency" text NOT NULL,
	"amount_due" bigint NOT NULL,
	"received_lines" jsonb NOT NULL,
	"change_lines" jsonb NOT NULL,
	"net_received" bigint NOT NULL,
	"shortfall" bigint NOT NULL,
	"shortfall_reason" text,
	"shortfall_note" text,
	"base_pay" bigint NOT NULL,
	"distance_pay" bigint NOT NULL,
	"top_up_pay" bigint NOT NULL,
	"waiting_pay" bigint NOT NULL,
	"waiting_minutes" integer NOT NULL,
	"recorded_at" timestamp with time zone NOT NULL,
	"recorded_by_type" text NOT NULL,
	"recorded_by_id" uuid NOT NULL,
	"recorded_by_device" text,
	"reason" text,
	CONSTRAINT "collections_money" CHECK ("amount_due" >= 0 AND "shortfall" >= 0 AND "base_pay" >= 0 AND "distance_pay" >= 0 AND "top_up_pay" >= 0 AND "waiting_pay" >= 0 AND "waiting_minutes" >= 0),
	CONSTRAINT "collections_shortfall" CHECK (("shortfall" > 0) = ("shortfall_reason" IS NOT NULL) AND ("shortfall_reason" IS NULL OR "shortfall_reason" IN ('customer_short', 'counting_error', 'other')) AND ("shortfall_note" IS NOT NULL) = ("shortfall_reason" IS NOT DISTINCT FROM 'other') AND char_length("shortfall_note") BETWEEN 1 AND 200),
	CONSTRAINT "collections_recorded_by" CHECK (("recorded_by_type" = 'captain' AND "reason" IS NULL) OR ("recorded_by_type" = 'admin' AND "reason" IS NOT NULL AND "recorded_by_device" IS NULL))
);
--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "delivered_at" timestamp with time zone;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "outcome" text;--> statement-breakpoint
ALTER TABLE "ordering"."collections" ADD CONSTRAINT "collections_order_id_order_placed_at_orders_id_placed_at_fk" FOREIGN KEY ("order_id","order_placed_at") REFERENCES "ordering"."orders"("id","placed_at") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE UNIQUE INDEX "collections_one_per_order" ON "ordering"."collections" USING btree ("order_id");--> statement-breakpoint
CREATE INDEX "collections_captain" ON "ordering"."collections" USING btree ("captain_id","recorded_at");--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD CONSTRAINT "orders_delivery" CHECK (("status" = 'delivered') = ("delivered_at" IS NOT NULL) AND ("status" IN ('delivered', 'failed')) = ("outcome" IS NOT NULL) AND ("outcome" IS NULL OR "outcome" IN ('normal', 'free', 'fake', 'damaged', 'wrong_refused', 'failed_other')));