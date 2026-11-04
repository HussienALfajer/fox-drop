CREATE SCHEMA "settings";
--> statement-breakpoint
GRANT USAGE ON SCHEMA "settings" TO fox_drop_app;
--> statement-breakpoint
ALTER DEFAULT PRIVILEGES IN SCHEMA "settings" GRANT SELECT, INSERT, UPDATE ON TABLES TO fox_drop_app;
--> statement-breakpoint
ALTER DEFAULT PRIVILEGES IN SCHEMA "settings" GRANT USAGE, SELECT ON SEQUENCES TO fox_drop_app;
--> statement-breakpoint
CREATE TABLE "settings"."changes" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"key" text NOT NULL,
	"city_id" uuid,
	"action" text NOT NULL,
	"before" jsonb,
	"after" jsonb,
	"editor_id" uuid NOT NULL,
	"editor_roles" text[] NOT NULL,
	"reason" text,
	"changed_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "changes_action_values" CHECK ("settings"."changes"."action" IN ('update', 'reset'))
);
--> statement-breakpoint
CREATE TABLE "settings"."values" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"key" text NOT NULL,
	"city_id" uuid,
	"value" jsonb,
	"is_default" boolean DEFAULT false NOT NULL,
	"version" integer DEFAULT 1 NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "values_key_city" UNIQUE NULLS NOT DISTINCT("key","city_id"),
	CONSTRAINT "values_default_has_no_value" CHECK (NOT "settings"."values"."is_default" OR "settings"."values"."value" IS NULL)
);
--> statement-breakpoint
CREATE INDEX "changes_key_city_changed_at" ON "settings"."changes" USING btree ("key","city_id","changed_at");
--> statement-breakpoint
-- The change history is append-only (AP §4.4): the application role adds and
-- reads changes, never edits one.
REVOKE UPDATE ON "settings"."changes" FROM fox_drop_app;
