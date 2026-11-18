CREATE TABLE "marketing"."banners" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"city_id" uuid NOT NULL,
	"title" text NOT NULL,
	"image_key" text NOT NULL,
	"target" text NOT NULL,
	"restaurant_ids" uuid[] DEFAULT '{}'::uuid[] NOT NULL,
	"category_id" uuid,
	"code_id" uuid,
	"zone_ids" uuid[] DEFAULT '{}'::uuid[] NOT NULL,
	"position" integer NOT NULL,
	"starts_at" timestamp with time zone NOT NULL,
	"ends_at" timestamp with time zone NOT NULL,
	"created_by" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_by" uuid NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	"removed_at" timestamp with time zone,
	CONSTRAINT "banners_target_values" CHECK ("marketing"."banners"."target" IN ('restaurant', 'category', 'restaurants', 'code')),
	CONSTRAINT "banners_title" CHECK (char_length("marketing"."banners"."title") BETWEEN 1 AND 60),
	CONSTRAINT "banners_period" CHECK ("marketing"."banners"."starts_at" < "marketing"."banners"."ends_at"),
	CONSTRAINT "banners_target" CHECK (CASE "marketing"."banners"."target"
        WHEN 'restaurant' THEN cardinality("marketing"."banners"."restaurant_ids") = 1 AND "marketing"."banners"."category_id" IS NULL AND "marketing"."banners"."code_id" IS NULL
        WHEN 'restaurants' THEN cardinality("marketing"."banners"."restaurant_ids") BETWEEN 1 AND 30 AND "marketing"."banners"."category_id" IS NULL AND "marketing"."banners"."code_id" IS NULL
        WHEN 'category' THEN cardinality("marketing"."banners"."restaurant_ids") = 0 AND "marketing"."banners"."category_id" IS NOT NULL AND "marketing"."banners"."code_id" IS NULL
        ELSE cardinality("marketing"."banners"."restaurant_ids") = 0 AND "marketing"."banners"."category_id" IS NULL AND "marketing"."banners"."code_id" IS NOT NULL
      END)
);
--> statement-breakpoint
ALTER TABLE "files"."uploads" DROP CONSTRAINT "uploads_purpose_values";--> statement-breakpoint
CREATE INDEX "banners_city" ON "marketing"."banners" USING btree ("city_id","position");--> statement-breakpoint
ALTER TABLE "files"."uploads" ADD CONSTRAINT "uploads_purpose_values" CHECK ("files"."uploads"."purpose" IN ('restaurant_logo', 'restaurant_cover', 'item_photo', 'report_photo', 'category_image', 'banner_image'));