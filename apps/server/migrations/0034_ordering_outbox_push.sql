ALTER TABLE "ordering"."outbox" ADD COLUMN "push_queued_at" timestamp with time zone;--> statement-breakpoint
-- The events written before push existed are never pushed: they are told.
UPDATE "ordering"."outbox" SET "push_queued_at" = "created_at" WHERE "push_queued_at" IS NULL;--> statement-breakpoint
CREATE INDEX "outbox_push_unqueued" ON "ordering"."outbox" USING btree ("id") WHERE "ordering"."outbox"."push_queued_at" IS NULL;--> statement-breakpoint
-- The push relay marks a row queued; nothing else changes it.
GRANT UPDATE ("push_queued_at") ON "ordering"."outbox" TO fox_drop_app;
