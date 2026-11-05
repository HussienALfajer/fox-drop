ALTER TABLE "identity"."app_refresh_tokens" ADD COLUMN "superseded_at" timestamp with time zone;--> statement-breakpoint
ALTER TABLE "identity"."app_sessions" ADD COLUMN "last_used_token_id" uuid;