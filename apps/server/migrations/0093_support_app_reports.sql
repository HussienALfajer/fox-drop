-- CU §12.2, §9.5 (slice 2.24a): the customer app's reports. Expand only; the
-- new ticket columns are written at the opening, so no UPDATE is granted.
ALTER TABLE "files"."uploads" DROP CONSTRAINT "uploads_purpose_values";--> statement-breakpoint
ALTER TABLE "support"."tickets" DROP CONSTRAINT "tickets_source_values";--> statement-breakpoint
ALTER TABLE "support"."tickets" ADD COLUMN "reported_lines" jsonb;--> statement-breakpoint
ALTER TABLE "support"."tickets" ADD COLUMN "photo_keys" jsonb;--> statement-breakpoint
ALTER TABLE "support"."tickets" ADD COLUMN "reported_item_id" uuid;--> statement-breakpoint
ALTER TABLE "support"."tickets" ADD COLUMN "reported_item_name" text;--> statement-breakpoint
ALTER TABLE "support"."tickets" ADD COLUMN "shop_price" bigint;--> statement-breakpoint
ALTER TABLE "support"."tickets" ADD COLUMN "shop_price_currency" text;--> statement-breakpoint
CREATE UNIQUE INDEX "tickets_customer_report" ON "support"."tickets" USING btree ("order_id") WHERE "support"."tickets"."source" = 'customer_report';--> statement-breakpoint
CREATE INDEX "tickets_price_reports" ON "support"."tickets" USING btree ("party_id","restaurant_id","opened_at") WHERE "support"."tickets"."source" = 'price_report';--> statement-breakpoint
ALTER TABLE "files"."uploads" ADD CONSTRAINT "uploads_purpose_values" CHECK ("files"."uploads"."purpose" IN ('restaurant_logo', 'restaurant_cover', 'item_photo', 'report_photo')) NOT VALID;--> statement-breakpoint
ALTER TABLE "support"."tickets" ADD CONSTRAINT "tickets_app_sources" CHECK (("support"."tickets"."source" <> 'customer_report' OR ("support"."tickets"."party" = 'customer' AND "support"."tickets"."order_id" IS NOT NULL)) AND ("support"."tickets"."source" <> 'price_report' OR "support"."tickets"."type_code" = 'price_difference')) NOT VALID;--> statement-breakpoint
ALTER TABLE "support"."tickets" ADD CONSTRAINT "tickets_price_report" CHECK (("support"."tickets"."shop_price" IS NULL) = ("support"."tickets"."shop_price_currency" IS NULL) AND ("support"."tickets"."shop_price" IS NULL OR "support"."tickets"."shop_price" > 0) AND ("support"."tickets"."reported_item_id" IS NULL) = ("support"."tickets"."reported_item_name" IS NULL) AND (("support"."tickets"."shop_price" IS NULL AND "support"."tickets"."reported_item_id" IS NULL) OR "support"."tickets"."type_code" = 'price_difference')) NOT VALID;--> statement-breakpoint
ALTER TABLE "support"."tickets" ADD CONSTRAINT "tickets_source_values" CHECK ("support"."tickets"."source" IN ('manual', 'pickup_dispute', 'customer_report', 'price_report')) NOT VALID;--> statement-breakpoint
ALTER TABLE "files"."uploads" VALIDATE CONSTRAINT "uploads_purpose_values";--> statement-breakpoint
ALTER TABLE "support"."tickets" VALIDATE CONSTRAINT "tickets_app_sources";--> statement-breakpoint
ALTER TABLE "support"."tickets" VALIDATE CONSTRAINT "tickets_price_report";--> statement-breakpoint
ALTER TABLE "support"."tickets" VALIDATE CONSTRAINT "tickets_source_values";
