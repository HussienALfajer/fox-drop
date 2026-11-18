ALTER TABLE "notifications"."push_messages" ADD COLUMN "title" text;--> statement-breakpoint
ALTER TABLE "notifications"."push_messages" ADD COLUMN "campaign_id" uuid;--> statement-breakpoint
ALTER TABLE "notifications"."push_messages" ADD COLUMN "delivered_at" timestamp with time zone;--> statement-breakpoint
CREATE INDEX "push_messages_campaign" ON "notifications"."push_messages" USING btree ("campaign_id") WHERE "notifications"."push_messages"."campaign_id" IS NOT NULL;