CREATE TABLE "ordering"."pickup_disputes" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"order_id" uuid NOT NULL,
	"order_placed_at" timestamp with time zone NOT NULL,
	"city_id" uuid NOT NULL,
	"pickup_request_id" uuid NOT NULL,
	"account_id" uuid NOT NULL,
	"device" text NOT NULL,
	"received_lines" jsonb NOT NULL,
	"created_at" timestamp with time zone NOT NULL,
	"status" text NOT NULL,
	CONSTRAINT "pickup_disputes_status_values" CHECK ("status" IN ('open'))
);
--> statement-breakpoint
CREATE TABLE "ordering"."pickup_requests" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"order_id" uuid NOT NULL,
	"order_placed_at" timestamp with time zone NOT NULL,
	"city_id" uuid NOT NULL,
	"captain_id" uuid NOT NULL,
	"currency" text NOT NULL,
	"amount" bigint NOT NULL,
	"lines" jsonb NOT NULL,
	"opened_at" timestamp with time zone NOT NULL,
	"confirm_by" timestamp with time zone NOT NULL,
	"status" text NOT NULL,
	"closed_at" timestamp with time zone,
	"outcome" text,
	"closed_by_type" text,
	"closed_by_id" uuid,
	"closed_by_device" text,
	"booked_lines" jsonb,
	"received_lines" jsonb,
	"reason" text,
	CONSTRAINT "pickup_requests_status_values" CHECK ("status" IN ('open', 'confirmed', 'rejected', 'voided')),
	CONSTRAINT "pickup_requests_outcome" CHECK (CASE "status"
        WHEN 'open' THEN "outcome" IS NULL AND "closed_at" IS NULL
        WHEN 'confirmed' THEN "outcome" IN ('restaurant', 'automatic', 'operations') AND "closed_at" IS NOT NULL AND "booked_lines" IS NOT NULL
        WHEN 'rejected' THEN "outcome" IN ('amount_incorrect', 'incomplete') AND "closed_at" IS NOT NULL
        ELSE "outcome" = 'cancelled' AND "closed_at" IS NOT NULL
      END),
	CONSTRAINT "pickup_requests_received" CHECK (("received_lines" IS NOT NULL) = ("outcome" IS NOT DISTINCT FROM 'amount_incorrect')),
	CONSTRAINT "pickup_requests_amount" CHECK ("amount" >= 0)
);
--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "picked_up_at" timestamp with time zone;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "ready_by_pickup" boolean;--> statement-breakpoint
ALTER TABLE "ordering"."pickup_disputes" ADD CONSTRAINT "pickup_disputes_pickup_request_id_pickup_requests_id_fk" FOREIGN KEY ("pickup_request_id") REFERENCES "ordering"."pickup_requests"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "ordering"."pickup_disputes" ADD CONSTRAINT "pickup_disputes_order_id_order_placed_at_orders_id_placed_at_fk" FOREIGN KEY ("order_id","order_placed_at") REFERENCES "ordering"."orders"("id","placed_at") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "ordering"."pickup_requests" ADD CONSTRAINT "pickup_requests_order_id_order_placed_at_orders_id_placed_at_fk" FOREIGN KEY ("order_id","order_placed_at") REFERENCES "ordering"."orders"("id","placed_at") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE UNIQUE INDEX "pickup_disputes_one_per_order" ON "ordering"."pickup_disputes" USING btree ("order_id");--> statement-breakpoint
CREATE INDEX "pickup_disputes_request" ON "ordering"."pickup_disputes" USING btree ("pickup_request_id");--> statement-breakpoint
CREATE INDEX "pickup_requests_order" ON "ordering"."pickup_requests" USING btree ("order_id","opened_at");--> statement-breakpoint
CREATE UNIQUE INDEX "pickup_requests_one_open_per_order" ON "ordering"."pickup_requests" USING btree ("order_id") WHERE "status" = 'open';--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD CONSTRAINT "orders_pickup" CHECK (("picked_up_at" IS NULL) = ("ready_by_pickup" IS NULL) AND ("status" NOT IN ('picked_up', 'arrived', 'delivered', 'failed') OR ("picked_up_at" IS NOT NULL AND "ready_at" IS NOT NULL)));