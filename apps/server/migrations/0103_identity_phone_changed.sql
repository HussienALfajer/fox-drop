ALTER TABLE "identity"."app_sessions" DROP CONSTRAINT "app_sessions_end_reason_values";--> statement-breakpoint
ALTER TABLE "identity"."app_sessions" ADD CONSTRAINT "app_sessions_end_reason_values" CHECK ("identity"."app_sessions"."end_reason" IN ('sign_out', 'sign_out_everywhere', 'refresh_reuse', 'new_sign_in', 'other_device', 'device_released', 'phone_changed')) NOT VALID;--> statement-breakpoint
ALTER TABLE "identity"."app_sessions" VALIDATE CONSTRAINT "app_sessions_end_reason_values";--> statement-breakpoint
-- AP §9.8, §6.3 (slice 2.25b): «تسجيل الخروج من كل الأجهزة» from the panel.
INSERT INTO "identity"."admin_permissions" ("code") VALUES ('customers.sign_out_everywhere');--> statement-breakpoint
INSERT INTO "identity"."admin_role_permissions" ("role_code", "permission_code") VALUES
	('OWN', 'customers.sign_out_everywhere'),
	('OPS', 'customers.sign_out_everywhere'),
	('SUP', 'customers.sign_out_everywhere');
