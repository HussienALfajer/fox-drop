ALTER TABLE "cashdesk"."drawer_sessions" DROP CONSTRAINT "drawer_sessions_kind_values";--> statement-breakpoint
ALTER TABLE "cashdesk"."receipts" ADD COLUMN "method" text DEFAULT 'office' NOT NULL;--> statement-breakpoint
ALTER TABLE "cashdesk"."receipts" ADD COLUMN "visitor_id" uuid;--> statement-breakpoint
ALTER TABLE "cashdesk"."receipts" ADD COLUMN "visitor_name" text;--> statement-breakpoint
ALTER TABLE "cashdesk"."drawer_sessions" ADD CONSTRAINT "drawer_sessions_kind_values" CHECK ("cashdesk"."drawer_sessions"."kind" IN ('office', 'field'));--> statement-breakpoint
ALTER TABLE "cashdesk"."receipts" ADD CONSTRAINT "receipts_method_values" CHECK ("cashdesk"."receipts"."method" IN ('office', 'field'));--> statement-breakpoint
ALTER TABLE "cashdesk"."receipts" ADD CONSTRAINT "receipts_visitor" CHECK (CASE WHEN "cashdesk"."receipts"."method" = 'field' THEN "cashdesk"."receipts"."restaurant_id" IS NOT NULL AND "cashdesk"."receipts"."visitor_id" IS NOT NULL AND COALESCE("cashdesk"."receipts"."visitor_name", '') <> '' ELSE "cashdesk"."receipts"."visitor_id" IS NULL AND "cashdesk"."receipts"."visitor_name" IS NULL END);