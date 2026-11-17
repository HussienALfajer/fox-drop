ALTER TABLE "support"."tickets" DROP CONSTRAINT "tickets_source_values";--> statement-breakpoint
ALTER TABLE "support"."tickets" ADD COLUMN "restaurant_id" uuid;--> statement-breakpoint
ALTER TABLE "support"."tickets" ADD COLUMN "pickup_dispute_id" uuid;--> statement-breakpoint
ALTER TABLE "support"."tickets" ADD COLUMN "resolution" text;--> statement-breakpoint
ALTER TABLE "support"."tickets" ADD COLUMN "responsible" text;--> statement-breakpoint
ALTER TABLE "support"."tickets" ADD COLUMN "message" text;--> statement-breakpoint
ALTER TABLE "support"."tickets" ADD COLUMN "corrected_lines" jsonb;--> statement-breakpoint
ALTER TABLE "support"."tickets" ADD COLUMN "journal_ids" jsonb;--> statement-breakpoint
ALTER TABLE "support"."tickets" ADD COLUMN "resolved_by" uuid;--> statement-breakpoint
ALTER TABLE "support"."tickets" ADD COLUMN "resolved_at" timestamp with time zone;--> statement-breakpoint
ALTER TABLE "support"."tickets" ADD COLUMN "close_reason" text;--> statement-breakpoint
ALTER TABLE "support"."tickets" ADD COLUMN "closed_by" uuid;--> statement-breakpoint
ALTER TABLE "support"."tickets" ADD COLUMN "closed_at" timestamp with time zone;--> statement-breakpoint
CREATE UNIQUE INDEX "tickets_pickup_dispute" ON "support"."tickets" USING btree ("pickup_dispute_id");--> statement-breakpoint
ALTER TABLE "support"."tickets" ADD CONSTRAINT "tickets_resolution_values" CHECK ("support"."tickets"."resolution" IN ('none_explained', 'price_corrected', 'price_correct', 'captain_paid', 'accounts_corrected', 'payment_correct')) NOT VALID;--> statement-breakpoint
ALTER TABLE "support"."tickets" ADD CONSTRAINT "tickets_responsible_values" CHECK ("support"."tickets"."responsible" IN ('restaurant', 'captain', 'customer', 'platform')) NOT VALID;--> statement-breakpoint
ALTER TABLE "support"."tickets" ADD CONSTRAINT "tickets_resolved" CHECK (("support"."tickets"."status" = 'resolved') = ("support"."tickets"."resolution" IS NOT NULL AND "support"."tickets"."message" IS NOT NULL AND "support"."tickets"."resolved_by" IS NOT NULL AND "support"."tickets"."resolved_at" IS NOT NULL) AND ("support"."tickets"."resolution" IS NOT NULL OR ("support"."tickets"."responsible" IS NULL AND "support"."tickets"."corrected_lines" IS NULL AND "support"."tickets"."journal_ids" IS NULL))) NOT VALID;--> statement-breakpoint
ALTER TABLE "support"."tickets" ADD CONSTRAINT "tickets_closed" CHECK (("support"."tickets"."status" = 'closed') = ("support"."tickets"."close_reason" IS NOT NULL AND "support"."tickets"."closed_by" IS NOT NULL AND "support"."tickets"."closed_at" IS NOT NULL)) NOT VALID;--> statement-breakpoint
ALTER TABLE "support"."tickets" ADD CONSTRAINT "tickets_pickup_dispute_source" CHECK (("support"."tickets"."source" = 'pickup_dispute') = ("support"."tickets"."pickup_dispute_id" IS NOT NULL) AND ("support"."tickets"."pickup_dispute_id" IS NULL OR "support"."tickets"."order_id" IS NOT NULL)) NOT VALID;--> statement-breakpoint
ALTER TABLE "support"."tickets" ADD CONSTRAINT "tickets_restaurant" CHECK ("support"."tickets"."restaurant_id" IS NULL OR ("support"."tickets"."order_id" IS NULL AND "support"."tickets"."party" = 'customer')) NOT VALID;--> statement-breakpoint
ALTER TABLE "support"."tickets" ADD CONSTRAINT "tickets_source_values" CHECK ("support"."tickets"."source" IN ('manual', 'pickup_dispute')) NOT VALID;--> statement-breakpoint
ALTER TABLE "support"."tickets" VALIDATE CONSTRAINT "tickets_resolution_values";--> statement-breakpoint
ALTER TABLE "support"."tickets" VALIDATE CONSTRAINT "tickets_responsible_values";--> statement-breakpoint
ALTER TABLE "support"."tickets" VALIDATE CONSTRAINT "tickets_resolved";--> statement-breakpoint
ALTER TABLE "support"."tickets" VALIDATE CONSTRAINT "tickets_closed";--> statement-breakpoint
ALTER TABLE "support"."tickets" VALIDATE CONSTRAINT "tickets_pickup_dispute_source";--> statement-breakpoint
ALTER TABLE "support"."tickets" VALIDATE CONSTRAINT "tickets_restaurant";--> statement-breakpoint
ALTER TABLE "support"."tickets" VALIDATE CONSTRAINT "tickets_source_values";--> statement-breakpoint
-- AP §9.9.3 (slice 2.23b): resolving and closing write their columns once.
GRANT UPDATE ("resolution", "responsible", "message", "corrected_lines", "journal_ids", "resolved_by", "resolved_at", "close_reason", "closed_by", "closed_at") ON "support"."tickets" TO fox_drop_app;
