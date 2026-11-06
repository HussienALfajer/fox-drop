CREATE TABLE "identity"."captain_accounts" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"city_id" uuid NOT NULL,
	"captain_id" uuid NOT NULL,
	"phone_encrypted" text NOT NULL,
	"phone_hash" text NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "captain_accounts_captain_id_unique" UNIQUE("captain_id"),
	CONSTRAINT "captain_accounts_phone_hash_unique" UNIQUE("phone_hash")
);
--> statement-breakpoint
ALTER TABLE "identity"."app_sessions" DROP CONSTRAINT "app_sessions_party_values";--> statement-breakpoint
ALTER TABLE "identity"."app_sessions" DROP CONSTRAINT "app_sessions_end_reason_values";--> statement-breakpoint
ALTER TABLE "identity"."app_sign_in_codes" DROP CONSTRAINT "app_sign_in_codes_party_values";--> statement-breakpoint
ALTER TABLE "identity"."app_sessions" ADD CONSTRAINT "app_sessions_party_values" CHECK ("identity"."app_sessions"."party" IN ('customer', 'merchant', 'captain'));--> statement-breakpoint
ALTER TABLE "identity"."app_sessions" ADD CONSTRAINT "app_sessions_end_reason_values" CHECK ("identity"."app_sessions"."end_reason" IN ('sign_out', 'sign_out_everywhere', 'refresh_reuse', 'new_sign_in', 'other_device'));--> statement-breakpoint
ALTER TABLE "identity"."app_sign_in_codes" ADD CONSTRAINT "app_sign_in_codes_party_values" CHECK ("identity"."app_sign_in_codes"."party" IN ('customer', 'merchant', 'captain'));