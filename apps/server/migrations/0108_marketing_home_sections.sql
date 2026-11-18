CREATE TABLE "marketing"."home_sections" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"city_id" uuid NOT NULL,
	"kind" text NOT NULL,
	"title" text,
	"restaurant_ids" uuid[] DEFAULT '{}'::uuid[] NOT NULL,
	"position" integer NOT NULL,
	"visible" boolean DEFAULT true NOT NULL,
	"removed_at" timestamp with time zone,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "home_sections_kind_values" CHECK ("marketing"."home_sections"."kind" IN ('banners', 'categories', 'nearest', 'most_ordered', 'new', 'offers', 'custom')),
	CONSTRAINT "home_sections_custom" CHECK (CASE WHEN "marketing"."home_sections"."kind" = 'custom'
        THEN "marketing"."home_sections"."title" IS NOT NULL AND char_length("marketing"."home_sections"."title") BETWEEN 1 AND 40
        ELSE "marketing"."home_sections"."title" IS NULL AND cardinality("marketing"."home_sections"."restaurant_ids") = 0 AND "marketing"."home_sections"."removed_at" IS NULL
      END)
);
--> statement-breakpoint
CREATE UNIQUE INDEX "home_sections_built_in" ON "marketing"."home_sections" USING btree ("city_id","kind") WHERE "marketing"."home_sections"."kind" <> 'custom';--> statement-breakpoint
CREATE INDEX "home_sections_city" ON "marketing"."home_sections" USING btree ("city_id","position");