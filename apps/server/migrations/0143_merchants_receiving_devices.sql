CREATE TABLE "merchants"."receiving" (
	"restaurant_id" uuid PRIMARY KEY NOT NULL,
	"without_device_since" timestamp with time zone,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
ALTER TABLE "merchants"."devices" ADD COLUMN "ringing" boolean DEFAULT true NOT NULL;--> statement-breakpoint
ALTER TABLE "merchants"."devices" ADD COLUMN "checked_at" timestamp with time zone;--> statement-breakpoint
ALTER TABLE "merchants"."devices" ADD COLUMN "check_passed" boolean;--> statement-breakpoint
ALTER TABLE "merchants"."devices" ADD COLUMN "check_failed" text[];--> statement-breakpoint
ALTER TABLE "merchants"."devices" ADD COLUMN "check_delay_ms" integer;--> statement-breakpoint
ALTER TABLE "merchants"."devices" ADD COLUMN "present_at" timestamp with time zone;--> statement-breakpoint
ALTER TABLE "merchants"."receiving" ADD CONSTRAINT "receiving_restaurant_id_restaurants_id_fk" FOREIGN KEY ("restaurant_id") REFERENCES "merchants"."restaurants"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "merchants"."devices" ADD CONSTRAINT "devices_check_complete" CHECK (("merchants"."devices"."checked_at" IS NULL) = ("merchants"."devices"."check_passed" IS NULL) AND ("merchants"."devices"."checked_at" IS NULL) = ("merchants"."devices"."check_failed" IS NULL));