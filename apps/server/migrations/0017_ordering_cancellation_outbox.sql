CREATE TABLE "ordering"."outbox" (
	"id" bigint PRIMARY KEY GENERATED ALWAYS AS IDENTITY (sequence name "ordering"."outbox_id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START WITH 1 CACHE 1),
	"created_at" timestamp with time zone NOT NULL,
	"city_id" uuid NOT NULL,
	"type" text NOT NULL,
	"order_id" uuid NOT NULL,
	"order_version" integer NOT NULL,
	"payload" jsonb NOT NULL,
	"published_at" timestamp with time zone
);
--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "cancelled_at" timestamp with time zone;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "cancel_reason" text;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "food_prepared" boolean;--> statement-breakpoint
CREATE INDEX "outbox_unpublished" ON "ordering"."outbox" USING btree ("id") WHERE "ordering"."outbox"."published_at" IS NULL;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD CONSTRAINT "orders_cancellation" CHECK (("status" = 'cancelled') = ("cancelled_at" IS NOT NULL AND "cancel_reason" IS NOT NULL AND "food_prepared" IS NOT NULL));--> statement-breakpoint
-- The relay marks a row published; nothing else changes it.
REVOKE UPDATE ON "ordering"."outbox" FROM fox_drop_app;
--> statement-breakpoint
GRANT UPDATE ("published_at") ON "ordering"."outbox" TO fox_drop_app;
