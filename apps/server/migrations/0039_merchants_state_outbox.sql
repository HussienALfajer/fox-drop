CREATE TABLE "merchants"."state_outbox" (
	"id" bigint PRIMARY KEY GENERATED ALWAYS AS IDENTITY (sequence name "merchants"."state_outbox_id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START WITH 1 CACHE 1),
	"created_at" timestamp with time zone NOT NULL,
	"restaurant_id" uuid NOT NULL,
	"city_id" uuid NOT NULL,
	"kind" text NOT NULL,
	"payload" jsonb NOT NULL,
	"relayed_at" timestamp with time zone
);
--> statement-breakpoint
ALTER TABLE "merchants"."restaurants" ADD COLUMN "busy_started_at" timestamp with time zone;--> statement-breakpoint
CREATE INDEX "state_outbox_unrelayed" ON "merchants"."state_outbox" USING btree ("id") WHERE "merchants"."state_outbox"."relayed_at" IS NULL;--> statement-breakpoint
-- Architecture §5.5, E4: the relay changes only when a row was relayed.
REVOKE UPDATE ON "merchants"."state_outbox" FROM fox_drop_app;--> statement-breakpoint
GRANT UPDATE ("relayed_at") ON "merchants"."state_outbox" TO fox_drop_app;
