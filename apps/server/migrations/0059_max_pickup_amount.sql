ALTER TABLE "captains"."captains" ADD COLUMN "max_pickup_amount" bigint;--> statement-breakpoint
ALTER TABLE "captains"."captains" ADD COLUMN "max_pickup_currency" text;--> statement-breakpoint
ALTER TABLE "captains"."captains" ADD COLUMN "max_pickup_set_at" timestamp with time zone;--> statement-breakpoint
ALTER TABLE "dispatch"."offers" ADD COLUMN "above_max_pickup" boolean DEFAULT false NOT NULL;--> statement-breakpoint
ALTER TABLE "captains"."captains" ADD CONSTRAINT "captains_max_pickup" CHECK (("captains"."captains"."max_pickup_amount" IS NULL) = ("captains"."captains"."max_pickup_currency" IS NULL)
          AND ("captains"."captains"."max_pickup_amount" IS NULL OR "captains"."captains"."max_pickup_amount" > 0)
          AND ("captains"."captains"."max_pickup_amount" IS NULL OR "captains"."captains"."max_pickup_set_at" IS NOT NULL)) NOT VALID;--> statement-breakpoint
ALTER TABLE "captains"."captains" VALIDATE CONSTRAINT "captains_max_pickup";