CREATE INDEX "push_messages_pending_plain" ON "notifications"."push_messages" USING btree ("next_attempt_at") WHERE "notifications"."push_messages"."sent_at" IS NULL AND "notifications"."push_messages"."gave_up_at" IS NULL AND "notifications"."push_messages"."campaign_id" IS NULL;--> statement-breakpoint
CREATE INDEX "push_messages_pending_campaign" ON "notifications"."push_messages" USING btree ("next_attempt_at") WHERE "notifications"."push_messages"."sent_at" IS NULL AND "notifications"."push_messages"."gave_up_at" IS NULL AND "notifications"."push_messages"."campaign_id" IS NOT NULL;--> statement-breakpoint
REVOKE UPDATE ON "marketing"."mass_pushes" FROM fox_drop_app;--> statement-breakpoint
GRANT UPDATE ("cancelled_at", "cancelled_by") ON "marketing"."mass_pushes" TO fox_drop_app;
