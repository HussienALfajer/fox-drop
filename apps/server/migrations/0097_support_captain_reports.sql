-- CA §13, §9.11, §9.4 item 6 (slice 2.24c): the captain app's tickets,
-- «إبلاغ عن مشكلة» and «مشكلة» with a quick reason, and the captain's
-- «مشكلة في مبلغ الاستلام», which records the pickup dispute as the
-- restaurant's does with who opened it. Expand only.
ALTER TABLE "support"."tickets" DROP CONSTRAINT "tickets_source_values";--> statement-breakpoint
ALTER TABLE "ordering"."pickup_disputes" ADD COLUMN "opened_by" text DEFAULT 'restaurant' NOT NULL;--> statement-breakpoint
ALTER TABLE "ordering"."pickup_disputes" ADD CONSTRAINT "pickup_disputes_opened_by_values" CHECK ("ordering"."pickup_disputes"."opened_by" IN ('restaurant', 'captain')) NOT VALID;--> statement-breakpoint
ALTER TABLE "support"."tickets" ADD CONSTRAINT "tickets_captain_sources" CHECK (("support"."tickets"."source" NOT IN ('captain_report', 'captain_problem') OR "support"."tickets"."party" = 'captain') AND ("support"."tickets"."source" <> 'captain_problem' OR "support"."tickets"."order_id" IS NOT NULL) AND ("support"."tickets"."source" <> 'pickup_dispute' OR "support"."tickets"."party" IN ('restaurant', 'captain'))) NOT VALID;--> statement-breakpoint
ALTER TABLE "support"."tickets" ADD CONSTRAINT "tickets_source_values" CHECK ("support"."tickets"."source" IN ('manual', 'pickup_dispute', 'customer_report', 'price_report', 'merchant_report', 'order_problem', 'captain_report', 'captain_problem')) NOT VALID;--> statement-breakpoint
ALTER TABLE "ordering"."pickup_disputes" VALIDATE CONSTRAINT "pickup_disputes_opened_by_values";--> statement-breakpoint
ALTER TABLE "support"."tickets" VALIDATE CONSTRAINT "tickets_captain_sources";--> statement-breakpoint
ALTER TABLE "support"."tickets" VALIDATE CONSTRAINT "tickets_source_values";
