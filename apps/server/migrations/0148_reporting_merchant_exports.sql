ALTER TABLE "reporting"."exports" DROP CONSTRAINT "exports_kind_values";--> statement-breakpoint
ALTER TABLE "reporting"."exports" ADD CONSTRAINT "exports_kind_values" CHECK ("reporting"."exports"."kind" IN ('restaurant_statement', 'daily_report', 'cost_report', 'order_history', 'report', 'merchant_report', 'merchant_order_history', 'merchant_statement')) NOT VALID;--> statement-breakpoint
ALTER TABLE "reporting"."exports" VALIDATE CONSTRAINT "exports_kind_values";
