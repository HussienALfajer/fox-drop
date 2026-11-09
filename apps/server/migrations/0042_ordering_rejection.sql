ALTER TABLE "ordering"."orders" ADD COLUMN "rejected_at" timestamp with time zone;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "reject_reason" text;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "reject_reason_label" text;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "reject_customer_text" text;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "reject_item_ids" jsonb;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD CONSTRAINT "orders_rejection" CHECK (("status" = 'rejected') = ("rejected_at" IS NOT NULL AND "reject_reason" IS NOT NULL AND "reject_reason_label" IS NOT NULL AND "reject_customer_text" IS NOT NULL AND "reject_item_ids" IS NOT NULL));