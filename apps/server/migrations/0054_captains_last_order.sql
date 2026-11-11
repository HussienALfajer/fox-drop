ALTER TABLE "captains"."online_periods" DROP CONSTRAINT "online_periods_end_reason_values";--> statement-breakpoint
ALTER TABLE "captains"."online_periods" ADD COLUMN "last_order_by" text;--> statement-breakpoint
ALTER TABLE "captains"."online_periods" ADD COLUMN "last_order_at" timestamp with time zone;--> statement-breakpoint
ALTER TABLE "captains"."online_periods" ADD COLUMN "last_order_reason" text;--> statement-breakpoint
ALTER TABLE "captains"."online_periods" ADD CONSTRAINT "online_periods_last_order" CHECK (("captains"."online_periods"."last_order_by" IS NULL) = ("captains"."online_periods"."last_order_at" IS NULL)
          AND (coalesce("captains"."online_periods"."last_order_by", '') = 'forced') = ("captains"."online_periods"."last_order_reason" IS NOT NULL)
          AND ("captains"."online_periods"."last_order_by" IS NULL OR "captains"."online_periods"."last_order_by" IN ('captain', 'forced', 'suspended', 'terminated')));--> statement-breakpoint
ALTER TABLE "captains"."online_periods" ADD CONSTRAINT "online_periods_end_reason_values" CHECK ("captains"."online_periods"."end_reason" IN ('captain', 'suspended', 'terminated', 'offers_expired', 'handed_over', 'last_order', 'forced'));