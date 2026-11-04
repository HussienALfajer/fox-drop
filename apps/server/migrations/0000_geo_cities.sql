CREATE SCHEMA "geo";
--> statement-breakpoint
-- The application role uses the schema and reads, adds and changes rows in
-- every table the migrations create in it. It never deletes (architecture §5.2)
-- and never changes the schema.
GRANT USAGE ON SCHEMA "geo" TO fox_drop_app;
--> statement-breakpoint
ALTER DEFAULT PRIVILEGES IN SCHEMA "geo" GRANT SELECT, INSERT, UPDATE ON TABLES TO fox_drop_app;
--> statement-breakpoint
ALTER DEFAULT PRIVILEGES IN SCHEMA "geo" GRANT USAGE, SELECT ON SEQUENCES TO fox_drop_app;
--> statement-breakpoint
CREATE TABLE "geo"."cities" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"code" text NOT NULL,
	"name" text NOT NULL,
	"time_zone" text DEFAULT 'Asia/Damascus' NOT NULL,
	"status" text DEFAULT 'active' NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "cities_code_unique" UNIQUE("code"),
	CONSTRAINT "cities_code_format" CHECK ("geo"."cities"."code" ~ '^[A-Z]{2,3}$'),
	CONSTRAINT "cities_status_values" CHECK ("geo"."cities"."status" IN ('active', 'inactive'))
);
--> statement-breakpoint
-- V1 serves Azaz (AP §1.3 item 6). Every environment starts with it.
INSERT INTO "geo"."cities" ("code", "name") VALUES ('AZ', 'أعزاز');
