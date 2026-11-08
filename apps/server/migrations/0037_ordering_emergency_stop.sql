CREATE TABLE "notifications"."platform_outbox" (
	"id" bigint PRIMARY KEY GENERATED ALWAYS AS IDENTITY (sequence name "notifications"."platform_outbox_id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START WITH 1 CACHE 1),
	"created_at" timestamp with time zone NOT NULL,
	"city_id" uuid,
	"type" text NOT NULL,
	"apps" text[] NOT NULL,
	"ops" boolean NOT NULL,
	"payload" jsonb NOT NULL,
	"published_at" timestamp with time zone,
	CONSTRAINT "platform_outbox_apps" CHECK ("notifications"."platform_outbox"."apps" <@ ARRAY['merchant', 'captain']::text[])
);
--> statement-breakpoint
CREATE TABLE "ordering"."emergency_stop_attempts" (
	"stop_id" uuid NOT NULL,
	"customer_account_id" uuid NOT NULL,
	"at" timestamp with time zone NOT NULL,
	CONSTRAINT "emergency_stop_attempts_stop_id_customer_account_id_pk" PRIMARY KEY("stop_id","customer_account_id")
);
--> statement-breakpoint
CREATE TABLE "ordering"."emergency_stops" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"city_id" uuid NOT NULL,
	"started_at" timestamp with time zone NOT NULL,
	"started_by" uuid NOT NULL,
	"internal_reason" text NOT NULL,
	"browse_message" text NOT NULL,
	"delay_notice" text NOT NULL,
	"customer_reason" text NOT NULL,
	"resume_at" timestamp with time zone,
	"ended_at" timestamp with time zone,
	"ended_by" uuid,
	"end_kind" text,
	"service_back_message" text,
	CONSTRAINT "emergency_stops_end" CHECK (("ordering"."emergency_stops"."ended_at" IS NULL AND "ordering"."emergency_stops"."end_kind" IS NULL AND "ordering"."emergency_stops"."ended_by" IS NULL) OR ("ordering"."emergency_stops"."ended_at" IS NOT NULL AND "ordering"."emergency_stops"."end_kind" IS NOT NULL AND ("ordering"."emergency_stops"."end_kind" = 'manual') = ("ordering"."emergency_stops"."ended_by" IS NOT NULL))),
	CONSTRAINT "emergency_stops_service_back" CHECK ("ordering"."emergency_stops"."service_back_message" IS NULL OR "ordering"."emergency_stops"."end_kind" = 'manual'),
	CONSTRAINT "emergency_stops_resume_after_start" CHECK ("ordering"."emergency_stops"."resume_at" IS NULL OR "ordering"."emergency_stops"."resume_at" > "ordering"."emergency_stops"."started_at")
);
--> statement-breakpoint
ALTER TABLE "ordering"."emergency_stop_attempts" ADD CONSTRAINT "emergency_stop_attempts_stop_id_emergency_stops_id_fk" FOREIGN KEY ("stop_id") REFERENCES "ordering"."emergency_stops"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "platform_outbox_unpublished" ON "notifications"."platform_outbox" USING btree ("id") WHERE "notifications"."platform_outbox"."published_at" IS NULL;--> statement-breakpoint
CREATE UNIQUE INDEX "emergency_stops_one_open" ON "ordering"."emergency_stops" USING btree ("city_id") WHERE "ordering"."emergency_stops"."ended_at" IS NULL;--> statement-breakpoint
CREATE INDEX "emergency_stops_city" ON "ordering"."emergency_stops" USING btree ("city_id","started_at");--> statement-breakpoint
-- The relay only marks rows published; a row is never rewritten.
REVOKE UPDATE ON "notifications"."platform_outbox" FROM fox_drop_app;
--> statement-breakpoint
GRANT UPDATE ("published_at") ON "notifications"."platform_outbox" TO fox_drop_app;
--> statement-breakpoint
-- A stop is kept as it started; only its end is written later (AP §9.1.6).
REVOKE UPDATE ON "ordering"."emergency_stops" FROM fox_drop_app;
--> statement-breakpoint
GRANT UPDATE ("ended_at", "ended_by", "end_kind", "service_back_message") ON "ordering"."emergency_stops" TO fox_drop_app;
--> statement-breakpoint
-- An attempt is counted once and never changed.
REVOKE UPDATE ON "ordering"."emergency_stop_attempts" FROM fox_drop_app;
