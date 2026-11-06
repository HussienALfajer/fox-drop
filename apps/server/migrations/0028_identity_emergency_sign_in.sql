ALTER TABLE "identity"."app_sign_in_codes" ALTER COLUMN "device_id" DROP NOT NULL;--> statement-breakpoint
ALTER TABLE "identity"."app_sign_in_codes" ADD COLUMN "issued_by" uuid;--> statement-breakpoint
ALTER TABLE "identity"."app_sign_in_codes" ADD COLUMN "issue_reason" text;--> statement-breakpoint
ALTER TABLE "identity"."app_sign_in_codes" ADD CONSTRAINT "app_sign_in_codes_device_or_issuer" CHECK (("identity"."app_sign_in_codes"."device_id" IS NULL) = ("identity"."app_sign_in_codes"."issued_by" IS NOT NULL) AND ("identity"."app_sign_in_codes"."issued_by" IS NULL) = ("identity"."app_sign_in_codes"."issue_reason" IS NULL) AND ("identity"."app_sign_in_codes"."issued_by" IS NULL OR "identity"."app_sign_in_codes"."party" <> 'customer'));--> statement-breakpoint
-- W4 (owner decision 2026-11-07): OWN and OPS issue emergency sign-in codes.
INSERT INTO "identity"."admin_permissions" ("code") VALUES ('sign_in.emergency_code');--> statement-breakpoint
INSERT INTO "identity"."admin_role_permissions" ("role_code", "permission_code") VALUES
	('OWN', 'sign_in.emergency_code'),
	('OPS', 'sign_in.emergency_code');
