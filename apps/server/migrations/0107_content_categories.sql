CREATE TABLE "content"."categories" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"name" text NOT NULL,
	"image_key" text,
	"active" boolean DEFAULT true NOT NULL,
	"position" integer NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "categories_name" CHECK (char_length("content"."categories"."name") BETWEEN 1 AND 40)
);
--> statement-breakpoint
ALTER TABLE "files"."uploads" DROP CONSTRAINT "uploads_purpose_values";--> statement-breakpoint
ALTER TABLE "merchants"."restaurants" ADD COLUMN "category_ids" uuid[] DEFAULT '{}'::uuid[] NOT NULL;--> statement-breakpoint
CREATE UNIQUE INDEX "categories_active_name" ON "content"."categories" USING btree ("name") WHERE "content"."categories"."active";--> statement-breakpoint
ALTER TABLE "files"."uploads" ADD CONSTRAINT "uploads_purpose_values" CHECK ("files"."uploads"."purpose" IN ('restaurant_logo', 'restaurant_cover', 'item_photo', 'report_photo', 'category_image'));--> statement-breakpoint
-- Slice 2.27a (owner decision 2026-11-18): the restaurants' free-text
-- categories become the platform's categories, by name, in alphabetical order.
INSERT INTO "content"."categories" ("name", "position")
SELECT "name", row_number() OVER (ORDER BY "name")
FROM (
	SELECT DISTINCT left(btrim("category", E' \t\r\n\u00a0'), 40) AS "name"
	FROM "merchants"."restaurants"
	WHERE btrim(coalesce("category", ''), E' \t\r\n\u00a0') <> ''
) AS "names";--> statement-breakpoint
UPDATE "merchants"."restaurants" AS "r"
SET "category_ids" = ARRAY["c"."id"]
FROM "content"."categories" AS "c"
WHERE "c"."name" = left(btrim("r"."category", E' \t\r\n\u00a0'), 40);
