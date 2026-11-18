CREATE TABLE "merchants"."contracts" (
	"restaurant_id" uuid PRIMARY KEY NOT NULL,
	"signed_on" date,
	"duration_months" smallint,
	"contract_key" text,
	"licence_key" text,
	"confirmed_at" timestamp with time zone,
	"confirmed_by" uuid,
	"updated_by" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "contracts_duration" CHECK ("merchants"."contracts"."duration_months" BETWEEN 1 AND 120),
	CONSTRAINT "contracts_confirmed" CHECK (("merchants"."contracts"."confirmed_at" IS NULL) = ("merchants"."contracts"."confirmed_by" IS NULL) AND ("merchants"."contracts"."confirmed_at" IS NULL OR ("merchants"."contracts"."signed_on" IS NOT NULL AND "merchants"."contracts"."duration_months" IS NOT NULL AND "merchants"."contracts"."contract_key" IS NOT NULL)))
);
--> statement-breakpoint
ALTER TABLE "files"."uploads" DROP CONSTRAINT "uploads_purpose_values";--> statement-breakpoint
ALTER TABLE "merchants"."restaurants" ALTER COLUMN "location" DROP NOT NULL;--> statement-breakpoint
ALTER TABLE "merchants"."restaurants" ALTER COLUMN "coverage_kind" DROP NOT NULL;--> statement-breakpoint
ALTER TABLE "merchants"."restaurants" ALTER COLUMN "minimum_order" DROP NOT NULL;--> statement-breakpoint
ALTER TABLE "merchants"."restaurants" ALTER COLUMN "minimum_order_currency" DROP NOT NULL;--> statement-breakpoint
ALTER TABLE "merchants"."restaurants" ALTER COLUMN "default_prep_min" DROP NOT NULL;--> statement-breakpoint
ALTER TABLE "merchants"."commission_rates" ADD COLUMN "withdrawn_at" timestamp with time zone;--> statement-breakpoint
ALTER TABLE "merchants"."restaurants" ADD COLUMN "owner_name" text;--> statement-breakpoint
ALTER TABLE "merchants"."contracts" ADD CONSTRAINT "contracts_restaurant_id_restaurants_id_fk" FOREIGN KEY ("restaurant_id") REFERENCES "merchants"."restaurants"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "files"."uploads" ADD CONSTRAINT "uploads_purpose_values" CHECK ("files"."uploads"."purpose" IN ('restaurant_logo', 'restaurant_cover', 'item_photo', 'report_photo', 'category_image', 'banner_image', 'restaurant_contract', 'restaurant_licence'));--> statement-breakpoint
ALTER TABLE "merchants"."commission_rates" ADD CONSTRAINT "commission_rates_withdrawn_before_start" CHECK ("merchants"."commission_rates"."withdrawn_at" IS NULL OR "merchants"."commission_rates"."withdrawn_at" <= "merchants"."commission_rates"."effective_from");--> statement-breakpoint
ALTER TABLE "merchants"."restaurants" ADD CONSTRAINT "restaurants_record_complete" CHECK ("merchants"."restaurants"."account_status" = 'draft' OR ("merchants"."restaurants"."location" IS NOT NULL AND "merchants"."restaurants"."coverage_kind" IS NOT NULL AND "merchants"."restaurants"."minimum_order" IS NOT NULL AND "merchants"."restaurants"."minimum_order_currency" IS NOT NULL AND "merchants"."restaurants"."default_prep_min" IS NOT NULL));--> statement-breakpoint
ALTER TABLE "merchants"."restaurants" ADD CONSTRAINT "restaurants_operations_together" CHECK (("merchants"."restaurants"."coverage_kind" IS NULL) = ("merchants"."restaurants"."minimum_order" IS NULL) AND ("merchants"."restaurants"."minimum_order" IS NULL) = ("merchants"."restaurants"."minimum_order_currency" IS NULL) AND ("merchants"."restaurants"."minimum_order" IS NULL) = ("merchants"."restaurants"."default_prep_min" IS NULL));--> statement-breakpoint
-- A version not yet in force is withdrawn when the wizard replaces the plan
-- (slice 2.30a); nothing else of a version ever changes.
GRANT UPDATE ("withdrawn_at") ON "merchants"."commission_rates" TO fox_drop_app;
