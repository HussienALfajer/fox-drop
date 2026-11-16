CREATE SCHEMA "reporting";
--> statement-breakpoint
GRANT USAGE ON SCHEMA "reporting" TO fox_drop_app;
--> statement-breakpoint
ALTER DEFAULT PRIVILEGES IN SCHEMA "reporting" GRANT SELECT, INSERT, UPDATE ON TABLES TO fox_drop_app;
--> statement-breakpoint
ALTER DEFAULT PRIVILEGES IN SCHEMA "reporting" GRANT USAGE, SELECT ON SEQUENCES TO fox_drop_app;
--> statement-breakpoint
CREATE TABLE "reporting"."exports" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"city_id" uuid NOT NULL,
	"kind" text NOT NULL,
	"params" jsonb NOT NULL,
	"requested_by" uuid NOT NULL,
	"idempotency_key" text NOT NULL,
	"file_name" text NOT NULL,
	"status" text DEFAULT 'pending' NOT NULL,
	"object_key" text,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"ready_at" timestamp with time zone,
	"expires_at" timestamp with time zone,
	CONSTRAINT "exports_kind_values" CHECK ("reporting"."exports"."kind" IN ('restaurant_statement')),
	CONSTRAINT "exports_status_values" CHECK ("reporting"."exports"."status" IN ('pending', 'ready', 'expired')),
	CONSTRAINT "exports_written" CHECK (("reporting"."exports"."status" = 'pending') = ("reporting"."exports"."object_key" IS NULL AND "reporting"."exports"."ready_at" IS NULL AND "reporting"."exports"."expires_at" IS NULL))
);
--> statement-breakpoint
CREATE UNIQUE INDEX "exports_requester_key" ON "reporting"."exports" USING btree ("requested_by","idempotency_key");