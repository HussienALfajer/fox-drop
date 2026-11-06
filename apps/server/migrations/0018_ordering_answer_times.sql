ALTER TABLE "ordering"."orders" ADD COLUMN "accept_alert_at" timestamp with time zone;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "auto_cancel_at" timestamp with time zone;