-- Slice 2.11b: an outcome with an amount to collect waits for its collection (K9, AP §9.3.2), which posts it and sets its money again.
ALTER TABLE "ordering"."order_outcomes" ADD COLUMN "collected_at" timestamp with time zone;--> statement-breakpoint
ALTER TABLE "ordering"."order_outcomes" ADD CONSTRAINT "order_outcomes_collection" CHECK (("ordering"."order_outcomes"."amount_to_collect" = 0 OR "ordering"."order_outcomes"."status" = 'delivered') AND ("ordering"."order_outcomes"."collected_at" IS NULL OR "ordering"."order_outcomes"."amount_to_collect" > 0));--> statement-breakpoint
GRANT UPDATE ("loss", "merchant_debit", "captain_pay", "collected_at") ON "ordering"."order_outcomes" TO fox_drop_app;
