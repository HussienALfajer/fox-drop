ALTER TABLE "captains"."captains" ADD COLUMN "device_checked_at" timestamp with time zone;--> statement-breakpoint
ALTER TABLE "captains"."captains" ADD COLUMN "device_check_device_id" text;--> statement-breakpoint
ALTER TABLE "captains"."captains" ADD COLUMN "device_check_failed" text[];--> statement-breakpoint
ALTER TABLE "captains"."captains" ADD CONSTRAINT "captains_device_check_complete" CHECK (("captains"."captains"."device_checked_at" IS NULL) = ("captains"."captains"."device_check_device_id" IS NULL)
          AND ("captains"."captains"."device_checked_at" IS NULL) = ("captains"."captains"."device_check_failed" IS NULL));