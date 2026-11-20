ALTER TABLE "reporting"."exports" DROP CONSTRAINT "exports_kind_values";--> statement-breakpoint
ALTER TABLE "cashdesk"."manual_entries" ADD COLUMN "order_id" uuid;--> statement-breakpoint
CREATE INDEX "manual_entries_order" ON "cashdesk"."manual_entries" USING btree ("order_id") WHERE "cashdesk"."manual_entries"."order_id" IS NOT NULL;--> statement-breakpoint
ALTER TABLE "cashdesk"."manual_entries" ADD CONSTRAINT "manual_entries_order_adjustment" CHECK ("cashdesk"."manual_entries"."order_id" IS NULL OR "cashdesk"."manual_entries"."kind" = 'adjustment') NOT VALID;--> statement-breakpoint
ALTER TABLE "cashdesk"."manual_entries" VALIDATE CONSTRAINT "manual_entries_order_adjustment";--> statement-breakpoint
ALTER TABLE "reporting"."exports" ADD CONSTRAINT "exports_kind_values" CHECK ("reporting"."exports"."kind" IN ('restaurant_statement', 'daily_report', 'cost_report', 'order_history')) NOT VALID;--> statement-breakpoint
ALTER TABLE "reporting"."exports" VALIDATE CONSTRAINT "exports_kind_values";