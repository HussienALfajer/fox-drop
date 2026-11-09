CREATE SCHEMA "files";
--> statement-breakpoint
GRANT USAGE ON SCHEMA "files" TO fox_drop_app;
--> statement-breakpoint
ALTER DEFAULT PRIVILEGES IN SCHEMA "files" GRANT SELECT, INSERT, UPDATE ON TABLES TO fox_drop_app;
--> statement-breakpoint
ALTER DEFAULT PRIVILEGES IN SCHEMA "files" GRANT USAGE, SELECT ON SEQUENCES TO fox_drop_app;
--> statement-breakpoint
CREATE TABLE "files"."uploads" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"purpose" text NOT NULL,
	"key" text NOT NULL,
	"content_type" text NOT NULL,
	"size_bytes" integer NOT NULL,
	"created_by" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"linked_at" timestamp with time zone,
	CONSTRAINT "uploads_key_unique" UNIQUE("key"),
	CONSTRAINT "uploads_purpose_values" CHECK ("files"."uploads"."purpose" IN ('restaurant_logo', 'restaurant_cover', 'item_photo')),
	CONSTRAINT "uploads_content_type_values" CHECK ("files"."uploads"."content_type" IN ('image/jpeg', 'image/png', 'image/webp')),
	CONSTRAINT "uploads_size_positive" CHECK ("files"."uploads"."size_bytes" > 0)
);
