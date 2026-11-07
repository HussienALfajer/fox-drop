CREATE TABLE "notifications"."alert_outbox" (
	"id" bigint PRIMARY KEY GENERATED ALWAYS AS IDENTITY (sequence name "notifications"."alert_outbox_id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START WITH 1 CACHE 1),
	"created_at" timestamp with time zone NOT NULL,
	"city_id" uuid,
	"type" text NOT NULL,
	"alert_id" uuid NOT NULL,
	"payload" jsonb NOT NULL,
	"published_at" timestamp with time zone,
	CONSTRAINT "alert_outbox_type" CHECK ("notifications"."alert_outbox"."type" IN ('alert.raised', 'alert.acknowledged', 'alert.resolved'))
);
--> statement-breakpoint
CREATE INDEX "alert_outbox_unpublished" ON "notifications"."alert_outbox" USING btree ("id") WHERE "notifications"."alert_outbox"."published_at" IS NULL;--> statement-breakpoint
-- The relay only marks rows published; a row is never rewritten.
REVOKE UPDATE ON "notifications"."alert_outbox" FROM fox_drop_app;
--> statement-breakpoint
GRANT UPDATE ("published_at") ON "notifications"."alert_outbox" TO fox_drop_app;
