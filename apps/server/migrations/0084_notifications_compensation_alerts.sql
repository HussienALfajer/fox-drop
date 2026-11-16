ALTER TABLE "notifications"."alerts" DROP CONSTRAINT "alerts_subject_type";--> statement-breakpoint
ALTER TABLE "notifications"."alerts" ADD CONSTRAINT "alerts_subject_type" CHECK ("notifications"."alerts"."subject_type" IN ('order', 'captain', 'otp_pool', 'otp_number', 'restaurant', 'currency', 'compensation')) NOT VALID;--> statement-breakpoint
ALTER TABLE "notifications"."alerts" VALIDATE CONSTRAINT "alerts_subject_type";--> statement-breakpoint
-- AP Appendix B «تعويض الزبون» (owner decision 2026-11-17): each reason takes an optional note.
INSERT INTO "content"."reasons" ("list", "code", "label", "customer_text", "note", "fixed", "position") VALUES
	('compensation', 'late', 'تأخير', NULL, 'optional', false, 1),
	('compensation', 'missing_item', 'صنف ناقص', NULL, 'optional', false, 2),
	('compensation', 'wrong_item', 'صنف خطأ', NULL, 'optional', false, 3),
	('compensation', 'food_quality', 'جودة الطعام', NULL, 'optional', false, 4),
	('compensation', 'captain_behaviour', 'سلوك الكابتن', NULL, 'optional', false, 5),
	('compensation', 'order_cancelled', 'إلغاء الطلب', NULL, 'optional', false, 6),
	('compensation', 'other', 'أخرى', NULL, 'optional', false, 7);
