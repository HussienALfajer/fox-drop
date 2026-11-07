CREATE SCHEMA "notifications";
--> statement-breakpoint
GRANT USAGE ON SCHEMA "notifications" TO fox_drop_app;
--> statement-breakpoint
ALTER DEFAULT PRIVILEGES IN SCHEMA "notifications" GRANT SELECT, INSERT, UPDATE ON TABLES TO fox_drop_app;
--> statement-breakpoint
ALTER DEFAULT PRIVILEGES IN SCHEMA "notifications" GRANT USAGE, SELECT ON SEQUENCES TO fox_drop_app;
--> statement-breakpoint
CREATE TABLE "notifications"."alerts" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"city_id" uuid,
	"code" text NOT NULL,
	"severity" text NOT NULL,
	"subject_type" text NOT NULL,
	"subject_id" text NOT NULL,
	"details" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"raised_at" timestamp with time zone NOT NULL,
	"acknowledged_at" timestamp with time zone,
	"acknowledged_by" uuid,
	"resolved_at" timestamp with time zone,
	CONSTRAINT "alerts_severity" CHECK ("notifications"."alerts"."severity" IN ('critical', 'warning', 'information')),
	CONSTRAINT "alerts_subject_type" CHECK ("notifications"."alerts"."subject_type" IN ('order', 'captain', 'otp_pool', 'otp_number')),
	CONSTRAINT "alerts_code" CHECK ("notifications"."alerts"."code" ~ '^[a-z0-9_]{1,40}$'),
	CONSTRAINT "alerts_acknowledged" CHECK (("notifications"."alerts"."acknowledged_at" IS NULL) = ("notifications"."alerts"."acknowledged_by" IS NULL))
);
--> statement-breakpoint
CREATE UNIQUE INDEX "alerts_open_one" ON "notifications"."alerts" USING btree ("code","subject_type","subject_id") WHERE "notifications"."alerts"."resolved_at" IS NULL;--> statement-breakpoint
CREATE INDEX "alerts_subject" ON "notifications"."alerts" USING btree ("subject_type","subject_id");--> statement-breakpoint
CREATE INDEX "alerts_city_raised" ON "notifications"."alerts" USING btree ("city_id","raised_at");