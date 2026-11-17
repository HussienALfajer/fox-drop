-- AP §9.9.3 (slice 2.23d): a free re-delivery is an order linked to the
-- ticket and the order it re-delivers items of, with a customer total of 0.
ALTER TABLE "ordering"."orders" DROP CONSTRAINT "orders_money";--> statement-breakpoint
ALTER TABLE "support"."tickets" DROP CONSTRAINT "tickets_resolution_values";--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "redelivery_of_id" uuid;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "redelivery_of_placed_at" timestamp with time zone;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "redelivery_of_number" bigint;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "redelivery_ticket_id" uuid;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "redelivery_responsible" text;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "redelivery_charge_pay" boolean;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "redelivery_captain_id" uuid;--> statement-breakpoint
CREATE INDEX "orders_redelivery_ticket" ON "ordering"."orders" USING btree ("redelivery_ticket_id") WHERE "ordering"."orders"."redelivery_ticket_id" IS NOT NULL;--> statement-breakpoint
CREATE INDEX "orders_redelivery_of" ON "ordering"."orders" USING btree ("redelivery_of_id") WHERE "ordering"."orders"."redelivery_of_id" IS NOT NULL;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD CONSTRAINT "orders_redelivery" CHECK (("redelivery_of_id" IS NULL) = ("redelivery_of_placed_at" IS NULL) AND ("redelivery_of_id" IS NULL) = ("redelivery_of_number" IS NULL) AND ("redelivery_of_id" IS NULL) = ("redelivery_ticket_id" IS NULL) AND ("redelivery_of_id" IS NULL) = ("redelivery_responsible" IS NULL) AND ("redelivery_of_id" IS NULL) = ("redelivery_charge_pay" IS NULL) AND ("redelivery_responsible" IS NULL OR "redelivery_responsible" IN ('restaurant', 'captain', 'platform')) AND (coalesce("redelivery_responsible", '') = 'captain') = ("redelivery_captain_id" IS NOT NULL) AND (coalesce("redelivery_responsible", '') <> 'platform' OR NOT "redelivery_charge_pay"));--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD CONSTRAINT "orders_money" CHECK ("items_value" >= 0 AND "delivery_fee" >= 0 AND "discount" >= 0 AND "total" >= 0 AND ("redelivery_of_id" IS NOT NULL OR "total" = "items_value" + "delivery_fee" - "discount" + "rounding") AND ("redelivery_of_id" IS NULL OR ("total" = 0 AND "delivery_fee" = 0 AND "discount" = 0 AND "rounding" = 0)));--> statement-breakpoint
ALTER TABLE "support"."tickets" ADD CONSTRAINT "tickets_resolution_values" CHECK ("support"."tickets"."resolution" IN ('none_explained', 'compensation_code', 'free_redelivery', 'price_corrected', 'price_correct', 'captain_paid', 'accounts_corrected', 'payment_correct')) NOT VALID;--> statement-breakpoint
ALTER TABLE "support"."tickets" VALIDATE CONSTRAINT "tickets_resolution_values";
