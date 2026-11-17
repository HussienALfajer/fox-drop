ALTER TABLE "support"."tickets" DROP CONSTRAINT "tickets_resolution_values";--> statement-breakpoint
ALTER TABLE "support"."tickets" ADD COLUMN "affected_lines" jsonb;--> statement-breakpoint
ALTER TABLE "support"."tickets" ADD COLUMN "affected_value" bigint;--> statement-breakpoint
ALTER TABLE "support"."tickets" ADD COLUMN "short_amount" bigint;--> statement-breakpoint
ALTER TABLE "support"."tickets" ADD COLUMN "money_currency" text;--> statement-breakpoint
ALTER TABLE "support"."tickets" ADD COLUMN "compensation_id" uuid;--> statement-breakpoint
ALTER TABLE "support"."tickets" ADD CONSTRAINT "tickets_money" CHECK (("support"."tickets"."affected_lines" IS NULL) = ("support"."tickets"."affected_value" IS NULL) AND ("support"."tickets"."affected_value" IS NULL OR "support"."tickets"."affected_value" > 0) AND ("support"."tickets"."short_amount" IS NULL OR "support"."tickets"."short_amount" > 0) AND (("support"."tickets"."affected_value" IS NULL AND "support"."tickets"."short_amount" IS NULL) = ("support"."tickets"."money_currency" IS NULL)) AND ("support"."tickets"."resolution" IS NOT NULL OR ("support"."tickets"."money_currency" IS NULL AND "support"."tickets"."compensation_id" IS NULL)) AND ("support"."tickets"."compensation_id" IS NULL OR "support"."tickets"."resolution" = 'compensation_code')) NOT VALID;--> statement-breakpoint
ALTER TABLE "support"."tickets" ADD CONSTRAINT "tickets_resolution_values" CHECK ("support"."tickets"."resolution" IN ('none_explained', 'compensation_code', 'price_corrected', 'price_correct', 'captain_paid', 'accounts_corrected', 'payment_correct')) NOT VALID;--> statement-breakpoint
ALTER TABLE "support"."tickets" VALIDATE CONSTRAINT "tickets_money";--> statement-breakpoint
ALTER TABLE "support"."tickets" VALIDATE CONSTRAINT "tickets_resolution_values";--> statement-breakpoint
-- AP §8.10 (slice 2.23c): resolving writes a problem's money once.
GRANT UPDATE ("affected_lines", "affected_value", "short_amount", "money_currency", "compensation_id") ON "support"."tickets" TO fox_drop_app;