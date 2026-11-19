-- Slice 2.32a: «تغيير أسعار كبير» (AP §9.1.3) is about one price change of a restaurant. Expand only.
ALTER TABLE "notifications"."alerts" DROP CONSTRAINT "alerts_subject_type";--> statement-breakpoint
ALTER TABLE "notifications"."alerts" ADD CONSTRAINT "alerts_subject_type" CHECK ("notifications"."alerts"."subject_type" IN ('order', 'captain', 'otp_pool', 'otp_number', 'restaurant', 'currency', 'compensation', 'ticket', 'price_change')) NOT VALID;--> statement-breakpoint
ALTER TABLE "notifications"."alerts" VALIDATE CONSTRAINT "alerts_subject_type";
