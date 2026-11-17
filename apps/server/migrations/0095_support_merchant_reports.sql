-- RA §15, §8.19 (slice 2.24b): the restaurant app's tickets, «إبلاغ عن
-- مشكلة» and «مشكلة في الطلب», the data change's subject and the index of
-- «بلاغاتي». Expand only; the subject is written at the opening, so no
-- UPDATE is granted.
ALTER TABLE "support"."tickets" DROP CONSTRAINT "tickets_source_values";--> statement-breakpoint
ALTER TABLE "support"."tickets" ADD COLUMN "request_subject" text;--> statement-breakpoint
CREATE INDEX "tickets_party" ON "support"."tickets" USING btree ("party","party_id","opened_at");--> statement-breakpoint
ALTER TABLE "support"."tickets" ADD CONSTRAINT "tickets_merchant_sources" CHECK (("support"."tickets"."source" NOT IN ('merchant_report', 'order_problem') OR "support"."tickets"."party" = 'restaurant') AND ("support"."tickets"."source" <> 'order_problem' OR "support"."tickets"."order_id" IS NOT NULL) AND ("support"."tickets"."request_subject" IS NULL OR ("support"."tickets"."source" = 'merchant_report' AND "support"."tickets"."type_code" = 'data_change'))) NOT VALID;--> statement-breakpoint
ALTER TABLE "support"."tickets" ADD CONSTRAINT "tickets_request_subject_values" CHECK ("support"."tickets"."request_subject" IN ('min_order', 'coverage', 'owners', 'owner_phone')) NOT VALID;--> statement-breakpoint
ALTER TABLE "support"."tickets" ADD CONSTRAINT "tickets_source_values" CHECK ("support"."tickets"."source" IN ('manual', 'pickup_dispute', 'customer_report', 'price_report', 'merchant_report', 'order_problem')) NOT VALID;--> statement-breakpoint
ALTER TABLE "support"."tickets" VALIDATE CONSTRAINT "tickets_merchant_sources";--> statement-breakpoint
ALTER TABLE "support"."tickets" VALIDATE CONSTRAINT "tickets_request_subject_values";--> statement-breakpoint
ALTER TABLE "support"."tickets" VALIDATE CONSTRAINT "tickets_source_values";
