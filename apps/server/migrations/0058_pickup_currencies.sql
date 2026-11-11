ALTER TABLE "captains"."captains" ADD COLUMN "carried_currencies" text[];--> statement-breakpoint
ALTER TABLE "ledger"."journals" ADD COLUMN "rates" jsonb;--> statement-breakpoint
ALTER TABLE "merchants"."restaurants" ADD COLUMN "pickup_currencies" text[] DEFAULT '{}'::text[] NOT NULL;--> statement-breakpoint
ALTER TABLE "ledger"."journals" ADD CONSTRAINT "journals_rates_array" CHECK ("ledger"."journals"."rates" IS NULL OR jsonb_typeof("ledger"."journals"."rates") = 'array') NOT VALID;--> statement-breakpoint
ALTER TABLE "ledger"."journals" VALIDATE CONSTRAINT "journals_rates_array";